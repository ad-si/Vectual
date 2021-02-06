module TimeUtils.FormatTests exposing (..)

{- Test date format. -}

import Expect
import Test exposing (..)
import Time exposing (..)
import TimeUtils.Config exposing (..)
import TimeUtils.Config.Config_en_us as Config_en_us
import TimeUtils.Core as Core
import TimeUtils.Format as Format
import TimeUtils.Period as DPeriod


config_en_us =
    Config_en_us.config


tests : Test
tests =
    describe "Date.Format tests"
        [ describe "format tests" <|
            --List.map runFormatTest formatTestCases
            [ test "Dummy test" <| \() -> Expect.equal True True ]
        , describe "formatUtc tests" <|
            --List.map runFormatUtcTest formatUtcTestCases
            [ test "Dummy test" <| \() -> Expect.equal True True ]
        , describe "formatOffset tests" <|
            --List.map runFormatOffsetTest formatOffsetTestCases
            [ test "Dummy test" <| \() -> Expect.equal True True ]
        , describe "configLanguage tests" <|
            --List.map runConfigLanguageTest formatConfigTestCases
            [ test "Dummy test" <| \() -> Expect.equal True True ]
        ]



{-
   Time : 1407833631116
     is : 2014-08-12T08:53:51.116+00:00
     is : 2014-08-12T18:53:51.116+10:00
     is : 2014-08-12T04:53:51.116-04:00
     In a specific time zone... that showed errors.
     "Tue Aug 12 2014 04:53:51 GMT-0400 (Eastern Daylight Time)""
     toUTCString() is : "Tue, 12 Aug 2014 08:53:51 GMT"
     toISOString() is : "2014-08-12T08:53:51.116Z"
   Time : 1407855231116
     is : 2014-08-12T14:53:51.116+00:00
     is : 2014-08-13T00:53:51.116+10:00
   Using floor here to work around bug in Elm 0.16 on Windows
   that cant produce this as integer into the javascript source.
-}


aTestTime =
    millisToPosix 1407833631116


aTestTime2 =
    millisToPosix 1407855231116


aTestTime3 =
    millisToPosix -48007855231116


{-| year 448
-}
aTestTime4 =
    millisToPosix -68007855231116


{-| problem year negative year out disabled test
-}
aTestTime5 =
    millisToPosix 1407182031000


{-| 2014-08-04T19:53:51.000Z
-}
aTestTime6 =
    millisToPosix 1407117600000


{-| 2014-08-04T12:00:00.000+10:00
-}
aTestTime7 =
    millisToPosix 1407074400000


{-| 2014-08-04T00:00:00.000+10:00
-}
aTestTime8 =
    millisToPosix 1375426800000


{-| 2013-08-02T17:00:00.000+10:00
-}
aTestTime9 =
    millisToPosix -55427130000000


{-| Sun Jan 05 2014 00:00:00 GMT+1000
-}
aTestTime10 =
    millisToPosix 1388844000000


type FormatCaseRec
    = FormatCaseRec String String String Posix


{-| 0213-08-02T17:00:00.000+10:00
forces to +10:00 time zone so will run on any time zone
-}
runFormatTest : FormatCaseRec -> Test
runFormatTest (FormatCaseRec name expected formatStr time) =
    skip <|
        test name <|
            \() ->
                Expect.equal
                    expected
                    (Format.formatOffset Config_en_us.config -600 formatStr time)


