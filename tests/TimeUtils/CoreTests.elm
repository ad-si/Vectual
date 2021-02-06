module TimeUtils.CoreTests exposing (..)

import Expect
import Test exposing (..)
import Time exposing (..)
import TimeExtra exposing (fromYMDHM)
import TimeUtils.Config.Config_en_us exposing (dayName)
import TimeUtils.Core as Core
import TimeUtils.Create as Create
import TimeUtils.Utils as DateUtils
import UtilsForTesting as TestUtils


tests : Test
tests =
    describe "Date.Core tests"
        [ let
            nd3 =
                Core.nextDay << Core.nextDay << Core.nextDay

            nd7 =
                nd3 << nd3 << Core.nextDay
          in
          test "nextDay cycles through all days" <|
            \() -> Expect.equal Mon (nd7 Mon)
        , let
            pd3 =
                Core.prevDay << Core.prevDay << Core.prevDay

            pd7 =
                pd3 << pd3 << Core.prevDay
          in
          test "prevDay cycles through all days" <|
            \() -> Expect.equal Mon (pd7 Mon)
        , test "2016 is a leap year in length" <|
            \() -> Expect.equal 366 (Core.yearToDayLength 2016)
        , test "1900 is not a leap year in length" <|
            \() -> Expect.equal 365 (Core.yearToDayLength 1900)
        , test "2016 is a leap year" <|
            \() -> Expect.equal True (Core.isLeapYear 2016)
        , test "1900 is not a leap year" <|
            \() -> Expect.equal False (Core.isLeapYear 1900)
        , let
            nm3 =
                Core.nextMonth << Core.nextMonth << Core.nextMonth

            nm12 =
                nm3 << nm3 << nm3 << nm3
          in
          test "nextMonth cycles through all months" <|
            \() -> Expect.equal Jan (nm12 Jan)
        , let
            pm3 =
                Core.prevMonth << Core.prevMonth << Core.prevMonth

            pm12 =
                pm3 << pm3 << pm3 << pm3
          in
          test "prevMonth cycles through all months" <|
            \() -> Expect.equal Jan (pm12 Jan)
        , test "daysInprevMonth" <|
            \() ->
                Expect.equal 29
                    (Core.daysInPrevMonth (fromYMDHM 2012 Mar 4 11 34))
        , test "daysInNextMonth" <|
            \() ->
                Expect.equal 31
                    (Core.daysInNextMonth (fromYMDHM 2011 Dec 25 22 23))
        , skip <|
            test "toFirstOfMonth \"2015-11-11 11:45\" is \"2015-11-01 11:45\"" <|
                TestUtils.assertDateFunc
                    "2015-11-11 11:45"
                    "2015-11-01T11:45:00.000"
                    Core.toFirstOfMonth
        , test "toFirstOfMonth \"2016-01-02 00:00\" is \"2016-01-01 00:00\"" <|
            TestUtils.assertDateFunc
                "2016-01-02"
                "2016-01-01T00:00:00.000"
                Core.toFirstOfMonth
        , test "toFirstOfMonth \"2016-01-02\" is \"2016-01-01\"" <|
            TestUtils.assertDateFunc
                "2016-01-02"
                "2016-01-01T00:00:00.000"
                Core.toFirstOfMonth
        , test "toFirstOfMonth \"2016-10-30\" is \"2016-10-01\"" <|
            TestUtils.assertDateFunc
                "2016-10-30"
                "2016-10-01T00:00:00.000"
                Core.toFirstOfMonth
        , test "toFirstOfMonth \"2016-10-02\" is \"2016-10-01\"" <|
            TestUtils.assertDateFunc
                "2016-10-02"
                "2016-10-01T00:00:00.000"
                Core.toFirstOfMonth
        , test "toFirstOfMonth \"2017-10-30\" is \"2017-10-01\" xx" <|
            TestUtils.assertDateFunc
                "2017-10-30"
                "2017-10-01T00:00:00.000"
                Core.toFirstOfMonth
        , test "toFirstOfMonth \"2017-10-02\" is \"2017-10-01\"" <|
            TestUtils.assertDateFunc
                "2017-10-02"
                "2017-10-01T00:00:00.000"
                Core.toFirstOfMonth
        , test "toFirstOfMonth \"2017-03-28\" is \"2017-03-01\"" <|
            TestUtils.assertDateFunc
                "2017-03-28"
                "2017-03-01T00:00:00.000"
                Core.toFirstOfMonth
        , skip <|
            test "lastOfMonthDate" <|
                TestUtils.assertDateFunc
                    "2015-11-11 11:45"
                    "2015-11-30T11:45:00.000"
                    Core.lastOfMonthDate
        , skip <|
            test "lastOfMonthDate Leap Year Feb" <|
                TestUtils.assertDateFunc
                    "2012-02-18 11:45"
                    "2012-02-29T11:45:00.000"
                    Core.lastOfMonthDate
        , skip <|
            test
                ("lastOfMonthDate \"2017-03-03\" is \"2017-03-31\""
                    ++ " daylight saving for UTC +02:00 CET to CEST"
                )
            <|
                TestUtils.assertDateFunc
                    "2017-03-03 11:45"
                    "2017-03-31T11:45:00.000"
                    Core.lastOfMonthDate
        , skip <|
            test
                ("lastOfMonthDate \"2017-10-03\" is \"2017-10-31\""
                    ++ " leave daylight saving for UTC +02:00 CEST to CET"
                )
            <|
                TestUtils.assertDateFunc
                    "2017-10-03 11:45"
                    "2017-10-31T11:45:00.000"
                    Core.lastOfMonthDate
        , skip <|
            test "lastOfPrevMonthDate" <|
                TestUtils.assertDateFunc
                    "2012-03-02 11:45"
                    "2012-02-29T11:45:00.000"
                    Core.lastOfPrevMonthDate
        , skip <|
            test
                ("lastOfPrevMonthDate \"2017-03-30\" is \"2017-02-28\""
                    ++ " where lastOfPrevMonth is CET and input date is CEST "
                )
            <|
                TestUtils.assertDateFunc
                    "2017-03-30 11:45"
                    "2017-02-28T11:45:00.000"
                    Core.lastOfPrevMonthDate
        , skip <|
            test
                ("lastOfPrevMonthDate \"2017-10-30\" is \"2017-09-30\""
                    ++ " where lastOfPrevMonth is CEST and input date is CET "
                )
            <|
                TestUtils.assertDateFunc
                    "2017-10-30 11:45"
                    "2017-09-30T11:45:00.000"
                    Core.lastOfPrevMonthDate
        , skip <|
            test "firstOfNextMonthDate" <|
                -- TODO: Fix firstOfNextMonthDate DTS compensation
                TestUtils.assertDateFunc
                    "2012-02-01 02:20"
                    "2012-03-01T02:20:00.000"
                    Core.firstOfNextMonthDate
        , skip <|
            test
                ("firstOfNextMonthDate \"2017-03-03\" is \"2017-04-01\" "
                    ++ "where `firstOfNextMonthDate` is CEST "
                    ++ "and input date is CET"
                )
            <|
                -- TODO: Fix firstOfNextMonthDate DTS compensation
                TestUtils.assertDateFunc
                    "2017-03-03 02:20"
                    "2017-04-01T02:20:00.000"
                    Core.firstOfNextMonthDate
        , skip <|
            test
                ("firstOfNextMonthDate \"2017-10-03\" is \"2017-11-01\""
                    ++ " where firstOfNextMonthDate is CET "
                    ++ "and input date is CEST"
                )
            <|
                -- TODO: Fix firstOfNextMonthDate DTS compensation
                TestUtils.assertDateFunc
                    "2017-10-03 02:20"
                    "2017-11-01T02:20:00.000"
                    Core.firstOfNextMonthDate

        -- this is all the possible cases.
        , describe "DateUtils.daysBackToStartOfWeek tests" <|
            List.map
                runBackToStartofWeekTests
                [ ( Mon, Mon, 0 )
                , ( Mon, Tue, 6 )
                , ( Mon, Wed, 5 )
                , ( Mon, Thu, 4 )
                , ( Mon, Fri, 3 )
                , ( Mon, Sat, 2 )
                , ( Mon, Sun, 1 )
                , ( Tue, Mon, 1 )
                , ( Tue, Tue, 0 )
                , ( Tue, Wed, 6 )
                , ( Tue, Thu, 5 )
                , ( Tue, Fri, 4 )
                , ( Tue, Sat, 3 )
                , ( Tue, Sun, 2 )
                , ( Wed, Mon, 2 )
                , ( Wed, Tue, 1 )
                , ( Wed, Wed, 0 )
                , ( Wed, Thu, 6 )
                , ( Wed, Fri, 5 )
                , ( Wed, Sat, 4 )
                , ( Wed, Sun, 3 )
                , ( Thu, Mon, 3 )
                , ( Thu, Tue, 2 )
                , ( Thu, Wed, 1 )
                , ( Thu, Thu, 0 )
                , ( Thu, Fri, 6 )
                , ( Thu, Sat, 5 )
                , ( Thu, Sun, 4 )
                , ( Fri, Mon, 4 )
                , ( Fri, Tue, 3 )
                , ( Fri, Wed, 2 )
                , ( Fri, Thu, 1 )
                , ( Fri, Fri, 0 )
                , ( Fri, Sat, 6 )
                , ( Fri, Sun, 5 )
                , ( Sat, Mon, 5 )
                , ( Sat, Tue, 4 )
                , ( Sat, Wed, 3 )
                , ( Sat, Thu, 2 )
                , ( Sat, Fri, 1 )
                , ( Sat, Sat, 0 )
                , ( Sat, Sun, 6 )
                , ( Sun, Mon, 6 )
                , ( Sun, Tue, 5 )
                , ( Sun, Wed, 4 )
                , ( Sun, Thu, 3 )
                , ( Sun, Fri, 2 )
                , ( Sun, Sat, 1 )
                , ( Sun, Sun, 0 )
                ]
        ]


runBackToStartofWeekTests : ( Weekday, Weekday, Int ) -> Test
runBackToStartofWeekTests ( dateDay, startOfWeekDay, expectedOffset ) =
    test
        ("dateDay "
            ++ dayName dateDay
            ++ " for startOfWeekDay "
            ++ dayName startOfWeekDay
            ++ " expects Offsetback of "
            ++ String.fromInt expectedOffset
        )
    <|
        \() ->
            Expect.equal
                expectedOffset
                (Core.daysBackToStartOfWeek dateDay startOfWeekDay)
