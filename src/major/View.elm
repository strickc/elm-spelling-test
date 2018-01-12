module View exposing (..)

import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (class, style, value)

import Models exposing (..)
import Msgs exposing (Msg)
import Views.WordList exposing (wordList)


view : Model -> Html Msg
view model =
    div [ class "main-container" ]
        [ wordList model
        ]
