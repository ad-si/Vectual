module TimeUtils.FieldTests exposing (..)

import Expect
import Iso8601 as Iso8601
import Test exposing (..)
import Time exposing (..)
import TimeUtils.Create as Create
import TimeUtils.Field as Field exposing (Field(..), fieldToString)
import TimeUtils.Format as Format
import TimeUtils.Utils as DateUtils
import UtilsForTesting as TestUtils


tests : Test
tests =
    describe "Date.Field tests"
        [ describe "fieldDate tests" <|
            List.map runFieldCase fieldCases
        , describe "fieldDateClamp tests" <|
            List.map runFieldClampCase fieldClampCases
        ]


runFieldCase : FieldCaseRec -> Test
runFieldCase (FieldCaseRec dateStr field expectedDate name) =
    let
        date =
            TestUtils.fudgeDate dateStr

        dateOut =
            Field.fieldToDate field date

        dateOutStr =
            Maybe.map Format.isoStringNoOffset dateOut
    in
    skip <|
        test
            ("field "
                ++ name
                ++ ""
                ++ fieldToString field
                ++ " on "
                ++ dateStr
                ++ " expects "
                ++ Maybe.withDefault "" expectedDate
                ++ ".\n"
            )
        <|
            \() -> Expect.equal expectedDate dateOutStr


type FieldCaseRec
    = FieldCaseRec String Field (Maybe String) String


fieldCases : List FieldCaseRec
fieldCases =
    [ FieldCaseRec
        "2016-06-05 04:03:02.111"
        (Millisecond 1)
        (Just "2016-06-05T04:03:02.001")
        "1"
    , FieldCaseRec
        "2016-06-05 04:03:02.111"
        (Second 3)
        (Just "2016-06-05T04:03:03.111")
        "2"
    , FieldCaseRec
        "2016-06-05 04:03:02.111"
        (Millisecond 1000)
        Nothing
        "3"
    , FieldCaseRec
        "2016-06-05 04:03:02.111"
        (Millisecond -1)
        Nothing
        "4"
    , FieldCaseRec
        "2016-06-05 04:03:02.111"
        (Second 60)
        Nothing
        "5"
    , FieldCaseRec
        "2016-06-05 04:03:02.111"
        (Second -1)
        Nothing
        "6"
    , FieldCaseRec
        "2016-06-05 04:03:02.111"
        (Minute 60)
        Nothing
        "7"
    , FieldCaseRec
        "2016-06-05 04:03:02.111"
        (Minute -1)
        Nothing
        "8"
    , FieldCaseRec
        "2016-06-05 04:03:02.111"
        (Hour 24)
        Nothing
        "9"
    , FieldCaseRec
        "2016-06-05 04:03:02.111"
        (Hour -1)
        Nothing
        "10"
    , FieldCaseRec
        "2016-06-05 04:03:02.111"
        (DayOfMonth 0)
        Nothing
        "11"
    , FieldCaseRec
        "2016-06-05 04:03:02.111"
        (DayOfMonth 31)
        Nothing
        "12"
    , FieldCaseRec
        "2016-06-05 04:03:02.111"
        (Year -1)
        Nothing
        "13"
    , FieldCaseRec
        "2016-06-05 04:03:02.111"
        (DayOfMonth 31)
        Nothing
        "14"
    , FieldCaseRec
        "2016-06-05 04:03:02.111"
        -- 2016-06-05 is Sunday
        (DayOfWeek ( Mon, Mon ))
        (Just "2016-05-30T04:03:02.111")
        "15"
    , FieldCaseRec
        "2016-06-05 04:03:02.111"
        (DayOfWeek ( Mon, Sun ))
        (Just "2016-06-06T04:03:02.111")
        "4"
    , FieldCaseRec
        "2016-06-05 04:03:02.111"
        (DayOfWeek ( Thu, Thu ))
        (Just "2016-06-02T04:03:02.111")
        "4"
    , FieldCaseRec
        "2016-06-05 04:03:02.111"
        (DayOfWeek ( Sat, Sun ))
        (Just "2016-06-11T04:03:02.111")
        "4"
    ]


