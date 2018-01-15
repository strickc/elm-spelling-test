module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)
import Html exposing (Attribute)
import Html.Events exposing (onWithOptions)
import Json.Decode as Decode
import Debug

import Models exposing (Route(..))


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map EditRoute (Debug.log "EditRoute" (s "edit"))
        , map TestRoute (s "test")
        , map CheckRoute (s "check")
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parsePath matchers location) of
        Just route ->
            route

        Nothing ->
            Debug.log "not found" NotFoundRoute

paths : { check : String, edit : String, test : String }
paths =
  { edit = "/edit"
  , test = "/test"
  , check = "/check"
  }

{-|
When clicking a link we want to prevent the default browser behaviour which is to load a new page.
So we use `onWithOptions` instead of `onClick`.
-}
onLinkClick : msg -> Attribute msg
onLinkClick message =
    let
        options =
            { stopPropagation = False
            , preventDefault = True
            }
    in
        onWithOptions "click" options (Decode.succeed message)
