module Main exposing (..)

import Charts exposing (..)
import Html exposing (Html, text)
import Svg exposing (Svg)
import Date
import Date.Extra.Format as Format exposing (utcIsoDateString)
import Types exposing (..)


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


stringToDate string =
    Result.withDefault
        (Date.fromTime 0)
        (Date.fromString string)


keyData : Data
keyData =
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


timeData : Data
timeData =
    TimeData
        [ TimeRecord (stringToDate "2017-09-25T12:00Z") 50
        , TimeRecord (stringToDate "2017-09-26T12:00Z") 27
        , TimeRecord (stringToDate "2017-09-27T12:00Z") 11
        , TimeRecord (stringToDate "2017-09-28T12:00Z") 23
        , TimeRecord (stringToDate "2017-09-29T12:00Z") 13
        , TimeRecord (stringToDate "2017-09-30T12:00Z") 69
        , TimeRecord (stringToDate "2017-10-01T12:00Z") 26
        , TimeRecord (stringToDate "2017-10-02T12:00Z") 35
        , TimeRecord (stringToDate "2017-10-03T12:00Z") 56
        , TimeRecord (stringToDate "2017-10-04T12:00Z") 34
        , TimeRecord (stringToDate "2017-10-05T12:00Z") 65
        ]


barChart : Chart
barChart =
    BarChart
        { defaultBarChartConfig
            | xLabelFormatter = utcWeek
        }
        timeData



-- View


view : Model -> Svg msg
view model =
    viewChart barChart
