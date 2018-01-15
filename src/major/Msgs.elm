module Msgs exposing (..)

import Array exposing (Array)
import Navigation exposing (Location)
import Dom exposing (focus, Id)

import Models exposing (Model, Word)

type Msg
    = ShuffleIt
    | ShuffledList (Array Word)
    | InputWord Int String
    | InputSentence Int String
    | InputTest Int String
    | StartTest
    | StartEdit
    | StartCheck
    | ClearList
    | Speak Model Int
    | SwalResultOkCancel Bool
    | FocusResult (Result Dom.Error ())
    | OnLocationChange Location
    | ChangeLocation String

