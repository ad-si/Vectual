module TimeUtils.TwelveHourClock exposing
    ( TwelveHourPeriod(..)
    , twelveHourPeriod
    )

{-| Definition of 12-Hour clock and AM/PM value for dates.

@docs TwelveHourPeriod
@docs twelveHourPeriod

-}

import Time exposing (..)


{-| 12-Hour clock abbreviations (AM/PM)
-}
type TwelveHourPeriod
    = AM
    | PM


{-| Common Posix to AM/PM value.
-}
twelveHourPeriod : Posix -> TwelveHourPeriod
twelveHourPeriod d =
    if toHour utc d < 12 then
        AM

    else
        PM
