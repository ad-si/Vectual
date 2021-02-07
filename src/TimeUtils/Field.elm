module TimeUtils.Field exposing
    ( fieldToDate
    , fieldToDateClamp
    , Field(..)
    , fieldToString
    )

{-| Setting a date field on a date.

@docs fieldToDate
@docs fieldToDateClamp
@docs Field
@docs fieldToString

-}

import Time exposing (..)
import TimeUtils.Core as Core
import TimeUtils.Duration as Duration


{-| Configured Field and Value to set on date.

All field values are applied Modulus there maximum value.

  - DayOfWeek
      - The week keeps the same start of week day as passed in and changes day.
  - Month
      - Will not change year only the month of year.

-}
type Field
    = Millisecond Int
    | Second Int
    | Minute Int
    | Hour Int
    | DayOfWeek ( Weekday, Weekday ) -- (Target Day, Start of Weekday)
    | DayOfMonth Int
    | Month Month
    | Year Int


{-| -}
fieldToString : Field -> String
fieldToString field =
    case field of
        Millisecond int ->
            "Millisecond Int"

        Second int ->
            "Second Int"

        Minute int ->
            "Minute Int"

        Hour int ->
            "Hour Int"

        DayOfWeek ( wd1, wd2 ) ->
            "DayOfWeek ( Weekday, Weekday )"

        DayOfMonth int ->
            "DayOfMonth Int"

        Month month ->
            "Month Month"

        Year int ->
            "Year Int"


{-| Set a field on a date to a specific value.

If your value in field is out side of valid range for
the date field this function will return Nothing.

  - DayOfWeek cannot be invalid input range
  - Month cannot be invalid

Valid ranges

  - Millisecond 0 to 999
  - Second 0 to 59
  - Minute 0 to 59
  - Hour 0 to 23
  - DayOfMonth 1 to max day of month for year
  - Year >= 0

-}
fieldToDate : Field -> Posix -> Maybe Posix
fieldToDate field date =
    case field of
        Millisecond millisecond ->
            if millisecond < 0 || millisecond > 999 then
                Nothing

            else
                Just <| Duration.add Duration.Millisecond (millisecond - toMillis utc date) date

        Second second ->
            if second < 0 || second > 59 then
                Nothing

            else
                Just <| Duration.add Duration.Second (second - toSecond utc date) date

        Minute minute ->
            if minute < 0 || minute > 59 then
                Nothing

            else
                Just <| Duration.add Duration.Minute (minute - toMinute utc date) date

        Hour hour ->
            if hour < 0 || hour > 23 then
                Nothing

            else
                Just <| Duration.add Duration.Hour (hour - toHour utc date) date

        -- Inputs can't be out of range so Nothing is never returned
        DayOfWeek ( newDayOfWeek, startOfWeekDay ) ->
            -- Just date
            Just <| dayOfWeekToDate newDayOfWeek startOfWeekDay date

        DayOfMonth day ->
            let
                maxDays =
                    Core.daysInMonthDate date
            in
            if day < 1 || day > maxDays then
                Nothing

            else
                Just <| Duration.add Duration.Day (day - toDay utc date) date

        -- Inputs can't be out of range so Nothing is never returned.
        Month month ->
            Just <| monthToDate month date

        Year year ->
            if year < 0 then
                Nothing

            else
                Just <| Duration.add Duration.Year (year - toYear utc date) date


monthToDate : Month -> Posix -> Posix
monthToDate month date =
    let
        targetMonthInt =
            Core.monthToInt month

        monthInt =
            Core.monthToInt (toMonth utc date)
    in
    Duration.add Duration.Month (targetMonthInt - monthInt) date


dayOfWeekToDate : Weekday -> Weekday -> Posix -> Posix
dayOfWeekToDate newDayOfWeek startOfWeekDay date =
    let
        dayOfWeek =
            toWeekday utc date

        daysToStartOfWeek =
            Core.daysBackToStartOfWeek dayOfWeek startOfWeekDay

        targetIsoDay =
            Core.isoDayOfWeek newDayOfWeek

        isoDay =
            Core.isoDayOfWeek dayOfWeek

        dayDiff =
            targetIsoDay - isoDay

        adjustedDiff =
            if (daysToStartOfWeek + dayDiff) < 0 then
                dayDiff + 7

            else
                dayDiff
    in
    Duration.add Duration.Day adjustedDiff date


{-| Set a field on a date to a specific value.

This version clamps any input Field values to valid ranges as
described in the doc for fieldToDate function.

-}
fieldToDateClamp : Field -> Posix -> Posix
fieldToDateClamp field date =
    case field of
        Millisecond millisecond ->
            Duration.add Duration.Millisecond (clamp 0 999 millisecond - toMillis utc date) date

        Second second ->
            Duration.add Duration.Second (clamp 0 59 second - toSecond utc date) date

        Minute minute ->
            Duration.add Duration.Minute (clamp 0 59 minute - toMinute utc date) date

        Hour hour ->
            Duration.add Duration.Hour (clamp 0 23 hour - toHour utc date) date

        DayOfWeek ( newDayOfWeek, startOfWeekDay ) ->
            dayOfWeekToDate newDayOfWeek startOfWeekDay date

        DayOfMonth day ->
            let
                maxDays =
                    Core.daysInMonthDate date
            in
            Duration.add Duration.Day (clamp 1 maxDays day - toDay utc date) date

        Month month ->
            monthToDate month date

        Year year ->
            let
                minYear =
                    if year < 0 then
                        0

                    else
                        year
            in
            Duration.add Duration.Year (minYear - toYear utc date) date
