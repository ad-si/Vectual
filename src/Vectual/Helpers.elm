module Vectual.Helpers exposing
    ( getDataLabels
    , getDataLength
    , getDataRecords
    , getDataValues
    , getMetaData
    , toRotate
    , toTranslate
    , utcDate
    , utcDateTime
    , utcWeek
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
@docs utcDate
@docs utcDateTime
@docs utcWeek
@docs wrapChart

-}

import Debug exposing (toString)
import Iso8601
import Point2d exposing (..)
import Quantity exposing (Unitless)
import String exposing (replace)
import Styles exposing (stylusString)
import StylusParser exposing (stylusToCss)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (..)
import Vector2d exposing (..)
import Vectual.Types exposing (..)



-- Formatter
--diffDays : Date -> Date -> Int
--diffDays date1 date2 =
--    if Compare.is Compare.After date1 date2 then
--        positiveDiffDays date1 date2 1
--    else
--        positiveDiffDays date2 date1 -1
--{-| Return number of days added to date1 to produce date2
---}
--positiveDiffDays : Date -> Date -> Int -> Int
--positiveDiffDays date1 date2 multiplier =
--    let
--        date1DaysFromCivil =
--            Internal.daysFromCivil
--                (Date.year date1)
--                (Core.monthToInt (Date.month date1))
--                (Date.day date1)
--        date2DaysFromCivil =
--            Internal.daysFromCivil
--                (Date.year date2)
--                (Core.monthToInt (Date.month date2))
--                (Date.day date2)
--    in
--    (date1DaysFromCivil - date2DaysFromCivil) * multiplier
--getYearIsoWeekDate date =
--    let
--        inputYear =
--            Date.year date
--        maxIsoWeekDateInYear =
--            Create.dateFromFields inputYear Date.Dec 29 0 0 0 0
--    in
--    if is SameOrAfter date maxIsoWeekDateInYear then
--        let
--            nextYearIsoWeek1Date =
--                isoWeekOne (inputYear + 1)
--        in
--        if is Before date nextYearIsoWeek1Date then
--            ( inputYear, isoWeekOne inputYear )
--        else
--            ( inputYear + 1, nextYearIsoWeek1Date )
--    else
--        let
--            thisYearIsoWeek1Date =
--                isoWeekOne inputYear
--        in
--        if is Before date thisYearIsoWeek1Date then
--            ( inputYear - 1, isoWeekOne (inputYear - 1) )
--        else
--            ( inputYear, thisYearIsoWeek1Date )
--{-| Return iso week values year, week, isoDayOfWeek.
--Input date is expected to be in local time zone of vm.
---}


isoWeek : Time.Posix -> ( Int, Int, Int )
isoWeek date =
    --let
    --    ( year, isoWeek1Date ) =
    --        getYearIsoWeekDate date
    --    daysSinceIsoWeek1 =
    --        diffDays date isoWeek1Date
    --in
    --( year
    --, (daysSinceIsoWeek1 // 7) + 1
    --, Core.isoDayOfWeek (Date.dayOfWeek date)
    --)
    ( 1, 2, 3 )


{-| -}
utcDateTime : Posix -> String
utcDateTime =
    Iso8601.fromTime
        >> String.slice 0 16
        >> replace "T" " "


{-| -}
utcDate : Posix -> String
utcDate =
    Iso8601.fromTime >> String.slice 0 10


{-| -}
utcWeek : Posix -> String
utcWeek =
    isoWeek
        >> (\( year, week, dayOfWeek ) ->
                toString year
                    ++ "-W"
                    ++ toString week
                    ++ "-"
                    ++ toString dayOfWeek
           )



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
            List.map toString (List.range 0 (List.length list - 1))

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
            { label = toString record.utc
            , value = record.value
            , offset = record.offset
            }

        keyRecordToEntry record =
            { label = record.key
            , value = record.value
            , offset = record.offset
            }

        valueToEntry index value =
            { label = toString index
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
    "translate" ++ (Vector2d.components vector |> toString)


{-| -}
toRotate : Int -> Point2d units coordinates -> String
toRotate degree point =
    "rotate"
        ++ toString
            ( degree
            , Point2d.xCoordinate point
            , Point2d.yCoordinate point
            )


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
        , width (toString config.width ++ "px")
        , height (toString config.height ++ "px")
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
            , y (toString (10 + 0.05 * Basics.toFloat config.height))
            , Svg.Attributes.style
                ("font-size:"
                    ++ toString (0.05 * Basics.toFloat config.height)
                    ++ "px"
                )
            ]
            [ text config.title ]
        ]
