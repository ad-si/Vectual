module Charts
    exposing
        ( Chart
        , BarChartInfo
        , viewPieChart
        , viewBarChart
        , viewLineChart
        , viewTagCloud
        , viewMap
        , viewTable
        )

import Svg exposing (..)
import Svg.Attributes exposing (..)


type alias PieChartInfo =
    { title : String
    }


type alias BarChartInfo =
    { title : String
    , inline : Bool
    , width : Int
    , height : Int
    }


type alias LineChartInfo =
    { title : String
    }


type alias TagCloudInfo =
    { title : String
    }


type alias MapInfo =
    { title : String
    }


type alias TableInfo =
    { title : String
    }


type Chart
    = PieChart PieChartInfo
    | BarChart BarChartInfo
    | LineChart LineChartInfo
    | TagCloud TagCloudInfo
    | Map MapInfo
    | Table TableInfo


viewPieChart : PieChartInfo -> Svg msg
viewPieChart pieChartInfo =
    text (toString pieChartInfo)


viewBarChart : BarChartInfo -> Svg msg
viewBarChart barChartInfo =
    let
        className =
            if barChartInfo.inline then
                "vectual_inline"
            else
                "vectual"
    in
        svg
            [ version "1.1"
            , class className
            , width (toString barChartInfo.width)
            , height (toString barChartInfo.height)
            , viewBox
                ("0 0 "
                    ++ toString barChartInfo.width
                    ++ " "
                    ++ toString barChartInfo.height
                )
            ]
            [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
            ]


viewLineChart : LineChartInfo -> Svg msg
viewLineChart lineChartInfo =
    text (toString lineChartInfo)


viewTagCloud : TagCloudInfo -> Svg msg
viewTagCloud tagCloudInfo =
    text (toString tagCloudInfo)


viewMap : MapInfo -> Svg msg
viewMap mapInfo =
    text (toString mapInfo)


viewTable : TableInfo -> Svg msg
viewTable tableInfo =
    text (toString tableInfo)
