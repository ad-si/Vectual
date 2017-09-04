module Main exposing (..)

import Charts exposing (Chart, BarChartInfo, viewBarChart)
import Html exposing (Html, text)
import Svg exposing (Svg)


main =
    Html.beginnerProgram { model = model, view = view, update = update }


type alias Model =
    { title : String
    }


model : Model
model =
    { title = "This is sooo awesome" }


type Msg
    = Display
    | Hide


update : Msg -> Model -> Model
update msg model =
    case msg of
        Display ->
            { model | title = "Display" }

        Hide ->
            { model | title = "Hide" }


chartConfig =
    BarChartInfo "This is a test" False 100 100


view : Model -> Svg msg
view model =
    viewBarChart chartConfig
