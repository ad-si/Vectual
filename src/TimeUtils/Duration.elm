module TimeUtils.Duration exposing
    ( add
    , Duration(..)
    , DurationDeltaRecord
    , durationToString
    , zeroDelta
    , diff
    , diffDays
    , addMonth
    , addYear
    , deltaToString
    , positiveDiff
    , positiveDiffDays
    , requireDaylightCompensateInAdd
    )

{-| A Duration is a length of time that may vary with calendar date and time.
It can be used to modify a date.

Represents a period of time expressed in human chronological terms
in terms of a calendar which may have varying components based upon
the dates involved in the math.

When modify dates using Durations (`Day` | `Month` | `Week` | `Year`)
this module compensates for day light saving hour variations
to minimize the scenarios that cause the `Hour` field in the result
to be different to the input date.
It can't completely avoid the hour changing as some hours are not a real
world date and hence will modify the hour more than the Duration modified.

This behavior is modeled on moment.js so any observed behavior that is
not the same as moment.js should be raised as an issue.

Note adding or subtracting 24 \* Hour units from a date may produce a
different answer to adding or subtracting a Day if day light saving
transitions occur as part of the date change.

**Warning**

Be careful if you add Duration Delta to a Date as Duration contains months
and Years which are not fixed elapsed times like Period Delta
, however if
you really need a relative number of months or years then it may meet
your needs.

@docs add
@docs Duration
@docs DurationDeltaRecord
@docs durationToString
@docs zeroDelta
@docs diff
@docs diffDays

@docs addMonth
@docs addYear
@docs deltaToString
@docs positiveDiff
@docs positiveDiffDays
@docs requireDaylightCompensateInAdd

-}

-- import TimeUtilsCalendar as Calendar
-- import TimeUtils.Compare as Compare
-- import TimeUtils.Create as Create

import Time exposing (..)
import TimeUtils.Core as Core
import TimeUtils.Internal as Internal
import TimeUtils.Internal2 exposing (monthToInt)
import TimeUtils.Period as Period exposing (..)


{-| A Duration is time period that may vary with with calendar and time.

Using `Duration` adding 24 hours can produce different result to adding 1 day.

-}
type Duration
    = Millisecond
    | Second
    | Minute
    | Hour
    | Day
    | Week
    | Month
    | Year
    | Delta DurationDeltaRecord


{-| Convert a `Duration` to a `String`.
Especially helpful printing debugging information.
-}
durationToString : Duration -> String
durationToString dur =
    case dur of
        Millisecond ->
            "Millisecond"

        Second ->
            "Second"

        Minute ->
            "Minute"

        Hour ->
            "Hour"

        Day ->
            "Day"

        Week ->
            "Week"

        Month ->
            "Month"

        Year ->
            "Year"

        Delta durDeltaRec ->
            "Delta " ++ deltaToString durDeltaRec


{-| A multi granularity duration delta.
This does not contain week like Period.DeltaRecord.
It does contain month and year.
-}
type alias DurationDeltaRecord =
    { year : Int
    , month : Int
    , day : Int
    , hour : Int
    , minute : Int
    , second : Int
    , millisecond : Int
    }


{-| All zero delta.
Useful as a starting point if you want to set a few fields only.
-}
zeroDelta : DurationDeltaRecord
zeroDelta =
    { year = 0
    , month = 0
    , day = 0
    , hour = 0
    , minute = 0
    , second = 0
    , millisecond = 0
    }


{-| Convert a `DurationDeltaRecord` to a `String`
to easily display it during testing.
-}
deltaToString : DurationDeltaRecord -> String
deltaToString durDeltaRec =
    "{ year : "
        ++ String.fromInt durDeltaRec.year
        ++ "\n, month : "
        ++ String.fromInt durDeltaRec.month
        ++ "\n, day : "
        ++ String.fromInt durDeltaRec.day
        ++ "\n, hour : "
        ++ String.fromInt durDeltaRec.hour
        ++ "\n, minute : "
        ++ String.fromInt durDeltaRec.minute
        ++ "\n, second : "
        ++ String.fromInt durDeltaRec.second
        ++ "\n, millisecond : "
        ++ String.fromInt durDeltaRec.millisecond
        ++ "\n}"


{-| Return true if this Duration unit compensates
for crossing daylight saving boundaries.
TODO: This may need to compensate for day light saving
for all fields as all of them
can cause the date to change the zone offset.
-}
requireDaylightCompensateInAdd : Duration -> Bool
requireDaylightCompensateInAdd duration =
    case duration of
        Millisecond ->
            False

        Second ->
            False

        Minute ->
            False

        Hour ->
            False

        Day ->
            True

        Week ->
            True

        Month ->
            True

        Year ->
            True

        --  If day,month,year is non zero in Delta then compensate.
        Delta delta ->
            delta.day /= 0 || delta.month /= 0 || delta.year /= 0


