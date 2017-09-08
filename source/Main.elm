module Main exposing (..)

import Charts exposing (Chart, BarChartInfo, viewBarChart)
import Html exposing (Html, text)
import Svg exposing (Svg)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }


type alias Model =
    { title : String }


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


chartConfig : BarChartInfo
chartConfig =
    { title = "This is a test"
    , inline = False
    , width = 400
    , height = 300
    , borderRadius = ( 2, 2 )
    }


view : Model -> Svg msg
view model =
    viewBarChart chartConfig
