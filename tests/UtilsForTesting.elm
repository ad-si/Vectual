module UtilsForTesting exposing (..)

{-| Useful for testing with Test.
-}

import Expect
import Iso8601 as Iso8601
import Result as Result
import String
import Test exposing (..)
import Time exposing (..)
import TimeExtra exposing (fromYMD)
import TimeUtils.Config.Config_en_us as Config
import TimeUtils.Core as Core
import TimeUtils.Create as Create
import TimeUtils.Format as Format
import TimeUtils.Utils as DateUtils
import Tuple


config =
    Config.config


dateStr =
    Format.isoString


{-| Helper for testing Date transform functions without offset.
-}
assertDateFunc :
    String
    -> String
    -> (Posix -> Posix)
    -> (() -> Expect.Expectation)
assertDateFunc inputDateStr expectedDateStr dateFunc =
    let
        inputDate =
            Result.withDefault (millisToPosix 0) (Iso8601.toTime inputDateStr)

        outputDate =
            dateFunc inputDate

        expectedDate =
            Result.withDefault (millisToPosix 0) (Iso8601.toTime expectedDateStr)
    in
    \() ->
        Expect.equal expectedDateStr (Format.isoStringNoOffset outputDate)


{-| Helper for testing Date transform functions, including offset.
-}
assertDateFuncOffset :
    String
    -> String
    -> (Posix -> Posix)
    -> (() -> Expect.Expectation)
assertDateFuncOffset inputDateStr expectedDateStr dateFunc =
    let
        inputDate =
            fudgeDate inputDateStr

        outputDate =
            dateFunc inputDate
    in
    \() -> Expect.equal expectedDateStr (Format.isoString outputDate)


{-| Return min and max zone offsets in current zone.
As a rule (fst (getZoneOffsets year)) will return standard timezoneOffset
for local zone as per referenced information.
<https://stackoverflow.com/questions/11887934/check-if-daylight-saving-time-is-in-effect-and-if-it-is-for-how-many-hours/11888430#11888430>
-}
getZoneOffsets : Int -> ( Int, Int )
getZoneOffsets year =
    let
        jan01offset =
            fromYMD year Jan 1
                |> Create.getTimezoneOffset

        jul01offset =
            fromYMD year Jun 1
                |> Create.getTimezoneOffset

        minOffset =
            min jan01offset jul01offset

        maxOffset =
            max jan01offset jul01offset
    in
    ( minOffset, maxOffset )


{-| TODO: Parse all variants of ISO 8601 (e.g. 2020-12-16 17:55)
-}
fudgeDate : String -> Posix
fudgeDate str =
    Result.withDefault
        (millisToPosix 0)
        (Iso8601.toTime str)


{-| Given a year and list of offset and test data,
only run tests that match the minimum and maximum time zone offset of that test.
-}
describeOffsetTests : String -> Int -> List ( ( Int, Int ), () -> Test ) -> Test
describeOffsetTests description year candidateTests =
    let
        -- currentOffsetFilter : ( ( Int, Int ), () -> Test ) -> Maybe Test
        currentOffsetFilter ( offsets, test ) =
            if getZoneOffsets year == offsets then
                Just (test ())

            else
                let
                    firstInt tuple =
                        " " ++ (String.fromInt <| Tuple.first tuple)

                    secondInt tuple =
                        " " ++ (String.fromInt <| Tuple.second tuple)

                    uniqueDescripton =
                        description ++ firstInt offsets ++ secondInt offsets
                in
                Just
                    (dummyPassingTest uniqueDescripton)
    in
    describe description <|
        List.append
            (List.filterMap currentOffsetFilter candidateTests)
            [ test
                ("Passing test to make suite not fail if empty for "
                    ++ description
                )
              <|
                \_ -> Expect.pass
            ]


dummyPassingTest : String -> Test
dummyPassingTest description =
    test ("Dummy passing test" ++ description) <|
        \_ -> Expect.pass
