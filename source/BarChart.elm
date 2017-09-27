module BarChart exposing (defaultBarChartConfig, viewBarChart, getBar)

{-| This module creates a simple SVG bar chart.

![Bar Chart](../images/barChart.png)

@docs defaultBarChartConfig

@docs viewBarChart

@docs getBar

-}

import Svg exposing (..)
import Svg.Attributes exposing (..)
import OpenSolid.Geometry.Types exposing (..)
import OpenSolid.Point2d as Point2d
import OpenSolid.Vector2d as Vector2d
import Types exposing (..)
import Helpers exposing (..)
import CoordinateSystem exposing (..)


{-| The default configuration for the bar chart.
Create your own config by overwriting the fields you want to change.

    barChart =
        BarChart
            { defaultBarChartConfig
                | xLabelFormatter = utcWeek
            }
            timeData

-}
defaultBarChartConfig : BarChartConfig
defaultBarChartConfig =
    { title = "Vectual Bar Chart"
    , inline = False
    , width = 400
    , height = 300
    , borderRadius = ( 2, 2 )
    , xLabelFormatter = utcDateTime

    --
    , labelAngle = 1.5
    , yStartAtZero = True
    , alignBars = Center
    }


{-| Helper to get SVG element for a single bar.
-}
getBar : BarChartConfig -> Data -> MetaData -> Int -> Entry -> Svg msg
getBar config data metaData index entry =
    let
        yScaleFactor =
            ((toFloat metaData.coordSysHeight) / metaData.yRange)

        barProportionalWidth =
            0.7

        barHeight =
            (entry.value - metaData.yMinimum) * yScaleFactor

        barDistance =
            (toFloat metaData.coordSysWidth)
                / (toFloat metaData.numberOfEntries)

        title =
            (entry.label ++ ": " ++ (toString entry.value))

        xLeft =
            truncate ((toFloat index) * barDistance)

        xValue =
            case config.alignBars of
                Left ->
                    xLeft

                Center ->
                    round
                        ((toFloat xLeft)
                            + (((1 - barProportionalWidth) / 2) * barDistance)
                        )

                Right ->
                    round
                        ((toFloat xLeft)
                            + ((1 - barProportionalWidth) * barDistance)
                        )
    in
        rect
            [ x (toString xValue)
            , height (toString barHeight)
            , width (toString (barProportionalWidth * barDistance))
            , transform
                (toTranslate
                    (Vector2d ( 0, -barHeight - (entry.offset * yScaleFactor) ))
                )
            ]
            [ Svg.title [] [ text title ] ]


getBars : BarChartConfig -> Data -> MetaData -> Svg msg
getBars config data metaData =
    g
        [ class "vectual_bars" ]
        (List.indexedMap
            (getBar config data metaData)
            (getDataRecords data)
        )


{-| Create SVG from bar chart config and a data set.

    svgElement =
        viewBarChart config dataSet

-}
viewBarChart : BarChartConfig -> Data -> Svg msg
viewBarChart config data =
    let
        metaData =
            getMetaData config data

        dataValues =
            getDataValues data

        chart =
            g
                [ transform (toTranslate metaData.translation) ]
                [ getCoordinateSystem config data metaData
                , getBars config data metaData
                ]
    in
        wrapChart config chart
