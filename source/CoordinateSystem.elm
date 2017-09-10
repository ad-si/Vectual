module CoordinateSystem exposing (..)

import Array
import Svg exposing (..)
import Svg.Attributes exposing (..)
import OpenSolid.Geometry.Types exposing (..)
import OpenSolid.Point2d as Point2d
import Types exposing (..)
import Helpers exposing (..)


getOrdinates : BaseConfigAnd a -> Data -> MetaData -> List (Svg msg)
getOrdinates config data metaData =
    let
        yAxisOffset =
            5

        className number =
            if number == 0 then
                "vectual_coordinate_axis_y"
            else
                "vectual_coordinate_lines_y"

        dataLabelAt index =
            let
                array =
                    Array.fromList (getDataLabels config data)

                maybeElement =
                    Array.get index array

                errorMessage =
                    "Error: Trying to access non existant element "
                        ++ "at index"
            in
                case maybeElement of
                    Just element ->
                        element

                    Nothing ->
                        Debug.log errorMessage (toString index)

        xValue : Int -> Float
        xValue number =
            (((toFloat metaData.coordSysWidth)
                / (toFloat metaData.numberOfEntries)
             )
                * (toFloat number)
            )

        numToLine number =
            let
                rotationPoint =
                    Point2d ( xValue number, 10 )

                keys =
                    List.map .key
            in
                g []
                    [ line
                        [ class (className number)
                        , x1 (toString (xValue number))
                        , y1 (toString yAxisOffset)
                        , x2 (toString (xValue number))
                        , y2 (toString -metaData.coordSysHeight)
                        ]
                        []
                    , text_
                        [ class "vectual_coordinate_labels_x"
                        , transform (toRotate 40 rotationPoint)
                        , x (toString (xValue number))
                        , y "10"
                        ]
                        [ text (dataLabelAt number) ]
                    ]
    in
        (List.range 0 (metaData.numberOfEntries - 1))
            |> (List.map numToLine)


getAbscissas : BaseConfigAnd a -> Data -> MetaData -> List (Svg msg)
getAbscissas config data metaData =
    let
        yDensity =
            0.1

        xAxisOffset =
            5

        className number =
            if number == 0 then
                "vectual_coordinate_axis_x"
            else
                "vectual_coordinate_lines_x"

        yValue : Int -> String
        yValue number =
            -((toFloat metaData.coordSysHeight) / metaData.yRange)
                * ((toFloat number) / yDensity)
                |> toString

        numToLine : Int -> Svg msg
        numToLine number =
            g []
                [ line
                    [ class (className number)
                    , x1 (toString -xAxisOffset)
                    , y1 (yValue number)
                    , x2 (metaData.coordSysWidth |> toString)
                    , y2 (yValue number)
                    ]
                    []
                , text_
                    [ class "vectual_coordinate_labels_y"
                    , x (toString ((toFloat -metaData.coordSysWidth) * 0.05))
                    , y (yValue number)
                    ]
                    [ text
                        (((toFloat number) / yDensity + metaData.yMinimum)
                            |> toString
                        )
                    ]
                ]
    in
        (List.range 0 (truncate (metaData.yRange * yDensity)))
            |> (List.map numToLine)


getCoordinateSystem : BaseConfigAnd a -> Data -> MetaData -> Svg msg
getCoordinateSystem config data metaData =
    g []
        (List.append
            (getOrdinates config data metaData)
            (getAbscissas config data metaData)
        )
