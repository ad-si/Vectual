module Vectual.Types exposing
    ( Alignment(..)
    , LineChartConfig
    , BarChartConfig
    , BaseConfigAnd
    , Chart(..)
    , Data(..)
    , Datas
    , Entries
    , Entry
    , Key
    , KeyRecord
    , MetaData
    , PieChartConfig
    , Radian
    , TimeRecord
    , Value(..)
    )

{-| All types that are used in Vectual

@docs Alignment
@docs LineChartConfig
@docs BarChartConfig
@docs BaseConfigAnd
@docs Chart
@docs Data
@docs Datas
@docs Entries
@docs Entry
@docs Key
@docs KeyRecord
@docs MetaData
@docs PieChartConfig
@docs Radian
@docs TimeRecord
@docs Value

-}

import Time exposing (Posix)
import Vector2d exposing (..)


{-| -}
type alias Radian =
    Float


{-| -}
type alias Key =
    String


{-| -}
type Value
    = Int
    | Float



-- TODO: Add GridBaseConfig for all chart types with a coordinate system


{-| -}
type alias BaseConfigAnd extraFields =
    { extraFields
        | title : String
        , inline : Bool
        , width : Int
        , height : Int
        , borderRadius : ( Int, Int )
        , xLabelFormatter : Posix -> String
    }


{-| -}
type alias PieChartConfig =
    BaseConfigAnd
        { radius : Int
        , showAnimations : Bool
        , yStartAtZero : Bool -- TODO: Remove
        }


{-| -}
type Alignment
    = Left
    | Center
    | Right


{-| -}
type alias LineChartConfig =
    BaseConfigAnd
        { labelAngle : Radian
        , yStartAtZero : Bool
        , alignBars : Alignment
        , showAnimations : Bool
        }


{-| -}
type alias BarChartConfig =
    BaseConfigAnd
        { labelAngle : Radian
        , yStartAtZero : Bool
        , alignBars : Alignment
        }


{-| -}
type alias TimeRecord =
    { utc : Posix
    , value : Float
    , offset : Float
    }


{-| -}
type alias KeyRecord =
    { key : Key
    , value : Float
    , offset : Float
    }



-- TODO: Normalize records to entries


{-| -}
type alias Entry =
    { label : String
    , value : Float
    , offset : Float -- Store offset in e.g. BarChartStacked or PieChart
    }


{-| -}
type alias Entries =
    -- Normalized form of Data
    List Entry


{-| -}
type Data
    = TimeData (List TimeRecord)
    | KeyData (List KeyRecord)
    | Values (List Float)
    | InvalidData


{-| -}
type alias Datas =
    List Data


{-| -}
type Chart
    = LineChart LineChartConfig Data
    | BarChart BarChartConfig Data
    | BarChartStacked BarChartConfig Datas
    | PieChart PieChartConfig Data


{-| -}
type alias MetaData units coordinates =
    { graphWidth : Int
    , graphHeight : Int
    , coordSysWidth : Int
    , coordSysHeight : Int
    , translation : Vector2d units coordinates
    , numberOfEntries : Int
    , yMinimum : Float
    , yMaximum : Float
    , yRange : Float
    }
