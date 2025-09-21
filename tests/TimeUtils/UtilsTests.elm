module TimeUtils.UtilsTests exposing (..)

import Expect
import Iso8601
import Test exposing (..)
import Time exposing (..)
import TimeExtra exposing (fromYMD)
import TimeUtils.Config.Config_en_us as Config_en_us
import TimeUtils.Core as Core
import TimeUtils.Create as Create
import TimeUtils.Format as Format
import TimeUtils.Utils as Utils
import UtilsForTesting as TestUtils


config_en_us =
    Config_en_us.config


tests : Test
tests =
    describe "Utils tests"
        [ let
            resultList =
                Utils.dayList 35 (fromYMD 2015 Dec 28)
          in
          test "Test dayList 2016 Jan calendar grid date list." <|
            \() ->
                Expect.equal
                    (List.range 28 31 ++ List.range 1 31)
                    (List.map (toDay utc) resultList)
        , let
            resultList =
                Utils.dayList 2 (fromYMD 2017 Oct 29)
          in
          test "Test dayList UTC +01:00 Amsterdam, Berlin cross daylight saving end" <|
            \() ->
                Expect.equal
                    (List.range 29 30)
                    (List.map (toDay utc) resultList)
        , let
            resultList =
                Utils.dayList 2 (fromYMD 2017 Mar 26)
          in
          test "Test dayList UTC +01:00 Amsterdam, Berlin cross daylight saving start" <|
            \() ->
                Expect.equal
                    (List.range 26 27)
                    (List.map (toDay utc) resultList)
        , let
            resultList =
                Utils.dayList -2 (fromYMD 2017 Mar 26)
          in
          test "Test dayList negative count eg -2 counts down dates not up" <|
            \() ->
                Expect.equal
                    (List.reverse (List.range 25 26))
                    (List.map (toDay utc) resultList)
        , TestUtils.describeOffsetTests "Utils.isoWeek - test in matching time zones only."
            2016
            [ ( ( -180, -120 )
                -- UTC +02:00 Helsinki timezone (in windows its called that)
                -- its +03:00 with daylight saving
              , testNeg180HelsinkiIsoWeek
              )
            ]
        , describe "isoWeekOne tests" <|
            List.map runIsoWeekOneTest
                [ ( 2005, "2005-01-03T00:00:00.000" )
                , ( 2006, "2006-01-02T00:00:00.000" )
                , ( 2007, "2007-01-01T00:00:00.000" )
                , ( 2008, "2007-12-31T00:00:00.000" )
                , ( 2009, "2008-12-29T00:00:00.000" )
                , ( 2010, "2010-01-04T00:00:00.000" )
                ]
        , isoWeekTests
        , describe "getYearIsoWeekDate"
            [ test "2021-02-06 10:20:33.123" <|
                \() ->
                    let
                        -- 2021-W05-6 10:20:33.123
                        -- 2021-02-06 10:20:33.123
                        now =
                            millisToPosix 1612606833123

                        -- 2021-W01-1 00:00
                        -- 2021-01-04 00:00
                        firstIsoWeek =
                            millisToPosix 1609718400000
                    in
                    Expect.equal
                        (Utils.getYearIsoWeekDate now)
                        ( 2021, firstIsoWeek )
            , test "2021-01-03 12:00" <|
                \() ->
                    let
                        -- 2020-W53-7 12:00
                        -- 2021-01-03 12:00
                        now =
                            millisToPosix 1609675200000

                        -- 2020-W01-1 00:00
                        -- 2019-12-30 00:00
                        firstIsoWeek =
                            millisToPosix 1577664000000
                    in
                    Expect.equal
                        (Utils.getYearIsoWeekDate now)
                        ( 2020, firstIsoWeek )
            ]
        ]


isoWeekTests : Test
isoWeekTests =
    describe "isoWeek tests" <|
        List.map runIsoWeekTest
            [ IsoWeekTestRec "2005-01-01" 2004 53 6
            , IsoWeekTestRec "2005-01-02" 2004 53 7
            , IsoWeekTestRec "2005-01-03" 2005 1 1
            , IsoWeekTestRec "2007-01-01" 2007 1 1
            , IsoWeekTestRec "2007-12-30" 2007 52 7
            , IsoWeekTestRec "2010-01-03" 2009 53 7
            , IsoWeekTestRec "2016-03-28" 2016 13 1
            , IsoWeekTestRec "2016-03-27" 2016 12 7
            ]


{-| Example data
Year: DST Start (Clock Forward): DST End (Clock Backward)
2015: Sunday, March 29, 3:00 am: Sunday, October 25, 4:00 am
2016: Sunday, March 27, 3:00 am: Sunday, October 30, 4:00 am
2017: Sunday, March 26, 3:00 am: Sunday, October 29, 4:00 am
Move this test to its own file - to test daylight saving case problem.
-}
testNeg180HelsinkiIsoWeek : a -> Test
testNeg180HelsinkiIsoWeek _ =
    let
        currentOffsets =
            TestUtils.getZoneOffsets 2015
    in
    if currentOffsets /= ( -180, -120 ) then
        test
            """
                This test describe requires to be run in a specific time zone.
                Helsinki UTC+02:00 with daylight saving variations.
                Testing Utils.isoWeek Offsets (-180, -120)
                """
        <|
            \() -> Expect.fail "currentOffsets incorrect for this test"

    else
        -- Reference: https://www.epochconverter.com/weeks/2016
        describe "Timezone +02:00 Helisnki (daylight saving +03:00)"
            [ isoWeekTests
            ]


runIsoWeekOneTest : ( Int, String ) -> Test
runIsoWeekOneTest ( year, expectedDateStr ) =
    test ("isoWeekOne of year " ++ String.fromInt year) <|
        \() ->
            Expect.equal
                expectedDateStr
                (Format.isoStringNoOffset (Utils.isoWeekOne year))


type IsoWeekTestRec
    = IsoWeekTestRec String Int Int Int


runIsoWeekTest : IsoWeekTestRec -> Test
runIsoWeekTest (IsoWeekTestRec dateStr expectedYear expectedWeek expectedIsoDay) =
    test ("isoWeek of " ++ dateStr) <|
        \() ->
            Expect.equal
                ( expectedYear, expectedWeek, expectedIsoDay )
                (Utils.isoWeek
                    (Result.withDefault (millisToPosix 0)
                        (Iso8601.toTime dateStr)
                    )
                )
