module Models exposing (Word, Mode(..), Model, wordGet, emptyWord, startingWords)

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


emptyWord : Word
emptyWord =
    Word "" "" ""


startingWords : Array Word
startingWords =
    Array.fromList
        [ Word "try" "" "Try this spelling test"
        , Word "spelling" "" ""
        , Word "fun" "" "That playground was fun"
        , Word "application" "" ""
        ]



wordGet : Array Word -> Int -> Word
wordGet arr index =
    case Array.get index arr of
        Just myWord ->
            myWord

        Nothing ->
            emptyWord

