module Main exposing (main)

import Html
import View exposing (view)
import Models exposing (Model, Mode(..), startingWords)
import Update exposing (update)
import Msgs exposing (Msg)
import Subs exposing (subscriptions)

init : ( Model, Cmd Msg )
init =
    ( { words = startingWords
      , mode = Edit
      }
    , Cmd.none
    )

main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
