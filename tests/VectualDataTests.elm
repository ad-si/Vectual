module VectualDataTests exposing (..)

import Expect
import Test exposing (..)
import Time exposing (Posix, millisToPosix)
import Vectual.Types exposing (..)


suite : Test
suite =
    describe "Vectual Data Types Tests"
        [ describe "Data type tests"
            [ test "TimeData stores time records correctly" <|
                \_ ->
                    let
                        timeRecord =
                            { utc = millisToPosix 1000, value = 10.0, offset = 0.0 }

                        timeData =
                            TimeData [ timeRecord ]
                    in
                    case timeData of
                        TimeData records ->
                            case List.head records of
                                Just record ->
                                    Expect.all
                                        [ \r -> Expect.equal r.utc (millisToPosix 1000)
                                        , \r -> Expect.equal r.value 10.0
                                        , \r -> Expect.equal r.offset 0.0
                                        ]
                                        record

                                Nothing ->
                                    Expect.fail "Expected a record"

                        _ ->
                            Expect.fail "Expected TimeData"
            , test "KeyData stores key records correctly" <|
                \_ ->
                    let
                        keyRecord =
                            { key = "Apple", value = 25.0, offset = 0.0 }

                        keyData =
                            KeyData [ keyRecord ]
                    in
                    case keyData of
                        KeyData records ->
                            case List.head records of
                                Just record ->
                                    Expect.all
                                        [ \r -> Expect.equal r.key "Apple"
                                        , \r -> Expect.equal r.value 25.0
                                        , \r -> Expect.equal r.offset 0.0
                                        ]
                                        record

                                Nothing ->
                                    Expect.fail "Expected a record"

                        _ ->
                            Expect.fail "Expected KeyData"
            , test "Values stores float list correctly" <|
                \_ ->
                    let
                        values =
                            Values [ 1.0, 2.0, 3.0 ]
                    in
                    case values of
                        Values list ->
                            Expect.equal list [ 1.0, 2.0, 3.0 ]

                        _ ->
                            Expect.fail "Expected Values"
            , test "InvalidData represents invalid state" <|
                \_ ->
                    let
                        invalidData =
                            InvalidData
                    in
                    case invalidData of
                        InvalidData ->
                            Expect.pass

                        _ ->
                            Expect.fail "Expected InvalidData"
            ]
        , describe "Chart type tests"
            [ test "LineChart type holds config and data" <|
                \_ ->
                    let
                        config =
                            { title = "Test", inline = False, width = 400, height = 300, borderRadius = ( 2, 2 ), xLabelFormatter = \_ -> "", labelAngle = 0, yStartAtZero = True, alignBars = Center, showAnimations = False }

                        data =
                            Values [ 1.0, 2.0 ]

                        chart =
                            LineChart config data
                    in
                    case chart of
                        LineChart chartConfig chartData ->
                            Expect.all
                                [ \_ -> Expect.equal chartConfig.title "Test"
                                , \_ -> Expect.equal chartData data
                                ]
                                ()

                        _ ->
                            Expect.fail "Expected LineChart"
            , test "BarChart type holds config and data" <|
                \_ ->
                    let
                        config =
                            { title = "Test", inline = False, width = 400, height = 300, borderRadius = ( 2, 2 ), xLabelFormatter = \_ -> "", labelAngle = 0, yStartAtZero = True, alignBars = Center }

                        data =
                            Values [ 1.0, 2.0 ]

                        chart =
                            BarChart config data
                    in
                    case chart of
                        BarChart chartConfig chartData ->
                            Expect.all
                                [ \_ -> Expect.equal chartConfig.title "Test"
                                , \_ -> Expect.equal chartData data
                                ]
                                ()

                        _ ->
                            Expect.fail "Expected BarChart"
            , test "PieChart type holds config and data" <|
                \_ ->
                    let
                        config =
                            { title = "Test", inline = False, width = 400, height = 300, borderRadius = ( 2, 2 ), xLabelFormatter = \_ -> "", radius = 100, showAnimations = False, yStartAtZero = True }

                        data =
                            Values [ 1.0, 2.0 ]

                        chart =
                            PieChart config data
                    in
                    case chart of
                        PieChart chartConfig chartData ->
                            Expect.all
                                [ \_ -> Expect.equal chartConfig.title "Test"
                                , \_ -> Expect.equal chartData data
                                ]
                                ()

                        _ ->
                            Expect.fail "Expected PieChart"
            ]
        , describe "Alignment type tests"
            [ test "Left alignment" <|
                \_ ->
                    let
                        alignment =
                            Left
                    in
                    case alignment of
                        Left ->
                            Expect.pass

                        _ ->
                            Expect.fail "Expected Left alignment"
            , test "Center alignment" <|
                \_ ->
                    let
                        alignment =
                            Center
                    in
                    case alignment of
                        Center ->
                            Expect.pass

                        _ ->
                            Expect.fail "Expected Center alignment"
            , test "Right alignment" <|
                \_ ->
                    let
                        alignment =
                            Right
                    in
                    case alignment of
                        Right ->
                            Expect.pass

                        _ ->
                            Expect.fail "Expected Right alignment"
            ]
        ]
