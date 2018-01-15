module Main exposing (main)

import Html
import Navigation exposing (Location)

import View exposing (view)
import Models exposing (Model, Mode(..), Route(..), startingWords)
import Update exposing (update)
import Msgs exposing (Msg)
import Subs exposing (subscriptions)
import Routing

init : Location -> ( Model, Cmd Msg )
init location =
    ( { words = startingWords
      , mode = Edit
      , route = (Routing.parseLocation location)
      }
    , Cmd.none
    )

main =
    Navigation.program Msgs.OnLocationChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
