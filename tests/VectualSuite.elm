module VectualSuite exposing (..)

import Test exposing (..)
import VectualDataTests
import VectualHelpersTests
import VectualHorizontalBarChartTests
import VectualTests


suite : Test
suite =
    describe "Vectual Library Test Suite"
        [ VectualTests.suite
        , VectualHelpersTests.suite
        , VectualHorizontalBarChartTests.suite
        , VectualDataTests.suite
        ]
