module Stylus exposing (..)

import Expect exposing (Expectation)
import List exposing (foldr)
import Parser.Advanced exposing (Step(..), run)
import String exposing (join)
import Stylus.Parser exposing (..)
import Test exposing (..)
import Tuple exposing (..)


newlineFold : List String -> String
newlineFold =
    foldr (\a b -> a ++ "\n" ++ b) ""


primitiveTests : Test
primitiveTests =
    describe "Primitives"
        [ test "Selector" <|
            \_ ->
                Expect.equal (Ok "main[foo=bar]")
                    (run selector "main[foo=bar]")
        , test "Selectors" <|
            \_ ->
                Expect.equal
                    (Ok [ "h1", "h2", "h3 p", ".error", "main[foo=bar]" ])
                    (run selectors "h1, h2, h3 p, .error, main[foo=bar]\n")
        , test "Declaration" <|
            \_ ->
                Expect.equal
                    (Ok (Loop [ ( "display", "inline-block" ) ]))
                    (run (declaration []) "  display inline-block\n")
        , test "Declarations" <|
            \_ ->
                let
                    declarationsStr =
                        "  display inline-block\n"
                            ++ "  margin 0\n"
                            ++ "  font-size 12\n"
                in
                Expect.equal
                    (Ok
                        [ ( "display", "inline-block" )
                        , ( "margin", "0" )
                        , ( "font-size", "12" )
                        ]
                    )
                    (run declarations declarationsStr)
        , test "Rule with rule" <|
            \_ ->
                Expect.equal
                    (Ok
                        (Rule
                            ( [ "h1.important" ]
                            , [ ( "display", "inline-block" )
                              , ( "margin", "0" )
                              , ( "font-size", "2em" )
                              ]
                            )
                        )
                    )
                    (run rule
                        ("h1.important\n"
                            ++ "  display inline-block\n"
                            ++ "  margin 0\n"
                            ++ "  font-size 2em\n"
                        )
                    )
        , test "Comment" <|
            \_ ->
                Expect.equal (Ok (Comment "Just a test"))
                    (run commentLine "// Just a test\n")
        , test "Newlines" <|
            \_ ->
                Expect.equal (Ok Newlines) (run newlines "\n\n\n")
        , test "No Newlines" <|
            \_ ->
                Expect.equal
                    (Err
                        [ { col = 1
                          , contextStack = []
                          , problem = GenericProblem
                          , row = 1
                          }
                        ]
                    )
                    (run newlines "")
        ]


stylusTests : Test
stylusTests =
    describe "Stylus Parsing"
        [ test "Rule" <|
            \_ ->
                Expect.equal
                    (Ok
                        (Rule
                            ( [ "h1.important" ]
                            , [ ( "display", "inline-block" )
                              , ( "margin", "0" )
                              , ( "font-size", "2em" )
                              ]
                            )
                        )
                    )
                    (run rule
                        ("h1.important\n"
                            ++ "  display inline-block\n"
                            ++ "  margin 0\n"
                            ++ "  font-size 2em\n"
                        )
                    )
        , test "Section" <|
            \_ ->
                Expect.equal
                    (Ok
                        (Loop
                            [ Rule
                                ( [ "h1.important" ]
                                , [ ( "display", "inline-block" )
                                  , ( "margin", "0" )
                                  , ( "font-size", "2em" )
                                  ]
                                )
                            ]
                        )
                    )
                    (run (section [])
                        ("h1.important\n"
                            ++ "  display inline-block\n"
                            ++ "  margin 0\n"
                            ++ "  font-size 2em\n"
                        )
                    )
        , test "Rules" <|
            \_ ->
                Expect.equal
                    (Ok
                        [ Rule
                            ( [ "h1.important" ]
                            , [ ( "display"
                                , "inline-block"
                                )
                              , ( "margin", "0" )
                              , ( "font-size", "2em" )
                              ]
                            )
                        , Rule
                            ( [ ".alert" ]
                            , [ ( "color"
                                , "rgb(50, 50, 50)"
                                )
                              ]
                            )
                        , Rule
                            ( [ ".primary" ]
                            , [ ( "font-weight"
                                , "900"
                                )
                              ]
                            )
                        ]
                    )
                    (run stylus
                        (""
                            ++ "h1.important\n"
                            ++ "  display inline-block\n"
                            ++ "  margin 0\n"
                            ++ "  font-size 2em\n"
                            ++ ".alert\n"
                            ++ "  color rgb(50, 50, 50)\n"
                            ++ ".primary\n"
                            ++ "  font-weight 900\n"
                        )
                    )
        , test "Rules With Comments" <|
            \_ ->
                Expect.equal
                    (Ok
                        [ Rule
                            ( [ "h1.important" ]
                            , [ ( "display", "inline-block" )
                              , ( "margin", "0" )
                              , ( "font-size", "2em" )
                              ]
                            )
                        , Comment "Just like that"
                        , Rule
                            ( [ ".alert" ]
                            , [ ( "color"
                                , "rgb(50, 50, 50)"
                                )
                              ]
                            )
                        , Comment "Even more"
                        , Comment "Wow, so much comment"
                        , Comment "A lot of special chars : . // $ % ^ *"
                        ]
                    )
                    (run stylus
                        (""
                            ++ "h1.important\n"
                            ++ "  display inline-block\n"
                            ++ "  margin 0\n"
                            ++ "  font-size 2em\n"
                            ++ "// Just like that\n"
                            ++ ".alert\n"
                            ++ "  color rgb(50, 50, 50)\n"
                            ++ "// Even more\n"
                            ++ "// Wow, so much comment\n"
                            ++ "// A lot of special chars : . // $ % ^ *\n"
                        )
                    )
        , test "Rules With Newlines" <|
            \_ ->
                Expect.equal
                    (Ok
                        [ Rule
                            ( [ "h1.important" ]
                            , [ ( "display"
                                , "inline-block"
                                )
                              , ( "margin", "0" )
                              , ( "font-size", "2em" )
                              ]
                            )
                        , Newlines
                        , Comment "Just like that"
                        , Newlines
                        , Rule
                            ( [ ".alert" ]
                            , [ ( "color"
                                , "rgb(50, 50, 50)"
                                )
                              ]
                            )
                        ]
                    )
                    (run stylus
                        (""
                            ++ "h1.important\n"
                            ++ "  display inline-block\n"
                            ++ "  margin 0\n"
                            ++ "  font-size 2em\n"
                            ++ "\n"
                            ++ "// Just like that\n"
                            ++ "\n"
                            ++ "\n"
                            ++ ".alert\n"
                            ++ "  color rgb(50, 50, 50)\n"
                        )
                    )
        ]


