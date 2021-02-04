module Vectual.CoordinateSystem exposing
    ( getAbscissas
    , getCoordinateSystem
    , getOrdinates
    )

{-| Create ordinates, abscissas or a complete coordinate system.

@docs getAbscissas
@docs getCoordinateSystem
@docs getOrdinates

-}

import Array
import Point2d exposing (Point2d, coordinates)
import Quantity exposing (Unitless)
import String exposing (fromFloat, fromInt)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Vectual.Helpers exposing (..)
import Vectual.Types exposing (..)


{-| -}
getOrdinates :
    BaseConfigAnd a
    -> Data
    -> MetaData Unitless coordinates
    -> List (Svg msg)
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
                    Debug.log errorMessage (fromInt index)

        xValue : Int -> Float
        xValue number =
            (toFloat metaData.coordSysWidth
                / toFloat metaData.numberOfEntries
            )
                * toFloat number

        numToLine number =
            let
                rotationPoint =
                    Point2d.unitless (xValue number) 10

                keys =
                    List.map .key
            in
            g []
                [ line
                    [ class (className number)
                    , x1 (fromFloat (xValue number))
                    , y1 (fromFloat yAxisOffset)
                    , x2 (fromFloat (xValue number))
                    , y2 (fromInt -metaData.coordSysHeight)
                    ]
                    []
                , text_
                    [ class "vectual_coordinate_labels_x"
                    , transform (toRotate 40 rotationPoint)
                    , x (fromFloat (xValue number))
                    , y "10"
                    ]
                    [ text (dataLabelAt number) ]
                ]
    in
    List.range 0 (metaData.numberOfEntries - 1)
        |> List.map numToLine


{-| -}
getAbscissas :
    BaseConfigAnd a
    -> Data
    -> MetaData Unitless coordinates
    -> List (Svg msg)
getAbscissas config data metaData =
    let
        yDensity =
            0.1

        xAxisOffset =
            5

        -- TODO: Should be half of font size
        yAxisOffset =
            3

        className number =
            if number == 0 then
                "vectual_coordinate_axis_x"

            else
                "vectual_coordinate_lines_x"

        yValue : Int -> Float
        yValue number =
            -(toFloat metaData.coordSysHeight / metaData.yRange)
                * (toFloat number / yDensity)

        numToLine : Int -> Svg msg
        numToLine number =
            g []
                [ line
                    [ class (className number)
                    , x1 (fromFloat -xAxisOffset)
                    , y1 (yValue number |> fromFloat)
                    , x2 (metaData.coordSysWidth |> fromInt)
                    , y2 (yValue number |> fromFloat)
                    ]
                    []
                , text_
                    [ class "vectual_coordinate_labels_y"
                    , x (fromFloat (toFloat -metaData.coordSysWidth * 0.03))
                    , y (fromFloat (yValue number + yAxisOffset))
                    ]
                    [ text
                        ((toFloat number / yDensity + metaData.yMinimum)
                            |> fromFloat
                        )
                    ]
                ]
    in
    List.range 0 (truncate (metaData.yRange * yDensity))
        |> List.map numToLine


{-| -}
getCoordinateSystem :
    BaseConfigAnd a
    -> Data
    -> MetaData Unitless coordinates
    -> Svg msg
getCoordinateSystem config data metaData =
    g []
        (List.append
            (getOrdinates config data metaData)
            (getAbscissas config data metaData)
        )
