module Vectual exposing
    ( defaultBaseConfig
    , viewChart
    )

{-| Contains methods that are relevant for all chart types

@docs defaultBaseConfig
@docs viewChart

-}

import Styles exposing (stylusString)
import Stylus.Parser exposing (stylusToCss)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import TimeUtils.Time exposing (..)
import Vectual.BarChart exposing (..)
import Vectual.BarChartStacked exposing (..)
import Vectual.Helpers exposing (..)
import Vectual.LineChart exposing (..)
import Vectual.PieChart exposing (..)
import Vectual.TagCloud exposing (..)
import Vectual.Types exposing (..)


{-| -}
defaultBaseConfig : BaseConfigAnd {}
defaultBaseConfig =
    { title = "Vectual Chart"
    , inline = False
    , width = 400
    , height = 300
    , borderRadius = ( 2, 2 )
    , xLabelFormatter = utcDateTime
    }


{-| -}
viewChart : Chart -> Svg msg
viewChart chart =
    case chart of
        LineChart config data ->
            viewLineChart config data

        BarChart config data ->
            viewBarChart config data

        BarChartStacked config dataSet ->
            viewBarChartStacked config dataSet

        PieChart config data ->
            viewPieChart config data

        TagCloud config _ ->
            viewTagCloud config