stylusAstToCssTests : Test
stylusAstToCssTests =
    describe "Stylus AST to CSS"
        [ test "Rule" <|
            \_ ->
                Expect.equal
                    ("h1.important"
                        ++ "{display:inline-block;margin:0;font-size:2em}\n"
                    )
                    (serializeStylusAst
                        [ Rule
                            ( [ "h1.important" ]
                            , [ ( "display", "inline-block" )
                              , ( "margin", "0" )
                              , ( "font-size", "2em" )
                              ]
                            )
                        ]
                    )
        , test "Rules" <|
            \_ ->
                Expect.equal
                    ("h1.important"
                        ++ "{display:inline-block;margin:0;font-size:2em}\n"
                        ++ ".alert{color:rgb(50, 50, 50)}\n"
                        ++ ".primary{font-weight:900}\n"
                    )
                    (serializeStylusAst
                        [ Rule
                            ( [ "h1.important" ]
                            , [ ( "display"
                                , "inline-block"
                                )
                              , ( "margin", "0" )
                              , ( "font-size", "2em" )
                              ]
                            )
                        , Rule
                            ( [ ".alert" ]
                            , [ ( "color"
                                , "rgb(50, 50, 50)"
                                )
                              ]
                            )
                        , Rule
                            ( [ ".primary" ]
                            , [ ( "font-weight"
                                , "900"
                                )
                              ]
                            )
                        ]
                    )
        , test "Rule With Comments" <|
            \_ ->
                Expect.equal
                    (""
                        ++ "h1.important"
                        ++ "{display:inline-block;margin:0;font-size:2em}\n"
                        ++ "/*Just like that*/\n"
                        ++ ".alert{color:rgb(50, 50, 50)}\n"
                        ++ "/*Even more*/\n"
                        ++ "/*Wow, so much comment*/\n"
                        ++ "/*A lot of special chars : . // $ % ^ **/\n"
                    )
                    (serializeStylusAst
                        [ Rule
                            ( [ "h1.important" ]
                            , [ ( "display", "inline-block" )
                              , ( "margin", "0" )
                              , ( "font-size", "2em" )
                              ]
                            )
                        , Comment "Just like that"
                        , Rule
                            ( [ ".alert" ]
                            , [ ( "color"
                                , "rgb(50, 50, 50)"
                                )
                              ]
                            )
                        , Comment "Even more"
                        , Comment "Wow, so much comment"
                        , Comment "A lot of special chars : . // $ % ^ *"
                        ]
                    )
        , test "Rules With Newlines" <|
            \_ ->
                Expect.equal
                    (""
                        ++ "\n"
                        ++ "h1.important"
                        ++ "{display:inline-block;margin:0;font-size:2em}\n"
                        ++ "\n"
                        ++ "/*Just like that*/\n"
                        ++ "\n"
                        ++ ".alert{color:rgb(50, 50, 50)}\n"
                        ++ "\n"
                    )
                    (serializeStylusAst
                        [ Newlines
                        , Rule
                            ( [ "h1.important" ]
                            , [ ( "display"
                                , "inline-block"
                                )
                              , ( "margin", "0" )
                              , ( "font-size", "2em" )
                              ]
                            )
                        , Newlines
                        , Comment "Just like that"
                        , Newlines
                        , Rule
                            ( [ ".alert" ]
                            , [ ( "color"
                                , "rgb(50, 50, 50)"
                                )
                              ]
                            )
                        , Newlines
                        ]
                    )
        ]


