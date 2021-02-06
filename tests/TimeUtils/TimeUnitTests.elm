module TimeUtils.TimeUnitTests exposing (..)

import Expect
import Test exposing (..)
import Time exposing (..)
import TimeUtils.Duration as Duration
import TimeUtils.Format as Format
import TimeUtils.TimeUnit as TimeUnit exposing (TimeUnit(..), timeUnitToString)
import TimeUtils.Utils as DateUtils
import UtilsForTesting as TestUtils


tests : Test
tests =
    describe "TimeUnit tests" <|
        [ describe "TimeUnit.startOfTime tests" <|
            List.map runStartOfTimeCase startOfTimeCases
        , describe "TimeUnit.endOfTime tests" <|
            List.map runEndOfTimeCase endOfTimeCases
        ]


runStartOfTimeCase : ( String, TimeUnit, String ) -> Test
runStartOfTimeCase ( dateStr, timeUnit, expectedDate ) =
    let
        inputDate =
            TestUtils.fudgeDate dateStr

        dateOut =
            TimeUnit.startOfTime timeUnit inputDate

        dateOutStr =
            Format.isoStringNoOffset dateOut
    in
    skip <|
        test
            ("unit "
                ++ timeUnitToString timeUnit
                ++ " on "
                ++ dateStr
                ++ "."
            )
        <|
            \() -> Expect.equal expectedDate dateOutStr


type StartOfTimeCase
    = StartOfTimeCase String Int String


startOfTimeCases : List ( String, TimeUnit, String )
startOfTimeCases =
    [ ( "2016-06-05 04:03:02.111", Millisecond, "2016-06-05T04:03:02.111" )
    , ( "2016-06-05 04:03:02.111", Second, "2016-06-05T04:03:02.000" )
    , ( "2016-06-05 04:03:02.111", Minute, "2016-06-05T04:03:00.000" )
    , ( "2016-06-05 04:03:02.111", Hour, "2016-06-05T04:00:00.000" )
    , ( "2016-06-05 04:03:02.111", Day, "2016-06-05T00:00:00.000" )
    , ( "2016-06-05 23:03:02.111", Day, "2016-06-05T00:00:00.000" )

    --
    , ( "2016-06-05 04:03:02.111", Month, "2016-06-01T00:00:00.000" )
    , ( "2016-06-05 04:03:02.111", Year, "2016-01-01T00:00:00.000" )

    -- Verify dates before 1970
    -- as their internal tick representation is negative.
    , ( "1965-01-02 03:04:05.678", Millisecond, "1965-01-02T03:04:05.678" )
    , ( "1965-01-02 03:04:05.678", Second, "1965-01-02T03:04:05.000" )
    , ( "1965-01-02 03:04:05.678", Minute, "1965-01-02T03:04:00.000" )
    , ( "1965-01-02 03:04:05.678", Hour, "1965-01-02T03:00:00.000" )
    , ( "1965-01-02 03:04:05.678", Day, "1965-01-02T00:00:00.000" )
    , ( "1965-03-02 03:04:05.678", Month, "1965-03-01T00:00:00.000" )
    , ( "1965-03-02 03:04:05.678", Year, "1965-01-01T00:00:00.000" )
    ]


runEndOfTimeCase ( dateStr, timeUnit, expectedDate ) =
    let
        inputDate =
            TestUtils.fudgeDate dateStr

        dateOut =
            TimeUnit.endOfTime timeUnit inputDate

        dateOutStr =
            Format.isoStringNoOffset dateOut
    in
    skip <|
        test
            ("unit "
                ++ timeUnitToString timeUnit
                ++ " on "
                ++ dateStr
                ++ "."
            )
        <|
            \() -> Expect.equal expectedDate dateOutStr


endOfTimeCases : List ( String, TimeUnit, String )
endOfTimeCases =
    [ ( "2016-06-05 04:03:02.111", Millisecond, "2016-06-05T04:03:02.111" )
    , ( "2016-06-05 04:03:02.111", Second, "2016-06-05T04:03:02.999" )
    , ( "2016-06-05 04:03:02.111", Minute, "2016-06-05T04:03:59.999" )
    , ( "2016-06-05 04:03:02.111", Hour, "2016-06-05T04:59:59.999" )
    , ( "2016-06-05 04:03:02.111", Day, "2016-06-05T23:59:59.999" )

    --month with 30 days
    , ( "2016-06-05 04:03:02.111", Month, "2016-06-30T23:59:59.999" )

    --month with 31 days
    , ( "2016-07-05 04:03:02.111", Month, "2016-07-31T23:59:59.999" )
    , ( "2016-06-05 04:03:02.111", Year, "2016-12-31T23:59:59.999" )

    --leap year
    , ( "2016-02-05 04:03:02.111", Month, "2016-02-29T23:59:59.999" )
    , ( "2017-02-05 04:03:02.111", Month, "2017-02-28T23:59:59.999" )
    , ( "1965-01-02 03:04:05.678", Millisecond, "1965-01-02T03:04:05.678" )
    , ( "1965-01-02 03:04:05.678", Second, "1965-01-02T03:04:05.999" )
    , ( "1965-01-02 03:04:05.678", Minute, "1965-01-02T03:04:59.999" )
    , ( "1965-01-02 03:04:05.678", Hour, "1965-01-02T03:59:59.999" )
    , ( "1965-01-02 03:04:05.678", Day, "1965-01-02T23:59:59.999" )
    , ( "1964-02-02 03:04:05.678", Month, "1964-02-29T23:59:59.999" )
    , ( "1965-02-02 03:04:05.678", Month, "1965-02-28T23:59:59.999" )
    , ( "1965-03-02 03:04:05.678", Year, "1965-12-31T23:59:59.999" )
    ]
