module Website exposing
    ( Model
    , Msg(..)
    , areaChart
    , barChart
    , barChartStacked
    , dataTable
    , horizontalBarChart
    , keyData
    , lineChart
    , main
    , model
    , stringToPosix
    , timeData
    , timeData1
    , timeData2
    , update
    , values
    , view
    )

import Browser
import Html exposing (Attribute, Html, a, div, h1, h2, main_, nav, node, p, section, text)
import Html.Attributes exposing (class, href)
import Iso8601 exposing (toTime)
import Stylus.Parser exposing (stylusToCss)
import Svg exposing (path, svg)
import Svg.Attributes as SA
import Time exposing (..)
import TimeUtils.Time exposing (utcWeek)
import Vectual exposing (..)
import Vectual.AreaChart exposing (..)
import Vectual.BarChart exposing (..)
import Vectual.BarChartStacked exposing (..)
import Vectual.Helpers exposing (..)
import Vectual.HorizontalBarChart exposing (..)
import Vectual.LineChart exposing (..)
import Vectual.PieChart exposing (..)
import Vectual.TagCloud exposing (..)
import Vectual.Types exposing (..)



-- Model,


type alias Model =
    { title : String }


model : Model
model =
    { title = "This is sooo awesome" }


type Msg
    = Display
    | Hide



-- Update


update : Msg -> Model -> Model
update msg mdl =
    case msg of
        Display ->
            { mdl | title = "Display" }

        Hide ->
            { mdl | title = "Hide" }


stringToPosix : String -> Posix
stringToPosix string =
    Result.withDefault
        (millisToPosix 0)
        (toTime string)


type FruitRecord
    = FruitRecord String String Float Float Float


dataTable : List FruitRecord
dataTable =
    [ FruitRecord "2020-12-25T12:00:00Z" "Apple" 50 50 12
    , FruitRecord "2020-12-26T12:00:00Z" "Plum" 32 16 12
    , FruitRecord "2020-12-27T12:00:00Z" "Peach" 11 29 12
    , FruitRecord "2020-12-28T12:00:00Z" "Lime" 23 9 12
    , FruitRecord "2020-12-29T12:00:00Z" "Cherry" 13 5 12
    , FruitRecord "2020-12-30T12:00:00Z" "Pineapple" 69 35 12
    , FruitRecord "2020-12-31T12:00:00Z" "Melon" 26 58 12
    , FruitRecord "2021-01-01T12:00:00Z" "Grapefruit" 35 13 12
    , FruitRecord "2021-01-02T12:00:00Z" "Strawberry" 56 25 12
    , FruitRecord "2021-01-03T12:00:00Z" "Orange" 34 38 12
    , FruitRecord "2021-01-04T12:00:00Z" "Kiwi" 65 44 12
    ]


values : Data
values =
    Values (List.map (\(FruitRecord _ _ value _ _) -> value) dataTable)


fruitRecToKeyRecord =
    \(FruitRecord _ key value _ _) -> KeyRecord key value 0


keyData : Data
keyData =
    KeyData (List.map fruitRecToKeyRecord dataTable)


timeData : Data
timeData =
    let
        fruitRecToRecord =
            \(FruitRecord key _ value _ _) ->
                TimeRecord (stringToPosix key) value 0
    in
    TimeData (List.map fruitRecToRecord dataTable)


timeData1 : Data
timeData1 =
    let
        fruitRecToRecord =
            \(FruitRecord key _ _ value _) ->
                TimeRecord (stringToPosix key) value 0
    in
    TimeData (List.map fruitRecToRecord dataTable)


timeData2 : Data
timeData2 =
    let
        fruitRecToRecord =
            \(FruitRecord key _ _ _ value) ->
                TimeRecord (stringToPosix key) value 0
    in
    TimeData (List.map fruitRecToRecord dataTable)


pieChart : Chart
pieChart =
    PieChart
        { defaultPieChartConfig
            | title = "Pie Chart"
            , xLabelFormatter = utcWeek
            , showAnimations = True
        }
        keyData


lineChart : Chart
lineChart =
    LineChart
        { defaultLineChartConfig
            | title = "Line Chart"
            , xLabelFormatter = utcWeek
            , showAnimations = True
        }
        timeData