{-| Add duration count to date.
-}
add : Duration -> Int -> Posix -> Posix
add duration addend date =
    let
        outputDate =
            doAdd duration addend date
    in
    if requireDaylightCompensateInAdd duration then
        daylightOffsetCompensate date outputDate

    else
        outputDate


doAdd : Duration -> Int -> Posix -> Posix
doAdd duration addend date =
    case duration of
        Millisecond ->
            Period.add Period.Millisecond addend date

        Second ->
            Period.add Period.Second addend date

        Minute ->
            Period.add Period.Minute addend date

        Hour ->
            Period.add Period.Hour addend date

        Day ->
            Period.add Period.Day addend date

        Week ->
            Period.add Period.Week addend date

        Month ->
            addMonth addend date

        Year ->
            addYear addend date

        Delta delta ->
            doAdd Year delta.year date
                |> doAdd Month delta.month
                |> Period.add
                    (Period.Delta
                        { week = 0
                        , day = delta.day
                        , hour = delta.hour
                        , minute = delta.minute
                        , second = delta.second
                        , millisecond = delta.millisecond
                        }
                    )
                    addend


daylightOffsetCompensate : Posix -> Posix -> Posix
daylightOffsetCompensate dateBefore dateAfter =
    let
        offsetBefore =
            Internal.getTimezoneOffset dateBefore

        offsetAfter =
            Internal.getTimezoneOffset dateAfter
    in
    -- this 'fix' can only happen if the date isnt allready shifted ?
    if offsetBefore /= offsetAfter then
        let
            adjustedDate =
                Period.add
                    Period.Millisecond
                    ((offsetAfter - offsetBefore) * Core.ticksAMinute)
                    dateAfter

            adjustedOffset =
                Internal.getTimezoneOffset adjustedDate
        in
        -- our timezone difference compensation caused us to leave the
        -- the after time zone this indicates we are falling in a place
        -- that is shifted by daylight saving so do not compensate
        if adjustedOffset /= offsetAfter then
            dateAfter

        else
            adjustedDate

    else
        dateAfter


