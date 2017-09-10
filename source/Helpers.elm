module Helpers exposing (..)

import Date exposing (Date)
import Date.Extra.Format as Format exposing (utcIsoString)
import Date.Extra.Utils as Utils exposing (isoWeek)
import String.Extra exposing (replace)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import OpenSolid.Geometry.Types exposing (..)
import OpenSolid.Point2d as Point2d
import OpenSolid.Vector2d as Vector2d
import Styles exposing (stylusString)
import StylusParser exposing (stylusToCss)
import Types exposing (..)


-- Formatter


utcDateTime : Date -> String
utcDateTime =
    utcIsoString
        >> String.slice 0 16
        >> replace "T" " "


utcDate : Date -> String
utcDate =
    utcIsoString >> String.slice 0 10


utcWeek : Date -> String
utcWeek =
    isoWeek
        >> (\( year, week, dayOfWeek ) ->
                (toString year)
                    ++ "-W"
                    ++ (toString week)
                    ++ "-"
                    ++ (toString dayOfWeek)
           )



-- Data Converter


getMetaData :
    { a | width : Int, height : Int, yStartAtZero : Bool }
    -> Data
    -> MetaData
getMetaData config data =
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
    in
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


getDataLength : Data -> Int
getDataLength data =
    case data of
        TimeData list ->
            List.length list

        KeyData list ->
            List.length list

        Values list ->
            List.length list

        InvalidData ->
            0


getDataLabels : BaseConfigAnd a -> Data -> List String
getDataLabels config data =
    case data of
        TimeData list ->
            List.map (.utc >> config.xLabelFormatter) list

        KeyData list ->
            List.map .key list

        Values list ->
            List.map toString (List.range 0 ((List.length list) - 1))

        InvalidData ->
            []


getDataValues : Data -> List Float
getDataValues data =
    case data of
        TimeData list ->
            List.map .value list

        KeyData list ->
            List.map .value list

        Values list ->
            list

        InvalidData ->
            []


getDataRecords : Data -> Entries
getDataRecords data =
    let
        timeRecordToEntry record =
            { label = (toString record.utc)
            , value = record.value
            , offset = record.offset
            }

        keyRecordToEntry record =
            { label = record.key
            , value = record.value
            , offset = record.offset
            }

        valueToEntry index value =
            { label = (toString index)
            , value = value
            , offset = 0
            }
    in
        case data of
            TimeData list ->
                List.map timeRecordToEntry list

            KeyData list ->
                List.map keyRecordToEntry list

            Values list ->
                List.indexedMap valueToEntry list

            InvalidData ->
                []



-- SVG Helpers


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


wrapChart : BaseConfigAnd a -> Svg msg -> Svg msg
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
