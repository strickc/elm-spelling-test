module Update exposing (..)

import Array exposing (Array)
import Random exposing (Seed, generate)
import Random.Array exposing (shuffle)
import Dom exposing (focus, Id)
import Navigation
import Task

import Ordinal exposing (makeOrdinal)
import Models exposing (Word, Mode(..), Model, Route(..), emptyWord, startingWords, wordGet)
import Msgs exposing (Msg(..))
import PortsIndex exposing (..)
import Routing exposing (parseLocation)

doFocus : Id -> Cmd Msg
doFocus id =
    Task.attempt FocusResult (Dom.focus id)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShuffleIt ->
            ( model, generate ShuffledList (shuffle model.words) )

        ShuffledList shuffledList ->
            { model | words = shuffledList } ! []

        InputWord index word ->
            let
                relevantWord =
                    wordGet model.words index

                wordList w a =
                    case index of
                        (-1) ->
                            Array.push (Word w "" "") a

                        _ ->
                            Array.set index { relevantWord | entry = w } a
            in
            { model
                | words = wordList word model.words
            }
                ! []


        InputSentence index sen ->
            let
                relevantWord =
                    wordGet model.words index

            in
            { model
                | words = (Array.set index { relevantWord | sentence = sen } model.words)
            }
                ! []


        InputTest index word ->
            let
                origItem =
                    wordGet model.words index

                updatedItem =
                    { origItem | test = word }
            in
            { model
                | words =
                    Array.set index updatedItem model.words
            }
                ! []
        
        StartTest ->
            { model
            | route = TestRoute
            , words = Array.map (\w -> { w | test = "" }) model.words
            } ! [ doFocus "0word" ]

        FocusResult result ->
            ( model, Cmd.none )

        StartEdit ->
            { model | route = EditRoute } ! []
            -- { model | mode = Edit } ! []
        
        StartCheck ->
            { model | route = CheckRoute } ! []
        
        ClearList ->
            model
            ! [ swalWithResult (SwalParams "Clear List?" "Do you want to clear the list?" "warning") ]

        Speak model index ->
            let
                num =
                    "The " ++ makeOrdinal (index+1) ++ " word is, "

                construct word =
                    if word.entry /= "" then
                        if word.sentence == "" then
                            num ++ word.entry
                        else
                            num ++ word.entry ++ ", as in " ++ word.sentence
                    else
                        ""

                word =
                    construct (wordGet model.words index)
                
            in
            ( model, speak word )

        SwalResultOkCancel ok ->
            case ok of
                True -> { model | words = Array.fromList [emptyWord] } ! []
                False -> ( model, Cmd.none )
        
        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )
        
        ChangeLocation path ->
            ( model, Navigation.newUrl path )