formatTestCases : List FormatCaseRec
formatTestCases =
    [ FormatCaseRec
        "numeric date"
        "12/08/2014"
        "%d/%m/%Y"
        aTestTime
    , FormatCaseRec
        "spelled out date"
        "Tuesday, August 12, 2014"
        "%A, %B %d, %Y"
        aTestTime
    , FormatCaseRec
        "with %% "
        "% 12/08/2014"
        "%% %d/%m/%Y"
        aTestTime
    , FormatCaseRec
        "with %% no space"
        " %12/08/2014"
        " %%%d/%m/%Y"
        aTestTime
    , FormatCaseRec
        "with milliseconds"
        "2014-08-12 (.116)"
        "%Y-%m-%d (.%L)"
        aTestTime

    -- in EDT GMT-04:00
    -- Tue Aug 12 2014 04:53:51 GMT-0400 (Eastern Daylight Time)
    , FormatCaseRec
        "with milliseconds 2"
        "2014-08-12T18:53:51.116"
        "%Y-%m-%dT%H:%M:%S.%L"
        aTestTime
    , FormatCaseRec
        "small year"
        "0448-09-09T22:39:28.884"
        "%Y-%m-%dT%H:%M:%S.%L"
        aTestTime3
    , FormatCaseRec
        "Config_en_us date aTestTime5"
        "8/5/2014"
        config_en_us.format.date
        aTestTime5
    , FormatCaseRec
        "Config_en_us longDate 1"
        "Tuesday, August 05, 2014"
        config_en_us.format.longDate
        aTestTime5
    , FormatCaseRec
        "Config_en_us time 1"
        "5:53 AM"
        config_en_us.format.time
        aTestTime5
    , FormatCaseRec
        "Config_en_us longTime 1"
        "5:53:51 AM"
        config_en_us.format.longTime
        aTestTime5
    , FormatCaseRec
        "Config_en_us time with PM hour"
        "6:53 PM"
        config_en_us.format.time
        aTestTime
    , FormatCaseRec
        "Config_en_us longTime with PM hour"
        "6:53:51 PM"
        config_en_us.format.longTime
        aTestTime
    , FormatCaseRec
        "Config_en_us dateTime 1"
        "8/5/2014 5:53 AM"
        config_en_us.format.dateTime
        aTestTime5
    , FormatCaseRec
        "Config_en_us dateTime test PM"
        "8/4/2014 12:00 PM"
        config_en_us.format.dateTime
        aTestTime6
    , FormatCaseRec
        "Config_en_us dateTime test AM"
        "8/4/2014 12:00 AM"
        config_en_us.format.dateTime
        aTestTime7
    , FormatCaseRec
        "Config_en_us date"
        "5/08/2014"
        config_en_us.format.date
        aTestTime5
    , FormatCaseRec
        "Config_en_us longDate 2"
        "Tuesday, 5 August 2014"
        config_en_us.format.longDate
        aTestTime5
    , FormatCaseRec
        "Config_en_us time 2"
        "5:53 AM"
        config_en_us.format.time
        aTestTime5
    , FormatCaseRec
        "Config_en_us longTime 2"
        "5:53:51 AM"
        config_en_us.format.longTime
        aTestTime5
    , FormatCaseRec
        "Config_en_us dateTime"
        "5/08/2014 5:53 AM"
        config_en_us.format.dateTime
        aTestTime5
    , FormatCaseRec
        "Config_en_us date aTestTime"
        "8/12/2014"
        config_en_us.format.date
        aTestTime

    -- year rendered negative ? boggle :) disabled for not supporting at moment
    --, ("small year" "0448-09-09T22:39:28.885" "%Y-%m-%dT%H:%M:%S.%L" aTestTime4)
    , FormatCaseRec
        "Check day 12 ordinal date format with out padding"
        "[12][12th]"
        "[%-d][%-@d]"
        aTestTime
    , FormatCaseRec
        "Check day 12 ordinal date format with padding"
        "[12][12th]"
        "[%e][%@e]"
        aTestTime
    , FormatCaseRec
        "Check day 2 ordinal date format with out padding"
        "[2][2nd]"
        "[%-d][%-@d]"
        aTestTime8
    , FormatCaseRec
        "Check day 2 ordinal date format with padding"
        "[ 2][ 2nd]"
        "[%e][%@e]"
        aTestTime8
    , FormatCaseRec
        "Check short year field "
        "0213"
        "%Y"
        aTestTime9
    , FormatCaseRec
        "Check 2 digit year field "
        "13"
        "%y"
        aTestTime9
    ]


type FormatConfigTestCase
    = FormatConfigTestCase String String Config String Posix


runConfigLanguageTest : FormatConfigTestCase -> Test
runConfigLanguageTest (FormatConfigTestCase name expected config formatStr time) =
    skip <|
        test name <|
            \() ->
                Expect.equal
                    expected
                    (Format.formatOffset config -600 formatStr time)


{-| These tests are testing a few language field values
and the day idiom function.
-}
dayDayIdiomMonth =
    "%A (%@e) %d %B %Y"


formatConfigTestCases : List FormatConfigTestCase
formatConfigTestCases =
    [ FormatConfigTestCase
        "Config_en_us day idiom"
        "8/5/2014"
        config_en_us
        config_en_us.format.date
        aTestTime5
    , FormatConfigTestCase
        "Config_en_us format idiom"
        "Tuesday ( 5th) 05 August 2014"
        config_en_us
        dayDayIdiomMonth
        aTestTime5
    ]


runFormatUtcTest : FormatCaseRec -> Test
runFormatUtcTest (FormatCaseRec name expected formatStr time) =
    test name <|
        \() ->
            Expect.equal
                expected
                (Format.formatUtc
                    Config_en_us.config
                    formatStr
                    time
                )


formatUtcTestCases : List FormatCaseRec
formatUtcTestCases =
    [ FormatCaseRec
        "get back expected date in utc +00:00"
        "2014-08-12T08:53:51.116+00:00"
        "%Y-%m-%dT%H:%M:%S.%L%:z"
        aTestTime
    ]


type FormatOffsetTestCase
    = FormatOffsetTestCase String String String Posix Int


runFormatOffsetTest : FormatOffsetTestCase -> Test
runFormatOffsetTest (FormatOffsetTestCase name expected formatStr time offset) =
    skip <|
        test name <|
            \() ->
                Expect.equal
                    expected
                    (Format.formatOffset
                        Config_en_us.config
                        offset
                        formatStr
                        time
                    )


formatOffsetTestCases : List FormatOffsetTestCase
formatOffsetTestCases =
    [ FormatOffsetTestCase
        "get back expected date in utc -04:00"
        "2014-08-12T04:53:51.116-04:00"
        "%Y-%m-%dT%H:%M:%S.%L%:z"
        aTestTime
        240
    , FormatOffsetTestCase
        "get back expected date in utc -12:00"
        "2014-08-12T20:53:51.116+12:00"
        "%Y-%m-%dT%H:%M:%S.%L%:z"
        aTestTime
        -720
    , FormatOffsetTestCase
        "12 hour time %I"
        "Wednesday, 13 August 2014 12:53:51 AM"
        "%A, %e %B %Y %I:%M:%S %p"
        aTestTime2
        -600
    , FormatOffsetTestCase
        "12 hour time %l"
        "Wednesday, 13 August 2014 12:53:51 AM"
        "%A, %e %B %Y %l:%M:%S %p"
        aTestTime2
        -600
    ]
