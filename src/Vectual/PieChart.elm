module Vectual.PieChart exposing (..)

{-| This module creates a simple pie chart.

@docs viewPieChart

-}

import List exposing (foldl)
import Quantity exposing (Unitless)
import Svg exposing (..)
import Svg.Attributes as SvgA exposing (..)
import TimeUtils.Time exposing (utcDateTime)
import Vector2d
import Vectual.Helpers exposing (..)
import Vectual.Types exposing (..)


defaultPieChartConfig : PieChartConfig
defaultPieChartConfig =
    { title = "Vectual Bar Chart"
    , inline = False
    , width = 400
    , height = 300
    , borderRadius = ( 2, 2 )
    , radius = 10
    , xLabelFormatter = utcDateTime
    , yStartAtZero = False -- TODO: Remove
    , showAnimations = False
    }


setAnimations : Float -> Float -> Float -> Svg msg
setAnimations tx ty combinedAngle =
    g []
        [ g [ class "sector" ]
            []
        , g [ class "path" ]
            []
        , g [ class "text" ]
            []
        ]


type alias PrevSectorRec msg =
    { index : Int
    , combinedAngleStart : Float -- rad
    , xStart : Float
    , yStart : Float
    , svgElems : List (Svg msg)
    }


addSector :
    MetaData Unitless coordinates
    -> Bool
    -> Float
    -> Float
    -> KeyRecord
    -> PrevSectorRec msg
    -> PrevSectorRec msg
addSector config showAnimations pieRadius totalValue keyRec prevSectorRec =
    let
        { index, combinedAngleStart, xStart, yStart, svgElems } =
            prevSectorRec

        angleThis =
            (keyRec.value / totalValue) * 360

        angleAdd =
            angleThis / 2

        transDeg =
            combinedAngleStart + angleAdd

        angleTranslate =
            degrees transDeg

        xTrans =
            -(cos angleTranslate) * pieRadius

        yTrans =
            sin angleTranslate * pieRadius

        size =
            if
                ((keyRec.value / totalValue) * 360)
                    > 180
            then
                "0 1,0"

            else
                "0 0,0"

        combinedAngleEnd =
            combinedAngleStart + angleThis

        combinedAngleEndRad =
            degrees combinedAngleEnd

        xEnd =
            -(cos combinedAngleEndRad * pieRadius)

        yEnd =
            sin combinedAngleEndRad * pieRadius

        position =
            if transDeg <= 75 then
                "end"

            else if transDeg <= 105 then
                "middle"

            else if transDeg <= 255 then
                "start"

            else if transDeg <= 285 then
                "middle"

            else
                "end"

        sectorPath =
            Svg.path
                [ class "vectual_pie_sector_path"
                , class ("vectual_color_" ++ String.fromInt index)
                , SvgA.style
                    ("stroke-width:"
                        ++ String.fromFloat (pieRadius * 0.015)
                        ++ ";"
                    )
                , d
                    ("M 0,0 L "
                        ++ String.fromFloat xStart
                        ++ ","
                        ++ String.fromFloat yStart
                        ++ " A "
                        ++ String.fromFloat pieRadius
                        ++ ","
                        ++ String.fromFloat pieRadius
                        ++ " "
                        ++ size
                        ++ " "
                        ++ String.fromFloat xEnd
                        ++ ","
                        ++ String.fromFloat yEnd
                        ++ " z"
                    )
                ]
                [ if showAnimations then
                    animate
                        [ attributeName "opacity"
                        , from "0"
                        , to "1"
                        , dur "0.6s"
                        , fill "freeze"
                        ]
                        []

                  else
                    g [] []
                , if showAnimations then
                    animateTransform
                        [ attributeName "transform"
                        , type_ "rotate"
                        , dur "1s"
                        , calcMode "spline"
                        , keySplines "0 0 0 1"
                        , values
                            (String.fromFloat combinedAngleEnd
                                ++ ",0,0; 0,0,0"
                            )
                        , additive "replace"
                        , fill "freeze"
                        ]
                        []

                  else
                    g [] []
                ]

        sectorText =
            Svg.text_
                [ class "vectual_pie_text"
                , class ("vectual_color_" ++ String.fromInt index)
                , x (String.fromFloat (xTrans * 1.2))
                , y (String.fromFloat (yTrans * 1.2))
                , textAnchor position
                , SvgA.style
                    ("font-size:"
                        ++ String.fromFloat (angleThis * pieRadius * 0.002 + 8)
                        ++ "px"
                    )
                , transform "translate(0, 5)"
                ]
                [ text keyRec.key
                , if showAnimations then
                    animate
                        [ attributeName "opacity"
                        , begin "0s"
                        , values "0;0;1"
                        , dur "1s"
                        , fill "freeze"
                        ]
                        []

                  else
                    g [] []
                ]

        sectorTitle =
            Svg.title []
                [ text
                    (keyRec.key
                        ++ " | "
                        ++ String.fromFloat keyRec.value
                        ++ " | "
                        ++ String.fromInt
                            (round (keyRec.value / totalValue * 100))
                        ++ "%"
                    )
                ]

        sector =
            g [ class "vectual_pie_sector" ]
                [ sectorPath
                , sectorText
                , sectorTitle
                , -- TODO: Conditionally add element to array
                  if showAnimations then
                    animateTransform
                        [ attributeName "transform"
                        , type_ "translate"
                        , begin "mouseover"
                        , to
                            (String.fromFloat (xTrans * 0.2)
                                ++ ", "
                                ++ String.fromFloat (yTrans * 0.2)
                            )
                        , dur "300ms"
                        , additive "replace"
                        , fill "freeze"
                        ]
                        []

                  else
                    g [] []
                , -- TODO: Conditionally add element to array
                  if showAnimations then
                    animateTransform
                        [ attributeName "transform"
                        , type_ "translate"
                        , begin "mouseout"
                        , to "0,0"
                        , dur "600ms"
                        , additive "replace"
                        , fill "freeze"
                        ]
                        []

                  else
                    g [] []
                ]
    in
    { index = index + 1
    , combinedAngleStart = combinedAngleEnd
    , xStart = xEnd
    , yStart = yEnd
    , svgElems = sector :: svgElems
    }


