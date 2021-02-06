module TimeUtils.Config.Configs exposing
    ( getConfig
    , configs
    )

{-| Get a TimeUtils.Config based up on a locale code.

@docs getConfig
@docs configs

-}

import Dict exposing (Dict)
import Regex as Regex
import String
import TimeUtils.Config as Config exposing (Config)
import TimeUtils.Config.Config_en_us as Config_en_us


{-| Built in configurations.
-}
configs : Dict String Config
configs =
    Dict.fromList
        [ ( "en_us", Config_en_us.config ) ]


{-| Get a TimeUtils.Config for a locale id.

Lower case matches strings and accepts "-" or "\_" to separate
the characters in code.

Returns "en\_us" config if it can't find a match in configs.

-}
getConfig : String -> Config
getConfig id =
    let
        lowerId =
            String.toLower id

        fixedId =
            Regex.replace
                (Maybe.withDefault Regex.never (Regex.fromString "-"))
                (\_ -> "_")
                lowerId
    in
    Maybe.withDefault Config_en_us.config
        (Dict.get fixedId configs)
