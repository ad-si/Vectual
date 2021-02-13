module Stylus.Parser exposing
    ( stylusToCss
    , Expression(..)
    , Problem(..)
    , selector
    , selectors
    , section
    , rule
    , declaration
    , declarations
    , newlines
    , commentLine
    , stylus
    , serializeStylusAst
    )

{-| Convert a strict subset of Stylus to CSS

@docs stylusToCss


## Internal

@docs Expression
@docs Problem
@docs selector
@docs selectors
@docs section
@docs rule
@docs declaration
@docs declarations
@docs newlines
@docs commentLine
@docs stylus
@docs serializeStylusAst

-}

import Char
import Parser.Advanced exposing (..)


type alias StyParser a =
    Parser.Advanced.Parser Context Problem a


type Context
    = Definition String
    | List
    | Record


{-| -}
type Problem
    = BadIndent
    | BadKeyword String
    | GenericProblem


type alias Selector =
    String


type alias Selectors =
    List String


type alias Property =
    String


type alias Value =
    String


type alias Declaration =
    ( Property, Value )


{-| -}
type Expression
    = Rule ( Selectors, List Declaration )
    | Comment String
    | Newlines


isNotNewline : Char -> Bool
isNotNewline char =
    char /= '\n'


isValidChar : Char -> Bool
isValidChar char =
    Char.isLower char
        || Char.isUpper char
        || List.member char [ '-', '_' ]


isValidValue : Char -> Bool
isValidValue char =
    isValidChar char
        || Char.isDigit char
        || List.member char [ ' ', '.', ',', '(', ')', '"', '#', '%', '/' ]


isValidSelector : Char -> Bool
isValidSelector char =
    isValidChar char
        || Char.isDigit char
        || List.member char [ ' ', '.', ':', '=', '(', ')', '[', ']' ]


{-| -}
selector : StyParser String
selector =
    getChompedString <|
        succeed ()
            |. chompIf isValidSelector GenericProblem
            |. chompWhile isValidSelector


{-| -}
selectors : StyParser Selectors
selectors =
    sequence
        { start = Token "" GenericProblem
        , separator = Token ", " GenericProblem
        , end = Token "\n" GenericProblem
        , spaces = symbol (Token "" GenericProblem)
        , item = selector
        , trailing = Forbidden
        }


property : StyParser Property
property =
    getChompedString <|
        succeed ()
            |. chompIf isValidChar GenericProblem
            |. chompWhile isValidChar


value : StyParser Value
value =
    getChompedString <|
        succeed ()
            |. chompIf isValidValue GenericProblem
            |. chompWhile isValidValue


comment : StyParser Expression
comment =
    map Comment (getChompedString (chompUntilEndOr "\n"))


{-| -}
declaration :
    List Declaration
    -> StyParser (Step (List Declaration) (List Declaration))
declaration dcls =
    oneOf
        [ succeed (\a b -> Loop (( a, b ) :: dcls))
            |. symbol (Token "  " GenericProblem)
            |= property
            |. symbol (Token " " GenericProblem)
            |= value
            |. symbol (Token "\n" GenericProblem)
        , succeed ()
            |> map (\_ -> Done (List.reverse dcls))
        ]


{-| -}
declarations : StyParser (List Declaration)
declarations =
    loop [] declaration


{-| -}
rule : StyParser Expression
rule =
    inContext (Definition "rule") <|
        succeed (\a b -> Rule ( a, b ))
            |= selectors
            |= declarations


{-| -}
commentLine : StyParser Expression
commentLine =
    inContext (Definition "comment") <|
        succeed identity
            |. symbol (Token "// " GenericProblem)
            |= comment
            |. symbol (Token "\n" GenericProblem)


{-| -}
newlines : StyParser Expression
newlines =
    succeed Newlines
        |. chompIf (\c -> c == '\n') GenericProblem
        |. chompWhile (\c -> c == '\n')


{-| -}
section :
    List Expression
    -> StyParser (Step (List Expression) (List Expression))
section scts =
    oneOf
        [ succeed
            (\start sct end ->
                if start == end then
                    Done (List.reverse scts)

                else
                    Loop (sct :: scts)
            )
            |= getOffset
            |= oneOf
                [ newlines
                , rule
                , commentLine
                ]
            |= getOffset
        , succeed ()
            |> map (\_ -> Done (List.reverse scts))
        ]


{-| -}
stylus : StyParser (List Expression)
stylus =
    loop [] section


serializeExpression : Expression -> String
serializeExpression expression =
    case expression of
        Newlines ->
            "\n"

        Comment string ->
            "/*" ++ string ++ "*/\n"

        Rule ( selectrs, decls ) ->
            let
                decToCss decTuple =
                    Tuple.first decTuple ++ ":" ++ Tuple.second decTuple
            in
            String.join ", " selectrs
                ++ "{"
                ++ String.join ";" (List.map decToCss decls)
                ++ "}\n"


{-| -}
serializeStylusAst : List Expression -> String
serializeStylusAst stylusAst =
    String.join ""
        (List.map serializeExpression stylusAst)


{-|

    stylusToCss """
    div
      width 400px
      height 300px
    """

yields

    div { width: 400px; height: 300px; }

-}
stylusToCss : String -> Result (List (DeadEnd Context Problem)) String
stylusToCss stylusString =
    Result.map serializeStylusAst (run stylus stylusString)
