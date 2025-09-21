module TimeUtils.Format exposing
    ( format
    , formatUtc
    , formatOffset
    , isoString
    , isoStringNoOffset
    , utcIsoString
    , isoDateString
    , utcIsoDateString
    , isoFormat
    , isoMsecFormat
    , isoOffsetFormat
    , isoMsecOffsetFormat
    , isoDateFormat
    , isoTimeFormat
    )

{-| Date Format, turning dates into strings.

The format code originally came from and was modified and extended from.
<https://github.com/mgold/elm-date-format/blob/1.0.4/src/Date/Format.elm>


## Date presentation

@docs format
@docs formatUtc
@docs formatOffset


## Extra presentation convenience

@docs isoString
@docs isoStringNoOffset
@docs utcIsoString


## Low level formats used in specific places in library.

@docs isoDateString
@docs utcIsoDateString


## Useful strings for format

@docs isoFormat
@docs isoMsecFormat
@docs isoOffsetFormat
@docs isoMsecOffsetFormat
@docs isoDateFormat
@docs isoTimeFormat

-}

import Regex
import String exposing (fromInt, padLeft, right)
import Time exposing (..)
import TimeUtils.Config as Config
import TimeUtils.Config.Config_en_us as English
import TimeUtils.Core as Core
import TimeUtils.Create as Create
import TimeUtils.Internal as Internal
import TimeUtils.TwelveHourClock exposing (twelveHourPeriod)
import TimeUtils.Utils as Utils


{-| ISO date time, 24hr.
-}
isoFormat : String
isoFormat =
    "%Y-%m-%dT%H:%M:%S"


{-| ISO Date time with milliseconds, 24hr.
-}
isoMsecFormat : String
isoMsecFormat =
    "%Y-%m-%dT%H:%M:%S.%L"


{-| ISO Date time with timezone, 24hr.
-}
isoOffsetFormat : String
isoOffsetFormat =
    "%Y-%m-%dT%H:%M:%S%z"


{-| ISO Date time with milliseconds and timezone, 24hr.
-}
isoMsecOffsetFormat : String
isoMsecOffsetFormat =
    "%Y-%m-%dT%H:%M:%S.%L%:z"


{-| ISO Date.
-}
isoDateFormat : String
isoDateFormat =
    "%Y-%m-%d"


{-| ISO Time 24hr.
-}
isoTimeFormat : String
isoTimeFormat =
    "%H:%M:%S"


month : Posix -> String
month date =
    padLeft 2 '0' <| fromInt (Core.monthToInt (toMonth utc date))


monthMonth : Month -> String
monthMonth m =
    padLeft 2 '0' <| fromInt (Core.monthToInt m)


year : Posix -> String
year date =
    padLeft 4 '0' <| fromInt (toYear utc date)


yearInt : Int -> String
yearInt y =
    padLeft 4 '0' <| fromInt y


{-| Return date and time as string in local zone.
-}
isoString : Posix -> String
isoString =
    format English.config isoMsecOffsetFormat


{-| Return date and time as string in local zone, without
a timezone offset as output by `Format.isoString`.
Introduced to deal with dates assuming local time zone.
-}
isoStringNoOffset : Posix -> String
isoStringNoOffset =
    format English.config isoMsecFormat


{-| Return date and time as string in ISO form with Z for UTC offset.
-}
utcIsoString : Posix -> String
utcIsoString date =
    formatUtc English.config isoMsecFormat date ++ "Z"


{-| Utc variant of isoDateString.

Low level routine required by areas like checkDateResult to avoid
recursive loops in Format.format.

-}
utcIsoDateString : Posix -> String
utcIsoDateString date =
    isoDateString (Internal.hackDateAsUtc date)


{-| Return date as string.

Low level routine required by areas like checkDateResult to avoid
recursive loops in Format.format.

-}
isoDateString : Posix -> String
isoDateString date =
    let
        theYear =
            toYear utc date

        theMonth =
            toMonth utc date

        theDay =
            toDay utc date
    in
    String.padLeft 4 '0' (fromInt theYear)
        ++ "-"
        ++ String.padLeft 2 '0' (fromInt (Core.monthToInt theMonth))
        ++ "-"
        ++ String.padLeft 2 '0' (fromInt theDay)


{-| Date formatter.

Initially from <https://github.com/mgold/elm-date-format/blob/1.0.4/src/Date/Format.elm>.

-}
formatRegex : Regex.Regex
formatRegex =
    Maybe.withDefault Regex.never
        (Regex.fromString
            ("%(y|Y|m|_m|-m|B|^B|b|^b|d|-d|-@d|e|@e|A|^A|a|^a|"
                ++ "H|-H|k|I|-I|l|p|P|M|S|%|L|z|:z|G|V|-V|u)"
            )
        )


{-| Use a format string to format a date.
This gets time zone offset from provided date.
-}
format : Config.Config -> String -> Posix -> String
format config formatStr date =
    formatOffset config (Create.getTimezoneOffset date) formatStr date


