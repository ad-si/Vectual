module TimeUtils.Time exposing
    ( daysInMonth
    , isLeapYear
    , isoDayOfWeek
    , monthToInt
    , utcDateTime
    , utcWeek
    )

{-| Helpers for working with elm/lang's Posix data type
(Mostly copied from
<https://package.elm-lang.org/packages/rluiten/elm-TimeUtils>)

@docs daysInMonth
@docs isLeapYear
@docs isoDayOfWeek
@docs monthToInt
@docs utcDateTime
@docs utcWeek

-}

import Iso8601 exposing (fromTime)
import String exposing (fromFloat, fromInt, join, replace)
import Time exposing (..)
import TimeExtra exposing (..)
import TimeUtils.Core as Core
import TimeUtils.Duration as Duration exposing (..)
import TimeUtils.Utils as Utils exposing (..)


{-| Return the ISO day of the week. From Monday == 1, to Sunday == 7.
-}
isoDayOfWeek : Weekday -> Int
isoDayOfWeek day =
    case day of
        Mon ->
            1

        Tue ->
            2

        Wed ->
            3

        Thu ->
            4

        Fri ->
            5

        Sat ->
            6

        Sun ->
            7


{-| Return the ISO number of each month [1-12].
-}
monthToInt : Month -> Int
monthToInt month =
    case month of
        Jan ->
            1

        Feb ->
            2

        Mar ->
            3

        Apr ->
            4

        May ->
            5

        Jun ->
            6

        Jul ->
            7

        Aug ->
            8

        Sep ->
            9

        Oct ->
            10

        Nov ->
            11

        Dec ->
            12


{-| Return `True` if year is a leap year.
-}
isLeapYear : Int -> Bool
isLeapYear year =
    ((remainderBy 4 year == 0) && (remainderBy 100 year /= 0))
        || (remainderBy 400 year == 0)


{-| Return days in month for year and month.
-}
daysInMonth : Int -> Month -> Int
daysInMonth year month =
    case month of
        Feb ->
            if isLeapYear year then
                29

            else
                28

        Apr ->
            30

        Jun ->
            30

        Sep ->
            30

        Nov ->
            30

        _ ->
            31


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
                fromInt year
                    ++ "-W"
                    ++ String.padLeft 2 '0' (fromInt week)
                    ++ "-"
                    ++ fromInt dayOfWeek
           )