areaChart : Chart
areaChart =
    AreaChart
        { defaultAreaChartConfig
            | title = "Area Chart"
            , xLabelFormatter = utcWeek
            , showAnimations = True
        }
        timeData


barChart : Chart
barChart =
    BarChart
        { defaultBarChartConfig
            | title = "Bar Chart"
            , xLabelFormatter = utcWeek
        }
        timeData


barChartStacked : Chart
barChartStacked =
    BarChartStacked
        { defaultBarChartConfig
            | title = "Stacked Bar Chart"
            , xLabelFormatter = utcWeek
        }
        [ timeData, timeData1, timeData2 ]


horizontalBarChart : Chart
horizontalBarChart =
    HorizontalBarChart
        { defaultHorizontalBarChartConfig
            | title = "Horizontal Bar Chart"
            , xLabelFormatter = utcWeek
        }
        timeData


tagCloud : Chart
tagCloud =
    TagCloud
        { defaultTagCloudConfig
            | title = "Tag Cloud"
        }
        keyData



-- View


styleEl : List (Attribute msg) -> List (Html msg) -> Html msg
styleEl attributes children =
    node "style" attributes children


bodyStylus =
    """
body
  font-family sans-serif
  background-color hsl(0, 0%, 12%)
  color lightgray

.wrapper
  width 54rem
  margin 0 auto

nav
  margin-bottom 2em
  display flex
  align-items baseline

h1
  color white
  font-size 2.2rem
  font-weight 900
  margin-right 0.5em
  margin-bottom 0
  display inline-block

a
  color hsl(176, 100%, 81%)

a:visited
  color hsl(346, 100%, 88%)

.github-btn
  margin-left auto
  display inline-flex
  align-items center
  align-self center
  background hsl(176, 25%, 28%)
  color #e6f3f1
  padding 0.35em 0.8em
  border-radius 6px
  font-weight 700
  text-decoration none
  border 1px solid rgba(255,255,255,0.12)
  transition background 120ms ease-in-out

.github-btn:visited
  color #e6f3f1

.github-btn:hover
  background hsl(176, 30%, 36%)
  color #ffffff

.github-btn svg
  margin-right 0.45em
  display inline-block
  vertical-align middle

.subtitle
  display inline-block

.vectual
  margin 0 1.5em 1.5em 0

.chart-section
  margin-bottom 3em

.chart-section h2
  color white
  font-size 1.8rem
  font-weight 700
  margin-bottom 1em
  border-bottom 1px solid dimgray
  padding-bottom 0.5em
"""


view : Model -> Html msg
view _ =
    div [ class "wrapper" ]
        [ styleEl []
            [ case stylusToCss bodyStylus of
                Ok value ->
                    text value

                Err error ->
                    Debug.log (Debug.toString error) (text "Error")
            ]
        , nav []
            [ h1 [] [ text "Vectual" ]
            , p [ class "subtitle" ]
                [ text "The Open Source Charting Library" ]
            , a [ class "github-btn", href "https://github.com/ad-si/vectual" ]
                [ svg
                    [ SA.width "16"
                    , SA.height "16"
                    , SA.viewBox "0 0 16 16"
                    , SA.fill "currentColor"
                    ]
                    [ path
                        [ SA.d """
                            M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38
                            0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82
                            -1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87
                            2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31
                            -1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32
                            -.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16
                            1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65
                            3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38
                            A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z
                            """ ]
                        []
                    ]
                , text "GitHub"
                ]
            ]
        , main_
            []
            [ section [ class "chart-section" ]
                [ h2 [] [ text "Line Charts" ]
                , viewChart lineChart
                , viewChart areaChart
                ]
            , section [ class "chart-section" ]
                [ h2 [] [ text "Bar Charts" ]
                , viewChart barChart
                , viewChart barChartStacked
                , viewChart horizontalBarChart
                ]
            , section [ class "chart-section" ]
                [ h2 [] [ text "Pie Charts" ]
                , viewChart pieChart
                ]
            , section [ class "chart-section" ]
                [ h2 [] [ text "Other Charts" ]
                , viewChart tagCloud
                ]
            ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = model
        , view = view
        , update = update
        }
