module Vectual.HorizontalBarChart exposing
    ( defaultHorizontalBarChartConfig
    , viewHorizontalBarChart
    , getHorizontalBars
    , estimateTextWidth
    , getMaxLabelWidth
    , getHorizontalMetaData
    )

{-| This module creates a simple SVG horizontal bar chart.

@docs defaultHorizontalBarChartConfig

@docs viewHorizontalBarChart

@docs getHorizontalBars

@docs estimateTextWidth

@docs getMaxLabelWidth

@docs getHorizontalMetaData

-}

import Array
import Html.Attributes exposing (style)
import List exposing (length)
import Quantity exposing (Unitless)
import String exposing (fromFloat, fromInt)
import Styles exposing (stylusString)
import Stylus.Parser exposing (stylusToCss)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Posix)
import TimeUtils.Time exposing (utcDateTime)
import Vector2d exposing (..)
import Vectual.CoordinateSystem exposing (..)
import Vectual.Helpers exposing (..)
import Vectual.Types exposing (..)


{-| The default configuration for the horizontal bar chart.
Create your own config by overwriting the fields you want to change.

    horizontalBarChart =
        HorizontalBarChart
            { defaultHorizontalBarChartConfig
                | xLabelFormatter = utcWeek
            }
            timeData

-}
defaultHorizontalBarChartConfig : BarChartConfig
defaultHorizontalBarChartConfig =
    { title = "Vectual Horizontal Bar Chart"
    , inline = False
    , width = 400
    , height = 300
    , borderRadius = ( 2, 2 )
    , xLabelFormatter = utcDateTime

    --
    , labelAngle = 0
    , yStartAtZero = True
    , alignBars = Center
    }


{-| Estimate text width based on character count and font size
-}
estimateTextWidth : String -> Float
estimateTextWidth text =
    let
        -- Very conservative character width in pixels for 10px Arial font
        avgCharWidth =
            12.0

        -- Add substantial padding for safety
        padding =
            40.0
    in
    (toFloat (String.length text) * avgCharWidth) + padding


{-| Tighter estimate for label width used for layout (less conservative).
Assumes 10px Arial: ~6.2px per character + small padding.
-}
estimateTextWidthTight : String -> Float
estimateTextWidthTight text =
    let
        avgCharWidth =
            6.2

        padding =
            4.0
    in
    (toFloat (String.length text) * avgCharWidth) + padding


{-| Calculate maximum label width using tighter estimate for layout
-}
getTightMaxLabelWidth :
    { a
        | title : String
        , inline : Bool
        , width : Int
        , height : Int
        , borderRadius : ( Int, Int )
        , xLabelFormatter : Posix -> String
        , yStartAtZero : Bool
    }
    -> Data
    -> Float
getTightMaxLabelWidth config data =
    let
        labels =
            getDataLabels config data
    in
    labels
        |> List.map estimateTextWidthTight
        |> List.maximum
        |> Maybe.withDefault 24.0


{-| Calculate maximum label width for a dataset
-}
getMaxLabelWidth :
    { a
        | title : String
        , inline : Bool
        , width : Int
        , height : Int
        , borderRadius : ( Int, Int )
        , xLabelFormatter : Posix -> String
        , yStartAtZero : Bool
    }
    -> Data
    -> Float
getMaxLabelWidth config data =
    let
        -- Use the actual labels as rendered (respects xLabelFormatter)
        labels =
            getDataLabels config data

        widths =
            List.map estimateTextWidth labels
    in
    Maybe.withDefault 60.0 (List.maximum widths)


{-| Custom metadata for horizontal bar charts with dynamic left margin for labels
-}
getHorizontalMetaData :
    { a
        | title : String
        , inline : Bool
        , width : Int
        , height : Int
        , borderRadius : ( Int, Int )
        , xLabelFormatter : Posix -> String
        , yStartAtZero : Bool
    }
    -> Data
    -> MetaData Unitless coordinates
