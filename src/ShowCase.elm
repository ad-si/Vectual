module ShowCase exposing
    ( Model
    , Msg(..)
    , barChart
    , barChartStacked
    , dataTable
    , keyData
    , main
    , model
    , stringToDate
    , timeData
    , timeData1
    , timeData2
    , update
    , values
    , view
    )

import Browser
import Html exposing (Html, text)
import Iso8601 exposing (fromTime, toTime)
import Svg exposing (Svg)
import Time exposing (..)
import Vectual exposing (..)
import Vectual.BarChart exposing (..)
import Vectual.BarChartStacked exposing (..)
import Vectual.Helpers exposing (..)
import Vectual.Types exposing (..)



-- Model


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


stringToDate : String -> Posix
stringToDate string =
    Result.withDefault
        (millisToPosix 0)
        (toTime string)


type FruitRecord
    = FruitRecord String String Float Float Float


dataTable : List FruitRecord
dataTable =
    [ FruitRecord "2017-09-25T12:00Z" "Apple" 50 50 12
    , FruitRecord "2017-09-26T12:00Z" "Plum" 32 16 12
    , FruitRecord "2017-09-27T12:00Z" "Peach" 11 29 12
    , FruitRecord "2017-09-28T12:00Z" "Lime" 23 9 12
    , FruitRecord "2017-09-29T12:00Z" "Cherry" 13 5 12
    , FruitRecord "2017-09-30T12:00Z" "Pineapple" 69 35 12
    , FruitRecord "2017-10-01T12:00Z" "Melon" 26 58 12
    , FruitRecord "2017-10-02T12:00Z" "Grapefruit" 35 13 12
    , FruitRecord "2017-10-03T12:00Z" "Strawberry" 56 25 12
    , FruitRecord "2017-10-04T12:00Z" "Orange" 34 38 12
    , FruitRecord "2017-10-05T12:00Z" "Kiwi" 65 44 12
    ]


values : Data
values =
    Values (List.map (\(FruitRecord _ _ value _ _) -> value) dataTable)


keyData : Data
keyData =
    let
        fruitRecToRecord =
            \(FruitRecord _ key value _ _) ->
                KeyRecord key value 0
    in
    KeyData (List.map fruitRecToRecord dataTable)


timeData : Data
timeData =
    let
        fruitRecToRecord =
            \(FruitRecord key _ value _ _) ->
                TimeRecord (stringToDate key) value 0
    in
    TimeData (List.map fruitRecToRecord dataTable)


timeData1 : Data
timeData1 =
    let
        fruitRecToRecord =
            \(FruitRecord key _ _ value _) ->
                TimeRecord (stringToDate key) value 0
    in
    TimeData (List.map fruitRecToRecord dataTable)


timeData2 : Data
timeData2 =
    let
        fruitRecToRecord =
            \(FruitRecord key _ _ _ value) ->
                TimeRecord (stringToDate key) value 0
    in
    TimeData (List.map fruitRecToRecord dataTable)


barChart : Chart
barChart =
    BarChart
        { defaultBarChartConfig
            | xLabelFormatter = utcWeek
        }
        timeData


barChartStacked : Chart
barChartStacked =
    BarChartStacked
        { defaultBarChartConfig
            | xLabelFormatter = utcWeek
        }
        [ timeData, timeData1, timeData2 ]



-- View


view : Model -> Svg msg
view _ =
    viewChart barChartStacked


main : Program () Model Msg
main =
    Browser.sandbox
        { init = model
        , view = view
        , update = update
        }
