module Tests exposing (..)

import StylusParser exposing (..)
import Html exposing (Html, div, pre, h1)
import Parser exposing (run)
import Test exposing (..)
import Expect exposing (..)
import List
import Fixtures exposing (..)


primitiveTests : Test
primitiveTests =
    describe "Primitives"
        [ test "Selector" <|
            \_ ->
                Expect.equal (run selector selectorRaw) (Ok selectorAst)
        , test "Selectors" <|
            \_ ->
                Expect.equal (run selectors selectorsRaw) (Ok selectorsAst)
        , test "Declaration" <|
            \_ ->
                Expect.equal (run declaration declarationRaw)
                    (Ok declarationAst)
        , test "Declaration + Newline" <|
            \_ ->
                Expect.equal (run declarations (declarationRaw ++ "\n"))
                    (Ok declarationNewlineAst)
        , test "Declarations" <|
            \_ ->
                Expect.equal (run declarations declarationsRaw)
                    (Ok declarationsAst)
        , test "Rule with rule" <|
            \_ ->
                Expect.equal (run rule ruleRaw) (Ok ruleAst)
        ]


stylusTests : Test
stylusTests =
    describe "Stylus"
        [ test "Rule" <|
            \_ ->
                Expect.equal (run stylus ruleRaw) (Ok ruleAsStylusAst)
        , test "Rules" <|
            \_ ->
                Expect.equal (run stylus rulesRaw) (Ok rulesAst)
        , test "Rules With Comments" <|
            \_ ->
                Expect.equal
                    (run stylus rulesWithCommentsRaw)
                    (Ok rulesWithCommentsAst)
        , test "Rules With Newlines" <|
            \_ ->
                Expect.equal
                    (run stylus rulesWithNewlinesRaw)
                    (Ok rulesWithNewlinesAst)
        ]


stylusAstToCssTests : Test
stylusAstToCssTests =
    describe "Stylus Ast To Css"
        [ test "Rule" <|
            \_ ->
                Expect.equal (serializeStylusAst ruleAsStylusAst) ruleCss
        , test "Rules" <|
            \_ ->
                Expect.equal (serializeStylusAst rulesAst) rulesCss
        , test "Rule With Comments" <|
            \_ ->
                Expect.equal
                    (serializeStylusAst rulesWithCommentsAst)
                    rulesWithCommentsCss
        , test "Rules With Newlines" <|
            \_ ->
                Expect.equal
                    (serializeStylusAst rulesWithNewlinesAst)
                    rulesWithNewlinesCss
        ]


stylusToCssTests : Test
stylusToCssTests =
    describe "Stylus To Css"
        [ test "Rule" <|
            \_ ->
                Expect.equal (stylusToCss ruleRaw) (Ok ruleCss)
        , test "Rules" <|
            \_ ->
                Expect.equal (stylusToCss rulesRaw) (Ok rulesCss)
        , test "Rule With Comments" <|
            \_ ->
                Expect.equal
                    (stylusToCss rulesWithCommentsRaw)
                    (Ok rulesWithCommentsCss)
        , test "Rules With Newlines" <|
            \_ ->
                Expect.equal
                    (stylusToCss rulesWithNewlinesRaw)
                    (Ok rulesWithNewlinesCss)
        ]


toHtml : Result Parser.Error StylusAst -> Html a
toHtml result =
    let
        cssResult =
            Result.map serializeStylusAst result
    in
        case cssResult of
            Ok css ->
                pre [] [ Html.text css ]

            Err error ->
                h1 [] [ Html.text (toString error) ]


main : Html a
main =
    div []
        [ div []
            (List.map (\x -> pre [] [ Html.text x ])
                [ toString (run selector selectorRaw)
                , toString (run selectors selectorsRaw)
                , toString (run declaration declarationRaw)
                , toString (run declarations (declarationRaw ++ "\n"))
                , toString (run declarations declarationsRaw)
                , toString (run rule ruleRaw)
                , toString (run stylus ruleRaw)
                , toString (run stylus rulesRaw)
                , toString (run stylus rulesWithCommentsRaw)
                , toString (run stylus rulesWithNewlinesRaw)
                ]
            )
        , div []
            (List.map toHtml
                [ run stylus ruleRaw
                , run stylus rulesRaw
                , run stylus rulesWithCommentsRaw
                , run stylus rulesWithNewlinesRaw
                ]
            )
        ]
