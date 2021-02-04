module Vectual.PieChart exposing (viewPieChart)

{-| This module creates a simple pie chart.

@docs viewPieChart

-}

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Vectual.Types exposing (..)


{-| -}
viewPieChart : PieChartConfig -> Data -> Svg msg
viewPieChart config data =
    circle [ r "50" ] []
