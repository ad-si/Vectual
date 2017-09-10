module BarChart exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import OpenSolid.Geometry.Types exposing (..)
import OpenSolid.Point2d as Point2d
import OpenSolid.Vector2d as Vector2d
import Types exposing (..)
import Helpers exposing (..)
import CoordinateSystem exposing (..)


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


getBar : BarChartConfig -> Data -> MetaData -> Int -> Entry -> Svg msg
getBar config data metaData index entry =
    let
        barProportionalWidth =
            0.7

        barHeight =
            (entry.value - metaData.yMinimum)
                * ((toFloat metaData.coordSysHeight) / metaData.yRange)

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
            [ class "vectual_bar_bar"
            , x (toString xValue)
            , height (toString barHeight)
            , width (toString (barProportionalWidth * barDistance))
            , transform (toTranslate (Vector2d ( 0, -barHeight )))
            ]
            [ Svg.title [] [ text title ] ]


getBars : BarChartConfig -> Data -> MetaData -> Svg msg
getBars config data metaData =
    g
        []
        (List.indexedMap
            (getBar config data metaData)
            (getDataRecords data)
        )


viewBarChart : BarChartConfig -> Data -> Svg msg
viewBarChart config data =
    let
        graphWidth =
            0.95 * (toFloat config.width)

        graphHeight =
            0.8 * (toFloat config.height)

        dataValues =
            getDataValues data

        yMinimum =
            if config.yStartAtZero then
                0
            else
                Maybe.withDefault 0 (List.minimum dataValues)

        yMaximum =
            Maybe.withDefault 0 (List.maximum dataValues)

        metaData : MetaData
        metaData =
            { graphWidth = ceiling graphWidth
            , graphHeight = ceiling graphHeight
            , coordSysWidth = ceiling (0.9 * graphWidth)
            , coordSysHeight = ceiling (0.8 * graphHeight)
            , translation = Vector2d ( graphWidth * 0.1, graphHeight )
            , numberOfEntries = getDataLength data
            , yMinimum = yMinimum
            , yMaximum = yMaximum
            , yRange = yMaximum - yMinimum
            }

        chart =
            g
                [ transform (toTranslate metaData.translation) ]
                [ getCoordinateSystem config data metaData
                , getBars config data metaData
                ]
    in
        wrapChart config chart
