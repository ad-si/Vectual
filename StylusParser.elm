module StylusParser exposing (..)

import Parser
    exposing
        ( Parser
        , Count(..)
        , (|.)
        , (|=)
        , end
        , float
        , ignore
        , keep
        , keyword
        , oneOrMore
        , repeat
        , run
        , succeed
        , symbol
        , zeroOrMore
        , inContext
        , oneOf
        )
import Parser.LanguageKit as Parser
    exposing
        ( Trailing(..)
        , LineComment(..)
        , MultiComment(..)
        , whitespace
        )
import Char


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


type alias Declarations =
    List Declaration


type Expression
    = Rule ( Selectors, Declarations )
    | Comment String
    | Newlines


type alias Stylus =
    List Expression


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
        || List.member char [ ' ', '.', ',', '(', ')', '"', '%' ]


isValidSelector : Char -> Bool
isValidSelector char =
    (isValidValue char) || (List.member char [ ' ', '.', '=', '[', ']' ])


selector : Parser String
selector =
    keep oneOrMore isValidSelector


selectors : Parser Selectors
selectors =
    Parser.sequence
        { start = ""
        , separator = ", "
        , end = ""
        , spaces = symbol ""
        , item = selector
        , trailing = Forbidden
        }


property : Parser Property
property =
    keep oneOrMore isValidChar


value : Parser Value
value =
    keep oneOrMore isValidValue


comment : Parser Expression
comment =
    Parser.map Comment (keep oneOrMore isNotNewline)


declaration : Parser Declaration
declaration =
    inContext "declaration" <|
        succeed (,)
            |. symbol "\n  "
            |= property
            |. symbol " "
            |= value


declarations : Parser Declarations
declarations =
    inContext "declarations" <|
        succeed identity
            |= (repeat oneOrMore declaration)
            |. symbol "\n"


rule : Parser Expression
rule =
    Parser.map Rule
        (inContext "rule" <|
            succeed (,)
                |= selectors
                |= declarations
        )


commentLine : Parser Expression
commentLine =
    inContext "comment" <|
        succeed identity
            |. symbol "// "
            |= comment
            |. symbol "\n"


newlines : Parser Expression
newlines =
    succeed Newlines
        |. (ignore oneOrMore (\char -> char == '\n'))


sections : Parser Expression
sections =
    oneOf
        [ rule
        , commentLine
        , newlines
        ]


stylus : Parser Stylus
stylus =
    inContext "stylus" <|
        succeed identity
            |= (repeat oneOrMore sections)
            |. end
