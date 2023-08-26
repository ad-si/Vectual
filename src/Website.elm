module Website exposing
    ( Model
    , Msg(..)
    , barChart
    , barChartStacked
    , dataTable
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
import Html exposing (Attribute, Html, a, div, h1, main_, nav, node, p, text)
import Html.Attributes exposing (class, href)
import Iso8601 exposing (toTime)
import Stylus.Parser exposing (stylusToCss)
import Time exposing (..)
import TimeUtils.Time exposing (utcWeek)
import Vectual exposing (..)
import Vectual.BarChart exposing (..)
import Vectual.BarChartStacked exposing (..)
import Vectual.Helpers exposing (..)
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


tagCloud : Chart
tagCloud =
    TagCloud
        { defaultTagCloudConfig
            | title = "Tag Cloud"
        }
        timeData



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
  border-bottom 1px solid dimgray
  margin-bottom 2em

h1
  color white
  font-size 2.2rem
  font-weight 900
  margin-right 0.5em
  margin-bottom 0.5em
  display inline-block

a
  color hsl(176, 100%, 81%)

a:visited
  color hsl(346, 100%, 88%)

.subtitle
  display inline-block

.vectual
  margin 0 1.5em 1.5em 0
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
            , p []
                [ text "Learn more at "
                , a
                    [ href "https://github.com/ad-si/vectual" ]
                    [ text "github.com/ad-si/vectual"
                    ]
                , text "."
                ]
            ]
        , main_
            []
            [ viewChart lineChart
            , viewChart barChart
            , viewChart barChartStacked
            , viewChart pieChart
            , viewChart tagCloud
            ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = model
        , view = view
        , update = update
        }
