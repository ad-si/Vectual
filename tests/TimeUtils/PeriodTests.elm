module TimeUtils.PeriodTests exposing (..)

import Expect
import String
import Test exposing (..)
import Time exposing (..)
import TimeUtils.Period as Period exposing (..)
import TimeUtils.Utils as DateUtils
import UtilsForTesting as TestUtils


tests : Test
tests =
    describe "Date.Period tests"
        [ addTests ()
        , diffTests ()
        ]


addTests _ =
    describe "Date.Period add tests"
        (List.map runAddCase addCases)


runAddCase : CaseRecord -> Test
runAddCase (CaseRecord inputDateStr period addend expectedDateStr) =
    skip <|
        test
            ("input "
                ++ inputDateStr
                ++ " add "
                ++ periodToString period
                ++ " addend "
                ++ String.fromInt addend
                ++ " expects "
                ++ expectedDateStr
            )
        <|
            TestUtils.assertDateFunc
                inputDateStr
                expectedDateStr
                (Period.add period addend)


type CaseRecord
    = CaseRecord String Period Int String


addCases =
    [ CaseRecord
        "2015-06-10 11:43:55.213"
        Millisecond
        1
        "2015-06-10T11:43:55.214"
    , CaseRecord
        "2015-06-10 11:43:55.213"
        Second
        1
        "2015-06-10T11:43:56.213"
    , CaseRecord
        "2015-06-10 11:43:55.213"
        Minute
        1
        "2015-06-10T11:44:55.213"
    , CaseRecord
        "2015-06-10 11:43:55.213"
        Hour
        1
        "2015-06-10T12:43:55.213"
    , CaseRecord
        "2015-06-10 11:43:55.213"
        Day
        1
        "2015-06-11T11:43:55.213"
    , CaseRecord
        "2015-06-10 11:43:55.213"
        Week
        1
        "2015-06-17T11:43:55.213"
    , CaseRecord
        "2015-06-10 11:43:55.213"
        Millisecond
        -1
        "2015-06-10T11:43:55.212"
    , CaseRecord
        "2015-06-10 11:43:55.213"
        Second
        -1
        "2015-06-10T11:43:54.213"
    , CaseRecord
        "2015-06-10 11:43:55.213"
        Minute
        -1
        "2015-06-10T11:42:55.213"
    , CaseRecord
        "2015-06-10 11:43:55.213"
        Hour
        -1
        "2015-06-10T10:43:55.213"
    , CaseRecord
        "2015-06-10 11:43:55.213"
        Day
        -1
        "2015-06-09T11:43:55.213"
    , CaseRecord
        "2015-06-10 11:43:55.213"
        Week
        -1
        "2015-06-03T11:43:55.213"
    , CaseRecord
        "2015-06-10 11:43:55.213"
        (Delta
            { week = 1
            , day = 1
            , hour = 1
            , minute = 1
            , second = 1
            , millisecond = 1
            }
        )
        1
        "2015-06-18T12:44:56.214"
    , CaseRecord
        "2015-06-10 11:43:55.213"
        (Delta
            { week = 1
            , day = 1
            , hour = 1
            , minute = 1
            , second = 1
            , millisecond = 1
            }
        )
        -1
        "2015-06-02T10:42:54.212"
    ]


diffTests _ =
    describe "Date.Period diff tests"
        (List.map runDiffCase diffCases)


runDiffCase (DiffCaseRecord date1Str date2Str expectedDiff) =
    skip <|
        test
            ("diff date1 "
                ++ date1Str
                ++ " date2 = "
                ++ date2Str
            )
        <|
            \() ->
                Expect.equal
                    expectedDiff
                    (Period.diff
                        (TestUtils.fudgeDate date1Str)
                        (TestUtils.fudgeDate date2Str)
                    )


type DiffCaseRecord
    = DiffCaseRecord String String PeriodDeltaRecord


diffCases =
    [ DiffCaseRecord
        "2015-06-10 11:43:55.213"
        "2015-06-10 11:43:55.214"
        { week = 0
        , day = 0
        , hour = 0
        , minute = 0
        , second = 0
        , millisecond = -1
        }
    , DiffCaseRecord
        "2015-06-10 11:43:55.213"
        "2015-06-02 10:42:54.212"
        { week = 1
        , day = 1
        , hour = 1
        , minute = 1
        , second = 1
        , millisecond = 1
        }
    , DiffCaseRecord
        "2015-06-02 10:42:54.212"
        "2015-06-10 11:43:55.213"
        { week = -1
        , day = -1
        , hour = -1
        , minute = -1
        , second = -1
        , millisecond = -1
        }
    ]
