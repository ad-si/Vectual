module Vectual.TagCloud exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import String exposing (fromFloat)
import Vector2d exposing (..)
import Vectual.CoordinateSystem exposing (..)
import Vectual.Helpers exposing (..)
import Vectual.Types exposing (..)


type alias CloudState msg =
    { x : Float
    , y : Float
    , lineMax : Float
    , nodes : List (Svg msg)
    }


defaultTagCloudConfig : TagCloudConfig
defaultTagCloudConfig =
    { title = "Vectual Tag Cloud"
    , inline = False
    , width = 400
    , height = 300
    , borderRadius = ( 2, 2 )
    , xLabelFormatter = \_ -> ""
    }


viewTagCloud : TagCloudConfig -> Data -> Svg msg
viewTagCloud config data =
    let
        entries =
            getDataRecords data

        values = List.map .value entries

        minVal = Maybe.withDefault 0 (List.minimum values)
        maxVal = Maybe.withDefault 0 (List.maximum values)

        minFont = 10.0
        maxFont = Basics.max 18.0 (0.12 * toFloat config.height)

        scale v =
            if maxVal == minVal then
                (minFont + maxFont) / 2
            else
                minFont + ((v - minVal) / (maxVal - minVal)) * (maxFont - minFont)

        estimateWidth fontSize label =
            -- rough estimate with extra padding to avoid edge overlap
            let
                chars = toFloat (String.length label)
                base = chars * 0.68 * fontSize
                padding = 0.45 * fontSize
            in
            base + padding

        leftPadding = 20.0
        rightPadding = 20.0
        topPadding = 0.18 * toFloat config.height
        lineGap = 6.0

        availableWidth = toFloat config.width - leftPadding - rightPadding

        -- Track current line height to prevent overlaps when mixing sizes
        step entry state =
            let
                fs = scale entry.value
                w = estimateWidth fs entry.label
                newX =
                    if state.x == 0 then
                        leftPadding
                    else
                        state.x

                -- gap scales with font size for better separation of large words
                gap = Basics.max 10 (0.35 * fs)
                nextX = newX + w + gap

                limit = leftPadding + availableWidth

                ( xPos, yPos, newState ) =
                    if nextX > limit then
                        let
                            newY = state.y + state.lineMax + lineGap
                        in
                        ( leftPadding
                        , newY
                        , { x = leftPadding + w + gap
                          , y = newY
                          , lineMax = fs
                          , nodes = state.nodes
                          }
                        )

                    else
                        ( newX
                        , state.y
                        , { state | x = nextX, lineMax = Basics.max state.lineMax fs }
                        )

                txt =
                    text_
                        [ class "vectual_tagcloud_text"
                        , x (fromFloat xPos)
                        , y (fromFloat (yPos + fs))
                        , Svg.Attributes.style ("font-size:" ++ fromFloat fs ++ "px")
                        ]
                        [ text entry.label ]
            in
            { newState | nodes = txt :: newState.nodes }

        words =
            case entries of
                [] ->
                    []

                _ ->
                    let
                        finalState : CloudState msg
                        finalState =
                            List.foldl
                                step
                                { x = 0, y = topPadding, lineMax = 0, nodes = [] }
                                entries
                    in
                    List.reverse finalState.nodes
    in
    wrapChart config (g [] words)



-- TODO: Port JavaScript code to Elm
--
-- export default function (svg, config) {
--   const minFontsize = 10 // minimum font-size
--   const until = 300 // size of spiral
--   const factor = 10 // resolution improvement
--   const density = 0.2 // density of spiral
--   const xySkew = 0.6 // elliptical shape of spiral (0 < xySkew < 1)
--   const cloud = shaven(
--     ['g', {
--       transform: 'translate(' +
--         (0.5 * config.width) + ', ' +
--         (0.5 * config.height) + ')',
--       class: 'vectualTagcloud',
--     }], svgNS,
--   )[0]
--   function init () {
--     config.data.forEach((element) => {
--       // font-size
--       element.fontSize = minFontsize +
--         ((config.height * 0.1) * (element.value - config.min.value)) /
--         (config.max.value - config.min.value)
--       // bounding-box
--       element.height = element.fontSize * 0.8
--       element.width = element.key.length * element.fontSize * 0.5
--     })
--     shaven([svg, [cloud]])
--   }
--   function build () {
--     const pointsNumber = until * factor * density
--     const points = []
--     let index
--     let bValue
--     let xValue
--     let yValue
--     function calculatePoints () {
--       for (index = 0; index < pointsNumber; index++) {
--         bValue = index * (1 / factor)
--         xValue = -(1 / density) * xySkew * bValue * Math.cos(bValue)
--         yValue = -(1 / density) * (1 - xySkew) * bValue * Math.sin(bValue)
--         points.push({
--           x: xValue, // eslint-disable-line id-length
--           y: yValue, // eslint-disable-line id-length
--         })
--       }
--     }
--     // function drawSpiral () {
--     //   let string = ''
--     //
--     //   points.forEach((point) => {
--     //     string += point.x + ',' + point.y + ' '
--     //   })
--     //
--     //   shaven(
--     //     [cloud,
--     //       ['polyline', {
--     //         points: string,
--     //         style: 'fill: none; stroke:red; stroke-width:1',
--     //       }],
--     //     ]
--     //     , svgNS
--     //   )
--     // }
--     function drawWords () {
--       function drawWord (element, wordIndex) {
--         function calculatePosition () {
--           // returns true if point was found and saves it in element
--           function testPoint (point) {
--             function notOverlapping (formerElement) {
--               // if element is already set
--               if (formerElement.x !== undefined) {
--                 return point.x > formerElement.x +
--                     formerElement.width || // right
--                   point.x < formerElement.x - element.width || // left
--                   point.y < formerElement.y - formerElement.height || // above
--                   point.y > formerElement.y + element.height // beyond
--               }
--               else {
--                 return true
--               }
--             }
--             // test if every element is not overlapping
--             if (config.data.every(notOverlapping) === true) {
--               element.x = point.x // eslint-disable-line id-length
--               element.y = point.y // eslint-disable-line id-length
--               return true
--             }
--             else {
--               return false
--             }
--           }
--           if (!points.some(testPoint)) {
--             console.error('Element could not be positioned')
--           }
--         }
--         function renderWord () {
--           shaven(
--             [cloud,
--               // bounding-box
--               /* ['rect', {
--                width: element.width,
--                height: element.height,
--                style: 'fill: rgba(0,0,255,0.2)',
--                x: element.x,
--                y: element.y - element.height
--                }],*/
--               ['text', element.key, {
--                 class: 'vectual_tagcloud_text',
--                 style: 'font-size: ' + element.fontSize,
--                 x: element.x, // eslint-disable-line id-length
--                 y: element.y, // eslint-disable-line id-length
--               },
--               ],
--             ], svgNS,
--           )
--         }
--         try {
--           if (wordIndex === 0) {
--             element.x = element.y = 0 // eslint-disable-line id-length
--           }
--           else {
--             calculatePosition()
--           }
--           renderWord()
--           return true
--         }
--         catch (error) {
--           console.error(error)
--           return false
--         }
--       }
--       config.data.every(drawWord)
--     }
--     calculatePoints()
--     // drawSpiral()
--     drawWords()
--   }
--   init()
--   build()
--   return svg
-- }