getHorizontalMetaData config data =
    let
        totalWidth =
            Basics.toFloat config.width

        totalHeight =
            Basics.toFloat config.height

        -- Vertical sizing: use a fixed bottom padding for a tighter bottom gap
        bottomPadding =
            30.0

        graphHeight =
            Basics.max 0 (totalHeight - bottomPadding)

        -- Compute left padding from a tighter label width estimate
        maxLabelWidth =
            getTightMaxLabelWidth config data

        xAxisOffset =
            5.0

        minLeft =
            10.0

        -- Keep the leftmost edge of labels aligned with the title's left margin
        titleOffset =
            20.0

        leftPadding =
            Basics.max minLeft (maxLabelWidth + xAxisOffset + titleOffset)

        -- Keep a fixed right padding so bars never touch edge
        rightPadding =
            20.0

        -- Available width for bars after accounting for label space and right padding
        availableChartWidth =
            Basics.max 0 (totalWidth - leftPadding - rightPadding)

        dataValues =
            getDataValues data

        yMinimum =
            if config.yStartAtZero then
                0

            else
                Maybe.withDefault 0 (List.minimum dataValues)

        yMaximum =
            Maybe.withDefault 0 (List.maximum dataValues)
    in
    { graphWidth = ceiling totalWidth
    , graphHeight = ceiling graphHeight
    , coordSysWidth = ceiling availableChartWidth
    , coordSysHeight = ceiling (0.85 * graphHeight)
    , translation = Vector2d.unitless leftPadding graphHeight
    , numberOfEntries = getDataLength data
    , yMinimum = yMinimum
    , yMaximum = yMaximum
    , yRange = yMaximum - yMinimum
    }


getHorizontalBar :
    BarChartConfig
    -> Data
    -> MetaData Unitless coordinates
    -> Int
    -> Entry
    -> Svg msg
getHorizontalBar config data metaData index entry =
    let
        xScaleFactor =
            toFloat metaData.coordSysWidth / metaData.yRange

        barProportionalHeight =
            0.7

        barWidth =
            (entry.value - metaData.yMinimum) * xScaleFactor

        barDistance =
            toFloat metaData.coordSysHeight
                / toFloat metaData.numberOfEntries

        title =
            entry.label ++ ": " ++ fromFloat entry.value

        yTop =
            truncate (toFloat index * barDistance)

        yValue =
            case config.alignBars of
                Left ->
                    yTop

                Center ->
                    round
                        (toFloat yTop
                            + (((1 - barProportionalHeight) / 2) * barDistance)
                        )

                Right ->
                    round
                        (toFloat yTop
                            + ((1 - barProportionalHeight) * barDistance)
                        )
    in
    rect
        [ y (fromInt yValue)
        , width (fromFloat barWidth)
        , height (fromFloat (barProportionalHeight * barDistance))
        , transform
            (toTranslate
                (Vector2d.unitless 0 -(toFloat metaData.coordSysHeight))
            )
        , class "vectual_bars"
        ]
        [ Svg.title [] [ text title ] ]


{-| -}
getHorizontalBars :
    BarChartConfig
    -> Data
    -> MetaData Unitless coordinates
    -> Svg msg
getHorizontalBars config data metaData =
    let
        entries =
            getDataRecords data

        bars =
            List.indexedMap (getHorizontalBar config data metaData) entries
    in
    g [] bars


{-| Horizontal coordinate system for horizontal bar charts
-}
getHorizontalCoordinateSystem :
    BaseConfigAnd a
    -> Data
    -> MetaData Unitless coordinates
    -> Svg msg
