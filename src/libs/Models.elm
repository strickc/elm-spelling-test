module Models exposing (Word, Mode(..), Model)

import Array exposing (Array)


type alias Word =
    { entry : String
    , test : String
    , sentence : String
    }


type Mode
    = Edit
    | Test
    | Check


type alias Model =
    { words : Array Word
    , mode : Mode
    }