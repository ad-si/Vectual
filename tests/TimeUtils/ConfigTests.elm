module TimeUtils.ConfigTests exposing (..)

import Expect
import Test exposing (..)
import Time exposing (..)
import TimeUtils.Config.Config_en_us as Config_en_us
import TimeUtils.Config.Configs as Configs


config_en_us =
    Config_en_us.config


tests : Test
tests =
    describe "Date.Config tests"
        [ test "getConfig anything returns en_us" <|
            \() ->
                Expect.equal
                    config_en_us.format
                    (Configs.getConfig "anything").format
        , test "getConfig en_us" <|
            \() ->
                Expect.equal
                    config_en_us.format
                    (Configs.getConfig "en_us").format
        ]
