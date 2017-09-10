module Charts exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Styles exposing (stylusString)
import StylusParser exposing (stylusToCss)
import Date exposing (Date)
import OpenSolid.Geometry.Types exposing (..)
import OpenSolid.Vector2d as Vector2d
import OpenSolid.Point2d as Point2d
import Array


type alias Radian =
    Float


type alias Key =
    String


type Value
    = Int
    | Float


type alias Charted extraFields =
    { extraFields
        | title : String
        , inline : Bool
        , width : Int
        , height : Int
        , borderRadius : ( Int, Int )
    }


type alias PieChartConfig =
    Charted { radius : Int }


type Alignment
    = Left
    | Center
    | Right


type alias BarChartConfig =
    Charted
        { labelAngle : Radian
        , yStartAtZero : Bool
        , alignBars : Alignment
        }


type alias TimeRecord =
    { utc : Date
    , value : Float
    }


type alias KeyRecord =
    { key : Key
    , value : Float
    }


type Data
    = TimeData (List TimeRecord)
    | KeyData (List KeyRecord)
    | Values (List Float)


type Chart
    = PieChart PieChartConfig Data
    | BarChart BarChartConfig Data


defaultBaseConfig : Charted {}
defaultBaseConfig =
    { title = "Vectual Chart"
    , inline = False
    , width = 400
    , height = 300
    , borderRadius = ( 2, 2 )
    }


wrapChart : Charted a -> Svg msg -> Svg msg
wrapChart config chart =
    let
        className =
            if config.inline then
                "vectual_inline"
            else
                "vectual"

        ( borderRadiusX, borderRadiusY ) =
            ( 10, 10 )

        -- config.borderRadius
    in
        Svg.svg
            [ version "1.1"
            , class className
            , width (toString config.width)
            , height (toString config.height)
            , viewBox
                (String.join " "
                    (List.map toString
                        [ 0, 0, config.width, config.height ]
                    )
                )
            ]
            [ Svg.style []
                [ text (Result.withDefault "" (stylusToCss stylusString)) ]
            , rect
                [ class "vectual_background"
                , width (toString config.width)
                , height (toString config.height)
                , rx (toString borderRadiusX)
                , ry (toString borderRadiusY)
                ]
                []
            , chart
            , text_
                [ class "vectual_title"
                , x (toString 20)
                , y (toString (10 + 0.05 * (toFloat config.height)))
                , Svg.Attributes.style
                    ("font-size:"
                        ++ (toString (0.05 * (toFloat config.height)))
                        ++ "px"
                    )
                ]
                [ text config.title ]
            ]


getOrdinates : Charted a -> Data -> MetaData -> List (Svg msg)
getOrdinates config data metaData =
    let
        yAxisOffset =
            5

        className number =
            if number == 0 then
                "vectual_coordinate_axis_y"
            else
                "vectual_coordinate_lines_y"

        dataLabelAt index =
            let
                array =
                    Array.fromList (getDataLabels data)

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
                        Debug.log errorMessage (toString index)

        xValue : Int -> Float
        xValue number =
            (((toFloat metaData.coordSysWidth)
                / (toFloat metaData.numberOfEntries)
             )
                * (toFloat number)
            )

        numToLine number =
            let
                rotationPoint =
                    Point2d ( xValue number, 10 )

                keys =
                    List.map .key
            in
                g []
                    [ line
                        [ class (className number)
                        , x1 (toString (xValue number))
                        , y1 (toString yAxisOffset)
                        , x2 (toString (xValue number))
                        , y2 (toString -metaData.coordSysHeight)
                        ]
                        []
                    , text_
                        [ class "vectual_coordinate_labels_x"
                        , transform (toRotate 40 rotationPoint)
                        , x (toString (xValue number))
                        , y "10"
                        ]
                        [ text (dataLabelAt number) ]
                    ]
    in
        (List.range 0 (metaData.numberOfEntries - 1))
            |> (List.map numToLine)


getAbscissas : Charted a -> Data -> MetaData -> List (Svg msg)
getAbscissas config data metaData =
    let
        yDensity =
            0.1

        xAxisOffset =
            5

        className number =
            if number == 0 then
                "vectual_coordinate_axis_x"
            else
                "vectual_coordinate_lines_x"

        yValue : Int -> String
        yValue number =
            -((toFloat metaData.coordSysHeight) / metaData.yRange)
                * ((toFloat number) / yDensity)
                |> toString

        numToLine : Int -> Svg msg
        numToLine number =
            g []
                [ line
                    [ class (className number)
                    , x1 (toString -xAxisOffset)
                    , y1 (yValue number)
                    , x2 (metaData.coordSysWidth |> toString)
                    , y2 (yValue number)
                    ]
                    []
                , text_
                    [ class "vectual_coordinate_labels_y"
                    , x (toString ((toFloat -metaData.coordSysWidth) * 0.05))
                    , y (yValue number)
                    ]
                    [ text
                        (((toFloat number) / yDensity + metaData.yMinimum)
                            |> toString
                        )
                    ]
                ]
    in
        (List.range 0 (truncate (metaData.yRange * yDensity)))
            |> (List.map numToLine)


getCoordinateSystem : Charted a -> Data -> MetaData -> Svg msg
getCoordinateSystem config data metaData =
    g []
        (List.append
            (getOrdinates config data metaData)
            (getAbscissas config data metaData)
        )


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


getDataLength : Data -> Int
getDataLength data =
    case data of
        TimeData list ->
            List.length list

        KeyData list ->
            List.length list

        Values list ->
            List.length list


getDataLabels : Data -> List String
getDataLabels data =
    case data of
        TimeData list ->
            List.map (.utc >> toString) list

        KeyData list ->
            List.map .key list

        Values list ->
            List.map toString (List.range 0 ((List.length list) - 1))


getDataValues : Data -> List Float
getDataValues data =
    case data of
        TimeData list ->
            List.map .value list

        KeyData list ->
            List.map .value list

        Values list ->
            list


type alias Entry =
    { label : String
    , value : Float
    }


getDataRecords : Data -> List Entry
getDataRecords data =
    let
        timeRecordToEntry record =
            { label = (toString record.utc), value = record.value }

        keyRecordToEntry record =
            { label = record.key, value = record.value }

        valueToEntry index value =
            { label = (toString index), value = value }
    in
        case data of
            TimeData list ->
                List.map timeRecordToEntry list

            KeyData list ->
                List.map keyRecordToEntry list

            Values list ->
                List.indexedMap valueToEntry list


toTranslate : Vector2d -> String
toTranslate vector =
    "translate" ++ (Vector2d.components vector |> toString)


toRotate : Int -> Point2d -> String
toRotate degree point =
    "rotate"
        ++ (toString
                ( degree
                , (Point2d.xCoordinate point)
                , (Point2d.yCoordinate point)
                )
           )


viewChart : Chart -> Svg msg
viewChart chart =
    case chart of
        BarChart config data ->
            viewBarChart config data

        PieChart config data ->
            viewPieChart config data


type alias MetaData =
    { graphWidth : Int
    , graphHeight : Int
    , coordSysWidth : Int
    , coordSysHeight : Int
    , translation : Vector2d
    , numberOfEntries : Int
    , yMinimum : Float
    , yMaximum : Float
    , yRange : Float
    }


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


viewPieChart : PieChartConfig -> Data -> Svg msg
viewPieChart config data =
    circle [ r "50" ] []
