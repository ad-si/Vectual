module BarChartStacked exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import OpenSolid.Geometry.Types exposing (..)
import OpenSolid.Point2d as Point2d
import OpenSolid.Vector2d as Vector2d
import BarChart exposing (..)
import Types exposing (..)
import Helpers exposing (..)
import CoordinateSystem exposing (..)


combiner : Data -> Data -> Data
combiner dataA dataB =
    let
        dataTuple =
            ( dataA, dataB )

        combineRecords recordA recordB =
            { recordB | value = recordA.value + recordB.value }

        combineLists listA listB =
            List.map2 combineRecords listA listB
    in
        case dataTuple of
            ( TimeData listA, TimeData listB ) ->
                TimeData (combineLists listA listB)

            ( KeyData listA, KeyData listB ) ->
                KeyData (combineLists listA listB)

            ( Values listA, Values listB ) ->
                Values (List.map2 (+) listA listB)

            ( _, _ ) ->
                InvalidData


foldDatas : Datas -> Data
foldDatas sets =
    let
        maybeFirst =
            List.head sets
    in
        case maybeFirst of
            Just first ->
                List.foldl
                    combiner
                    first
                    (Maybe.withDefault [] (List.tail sets))

            Nothing ->
                Values []


combineOffsets : Data -> Data -> Data
combineOffsets dataB dataA =
    let
        dataTuple =
            ( dataA, dataB )

        combineRecords recordA recordB =
            { recordB | offset = recordA.value + recordA.offset }

        combineLists listA listB =
            List.map2 combineRecords listA listB
    in
        case dataTuple of
            ( TimeData listA, TimeData listB ) ->
                TimeData (combineLists listA listB)

            ( KeyData listA, KeyData listB ) ->
                KeyData (combineLists listA listB)

            ( Values listA, Values listB ) ->
                Values (List.map2 (+) listA listB)

            ( _, _ ) ->
                InvalidData


shiftDatas : Datas -> Datas
shiftDatas datas =
    let
        maybeFirst =
            List.head datas
    in
        case maybeFirst of
            Just first ->
                List.scanl
                    combineOffsets
                    first
                    (Maybe.withDefault [] (List.tail datas))

            Nothing ->
                []


getBarsStacked : BarChartConfig -> Data -> Datas -> MetaData -> Svg msg
getBarsStacked config combinedData datas metaData =
    let
        getBarsFunc index data =
            g
                [ class ("vectual_bars vectual_bars" ++ (toString index)) ]
                (List.indexedMap
                    (getBar config data metaData)
                    (getDataRecords data)
                )
    in
        g
            []
            (List.indexedMap getBarsFunc (shiftDatas datas))


viewBarChartStacked : BarChartConfig -> Datas -> Svg msg
viewBarChartStacked config datas =
    let
        combinedData =
            foldDatas datas

        dataValues =
            getDataValues combinedData

        metaData =
            getMetaData config combinedData

        chart =
            g
                [ transform (toTranslate metaData.translation) ]
                [ getCoordinateSystem config combinedData metaData
                , getBarsStacked
                    config
                    combinedData
                    datas
                    metaData
                ]
    in
        wrapChart config chart
