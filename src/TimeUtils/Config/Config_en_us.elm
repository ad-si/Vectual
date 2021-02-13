module TimeUtils.Config.Config_en_us exposing
    ( config
    , dayName
    )

{-| This is the default english config for formatting dates.

@docs config
@docs dayName

-}

import String
import Time exposing (..)
import TimeUtils.Config as Config
import TimeUtils.TwelveHourClock exposing (..)


{-| Day short name.
-}
dayShort : Weekday -> String
dayShort day =
    case day of
        Mon ->
            "Mon"

        Tue ->
            "Tue"

        Wed ->
            "Wed"

        Thu ->
            "Thu"

        Fri ->
            "Fri"

        Sat ->
            "Sat"

        Sun ->
            "Sun"


{-| Day full name.
-}
dayName : Weekday -> String
dayName day =
    case day of
        Mon ->
            "Monday"

        Tue ->
            "Tuesday"

        Wed ->
            "Wednesday"

        Thu ->
            "Thursday"

        Fri ->
            "Friday"

        Sat ->
            "Saturday"

        Sun ->
            "Sunday"


{-| Month short name.
-}
monthShort : Month -> String
monthShort month =
    case month of
        Jan ->
            "Jan"

        Feb ->
            "Feb"

        Mar ->
            "Mar"

        Apr ->
            "Apr"

        May ->
            "May"

        Jun ->
            "Jun"

        Jul ->
            "Jul"

        Aug ->
            "Aug"

        Sep ->
            "Sep"

        Oct ->
            "Oct"

        Nov ->
            "Nov"

        Dec ->
            "Dec"


{-| Month full name.
-}
monthName : Month -> String
monthName month =
    case month of
        Jan ->
            "January"

        Feb ->
            "February"

        Mar ->
            "March"

        Apr ->
            "April"

        May ->
            "May"

        Jun ->
            "June"

        Jul ->
            "July"

        Aug ->
            "August"

        Sep ->
            "September"

        Oct ->
            "October"

        Nov ->
            "November"

        Dec ->
            "December"


{-| Returns a common english idiom for days of month.
Pad indicates space pad the day of month value so single
digit outputs have space padding to make them same
length as double digit days of monnth.
-}
dayOfMonthWithSuffix : Bool -> Int -> String
dayOfMonthWithSuffix pad day =
    let
        value =
            case day of
                1 ->
                    "1st"

                21 ->
                    "21st"

                2 ->
                    "2nd"

                22 ->
                    "22nd"

                3 ->
                    "3rd"

                23 ->
                    "23rd"

                31 ->
                    "31st"

                _ ->
                    String.fromInt day ++ "th"
    in
    if pad then
        String.padLeft 4 ' ' value

    else
        value


twelveHourPeriod : TwelveHourPeriod -> String
twelveHourPeriod period =
    case period of
        AM ->
            "AM"

        PM ->
            "PM"


{-| Config for en-us.
-}
config : Config.Config
config =
    { i18n =
        { dayShort = dayShort
        , dayName = dayName
        , monthShort = monthShort
        , monthName = monthName
        , dayOfMonthWithSuffix = dayOfMonthWithSuffix
        , twelveHourPeriod = twelveHourPeriod
        }
    , format =
        { date = "%Y-%-m-%-d"
        , longDate = "%Y %B %d %A"
        , time = "%-I:%M %p" -- h:mm tt
        , longTime = "%-I:%M:%S %p" -- h:mm:ss tt
        , dateTime = "%Y-%-m-%-d %-I:%M %p" -- date + time
        , firstDayOfWeek = Time.Mon
        }
    }
