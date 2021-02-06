module TimeUtils.TypeAlias exposing
    ( TimeFromFields
    , DateFromFields
    )

{-| Extra types for sharing between Internal and External interface.

@docs TimeFromFields
@docs DateFromFields

-}

import Time exposing (..)


{-| Alternate signature for Create.timeFromFields
-}
type alias TimeFromFields =
    { hour : Int
    , minute : Int
    , second : Int
    , millisecond : Int
    }


{-| Alternate signature for Create.dateFromFieldsRecord

See Core.inToMonth for converting an integer month to a Month.

-}
type alias DateFromFields =
    { year : Int
    , month : Month
    , day : Int
    , hour : Int
    , minute : Int
    , second : Int
    , millisecond : Int
    }
