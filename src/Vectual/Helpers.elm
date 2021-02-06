module Vectual.Helpers exposing
    ( getDataLabels
    , getDataLength
    , getDataRecords
    , getDataValues
    , getMetaData
    , toRotate
    , toTranslate
    , wrapChart
    )

{-| Helpers for normalizing / sanitizing data and easier SVG creation.

@docs getDataLabels
@docs getDataLength
@docs getDataRecords
@docs getDataValues
@docs getMetaData
@docs toRotate
@docs toTranslate
@docs wrapChart

-}

import Iso8601 exposing (fromTime)
import Point2d exposing (..)
import Quantity exposing (Unitless)
import String exposing (fromFloat, fromInt, join, replace)
import Styles exposing (stylusString)
import Stylus.Parser exposing (stylusToCss)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (..)
import TimeUtils.Time exposing (..)
import Vector2d exposing (..)
import Vectual.Types exposing (..)



-- Data Converter


{-| -}
getMetaData :
    { a | width : Int, height : Int, yStartAtZero : Bool }
    -> Data
    -> MetaData Unitless coordinates
getMetaData config data =
    let
        graphWidth =
            0.95 * Basics.toFloat config.width

        graphHeight =
            0.8 * Basics.toFloat config.height

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
    , translation = Vector2d.unitless (graphWidth * 0.1) graphHeight
    , numberOfEntries = getDataLength data
    , yMinimum = yMinimum
    , yMaximum = yMaximum
    , yRange = yMaximum - yMinimum
    }


{-| -}
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


{-| -}
getDataLabels : BaseConfigAnd a -> Data -> List String
getDataLabels config data =
    case data of
        TimeData list ->
            List.map (.utc >> config.xLabelFormatter) list

        KeyData list ->
            List.map .key list

        Values list ->
            List.map fromInt (List.range 0 (List.length list - 1))

        InvalidData ->
            []


{-| -}
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


{-| -}
getDataRecords : Data -> Entries
getDataRecords data =
    let
        timeRecordToEntry record =
            { label = fromTime record.utc
            , value = record.value
            , offset = record.offset
            }

        keyRecordToEntry record =
            { label = record.key
            , value = record.value
            , offset = record.offset
            }

        valueToEntry index value =
            { label = fromInt index
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


{-| -}
toTranslate : Vector2d units coordinates -> String
toTranslate vector =
    let
        vectorRec =
            Vector2d.unwrap vector
    in
    "translate("
        ++ fromFloat vectorRec.x
        ++ ","
        ++ fromFloat vectorRec.y
        ++ ")"


{-| -}
toRotate : Int -> Point2d units coordinates -> String
toRotate degree point =
    let
        pointRec =
            Point2d.unwrap point
    in
    "rotate("
        ++ join ","
            [ fromInt degree
            , fromFloat pointRec.x
            , fromFloat pointRec.y
            ]
        ++ ")"


{-| -}
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
    in
    Svg.svg
        [ version "1.1"
        , class className
        , width (fromInt config.width ++ "px")
        , height (fromInt config.height ++ "px")
        , viewBox
            (String.join " "
                (List.map fromInt
                    [ 0, 0, config.width, config.height ]
                )
            )
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
