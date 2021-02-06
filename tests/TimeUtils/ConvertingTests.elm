module TimeUtils.ConvertingTests exposing (..)

{-| Test conversion of dates
-}

import Expect
import Iso8601 as Iso8601
import Test exposing (..)
import Time exposing (..)
import TimeUtils.Config.Config_en_us exposing (config)
import TimeUtils.Format as Format
    exposing
        ( format
        , formatUtc
        , isoMsecOffsetFormat
        )


tests : Test
tests =
    describe "Date conversion tests"
        [ convertingDates
        ]


robDateToISO =
    Format.utcIsoString


dateToISO : Posix -> String
dateToISO date =
    formatUtc config isoMsecOffsetFormat date


convertingDates : Test
convertingDates =
    describe
        "Converting a date to ISO String"
        [ test
            "output is exactly the same as iso input v1"
            (\() ->
                Expect.equal
                    (Ok "2016-03-22T17:30:00.000+00:00")
                    (Iso8601.toTime "2016-03-22T17:30:00.000Z"
                        |> Result.andThen (Ok << dateToISO)
                    )
            )
        , test
            "output is exactly the same as iso input v2"
            (\() ->
                Expect.equal
                    (Ok "2016-03-22T17:30:00.000Z")
                    (Iso8601.toTime "2016-03-22T17:30:00.000Z"
                        |> Result.andThen (Ok << robDateToISO)
                    )
            )
        ]
