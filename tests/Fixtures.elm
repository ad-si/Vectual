module Fixtures exposing (..)

import StylusParser exposing (..)


selectorRaw =
    "main[foo=bar]"


selectorAst =
    "main[foo=bar]"


selectorsRaw =
    "h1, h2, h3 p, .error, main[foo=bar]"


selectorsAst =
    [ "h1"
    , "h2"
    , "h3 p"
    , ".error"
    , "main[foo=bar]"
    ]


declarationRaw =
    """
  display inline-block"""


declarationAst =
    ( "display", "inline-block" )


declarationNewlineAst =
    [ ( "display", "inline-block" ) ]


declarationsRaw =
    """
  display inline-block
  margin 0
  font-size 12
"""


declarationsAst =
    [ ( "display", "inline-block" )
    , ( "margin", "0" )
    , ( "font-size", "12" )
    ]


ruleRaw =
    """h1.important
  display inline-block
  margin 0
  font-size 2em
"""


ruleAst =
    Rule
        ( [ "h1.important" ]
        , [ ( "display", "inline-block" )
          , ( "margin", "0" )
          , ( "font-size", "2em" )
          ]
        )


ruleAsStylusAst =
    [ Rule
        ( [ "h1.important" ]
        , [ ( "display", "inline-block" )
          , ( "margin", "0" )
          , ( "font-size", "2em" )
          ]
        )
    ]


ruleCss =
    """h1.important{display:inline-block;margin:0;font-size:2em}
"""


rulesRaw =
    """h1.important
  display inline-block
  margin 0
  font-size 2em
.alert
  color rgb(50, 50, 50)
.primary
  font-weight 900
"""


rulesAst =
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


rulesCss =
    """h1.important{display:inline-block;margin:0;font-size:2em}
.alert{color:rgb(50, 50, 50)}
.primary{font-weight:900}
"""


rulesWithCommentsRaw =
    """h1.important
  display inline-block
  margin 0
  font-size 2em
// Just like that
.alert
  color rgb(50, 50, 50)
// Even more
// Wow, so much comment
"""


rulesWithCommentsAst =
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
    ]


rulesWithCommentsCss =
    """h1.important{display:inline-block;margin:0;font-size:2em}
/*Just like that*/
.alert{color:rgb(50, 50, 50)}
/*Even more*/
/*Wow, so much comment*/
"""


rulesWithNewlinesRaw =
    """
h1.important
  display inline-block
  margin 0
  font-size 2em

// Just like that

.alert
  color rgb(50, 50, 50)

"""


rulesWithNewlinesAst =
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


rulesWithNewlinesCss =
    """
h1.important{display:inline-block;margin:0;font-size:2em}

/*Just like that*/

.alert{color:rgb(50, 50, 50)}

"""
