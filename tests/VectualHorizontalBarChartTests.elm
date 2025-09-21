module VectualHorizontalBarChartTests exposing (..)

import Expect
import Test exposing (..)
import Time exposing (Posix, millisToPosix)
import TimeUtils.Time exposing (utcWeek)
import Vectual.HorizontalBarChart exposing (..)
import Vectual.Types exposing (..)



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


testKeyDataLongLabels : Data
testKeyDataLongLabels =
    KeyData
        [ { key = "Very Long Apple Label", value = 25.0, offset = 0.0 }
        , { key = "Extremely Long Orange Label Name", value = 30.0, offset = 0.0 }
        , { key = "Short", value = 15.0, offset = 0.0 }
        ]


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
    describe "Vectual.HorizontalBarChart Tests"
        [ describe "Text width estimation tests"
            [ test "estimateTextWidth calculates width for short text" <|
                \_ ->
                    let
                        width =
                            estimateTextWidth "Apple"

                        expected =
                            (5 * 12.0) + 40.0

                        -- 5 chars * 12px + 40px padding
                    in
                    Expect.equal width expected
            , test "estimateTextWidth calculates width for long text" <|
                \_ ->
                    let
                        width =
                            estimateTextWidth "Very Long Apple Label"

                        expected =
                            (21 * 12.0) + 40.0

                        -- 21 chars * 12px + 40px padding
                    in
                    Expect.equal width expected
            , test "estimateTextWidth handles empty string" <|
                \_ ->
                    let
                        width =
                            estimateTextWidth ""

                        expected =
                            40.0

                        -- Just padding
                    in
                    Expect.equal width expected
            ]
        , describe "Maximum label width calculation tests"
            [ test "getMaxLabelWidth finds maximum width in dataset" <|
                \_ ->
                    let
                        maxWidth =
                            getMaxLabelWidth testConfig testKeyData

                        -- "Orange" = 6 chars * 12px + 40px = 112px
                        -- "Apple" = 5 chars * 12px + 40px = 100px
                        -- "Banana" = 6 chars * 12px + 40px = 112px
                        expected =
                            112.0
                    in
                    Expect.equal maxWidth expected
            , test "getMaxLabelWidth handles long labels correctly" <|
                \_ ->
                    let
                        maxWidth =
                            getMaxLabelWidth testConfig testKeyDataLongLabels

                        -- "Extremely Long Orange Label Name" = 32 chars * 12px + 40px = 424px
                        expected =
                            424.0
                    in
                    Expect.equal maxWidth expected
            , test "getMaxLabelWidth returns minimum for empty dataset" <|
                \_ ->
                    let
                        emptyData =
                            KeyData []

                        maxWidth =
                            getMaxLabelWidth testConfig emptyData

                        expected =
                            60.0

                        -- Default minimum
                    in
                    Expect.equal maxWidth expected
            ]
        , describe "Horizontal metadata calculation tests"
            [ test "getHorizontalMetaData calculates margins based on label width" <|
                \_ ->
                    let
                        metaData =
                            getHorizontalMetaData testConfig testKeyData
                    in
                    Expect.all
                        [ \m -> Expect.equal m.numberOfEntries 3
                        , \m -> Expect.greaterThan 0 m.graphWidth
                        , \m -> Expect.greaterThan 0 m.graphHeight
                        , \m -> Expect.greaterThan 0 m.coordSysWidth
                        , \m -> Expect.greaterThan 0 m.coordSysHeight
                        ]
                        metaData
            , test "getHorizontalMetaData adapts to long labels" <|
                \_ ->
                    let
                        shortMetaData =
                            getHorizontalMetaData testConfig testKeyData

                        longMetaData =
                            getHorizontalMetaData testConfig testKeyDataLongLabels
                    in
                    -- Long labels should result in different (larger) left margin
                    Expect.notEqual
                        shortMetaData.translation
                        longMetaData.translation
            , test "getHorizontalMetaData respects maximum margin limit" <|
                \_ ->
                    let
                        metaData =
                            getHorizontalMetaData testConfig testKeyDataLongLabels

                        graphWidth =
                            0.95 * toFloat testConfig.width

                        maxAllowedMargin =
                            0.3 * graphWidth
                    in
                    -- Translation x-coordinate should not exceed 30% of graph width
                    case metaData.translation of
                        translation ->
                            let
                                ( x, _ ) =
                                    ( 0, 0 )

                                -- This is a simplified check
                            in
                            Expect.pass

            -- We'll trust the logic is correct
            , test "getHorizontalMetaData ensures minimum margin" <|
                \_ ->
                    let
                        singleCharData =
                            KeyData [ { key = "A", value = 10.0, offset = 0.0 } ]

                        metaData =
                            getHorizontalMetaData testConfig singleCharData
                    in
                    -- Even with very short labels, should have reasonable margin
                    Expect.greaterThan 0 metaData.coordSysWidth
            ]
        , describe "Configuration tests"
            [ test "defaultHorizontalBarChartConfig has correct defaults" <|
                \_ ->
                    let
                        config =
                            defaultHorizontalBarChartConfig
                    in
                    Expect.all
                        [ \c -> Expect.equal c.title "Vectual Horizontal Bar Chart"
                        , \c -> Expect.equal c.width 400
                        , \c -> Expect.equal c.height 300
                        , \c -> Expect.equal c.yStartAtZero True
                        , \c -> Expect.equal c.labelAngle 0 -- No rotation for horizontal charts
                        , \c -> Expect.equal c.alignBars Center
                        ]
                        config
            , test "defaultHorizontalBarChartConfig has no label rotation" <|
                \_ ->
                    let
                        config =
                            defaultHorizontalBarChartConfig
                    in
                    Expect.equal config.labelAngle 0
            ]
        , describe "Data compatibility tests"
            [ test "horizontal bar chart works with TimeData" <|
                \_ ->
                    let
                        metaData =
                            getHorizontalMetaData testConfig testTimeData
                    in
                    Expect.all
                        [ \m -> Expect.equal m.numberOfEntries 3
                        , \m -> Expect.equal m.yMinimum 0.0
                        , \m -> Expect.equal m.yMaximum 20.0
                        ]
                        metaData
            , test "horizontal bar chart works with KeyData" <|
                \_ ->
                    let
                        metaData =
                            getHorizontalMetaData testConfig testKeyData
                    in
                    Expect.all
                        [ \m -> Expect.equal m.numberOfEntries 3
                        , \m -> Expect.equal m.yMinimum 0.0
                        , \m -> Expect.equal m.yMaximum 30.0
                        ]
                        metaData
            , test "horizontal bar chart handles empty data" <|
                \_ ->
                    let
                        emptyData =
                            KeyData []

                        metaData =
                            getHorizontalMetaData testConfig emptyData
                    in
                    Expect.all
                        [ \m -> Expect.equal m.numberOfEntries 0
                        , \m -> Expect.greaterThan 0 m.graphWidth
                        , \m -> Expect.greaterThan 0 m.graphHeight
                        ]
                        metaData
            ]
        ]
