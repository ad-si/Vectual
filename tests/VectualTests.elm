module VectualTests exposing (..)

import Expect
import Test exposing (..)
import Time exposing (Posix, millisToPosix)
import Vectual exposing (..)
import Vectual.Types exposing (..)
import Vectual.BarChart exposing (defaultBarChartConfig)
import Vectual.LineChart exposing (defaultLineChartConfig)
import Vectual.AreaChart exposing (defaultAreaChartConfig)
import Vectual.PieChart exposing (defaultPieChartConfig)
import Vectual.HorizontalBarChart exposing (defaultHorizontalBarChartConfig)


-- Test data
testTimeData : Data
testTimeData =
    TimeData
        [ { utc = millisToPosix 1000, value = 10.0, offset = 0.0 }
        , { utc = millisToPosix 2000, value = 20.0, offset = 0.0 }
        , { utc = millisToPosix 3000, value = 15.0, offset = 0.0 }
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


suite : Test
suite =
    describe "Vectual Chart Tests"
        [ describe "Chart Creation Tests"
            [ test "LineChart creation with TimeData" <|
                \_ ->
                    let
                        chart = LineChart defaultLineChartConfig testTimeData
                    in
                    case chart of
                        LineChart config data ->
                            Expect.equal data testTimeData

                        _ ->
                            Expect.fail "Expected LineChart"

            , test "AreaChart creation with TimeData" <|
                \_ ->
                    let
                        chart = AreaChart defaultAreaChartConfig testTimeData
                    in
                    case chart of
                        AreaChart config data ->
                            Expect.equal data testTimeData

                        _ ->
                            Expect.fail "Expected AreaChart"

            , test "BarChart creation with TimeData" <|
                \_ ->
                    let
                        chart = BarChart defaultBarChartConfig testTimeData
                    in
                    case chart of
                        BarChart config data ->
                            Expect.equal data testTimeData

                        _ ->
                            Expect.fail "Expected BarChart"

            , test "HorizontalBarChart creation with TimeData" <|
                \_ ->
                    let
                        chart = HorizontalBarChart defaultHorizontalBarChartConfig testTimeData
                    in
                    case chart of
                        HorizontalBarChart config data ->
                            Expect.equal data testTimeData

                        _ ->
                            Expect.fail "Expected HorizontalBarChart"

            , test "PieChart creation with KeyData" <|
                \_ ->
                    let
                        chart = PieChart defaultPieChartConfig testKeyData
                    in
                    case chart of
                        PieChart config data ->
                            Expect.equal data testKeyData

                        _ ->
                            Expect.fail "Expected PieChart"

            , test "BarChartStacked creation with multiple datasets" <|
                \_ ->
                    let
                        datasets = [ testTimeData, testTimeData ]
                        chart = BarChartStacked defaultBarChartConfig datasets
                    in
                    case chart of
                        BarChartStacked config data ->
                            Expect.equal data datasets

                        _ ->
                            Expect.fail "Expected BarChartStacked"
            ]

        , describe "Chart Configuration Tests"
            [ test "LineChart config has correct defaults" <|
                \_ ->
                    let
                        config = defaultLineChartConfig
                    in
                    Expect.all
                        [ \c -> Expect.equal c.title "Vectual Line Chart"
                        , \c -> Expect.equal c.width 400
                        , \c -> Expect.equal c.height 300
                        , \c -> Expect.equal c.yStartAtZero True
                        ]
                        config

            , test "AreaChart config has correct defaults" <|
                \_ ->
                    let
                        config = defaultAreaChartConfig
                    in
                    Expect.all
                        [ \c -> Expect.equal c.title "Vectual Area Chart"
                        , \c -> Expect.equal c.width 400
                        , \c -> Expect.equal c.height 300
                        , \c -> Expect.equal c.yStartAtZero True
                        ]
                        config

            , test "BarChart config has correct defaults" <|
                \_ ->
                    let
                        config = defaultBarChartConfig
                    in
                    Expect.all
                        [ \c -> Expect.equal c.title "Vectual Bar Chart"
                        , \c -> Expect.equal c.width 400
                        , \c -> Expect.equal c.height 300
                        , \c -> Expect.equal c.yStartAtZero True
                        ]
                        config

            , test "HorizontalBarChart config has correct defaults" <|
                \_ ->
                    let
                        config = defaultHorizontalBarChartConfig
                    in
                    Expect.all
                        [ \c -> Expect.equal c.title "Vectual Horizontal Bar Chart"
                        , \c -> Expect.equal c.width 400
                        , \c -> Expect.equal c.height 300
                        , \c -> Expect.equal c.yStartAtZero True
                        , \c -> Expect.equal c.labelAngle 0
                        ]
                        config

            , test "PieChart config has correct defaults" <|
                \_ ->
                    let
                        config = defaultPieChartConfig
                    in
                    Expect.all
                        [ \c -> Expect.equal c.title "Vectual Pie Chart"
                        , \c -> Expect.equal c.width 400
                        , \c -> Expect.equal c.height 300
                        , \c -> Expect.equal c.showAnimations False
                        ]
                        config
            ]
        ]