stylusToCssTests : Test
stylusToCssTests =
    describe "Stylus to CSS"
        [ test "Rule" <|
            \_ ->
                Expect.equal
                    (Ok
                        ("h1.important"
                            ++ "{display:inline-block;margin:0;font-size:2em}\n"
                        )
                    )
                    (stylusToCss
                        (""
                            ++ "h1.important\n"
                            ++ "  display inline-block\n"
                            ++ "  margin 0\n"
                            ++ "  font-size 2em\n"
                        )
                    )
        , test "Rules" <|
            \_ ->
                Expect.equal
                    (Ok
                        (""
                            ++ "h1.important"
                            ++ "{display:inline-block;margin:0;font-size:2em}\n"
                            ++ ".alert{color:rgb(50, 50, 50)}\n"
                            ++ ".primary{font-weight:900}\n"
                        )
                    )
                    (stylusToCss
                        (""
                            ++ "h1.important\n"
                            ++ "  display inline-block\n"
                            ++ "  margin 0\n"
                            ++ "  font-size 2em\n"
                            ++ ".alert\n"
                            ++ "  color rgb(50, 50, 50)\n"
                            ++ ".primary\n"
                            ++ "  font-weight 900\n"
                        )
                    )
        , test "Rule With Comments" <|
            \_ ->
                Expect.equal
                    (Ok
                        (""
                            ++ "h1.important"
                            ++ "{display:inline-block;margin:0;font-size:2em}\n"
                            ++ "/*Just like that*/\n"
                            ++ ".alert{color:rgb(50, 50, 50)}\n"
                            ++ "/*Even more*/\n"
                            ++ "/*Wow, so much comment*/\n"
                            ++ "/*A lot of special chars : . // $ % ^ **/\n"
                        )
                    )
                    (stylusToCss
                        (""
                            ++ "h1.important\n"
                            ++ "  display inline-block\n"
                            ++ "  margin 0\n"
                            ++ "  font-size 2em\n"
                            ++ "// Just like that\n"
                            ++ ".alert\n"
                            ++ "  color rgb(50, 50, 50)\n"
                            ++ "// Even more\n"
                            ++ "// Wow, so much comment\n"
                            ++ "// A lot of special chars : . // $ % ^ *\n"
                        )
                    )
        , test "Rules With Newlines" <|
            \_ ->
                Expect.equal
                    (Ok
                        (""
                            ++ "h1.important"
                            ++ "{display:inline-block;margin:0;font-size:2em}\n"
                            ++ "/*Just like that*/\n"
                            ++ ".alert{color:rgb(50, 50, 50)}\n"
                        )
                    )
                    (stylusToCss
                        (""
                            ++ "h1.important\n"
                            ++ "  display inline-block\n"
                            ++ "  margin 0\n"
                            ++ "  font-size 2em\n"
                            ++ "// Just like that\n"
                            ++ ".alert\n"
                            ++ "  color rgb(50, 50, 50)\n"
                        )
                    )
        ]


suite : Test
suite =
    describe "Stylus Parser"
        [ describe "Selectors Parser"
            [ test "parsing" <|
                \_ ->
                    Expect.equal (Ok [ "h1", "h2", "h3" ])
                        (run selectors "h1, h2, h3\n")
            ]
        , primitiveTests
        , describe "Complete Parser"
            [ test "Parsing of complete file" <|
                \_ ->
                    let
                        stylusStr =
                            ""
                                ++ "h1, h2, h3\n"
                                ++ "  color blue\n"
                                ++ "  font-size 18\n"
                                ++ "// Just a comment\n"
                                ++ "div, section\n"
                                ++ "  margin-bottom 2em\n"
                                ++ "  border 1px solid black\n"

                        cssStr =
                            newlineFold
                                [ "h1, h2, h3{"
                                    ++ "color:blue;"
                                    ++ "font-size:18"
                                    ++ "}"
                                , "/*Just a comment*/"
                                , "div, section{"
                                    ++ "margin-bottom:2em;"
                                    ++ "border:1px solid black"
                                    ++ "}"
                                ]

                        --|> map (\c -> c ++ "\n")
                        --|> join ""
                    in
                    Expect.equal (Ok cssStr) (stylusToCss stylusStr)
            ]
        ]
