module Vectual.LineChart exposing
    ( defaultLineChartConfig
    , viewLineChart
    , buildLines
    )

{-| This module creates a simple SVG line chart.

![Line Chart](../images/lineChart.png)

@docs defaultLineChartConfig

@docs viewLineChart

@docs buildLines

-}

import List exposing (foldl, length)
import Quantity exposing (Unitless)
import String exposing (fromFloat, fromInt)
import Svg exposing (..)
import Svg.Attributes as SvgA exposing (..)
import TimeUtils.Time exposing (utcDateTime)
import Vector2d exposing (..)
import Vectual.CoordinateSystem exposing (..)
import Vectual.Helpers exposing (..)
import Vectual.Types exposing (..)


{-| The default configuration for the line chart.
Create your own config by overwriting the fields you want to change.

    lineChart =
        LineChart
            { defaultLineChartConfig
                | xLabelFormatter = utcWeek
            }
            timeData

-}
defaultLineChartConfig : LineChartConfig
defaultLineChartConfig =
    { title = "Vectual Line Chart"
    , inline = False
    , width = 400
    , height = 300
    , borderRadius = ( 2, 2 )
    , xLabelFormatter = utcDateTime

    --
    , labelAngle = 1.5
    , yStartAtZero = True
    , alignBars = Center
    , showAnimations = False
    }


{-| -}
buildLines :
    LineChartConfig
    -> Data
    -> MetaData Unitless coordinates
    -> Svg msg
buildLines config data metaData =
    let
        entries =
            getDataRecords data

        foldPoints ( x, y ) str =
            str ++ " " ++ fromFloat x ++ "," ++ fromFloat y

        startPointsStr =
            List.indexedMap
                (\index _ ->
                    ( toFloat index
                        * (toFloat metaData.coordSysWidth
                            / toFloat (List.length entries)
                          )
                    , 0
                    )
                )
                entries
                |> foldl foldPoints ""

        endPointsStr =
            List.indexedMap
                (\index entry ->
                    ( toFloat index
                        * (toFloat metaData.coordSysWidth
                            / toFloat (List.length entries)
                          )
                    , (-entry.value + metaData.yMinimum)
                        * (toFloat metaData.coordSysHeight / metaData.yRange)
                    )
                )
                entries
                |> foldl foldPoints ""
    in
    g
        [ class "vectual_lines" ]
        [ polyline
            [ class "vectual_line_polyline"
            , class "vectual_line_polyline_4"
            , points endPointsStr
            ]
            [ if config.showAnimations then
                animate
                    [ attributeName "points"
                    , SvgA.from startPointsStr
                    , to endPointsStr
                    , begin "0s"
                    , dur "1s"
                    , fill "freeze"
                    ]
                    []

              else
                g [] []
            , if config.showAnimations then
                animate
                    [ attributeName "opacity"
                    , begin "0s"
                    , SvgA.from "0"
                    , to "1"
                    , dur "1s"
                    , additive "replace"
                    , fill "freeze"
                    ]
                    []

              else
                g [] []
            ]
        ]


buildDot :
    LineChartConfig
    -> MetaData Unitless coordinates
    -> Int
    -> Entry
    -> Svg msg
buildDot config metaData index entry =
    circle
        [ class "vectual_line_dot"
        , class "vectual_color_4"
        , r "4"
        , cx
            (fromFloat
                (toFloat index
                    * (toFloat metaData.coordSysWidth
                        / toFloat metaData.numberOfEntries
                      )
                )
            )
        , cy
            (fromFloat
                ((-entry.value + metaData.yMinimum)
                    * (toFloat metaData.coordSysHeight / metaData.yRange)
                )
            )
        ]
        [ Svg.title [] [ text (entry.label ++ ":  " ++ fromFloat entry.value) ]
        , if config.showAnimations then
            animate
                [ attributeName "opacity"
                , begin "0s"
                , values "0;0;1"
                , keyTimes "0;0.8;1"
                , dur "1.5s"
                , additive "replace"
                , fill "freeze"
                ]
                []

          else
            g [] []
        , if config.showAnimations then
            animate
                [ attributeName "r"
                , to "8"
                , dur "0.1s"
                , begin "mouseover"
                , additive "replace"
                , fill "freeze"
                ]
                []

          else
            g [] []
        , if config.showAnimations then
            animate
                [ attributeName "r"
                , to "4"
                , dur "0.2s"
                , begin "mouseout"
                , additive "replace"
                , fill "freeze"
                ]
                []

          else
            g [] []
        ]


buildDots :
    LineChartConfig
    -> Data
    -> MetaData Unitless coordinates
    -> Svg msg
buildDots config data metaData =
    let
        entries =
            getDataRecords data

        dots =
            List.indexedMap (buildDot config metaData) entries
    in
    g [] dots


{-| Create SVG from bar chart config and a data set.

    svgElement =
        viewLineChart config dataSet

-}
viewLineChart : LineChartConfig -> Data -> Svg msg
viewLineChart config data =
    let
        metaData =
            getMetaData config data

        dataValues =
            getDataValues data

        chart =
            g
                [ transform (toTranslate metaData.translation) ]
                [ getCoordinateSystem config data metaData
                , buildLines config data metaData
                , buildDots config data metaData
                ]
    in
    wrapChart config chart
