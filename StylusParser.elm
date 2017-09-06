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


type alias Rule =
    ( Selectors, Declarations )


type alias Stylus =
    List Rule


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


meta : Parser ()
meta =
    ignore zeroOrMore (\c -> c == '\n')



-- oneOf
--     [ whitespace
--         { allowTabs = False
--         , lineComment = LineComment "// "
--         , multiComment = NestableComment "/*" "*/"
--         }
--     , symbol ""
--     ]


rule : Parser Rule
rule =
    inContext "rule" <|
        succeed (,)
            |. meta
            |= selectors
            |= declarations


stylus : Parser Stylus
stylus =
    inContext "stylus" <|
        succeed identity
            |= (repeat oneOrMore rule)
            |. meta
            |. end
