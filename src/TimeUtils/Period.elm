module TimeUtils.Period exposing
    ( add
    , diff
    , Period(..)
    , PeriodDeltaRecord
    , periodToString
    , zeroDelta
    , toTicks
    , addTimeUnit
    )

{-| Period is a fixed length of time. It is an elapsed time concept, which
does not include the concept of Years Months or Daylight saving variations.

  - Represents a fixed (and calendar-independent) length of time.

Name of type concept copied from NodaTime.

@docs add
@docs diff
@docs Period
@docs PeriodDeltaRecord
@docs periodToString
@docs zeroDelta
@docs toTicks
@docs addTimeUnit

-}

import Time exposing (..)
import TimeUtils.Internal2 exposing (..)


{-| A Period.

Week is a convenience for users if they want to use it, it does
just scale Day in functionality so is not strictly required.

`PeriodDeltaRecord` values are multiplied addend on application.

-}
type Period
    = Millisecond
    | Second
    | Minute
    | Hour
    | Day
    | Week
    | Delta PeriodDeltaRecord


{-| A multi granularity period delta.
-}
type alias PeriodDeltaRecord =
    { week : Int
    , day : Int
    , hour : Int
    , minute : Int
    , second : Int
    , millisecond : Int
    }


{-| All zero delta.
Useful as a starting point if you want to set a few fields only.
-}
zeroDelta : PeriodDeltaRecord
zeroDelta =
    { week = 0
    , day = 0
    , hour = 0
    , minute = 0
    , second = 0
    , millisecond = 0
    }


{-| Return tick counts for periods.
Useful to get total ticks in a Delta.
-}
toTicks : Period -> Int
toTicks period =
    case period of
        Millisecond ->
            ticksAMillisecond

        Second ->
            ticksASecond

        Minute ->
            ticksAMinute

        Hour ->
            ticksAnHour

        Day ->
            ticksADay

        Week ->
            ticksAWeek

        Delta delta ->
            (ticksAMillisecond * delta.millisecond)
                + (ticksASecond * delta.second)
                + (ticksAMinute * delta.minute)
                + (ticksAnHour * delta.hour)
                + (ticksADay * delta.day)
                + (ticksAWeek * delta.week)


{-| -}
periodToString : Period -> String
periodToString period =
    case period of
        Millisecond ->
            "TODO Millisecond"

        Second ->
            "TODO Second"

        Minute ->
            "TODO Minute"

        Hour ->
            "TODO Hour"

        Day ->
            "TODO Day"

        Week ->
            "TODO Week"

        Delta _ ->
            "TODO Delta"


{-| Add Period count to date.
-}
add : Period -> Int -> Posix -> Posix
add period =
    addTimeUnit (toTicks period)


{-| Add time units.
-}
addTimeUnit : Int -> Int -> Posix -> Posix
addTimeUnit unit addend date =
    date
        |> posixToMillis
        |> (+) (addend * unit)
        |> millisToPosix


{-| Return a Period representing date difference. date1 - date2.
If you add the result of this function to date2 with addend of 1
will return date1.
-}
diff : Posix -> Posix -> PeriodDeltaRecord
diff date1 date2 =
    let
        ticksDiff =
            posixToMillis date1 - posixToMillis date2

        hourDiff =
            toHour utc date1 - toHour utc date2

        minuteDiff =
            toMinute utc date1 - toMinute utc date2

        secondDiff =
            toSecond utc date1 - toSecond utc date2

        millisecondDiff =
            toMillis utc date1 - toMillis utc date2

        ticksDayDiff =
            ticksDiff
                - (hourDiff * ticksAnHour)
                - (minuteDiff * ticksAMinute)
                - (secondDiff * ticksASecond)
                - (millisecondDiff * ticksAMillisecond)

        onlyDaysDiff =
            ticksDayDiff // ticksADay

        ( weekDiff, dayDiff ) =
            if onlyDaysDiff < 0 then
                let
                    absDayDiff =
                        abs onlyDaysDiff
                in
                ( negate (absDayDiff // 7)
                , negate (remainderBy 7 absDayDiff)
                )

            else
                ( onlyDaysDiff // 7
                , remainderBy 7 onlyDaysDiff
                )
    in
    { week = weekDiff
    , day = dayDiff
    , hour = hourDiff
    , minute = minuteDiff
    , second = secondDiff
    , millisecond = millisecondDiff
    }
