module Vectual exposing (..)

{-| Contains methods that are relevant for all chart types
@docs defaultBaseConfig
@docs viewChart
-}

import Array
import Date exposing (Date)
import Date.Extra.Format as Format exposing (utcIsoString)
import Date.Extra.Utils as Utils exposing (isoWeek)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Styles exposing (stylusString)
import StylusParser exposing (stylusToCss)
import OpenSolid.Geometry.Types exposing (..)
import OpenSolid.Vector2d as Vector2d
import OpenSolid.Point2d as Point2d
import String.Extra exposing (replace)
import Vectual.Types exposing (..)
import Vectual.BarChart exposing (..)
import Vectual.BarChartStacked exposing (..)
import Vectual.PieChart exposing (..)
import Vectual.Helpers exposing (..)


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
