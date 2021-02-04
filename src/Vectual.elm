module Vectual exposing
    ( defaultBaseConfig
    , viewChart
    )

{-| Contains methods that are relevant for all chart types

@docs defaultBaseConfig
@docs viewChart

-}

--import Date exposing (Date)
--import Date.Extra.Format as Format exposing (utcIsoString)

import Styles exposing (stylusString)
import StylusParser exposing (stylusToCss)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Vectual.BarChart exposing (..)
import Vectual.BarChartStacked exposing (..)
import Vectual.Helpers exposing (..)
import Vectual.PieChart exposing (..)
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
        BarChart config data ->
            viewBarChart config data

        BarChartStacked config dataSet ->
            viewBarChartStacked config dataSet

        PieChart config data ->
            viewPieChart config data
