module TimeUtils.CompareTests exposing (..)

{-| Test date comparison.
-}

import Expect
import Test exposing (..)
import Time exposing (..)
import TimeUtils.Compare as Compare exposing (Compare2(..), Compare3(..))
import TimeUtils.Core as Core


tests : Test
tests =
    describe "Date.Compare tests"
        [ describe "is tests" <|
            List.map runIsCase isCases
        , describe "is3 tests" <|
            List.map runIs3Case is3TestCases
        ]


{-| Have no way to easily change into out of daylight saving
as cant set/check zones.
So this is limited, and there will be complications somewhere I am sure.
Time : 1407833631116
is : 2014-08-12T08:53:51.116+00:00
Time : 1407833631115
is : 2014-08-12T08:53:51.115+00:00
Time : 1407833631114
is : 2014-08-12T08:53:51.114+00:00
-}
aTestTime6 =
    floor 1407833631116.0


aTestTime5 =
    floor 1407833631115.0


aTestTime4 =
    floor 1407833631114.0


runIsCase (CaseRecord name comp date1 date2 expected) =
    test name <|
        \() ->
            Expect.equal
                expected
                (Compare.is comp date1 date2)


type CaseRecord
    = CaseRecord String Compare2 Posix Posix Bool


isCases =
    [ CaseRecord
        "is After date1 > date2"
        After
        (Core.fromTime aTestTime6)
        (Core.fromTime aTestTime5)
        True
    , CaseRecord
        "is After same dates"
        After
        (Core.fromTime aTestTime6)
        (Core.fromTime aTestTime6)
        False
    , CaseRecord
        "is SameOrAfter same dates"
        SameOrAfter
        (Core.fromTime aTestTime6)
        (Core.fromTime aTestTime6)
        True
    , CaseRecord
        "is Before date1 > date2"
        Before
        (Core.fromTime aTestTime6)
        (Core.fromTime aTestTime5)
        False
    , CaseRecord
        "is Before date1 < date2"
        Before
        (Core.fromTime aTestTime5)
        (Core.fromTime aTestTime6)
        True
    , CaseRecord
        "is Before same dates"
        Before
        (Core.fromTime aTestTime6)
        (Core.fromTime aTestTime6)
        False
    , CaseRecord
        "is SameOrBefore same dates"
        SameOrBefore
        (Core.fromTime aTestTime6)
        (Core.fromTime aTestTime6)
        True
    ]


type CaseRecordLong
    = CaseRecordLong String Compare3 Posix Posix Posix Bool


runIs3Case (CaseRecordLong name comp date1 date2 date3 expected) =
    test name <|
        \() ->
            Expect.equal
                expected
                (Compare.is3 comp date1 date2 date3)


is3TestCases =
    [ CaseRecordLong
        "is3 Between where date1 is between date2 and date3, date2 > date3"
        Between
        (Core.fromTime aTestTime5)
        (Core.fromTime aTestTime6)
        (Core.fromTime aTestTime4)
        True
    , CaseRecordLong
        "is3 Between where date1 is between date2 and date3, date2 < date3"
        Between
        (Core.fromTime aTestTime5)
        (Core.fromTime aTestTime4)
        (Core.fromTime aTestTime6)
        True
    , CaseRecordLong
        "is3 Between where date1 is before date2 or date3"
        Between
        (Core.fromTime aTestTime4)
        (Core.fromTime aTestTime6)
        (Core.fromTime aTestTime5)
        False
    , CaseRecordLong
        "is3 Between where date1 is after date2 or date3"
        Between
        (Core.fromTime aTestTime6)
        (Core.fromTime aTestTime4)
        (Core.fromTime aTestTime5)
        False
    , CaseRecordLong
        "is3 Between where date1 is same or after the lower of date2 or date3"
        Between
        (Core.fromTime aTestTime4)
        (Core.fromTime aTestTime5)
        (Core.fromTime aTestTime4)
        False
    , CaseRecordLong
        "is3 BetweenOpenStart where date1 is same as the the lower of date2 or date3"
        BetweenOpenStart
        (Core.fromTime aTestTime4)
        (Core.fromTime aTestTime5)
        (Core.fromTime aTestTime4)
        True
    , CaseRecordLong
        "is3 Between where date1 is same as the higher of date2 or date3"
        Between
        (Core.fromTime aTestTime5)
        (Core.fromTime aTestTime5)
        (Core.fromTime aTestTime4)
        False
    , CaseRecordLong
        "is3 BetweenOpenEnd where date1 is same as the higher of date2 or date3"
        BetweenOpenEnd
        (Core.fromTime aTestTime5)
        (Core.fromTime aTestTime5)
        (Core.fromTime aTestTime4)
        True
    , CaseRecordLong
        "is3 Between where date1 is same as both date2 and date3"
        Between
        (Core.fromTime aTestTime5)
        (Core.fromTime aTestTime5)
        (Core.fromTime aTestTime5)
        False
    , CaseRecordLong
        "is3 BetweenOpenStart where date1 is same as both date2 and date3"
        BetweenOpenStart
        (Core.fromTime aTestTime5)
        (Core.fromTime aTestTime5)
        (Core.fromTime aTestTime5)
        False
    , CaseRecordLong
        "is3 BetweenOpenEnd where date1 is same as both date2 and date3"
        BetweenOpenEnd
        (Core.fromTime aTestTime5)
        (Core.fromTime aTestTime5)
        (Core.fromTime aTestTime5)
        False
    , CaseRecordLong
        "is3 BetweenOpen where date1 is same as both date2 and date3"
        BetweenOpen
        (Core.fromTime aTestTime5)
        (Core.fromTime aTestTime5)
        (Core.fromTime aTestTime5)
        True
    , CaseRecordLong
        "is3 BetweenOpen where date1 is after both date2 and date3"
        BetweenOpen
        (Core.fromTime aTestTime6)
        (Core.fromTime aTestTime5)
        (Core.fromTime aTestTime5)
        False
    , CaseRecordLong
        "is3 BetweenOpen where date1 is before both date2 and date3"
        BetweenOpen
        (Core.fromTime aTestTime4)
        (Core.fromTime aTestTime5)
        (Core.fromTime aTestTime5)
        False
    ]
