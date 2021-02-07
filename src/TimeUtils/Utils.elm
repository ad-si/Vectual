module TimeUtils.Utils exposing
    ( dayList
    , isoWeek
    , isoWeekOne
    )

{-|


# Time Utils


## Utility

@docs dayList
@docs isoWeek
@docs isoWeekOne

-}

import Regex
import String
import Time exposing (..)
import TimeExtra exposing (..)
import TimeUtils.Compare as Compare exposing (Compare2(..), is)
import TimeUtils.Core as Core
import TimeUtils.Create as Create
import TimeUtils.Duration as Duration
import TimeUtils.TimeUnit as TimeUnit


{-| Return a list of days dayLength long for successive days
starting from startDate.

Now adds 1 day if dayCount is +ve to create day list.
Now subtracts 1 day if dayCount is -ve to create day list.

This could be made much faster by using `daysFromCivil`
and not using underlying date system at all I believe.

-}
dayList : Int -> Posix -> List Posix
dayList dayCount startDate =
    List.reverse (dayList_ dayCount startDate [])


dayList_ : Int -> Posix -> List Posix -> List Posix
dayList_ dayCount date list =
    if dayCount == 0 then
        list

    else if dayCount > 0 then
        dayList_
            (dayCount - 1)
            (Duration.add Duration.Day 1 date)
            (date :: list)

    else
        dayList_
            (dayCount + 1)
            (Duration.add Duration.Day -1 date)
            (date :: list)


{-| Return ISO week values `year`, `week`, `isoDayOfWeek`.
Input date is expected to be in local time zone of vm.
-}
isoWeek : Posix -> ( Int, Int, Int )
isoWeek date =
    let
        ( year, isoWeek1Date ) =
            getYearIsoWeekDate date

        daysSinceIsoWeek1 =
            Duration.diffDays date isoWeek1Date
    in
    ( year
    , (daysSinceIsoWeek1 // 7) + 1
    , Core.isoDayOfWeek (toWeekday utc date)
    )


{-| Return year of ISO week date
(which can be different than the normal calendar year)
and the timestamp of the first ISO week.
-}
getYearIsoWeekDate : Posix -> ( Int, Posix )
getYearIsoWeekDate date =
    let
        inputYear =
            toYear utc date

        maxIsoWeekDateInYear =
            fromYMD inputYear Dec 29
    in
    if is SameOrAfter date maxIsoWeekDateInYear then
        let
            nextYearIsoWeek1Date =
                isoWeekOne (inputYear + 1)
        in
        if is Before date nextYearIsoWeek1Date then
            ( inputYear, isoWeekOne inputYear )

        else
            ( inputYear + 1, nextYearIsoWeek1Date )

    else
        let
            thisYearIsoWeek1Date =
                isoWeekOne inputYear
        in
        if is Before date thisYearIsoWeek1Date then
            ( inputYear - 1, isoWeekOne (inputYear - 1) )

        else
            ( inputYear, thisYearIsoWeek1Date )


{-| Return date of start of ISO week one for given year.
-}
isoWeekOne : Int -> Posix
isoWeekOne year =
    let
        dateJan4 =
            fromYMD year Jan 4
    in
    Duration.add
        Duration.Day
        (Core.isoDayOfWeek Mon - Core.isoDayOfWeek (toWeekday utc dateJan4))
        dateJan4