{-| Return a date with month count added to date.
New version leveraging daysFromCivil does not loop
over months so faster and only compensates at outer
level for DST.
Expects input in local time zone.
Return is in local time zone.
-}
addMonth : Int -> Posix -> Posix
addMonth monthCount date =
    let
        year =
            toYear utc date

        monthInt =
            monthToInt (toMonth utc date)

        day =
            toDay utc date

        inputCivil =
            Internal.daysFromCivil year monthInt day

        newMonthInt =
            monthInt + monthCount

        targetMonthInt =
            remainderBy 12 newMonthInt

        yearOffset =
            if newMonthInt < 0 && targetMonthInt /= 0 then
                (newMonthInt // 12) - 1
                -- one extra year than the negative modulus

            else
                newMonthInt // 12

        newYear =
            year + yearOffset

        newDay =
            min (Core.daysInMonth newYear (Core.intToMonth newMonthInt)) day

        newCivil =
            Internal.daysFromCivil newYear targetMonthInt newDay

        daysDifferent =
            newCivil - inputCivil
    in
    Period.add Period.Day daysDifferent date


{-| Return a date with year count added to date.
-}
addYear : Int -> Posix -> Posix
addYear yearCount date =
    addMonth (12 * yearCount) date


{-| Return a `Period` representing date difference `date1 - date2`.
If you add the result of this function to `date2` with addend of 1
will not always return `date1`, this is because this module supports
human calendar concepts like Day Light Saving, Months with varying
number of days dependent on the month and leap years. So the difference
between two dates is dependent on when those dates are.
**Differences to `Period.diff`**

  - Duration `DurationDeltaRecord` excludes week field
  - Duration `DurationDeltaRecord` includes month field
  - Duration `DurationDeltaRecord` includes year field
  - Day is number of days difference between months.
    When adding a Duration `DurationDeltaRecord` to a date.
    The larger granularity fields are added before lower granularity fields
    so Years are added before Months before Days etc.
  - Very different behavior to Period diff
  - If date1 > date2
    then all fields in `DurationDeltaRecord`
    will be positive or zero.
  - If date1 < date2
    then all fields in `DurationDeltaRecord`
    will be negative or zero.
  - Because it deals with non fixed length periods of time
    Example 1.
    days in 2016-05 (May) = 31
    days in 2016-04 (Apr) = 30
    days in 2016-03 (Mar) = 31
    days in 2015-03 (Mar) = 31
    diff of "2016-05-15" "2015-03-20"
    result naive field diff.
    year 1, month 2, day -5
    days "2015-03-20" to "2015-04-01" (31 - 20) = 11 days (12).
    still in march with 11.
    days "2015-04-01" to "2016-04-15" (15 - 1) = 14 days
    months "2016-04-15" to "2016-05-15" 1 months
    result field diff
    year 1, month 1, day 26
    This logic applies all the way down to milliseconds.

-}
diff : Posix -> Posix -> DurationDeltaRecord
diff date1 date2 =
    if posixToMillis date1 < posixToMillis date2 then
        positiveDiff date1 date2 1

    else
        positiveDiff date2 date1 -1


{-| Return diff between dates.
It returns `date1 - date2` in a `DurationDeltaRecord`.
Precondition for this function is `date1` must be after `date2`.
Input multiplier is used to multiply output fields as needed for caller,
this is used to conditionally negate them in initial use case.
-}
positiveDiff : Posix -> Posix -> Int -> DurationDeltaRecord
positiveDiff date1 date2 multiplier =
    let
        year1 =
            toYear utc date1

        year2 =
            toYear utc date2

        month1Mon =
            toMonth utc date1

        month2Mon =
            toMonth utc date2

        month1 =
            Core.monthToInt month1Mon

        month2 =
            Core.monthToInt month2Mon

        day1 =
            toDay utc date1

        day2 =
            toDay utc date2

        hour1 =
            toHour utc date1

        hour2 =
            toHour utc date2

        minute1 =
            toMinute utc date1

        minute2 =
            toMinute utc date2

        second1 =
            toSecond utc date1

        second2 =
            toSecond utc date2

        msec1 =
            toMillis utc date1

        msec2 =
            toMillis utc date2

        accumulatedDiff acc v1 v2 maxV2 =
            if v1 < v2 then
                ( acc - 1, maxV2 + v1 - v2 )

            else
                ( acc, v1 - v2 )

        daysInDate1Month =
            Core.daysInMonth year1 month1Mon

        daysInDate2Month =
            Core.daysInMonth year2 month2Mon

        ( yearDiff, monthDiffA ) =
            accumulatedDiff (year1 - year2) month1 month2 12

        ( monthDiff, dayDiffA ) =
            accumulatedDiff monthDiffA day1 day2 daysInDate2Month

        ( dayDiff, hourDiffA ) =
            accumulatedDiff dayDiffA hour1 hour2 24

        ( hourDiff, minuteDiffA ) =
            accumulatedDiff hourDiffA minute1 minute2 60

        ( minuteDiff, secondDiffA ) =
            accumulatedDiff minuteDiffA second1 second2 60

        ( secondDiff, msecDiff ) =
            accumulatedDiff secondDiffA msec1 msec2 1000

        -- Need to carry negative differences to next higher unit
        -- to make all differences output positive.
        propogateCarry current carry maxVal =
            let
                adjusted =
                    current + carry
            in
            if adjusted < 0 then
                ( maxVal + adjusted, -1 )

            else
                ( adjusted, 0 )

        ( msecX, secondCarry ) =
            propogateCarry msecDiff 0 1000

        ( secondX, minuteCarry ) =
            propogateCarry secondDiff secondCarry 60

        ( minuteX, hourCarry ) =
            propogateCarry minuteDiff minuteCarry 60

        ( hourX, dayCarry ) =
            propogateCarry hourDiff hourCarry 60

        -- if `dayDiff + dayCarry` is negative
        --    then add days in `date1` month to make `dayDiff` positive
        --    and carry Month negative
        ( dayX, monthCarry ) =
            propogateCarry dayDiff dayCarry daysInDate1Month

        ( monthX, yearCarry ) =
            propogateCarry monthDiff monthCarry 12

        -- `maxVal` parameter no effect for year
        ( yearX, _ ) =
            propogateCarry yearDiff yearCarry 0
    in
    { year = yearX * multiplier
    , month = monthX * multiplier
    , day = dayX * multiplier
    , hour = hourX * multiplier
    , minute = minuteX * multiplier
    , second = secondX * multiplier
    , millisecond = msecX * multiplier
    }


{-| Returns `date1 - date2` as number of days
to add to `date1` to get to day `date2` is on.
`date1 - date2 in days`.
Only calculates days difference
and ignores any field smaller than day in calculation.
-}
diffDays : Posix -> Posix -> Int
diffDays date1 date2 =
    if compare (posixToMillis date1) (posixToMillis date2) == GT then
        positiveDiffDays date1 date2 1

    else
        positiveDiffDays date2 date1 -1


{-| Return number of days added to `date1` to produce `date2`
-}
positiveDiffDays : Posix -> Posix -> Int -> Int
positiveDiffDays date1 date2 multiplier =
    let
        date1DaysFromCivil =
            Internal.daysFromCivil
                (toYear utc date1)
                (Core.monthToInt (toMonth utc date1))
                (toDay utc date1)

        date2DaysFromCivil =
            Internal.daysFromCivil
                (toYear utc date2)
                (Core.monthToInt (toMonth utc date2))
                (toDay utc date2)
    in
    (date1DaysFromCivil - date2DaysFromCivil) * multiplier
