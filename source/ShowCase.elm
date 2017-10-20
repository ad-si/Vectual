module ShowCase exposing (..)

import Date
import Date.Extra.Format as Format exposing (utcIsoDateString)
import Html exposing (Html, text)
import Svg exposing (Svg)
import Vectual exposing (..)
import Vectual.BarChart exposing (..)
import Vectual.BarChartStacked exposing (..)
import Vectual.Types exposing (..)
import Vectual.Helpers exposing (..)


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
    [ ( "2017-09-25T12:00Z", "Apple", 50, 50, 12 )
    , ( "2017-09-26T12:00Z", "Plum", 32, 16, 12 )
    , ( "2017-09-27T12:00Z", "Peach", 11, 29, 12 )
    , ( "2017-09-28T12:00Z", "Lime", 23, 9, 12 )
    , ( "2017-09-29T12:00Z", "Cherry", 13, 5, 12 )
    , ( "2017-09-30T12:00Z", "Pineapple", 69, 35, 12 )
    , ( "2017-10-01T12:00Z", "Melon", 26, 58, 12 )
    , ( "2017-10-02T12:00Z", "Grapefruit", 35, 13, 12 )
    , ( "2017-10-03T12:00Z", "Strawberry", 56, 25, 12 )
    , ( "2017-10-04T12:00Z", "Orange", 34, 38, 12 )
    , ( "2017-10-05T12:00Z", "Kiwi", 65, 44, 12 )
    ]


values : Data
values =
    Values (List.map (\( _, _, value, _, _ ) -> value) dataTable)


keyData : Data
keyData =
    let
        tupleToRecord =
            \( _, key, value, _, _ ) -> KeyRecord key value 0
    in
        KeyData (List.map tupleToRecord dataTable)


timeData : Data
timeData =
    let
        tupleToRecord =
            \( key, _, value, _, _ ) -> TimeRecord (stringToDate key) value 0
    in
        TimeData (List.map tupleToRecord dataTable)


timeData1 : Data
timeData1 =
    let
        tupleToRecord =
            \( key, _, _, value, _ ) -> TimeRecord (stringToDate key) value 0
    in
        TimeData (List.map tupleToRecord dataTable)


timeData2 : Data
timeData2 =
    let
        tupleToRecord =
            \( key, _, _, _, value ) -> TimeRecord (stringToDate key) value 0
    in
        TimeData (List.map tupleToRecord dataTable)


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
view model =
    viewChart barChartStacked
