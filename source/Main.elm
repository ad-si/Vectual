module Main exposing (..)

import Date
import Date.Extra.Format as Format exposing (utcIsoDateString)
import Html exposing (Html, text)
import Svg exposing (Svg)
import Charts exposing (..)
import BarChart exposing (..)
import Types exposing (..)
import Helpers exposing (..)


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


dataTable =
    [ ( "2017-09-25T12:00Z", "Apple", 50, 49 )
    , ( "2017-09-26T12:00Z", "Plum", 27, 16 )
    , ( "2017-09-27T12:00Z", "Peach", 11, 29 )
    , ( "2017-09-28T12:00Z", "Lime", 23, 9 )
    , ( "2017-09-29T12:00Z", "Cherry", 13, 5 )
    , ( "2017-09-30T12:00Z", "Pineapple", 69, 35 )
    , ( "2017-10-01T12:00Z", "Melon", 26, 58 )
    , ( "2017-10-02T12:00Z", "Grapefruit", 35, 13 )
    , ( "2017-10-03T12:00Z", "Strawberry", 56, 25 )
    , ( "2017-10-04T12:00Z", "Orange", 34, 38 )
    , ( "2017-10-05T12:00Z", "Kiwi", 65, 44 )
    ]


keyData : Data
keyData =
    let
        tupleToRecord =
            \( _, key, value, _ ) -> KeyRecord key value
    in
        KeyData (List.map tupleToRecord dataTable)


timeData : Data
timeData =
    let
        tupleToRecord =
            \( key, _, value, _ ) -> TimeRecord (stringToDate key) value
    in
        TimeData (List.map tupleToRecord dataTable)


timeDataExtra : Data
timeDataExtra =
    let
        tupleToRecord =
            \( key, _, _, value ) -> TimeRecord (stringToDate key) value
    in
        TimeData (List.map tupleToRecord dataTable)


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