runFieldClampCase (FieldClampCaseRec dateStr field expectedDate name) =
    let
        date =
            TestUtils.fudgeDate dateStr

        dateOut =
            Field.fieldToDateClamp field date

        dateOutStr =
            Format.isoStringNoOffset dateOut
    in
    skip <|
        test
            ("field "
                ++ name
                ++ " "
                ++ fieldToString field
                ++ " on "
                ++ dateStr
                ++ " expects "
                ++ expectedDate
                ++ ".\n"
            )
        <|
            \() -> Expect.equal expectedDate dateOutStr


type FieldClampCaseRec
    = FieldClampCaseRec String Field String String


{-| These are same input cases as FieldCases, different results for clamp
-}
fieldClampCases : List FieldClampCaseRec
fieldClampCases =
    [ FieldClampCaseRec
        "2016-06-05 04:03:02.111"
        (Millisecond 1)
        "2016-06-05T04:03:02.001"
        "1"
    , FieldClampCaseRec
        "2016-06-05 04:03:02.111"
        (Second 3)
        "2016-06-05T04:03:03.111"
        "2"
    , FieldClampCaseRec
        "2016-06-05 04:03:02.111"
        (Millisecond 1000)
        "2016-06-05T04:03:02.999"
        "3"
    , FieldClampCaseRec
        "2016-06-05 04:03:02.111"
        (Millisecond -1)
        "2016-06-05T04:03:02.000"
        "4"
    , FieldClampCaseRec
        "2016-06-05 04:03:02.111"
        (Second 60)
        "2016-06-05T04:03:59.111"
        "5"
    , FieldClampCaseRec
        "2016-06-05 04:03:02.111"
        (Second -1)
        "2016-06-05T04:03:00.111"
        "6"
    , FieldClampCaseRec
        "2016-06-05 04:03:02.111"
        (Minute 60)
        "2016-06-05T04:59:02.111"
        "7"
    , FieldClampCaseRec
        "2016-06-05 04:03:02.111"
        (Minute -1)
        "2016-06-05T04:00:02.111"
        "8"
    , FieldClampCaseRec
        "2016-06-05 04:03:02.111"
        (Hour 24)
        "2016-06-05T23:03:02.111"
        "9"
    , FieldClampCaseRec
        "2016-06-05 04:03:02.111"
        (Hour -1)
        "2016-06-05T00:03:02.111"
        "10"
    , FieldClampCaseRec
        "2016-06-05 04:03:02.111"
        (DayOfMonth 0)
        "2016-06-01T04:03:02.111"
        "11"
    , FieldClampCaseRec
        "2016-06-05 04:03:02.111"
        (DayOfMonth 31)
        "2016-06-30T04:03:02.111"
        "12"
    , FieldClampCaseRec
        "2016-06-05 04:03:02.111"
        (Year -1)
        "0000-06-05T04:03:02.111"
        "13"
    , FieldClampCaseRec
        "2016-06-05 04:03:02.111"
        (DayOfMonth 31)
        "2016-06-30T04:03:02.111"
        "14"
    , FieldClampCaseRec
        "2016-06-05 04:03:02.111"
        -- 2016-06-05 is Sunday
        (DayOfWeek ( Mon, Mon ))
        "2016-05-30T04:03:02.111"
        "15"
    , FieldClampCaseRec
        "2016-06-05 04:03:02.111"
        (DayOfWeek ( Mon, Sun ))
        "2016-06-06T04:03:02.111"
        "16"
    , FieldClampCaseRec
        "2016-06-05 04:03:02.111"
        (DayOfWeek ( Thu, Thu ))
        "2016-06-02T04:03:02.111"
        "17"
    , FieldClampCaseRec
        "2016-06-05 04:03:02.111"
        (DayOfWeek ( Sat, Sun ))
        "2016-06-11T04:03:02.111"
        "17"
    ]
