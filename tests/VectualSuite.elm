module VectualSuite exposing (..)

import Test exposing (..)
import VectualTests
import VectualHelpersTests
import VectualHorizontalBarChartTests
import VectualDataTests


suite : Test
suite =
    describe "Vectual Library Test Suite"
        [ VectualTests.suite
        , VectualHelpersTests.suite
        , VectualHorizontalBarChartTests.suite
        , VectualDataTests.suite
        ]