getHorizontalCoordinateSystem config data metaData =
    let
        yDensity =
            0.1

        xAxisOffset =
            5

        yAxisOffset =
            3

        -- Horizontal lines (now for x-values)
        xValue : Int -> Float
        xValue number =
            (toFloat metaData.coordSysWidth / metaData.yRange)
                * (toFloat number / yDensity)

        numToXLine : Int -> Svg msg
        numToXLine number =
            let
                className =
                    if number == 0 then
                        "vectual_coordinate_axis_x"

                    else
                        "vectual_coordinate_lines_x"

                labelOffset =
                    10
            in
            g []
                [ line
                    [ class className
                    , x1 (fromFloat (xValue number))
                    , y1 (fromFloat yAxisOffset)
                    , x2 (fromFloat (xValue number))
                    , y2 (fromInt -metaData.coordSysHeight)
                    ]
                    []
                , text_
                    [ class "vectual_coordinate_labels_x"
                    , textAnchor "middle"
                    , x (fromFloat (xValue number))
                    , y (fromFloat (toFloat yAxisOffset + toFloat labelOffset))
                    ]
                    [ text
                        ((toFloat number / yDensity + metaData.yMinimum)
                            |> fromFloat
                        )
                    ]
                ]

        -- Y-axis labels (category names)
        dataLabelAt index =
            let
                array =
                    Array.fromList (getDataLabels config data)

                maybeElement =
                    Array.get index array

                errorMessage =
                    "Error: Trying to access non existant element "
                        ++ "at index"
            in
            case maybeElement of
                Just element ->
                    element

                Nothing ->
                    Debug.log errorMessage (fromInt index)

        yValue : Int -> Float
        yValue number =
            let
                barHeight =
                    toFloat metaData.coordSysHeight / toFloat metaData.numberOfEntries

                barCenter =
                    barHeight / 2
            in
            -((barHeight * toFloat number) + barCenter)

        numToYLabel number =
            g []
                [ text_
                    [ class "vectual_coordinate_labels_y"
                    , textAnchor "end"
                    , x (fromInt -xAxisOffset)
                    , y (fromFloat (yValue number + yAxisOffset))
                    ]
                    [ text (dataLabelAt number) ]
                ]

        xLines =
            List.range 0 (truncate (metaData.yRange * yDensity))
                |> List.map numToXLine

        yLabels =
            List.range 0 (metaData.numberOfEntries - 1)
                |> List.map numToYLabel
    in
    g [] (xLines ++ yLabels)


{-| Custom chart wrapper for horizontal bar charts. Keep viewBox equal to SVG size
to avoid scaling/skewing of elements.
-}
wrapHorizontalChart : BarChartConfig -> MetaData Unitless coordinates -> Svg msg -> Svg msg
wrapHorizontalChart config metaData chart =
    let
        className =
            if config.inline then
                "vectual_inline"

            else
                "vectual"

        ( borderRadiusX, borderRadiusY ) =
            ( 10, 10 )
    in
    Svg.svg
        [ version "1.1"
        , class className
        , width (fromInt config.width ++ "px")
        , height (fromInt config.height ++ "px")
        , viewBox (String.join " " [ "0", "0", fromInt config.width, fromInt config.height ])
        ]
        [ Svg.style []
            [ text (Result.withDefault "" (stylusToCss stylusString)) ]
        , rect
            [ class "vectual_background"
            , width (fromInt config.width)
            , height (fromInt config.height)
            , rx (fromInt borderRadiusX)
            , ry (fromInt borderRadiusY)
            ]
            []
        , chart
        , text_
            [ class "vectual_title"
            , x (fromInt 20)
            , y (fromFloat (10 + 0.05 * Basics.toFloat config.height))
            , Svg.Attributes.style
                ("font-size:"
                    ++ fromFloat (0.05 * Basics.toFloat config.height)
                    ++ "px"
                )
            ]
            [ text config.title ]
        ]


{-| Create SVG from horizontal bar chart config and a data set.

    svgElement =
        viewHorizontalBarChart config dataSet

-}
viewHorizontalBarChart : BarChartConfig -> Data -> Svg msg
viewHorizontalBarChart config data =
    let
        metaData =
            getHorizontalMetaData config data

        dataValues =
            getDataValues data

        chart =
            g
                [ transform (toTranslate metaData.translation) ]
                [ getHorizontalCoordinateSystem config data metaData
                , getHorizontalBars config data metaData
                ]
    in
    wrapHorizontalChart config metaData chart