{-| Convert date to utc then format it with offset set to 0 if rendered.
-}
formatUtc : Config.Config -> String -> Posix -> String
formatUtc config formatStr date =
    formatOffset config 0 formatStr date


{-| This adjusts date for offset, and renders with the offset
-}
formatOffset : Config.Config -> Int -> String -> Posix -> String
formatOffset config targetOffset formatStr date =
    let
        dateOffset =
            Create.getTimezoneOffset date

        hackOffset =
            dateOffset - targetOffset
    in
    Regex.replace
        formatRegex
        (formatToken
            config
            targetOffset
            (Internal.hackDateAsOffset hackOffset date)
        )
        formatStr


formatToken : Config.Config -> Int -> Posix -> Regex.Match -> String
formatToken config offset d m =
    let
        symbol =
            List.head m.submatches
                |> collapse
                |> Maybe.withDefault " "
    in
    case symbol of
        "Y" ->
            d |> toYear utc |> padWithN 4 '0'

        "y" ->
            d |> toYear utc |> padWithN 2 '0' |> right 2

        "m" ->
            d |> toMonth utc |> Core.monthToInt |> padWith '0'

        "_m" ->
            d |> toMonth utc |> Core.monthToInt |> padWith ' '

        "-m" ->
            d |> toMonth utc |> Core.monthToInt |> fromInt

        "B" ->
            d |> toMonth utc |> config.i18n.monthName

        "^B" ->
            d |> toMonth utc |> config.i18n.monthName |> String.toUpper

        "b" ->
            d |> toMonth utc |> config.i18n.monthShort

        "^b" ->
            d |> toMonth utc |> config.i18n.monthShort |> String.toUpper

        "d" ->
            d |> toDay utc |> padWith '0'

        "-d" ->
            d |> toDay utc |> fromInt

        "-@d" ->
            d |> toDay utc |> config.i18n.dayOfMonthWithSuffix False

        "e" ->
            d |> toDay utc |> padWith ' '

        "@e" ->
            d |> toDay utc |> config.i18n.dayOfMonthWithSuffix True

        "A" ->
            d |> toWeekday utc |> config.i18n.dayName

        "^A" ->
            d |> toWeekday utc |> config.i18n.dayName |> String.toUpper

        "a" ->
            d |> toWeekday utc |> config.i18n.dayShort

        "^a" ->
            d |> toWeekday utc |> config.i18n.dayShort |> String.toUpper

        "H" ->
            d |> toHour utc |> padWith '0'

        "-H" ->
            d |> toHour utc |> fromInt

        "k" ->
            d |> toHour utc |> padWith ' '

        "I" ->
            d |> toHour utc |> hourMod12 |> padWith '0'

        "-I" ->
            d |> toHour utc |> hourMod12 |> fromInt

        "l" ->
            d |> toHour utc |> hourMod12 |> padWith ' '

        "p" ->
            d
                |> twelveHourPeriod
                |> config.i18n.twelveHourPeriod
                |> String.toUpper

        "P" ->
            d |> twelveHourPeriod |> config.i18n.twelveHourPeriod

        "M" ->
            d |> toMinute utc |> padWith '0'

        "S" ->
            d |> toSecond utc |> padWith '0'

        "L" ->
            d |> toMillis utc |> padWithN 3 '0'

        "%" ->
            symbol

        "z" ->
            formatOffsetStr "" offset

        ":z" ->
            formatOffsetStr ":" offset

        "G" ->
            case Utils.isoWeek d of
                ( isoYear, _, _ ) ->
                    isoYear |> padWithN 3 '0'

        "V" ->
            case Utils.isoWeek d of
                ( _, isoWeek, _ ) ->
                    isoWeek |> padWith '0'

        "-V" ->
            case Utils.isoWeek d of
                ( _, isoWeek, _ ) ->
                    isoWeek |> fromInt

        "u" ->
            case Utils.isoWeek d of
                ( _, _, isoDow ) ->
                    isoDow |> fromInt

        _ ->
            ""


collapse : Maybe (Maybe a) -> Maybe a
collapse m =
    m |> Maybe.andThen identity


formatOffsetStr : String -> Int -> String
formatOffsetStr betweenHoursMinutes offset =
    let
        ( hour, minute ) =
            toHourMin (abs offset)
    in
    (if offset <= 0 then
        "+"
        -- "+" is displayed for negative offset.

     else
        "-"
    )
        ++ padWith '0' hour
        ++ betweenHoursMinutes
        ++ padWith '0' minute


hourMod12 h =
    if remainderBy 12 h == 0 then
        12

    else
        remainderBy 12 h


padWith : Char -> Int -> String
padWith c =
    padLeft 2 c << fromInt


padWithN : Int -> Char -> Int -> String
padWithN n c =
    padLeft n c << fromInt


{-| Return time zone offset in Hours and Minutes from minutes.
-}
toHourMin : Int -> ( Int, Int )
toHourMin offsetMinutes =
    ( offsetMinutes // 60, remainderBy 60 offsetMinutes )
