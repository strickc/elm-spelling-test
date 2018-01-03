port module App exposing (..)

import Array exposing (Array)
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (class, style, value)
import Html.Events exposing (onBlur, onClick, onFocus, onInput)
import Random exposing (Seed, generate)
import Random.Array exposing (shuffle)


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


init : ( Model, Cmd Msg )
init =
    ( { words = startingWords
      , mode = Edit
      }
    , Cmd.none
    )


wordGet : Array Word -> Int -> Word
wordGet arr index =
    case Array.get index arr of
        Just myWord ->
            myWord

        Nothing ->
            emptyWord


type Msg
    = ShuffleIt
    | ShuffledList (Array Word)
    | InputWord Int String
    | InputTest Int String
    | DoAction
    | Speak Model Int


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

        DoAction ->
            let
                mode =
                    case model.mode of
                        Test ->
                            Check

                        Edit ->
                            Test

                        Check ->
                            Edit
            in
            { model | mode = mode } ! []

        Speak model index ->
            let
                arrVal =
                    Array.get index model.words

                word =
                    case arrVal of
                        Just myWord ->
                            myWord.entry

                        Nothing ->
                            ""
            in
            ( model, speak (wordGet model.words index |> .entry) )


view : Model -> Html Msg
view model =
    div [ class "main-container" ]
        [ div [ class "centered-list" ]
            [ Html.h3 [] [ text "Spelling Test" ]
            , div []
                [ actionButton model
                ]
            , div
                [ style
                    [ ( "flex-direction", "column" )
                    ]
                ]
                (wordInputList model
                    ++ blankEndInput model
                )
            , div [] [ button [ onClick ShuffleIt ] [ text "Shuffle" ] ]
            ]
        ]


wordInputList : Model -> List (Html Msg)
wordInputList model =
    let
        inputGen i w =
            case model.mode of
                Test ->
                    wordTest model i w

                Edit ->
                    wordEdit model i w

                Check ->
                    wordCheck model i w
    in
    Array.indexedMap inputGen model.words |> Array.toList


wordEdit : Model -> Int -> Word -> Html Msg
wordEdit model index word =
    div []
        [ input
            [ value word.entry
            , onInput (InputWord index)
            , onBlur (Speak model index)
            ]
            []
        ]


wordTest : Model -> Int -> Word -> Html Msg
wordTest model index word =
    div []
        [ input
            [ onFocus (Speak model index)
            , onInput (InputTest index)
            ]
            []
        , button [ onClick (Speak model index) ] [ text "Repeat" ]
        ]


wordCheck : Model -> Int -> Word -> Html Msg
wordCheck model index word =
    let
        testWord =
            wordGet model.words index |> .test

        bgColor =
            if String.toLower word.entry == String.toLower word.test then
                "lightgreen"
            else
                "lightcoral"
    in
    div []
        [ input
            [ value word.test
            , onFocus (Speak model index)
            , onInput (InputTest index)
            , style [ ( "background-color", bgColor ) ]
            ]
            []
        , text word.entry
        ]


blankEndInput : Model -> (List (Html Msg))
blankEndInput model =
    case model.mode of
        Edit ->
            [ wordEdit model -1 (emptyWord) ]

        _ ->
            []


actionButton : Model -> Html Msg
actionButton model =
    let
        actionText =
            case model.mode of
                Edit ->
                    "Start Test"

                Test ->
                    "Check Answers"

                Check ->
                    "Back to Edit"
    in
    button [ onClick DoAction ] [ text actionText ]


port speak : String -> Cmd msg
