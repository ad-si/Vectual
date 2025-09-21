module VectualHelpersTests exposing (..)

import Expect
import Test exposing (..)
import Time exposing (Posix, millisToPosix)
import TimeUtils.Time exposing (utcWeek)
import Vectual.Helpers exposing (..)
import Vectual.Types exposing (..)


-- Test data
testTimeData : Data
testTimeData =
    TimeData
        [ { utc = millisToPosix 1609459200000, value = 10.0, offset = 0.0 }  -- 2021-01-01
        , { utc = millisToPosix 1609545600000, value = 20.0, offset = 0.0 }  -- 2021-01-02
        , { utc = millisToPosix 1609632000000, value = 15.0, offset = 0.0 }  -- 2021-01-03
        ]


testKeyData : Data
testKeyData =
    KeyData
        [ { key = "Apple", value = 25.0, offset = 0.0 }
        , { key = "Orange", value = 30.0, offset = 0.0 }
        , { key = "Banana", value = 15.0, offset = 0.0 }
        ]


testValues : Data
testValues =
    Values [ 10.0, 20.0, 15.0, 30.0 ]


testConfig : BaseConfigAnd { yStartAtZero : Bool }
testConfig =
    { title = "Test Chart"
    , inline = False
    , width = 400
    , height = 300
    , borderRadius = ( 2, 2 )
    , xLabelFormatter = utcWeek
    , yStartAtZero = True
    }


suite : Test
suite =
    describe "Vectual.Helpers Tests"
        [ describe "Data extraction tests"
            [ test "getDataValues extracts values from TimeData" <|
                \_ ->
                    let
                        values = getDataValues testTimeData
                        expected = [ 10.0, 20.0, 15.0 ]
                    in
                    Expect.equal values expected

            , test "getDataValues extracts values from KeyData" <|
                \_ ->
                    let
                        values = getDataValues testKeyData
                        expected = [ 25.0, 30.0, 15.0 ]
                    in
                    Expect.equal values expected

            , test "getDataValues extracts values from Values" <|
                \_ ->
                    let
                        values = getDataValues testValues
                        expected = [ 10.0, 20.0, 15.0, 30.0 ]
                    in
                    Expect.equal values expected

            , test "getDataValues returns empty list for InvalidData" <|
                \_ ->
                    let
                        values = getDataValues InvalidData
                        expected = []
                    in
                    Expect.equal values expected
            ]

        , describe "Data length tests"
            [ test "getDataLength returns correct length for TimeData" <|
                \_ ->
                    let
                        length = getDataLength testTimeData
                    in
                    Expect.equal length 3

            , test "getDataLength returns correct length for KeyData" <|
                \_ ->
                    let
                        length = getDataLength testKeyData
                    in
                    Expect.equal length 3

            , test "getDataLength returns correct length for Values" <|
                \_ ->
                    let
                        length = getDataLength testValues
                    in
                    Expect.equal length 4

            , test "getDataLength returns 0 for InvalidData" <|
                \_ ->
                    let
                        length = getDataLength InvalidData
                    in
                    Expect.equal length 0
            ]

        , describe "Data labels tests"
            [ test "getDataLabels extracts labels from TimeData" <|
                \_ ->
                    let
                        labels = getDataLabels testConfig testTimeData
                    in
                    Expect.equal (List.length labels) 3

            , test "getDataLabels extracts labels from KeyData" <|
                \_ ->
                    let
                        labels = getDataLabels testConfig testKeyData
                        expected = [ "Apple", "Orange", "Banana" ]
                    in
                    Expect.equal labels expected

            , test "getDataLabels generates labels for Values" <|
                \_ ->
                    let
                        labels = getDataLabels testConfig testValues
                        expected = [ "0", "1", "2", "3" ]
                    in
                    Expect.equal labels expected

            , test "getDataLabels returns empty list for InvalidData" <|
                \_ ->
                    let
                        labels = getDataLabels testConfig InvalidData
                        expected = []
                    in
                    Expect.equal labels expected
            ]

        , describe "Data records tests"
            [ test "getDataRecords converts TimeData to entries" <|
                \_ ->
                    let
                        records = getDataRecords testTimeData
                        firstRecord = List.head records
                    in
                    case firstRecord of
                        Just record ->
                            Expect.all
                                [ \r -> Expect.equal r.value 10.0
                                , \r -> Expect.equal r.offset 0.0
                                ]
                                record

                        Nothing ->
                            Expect.fail "Expected at least one record"

            , test "getDataRecords converts KeyData to entries" <|
                \_ ->
                    let
                        records = getDataRecords testKeyData
                        firstRecord = List.head records
                    in
                    case firstRecord of
                        Just record ->
                            Expect.all
                                [ \r -> Expect.equal r.label "Apple"
                                , \r -> Expect.equal r.value 25.0
                                , \r -> Expect.equal r.offset 0.0
                                ]
                                record

                        Nothing ->
                            Expect.fail "Expected at least one record"

            , test "getDataRecords converts Values to entries" <|
                \_ ->
                    let
                        records = getDataRecords testValues
                        firstRecord = List.head records
                    in
                    case firstRecord of
                        Just record ->
                            Expect.all
                                [ \r -> Expect.equal r.label "0"
                                , \r -> Expect.equal r.value 10.0
                                , \r -> Expect.equal r.offset 0.0
                                ]
                                record

                        Nothing ->
                            Expect.fail "Expected at least one record"
            ]

        , describe "MetaData tests"
            [ test "getMetaData calculates correct dimensions" <|
                \_ ->
                    let
                        metaData = getMetaData testConfig testTimeData
                    in
                    Expect.all
                        [ \m -> Expect.equal m.numberOfEntries 3
                        , \m -> Expect.equal m.yMinimum 0.0  -- yStartAtZero is True
                        , \m -> Expect.equal m.yMaximum 20.0
                        , \m -> Expect.equal m.yRange 20.0
                        , \m -> Expect.greaterThan 0 m.graphWidth
                        , \m -> Expect.greaterThan 0 m.graphHeight
                        ]
                        metaData

            , test "getMetaData respects yStartAtZero setting" <|
                \_ ->
                    let
                        configNoZero = { testConfig | yStartAtZero = False }
                        metaData = getMetaData configNoZero testTimeData
                    in
                    Expect.equal metaData.yMinimum 10.0  -- Should use data minimum
            ]
        ]