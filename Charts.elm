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


type alias ChartInfo =
    { title : String
    , inline : Bool
    , width : Int
    , height : Int
    , borderRadius : ( Int, Int )
    }


type alias PieChartInfo =
    { title : String
    }


type alias BarChartInfo =
    { title : String
    , inline : Bool
    , width : Int
    , height : Int
    , borderRadius : ( Int, Int )
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


chartWrapper : ChartInfo -> Svg msg
chartWrapper chartInfo =
    let
        className =
            if chartInfo.inline then
                "vectual_inline"
            else
                "vectual"

        ( borderRadiusX, borderRadiusY ) =
            chartInfo.borderRadius
    in
        svg
            [ version "1.1"
            , class className
            , width (toString chartInfo.width)
            , height (toString chartInfo.height)
            , viewBox
                ("0 0 "
                    ++ toString chartInfo.width
                    ++ " "
                    ++ toString chartInfo.height
                )
            ]
            [ Svg.style [] [ text "svg {color: green; font-family: Arial;}" ]
            , rect
                [ class "vectual_background"
                , width (toString chartInfo.width)
                , height (toString chartInfo.height)
                , rx (toString borderRadiusX)
                , ry (toString borderRadiusY)
                ]
                []
            , text_
                [ class "vectual_title"
                , x (toString 20)
                , y (toString (10 + 0.05 * (toFloat chartInfo.height)))
                , Svg.Attributes.style
                    ("font-size:"
                        ++ (toString (0.05 * (toFloat chartInfo.height)))
                        ++ "px"
                    )
                ]
                [ text chartInfo.title ]
            ]


viewBarChart : BarChartInfo -> Svg msg
viewBarChart barChartInfo =
    chartWrapper barChartInfo


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
