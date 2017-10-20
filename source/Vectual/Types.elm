module Vectual.Types
    exposing
        ( Radian
        , Key
        , Value(..)
        , BaseConfigAnd
        , PieChartConfig
        , Alignment(..)
        , BarChartConfig
        , TimeRecord
        , KeyRecord
        , Entry
        , Entries
        , Data(..)
        , Datas
        , Chart(..)
        , MetaData
        )

{-| All types that are used in Vectual

@docs Alignment
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

import Date exposing (Date)
import OpenSolid.Geometry.Types exposing (..)


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


{-| -}
type alias BaseConfigAnd extraFields =
    { extraFields
        | title : String
        , inline : Bool
        , width : Int
        , height : Int
        , borderRadius : ( Int, Int )
        , xLabelFormatter : Date -> String
    }


{-| -}
type alias PieChartConfig =
    BaseConfigAnd { radius : Int }


{-| -}
type Alignment
    = Left
    | Center
    | Right


{-| -}
type alias BarChartConfig =
    BaseConfigAnd
        { labelAngle : Radian
        , yStartAtZero : Bool
        , alignBars : Alignment
        }


{-| -}
type alias TimeRecord =
    { utc : Date
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
    = PieChart PieChartConfig Data
    | BarChart BarChartConfig Data
    | BarChartStacked BarChartConfig Datas


{-| -}
type alias MetaData =
    { graphWidth : Int
    , graphHeight : Int
    , coordSysWidth : Int
    , coordSysHeight : Int
    , translation : Vector2d
    , numberOfEntries : Int
    , yMinimum : Float
    , yMaximum : Float
    , yRange : Float
    }
