module Tests exposing (..)

import StylusParser exposing (..)
import Html exposing (Html, div, p)
import Parser exposing (run)


main : Html a
main =
    div []
        (List.map (\x -> p [] [ Html.text x ])
            [ toString (run selector rawSelector)
            , toString (run selectors rawSelectors)
            , toString (run declaration rawDeclaration)
            , toString (run declarations (rawDeclaration ++ "\n"))
            , toString (run declarations rawDeclarations)
            , toString (run rule rawRule)
            , toString (run stylus rawRule)
            , toString (run stylus rawStylus)
            , toString (run stylus rawStylusWithComments)
            , toString (run stylus rawStylusWithNewlines)
            ]
        )


rawSelector =
    "main[foo=bar]"


rawSelectors =
    "h1, h2, h3 p, .error, main[foo=bar]"


rawDeclaration =
    """
  display inline-block"""


rawDeclarations =
    """
  display inline-block
  margin 0
  font-size 12
"""


rawRule =
    """h1.important
  display inline-block
  margin 0
  like what
"""


rawStylus =
    """h1.important
  display inline-block
  margin 0
  like what
.alert
  color rgb(50, 50, 50)
.primary
  font-weight 900
"""


rawStylusWithComments =
    """h1.important
  display inline-block
  margin 0
  like what
// Just like that
.alert
  color rgb(50, 50, 50)
// Even more
// Wow, so much comment
"""


rawStylusWithNewlines =
    """
h1.important
  display inline-block
  margin 0
  like what

// Just like that

.alert
  color rgb(50, 50, 50)

"""
