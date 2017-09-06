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
import Html exposing (link)


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


css : String
css =
    """
    .vectual-title {
      fill: green;
      font-family: Arial;
    }
    """


chartWrapper : ChartInfo -> Svg msg
chartWrapper chartInfo =
    let
        className =
            if chartInfo.inline then
                "vectual-inline"
            else
                "vectual"

        ( borderRadiusX, borderRadiusY ) =
            chartInfo.borderRadius
    in
        Svg.svg
            [ version "1.1"
            , class className
            , width (toString chartInfo.width)
            , height (toString chartInfo.height)
            , viewBox
                (String.join " "
                    (List.map toString
                        [ 0, 0, chartInfo.width, chartInfo.height ]
                    )
                )
            ]
            [ Svg.style [] [ text css ]
            , link
                [ rel "stylesheet", type_ "text/css", href "css/vectual.css" ]
                []
            , rect
                [ class "vectual-background"
                , width (toString chartInfo.width)
                , height (toString chartInfo.height)
                , rx (toString borderRadiusX)
                , ry (toString borderRadiusY)
                ]
                []
            , text_
                [ class "vectual-title"
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
