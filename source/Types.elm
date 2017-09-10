module Types exposing (..)

import Date exposing (Date)
import OpenSolid.Geometry.Types exposing (..)


type alias Radian =
    Float


type alias Key =
    String


type Value
    = Int
    | Float


type alias BaseConfigAnd extraFields =
    { extraFields
        | title : String
        , inline : Bool
        , width : Int
        , height : Int
        , borderRadius : ( Int, Int )
        , xLabelFormatter : Date -> String
    }


type alias PieChartConfig =
    BaseConfigAnd { radius : Int }


type Alignment
    = Left
    | Center
    | Right


type alias BarChartConfig =
    BaseConfigAnd
        { labelAngle : Radian
        , yStartAtZero : Bool
        , alignBars : Alignment
        }


type alias TimeRecord =
    { utc : Date
    , value : Float
    }


type alias KeyRecord =
    { key : Key
    , value : Float
    }


type alias Entry =
    { label : String
    , value : Float
    }


type Data
    = TimeData (List TimeRecord)
    | KeyData (List KeyRecord)
    | Values (List Float)


type Chart
    = PieChart PieChartConfig Data
    | BarChart BarChartConfig Data


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
