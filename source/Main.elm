module Main exposing (..)

import Charts exposing (..)
import Html exposing (Html, text)
import Svg exposing (Svg)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



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
update msg model =
    case msg of
        Display ->
            { model | title = "Display" }

        Hide ->
            { model | title = "Hide" }


defaultData : Data
defaultData =
    KeyData
        [ KeyRecord "Apple" 50
        , KeyRecord "Plum" 27
        , KeyRecord "Peach" 11
        , KeyRecord "Lime" 23
        , KeyRecord "Cherry" 13
        , KeyRecord "Pineapple" 69
        , KeyRecord "Melon" 26
        , KeyRecord "Grapefruit" 35
        , KeyRecord "Strawberry" 56
        , KeyRecord "Orange" 34
        , KeyRecord "Kiwi" 65
        ]


barChartConfig : BarChartConfig
barChartConfig =
    { title = "This is a test"
    , inline = False
    , width = 400
    , height = 300
    , borderRadius = ( 2, 2 )
    , labelAngle = 1.5
    }


barChart : Chart
barChart =
    BarChart barChartConfig defaultData



-- View


view : Model -> Svg msg
view model =
    viewChart barChart