{-| -}
viewPieChart : PieChartConfig -> Data -> Svg msg
viewPieChart config data =
    let
        metaData =
            getMetaData config data

        pieRadius =
            Basics.min
                (toFloat metaData.graphHeight * 0.4)
                (toFloat metaData.graphWidth * 0.4)
    in
    case data of
        TimeData listTimeRecord ->
            Debug.todo "TimeData listTimeRecord"

        Values listFloat ->
            Debug.todo "Values listFloat"

        InvalidData ->
            Debug.todo "InvalidData"

        KeyData keyRecords ->
            let
                chart =
                    g
                        [ class "vectual_pie_chart"
                        , transform
                            (toTranslate
                                (Vector2d.unitless
                                    (0.5 * toFloat config.width)
                                    (0.5 * toFloat config.height)
                                )
                            )
                        ]
                        -- Draw full circle if only one value
                        (if List.length keyRecords == 1 then
                            [ circle
                                [ class "vectual_pie_sector"
                                , class "vectual_color_0"
                                , cx "0"
                                , cy "0"
                                , r (String.fromFloat pieRadius)
                                ]
                                []
                            , text_
                                [ class "vectual_pie_text_single"
                                , class "vectual_pie_text"
                                , x "0"
                                , y "0"
                                , SvgA.style
                                    ("font-size:"
                                        ++ String.fromFloat (pieRadius * 0.3)
                                        ++ "px"
                                    )
                                , textAnchor "middle"
                                , strokeWidth
                                    (String.fromFloat
                                        (pieRadius * 0.006)
                                    )
                                ]
                                [ text "config.max.key" ]
                            ]

                         else
                            let
                                totalVal =
                                    foldl
                                        (\rec total -> total + rec.value)
                                        0
                                        keyRecords

                                mergedSectors =
                                    foldl
                                        (addSector
                                            metaData
                                            config.showAnimations
                                            pieRadius
                                            totalVal
                                        )
                                        { index = 0
                                        , combinedAngleStart = 0
                                        , xStart = -pieRadius
                                        , yStart = 0
                                        , svgElems = []
                                        }
                                        keyRecords
                            in
                            mergedSectors.svgElems
                        )
            in
            wrapChart config chart
