module Vectual.AreaChart exposing
    ( defaultAreaChartConfig
    , viewAreaChart
    , buildArea
    )

{-| This module creates a simple SVG area chart.

@docs defaultAreaChartConfig

@docs viewAreaChart

@docs buildArea

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


{-| The default configuration for the area chart.
Create your own config by overwriting the fields you want to change.

    areaChart =
        AreaChart
            { defaultAreaChartConfig
                | xLabelFormatter = utcWeek
            }
            timeData

-}
defaultAreaChartConfig : LineChartConfig
defaultAreaChartConfig =
    { title = "Vectual Area Chart"
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
buildArea :
    LineChartConfig
    -> Data
    -> MetaData Unitless coordinates
    -> Svg msg
buildArea config data metaData =
    let
        entries =
            getDataRecords data

        foldPoints ( x, y ) str =
            str ++ " " ++ fromFloat x ++ "," ++ fromFloat y

        -- Calculate y-coordinate for y=0 on the chart (x-axis position)
        zeroY = (0 + metaData.yMinimum) * (toFloat metaData.coordSysHeight / metaData.yRange)

        startPointsStr =
            let
                -- For animation start: all data points at zero (x-axis) plus corners
                startDataPoints =
                    List.indexedMap
                        (\index _ ->
                            ( toFloat index
                                * (toFloat metaData.coordSysWidth
                                    / toFloat (List.length entries)
                                  )
                            , zeroY
                            )
                        )
                        entries

                -- Get x-coordinates for first and last data points
                firstX = 0
                lastX = toFloat (List.length entries - 1)
                    * (toFloat metaData.coordSysWidth / toFloat (List.length entries))

                allStartPoints =
                    [ ( firstX, zeroY ) ] -- Start at x-axis
                    ++ startDataPoints -- All data points at zero
                    ++ [ ( lastX, zeroY ) ] -- End at x-axis
            in
            allStartPoints
                |> foldl foldPoints ""

        endPointsStr =
            let
                -- Create the area points (bottom-left, data points, bottom-right)
                dataPoints =
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

                -- Get x-coordinates for first and last data points
                firstX = 0
                lastX = toFloat (List.length entries - 1)
                    * (toFloat metaData.coordSysWidth / toFloat (List.length entries))

                allPoints =
                    [ ( firstX, zeroY ) ] -- Start at x-axis
                    ++ dataPoints -- Add data points
                    ++ [ ( lastX, zeroY ) ] -- End at x-axis
            in
            allPoints
                |> foldl foldPoints ""
    in
    g
        [ class "vectual_area" ]
        [ polygon
            [ class "vectual_area_polygon"
            , class "vectual_area_polygon_4"
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
                    , to "0.7"
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
        [ class "vectual_area_dot"
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


{-| Create SVG from area chart config and a data set.

    svgElement =
        viewAreaChart config dataSet

-}
viewAreaChart : LineChartConfig -> Data -> Svg msg
viewAreaChart config data =
    let
        metaData =
            getMetaData config data

        dataValues =
            getDataValues data

        chart =
            g
                [ transform (toTranslate metaData.translation) ]
                [ getCoordinateSystem config data metaData
                , buildArea config data metaData
                , buildDots config data metaData
                ]
    in
    wrapChart config chart