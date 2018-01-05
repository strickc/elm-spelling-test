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
    | InputSentence Int String
    | InputTest Int String
    | StartTest
    | StartEdit
    | StartCheck
    | ClearList
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
            { model | mode = Test } ! []
        
        StartEdit ->
            { model | mode = Edit } ! []
        
        StartCheck ->
            { model | mode = Check } ! []
        
        ClearList ->
            { model | words = Array.fromList [emptyWord] } ! []

        Speak model index ->
            let
                construct word =
                    if word.entry /= "" then
                        if word.sentence == "" then
                            word.entry
                        else
                            word.entry ++ ", as in " ++ word.sentence
                    else
                        ""

                word =
                    construct (wordGet model.words index)
                
            in
            ( model, speak word )


view : Model -> Html Msg
view model =
    div [ class "main-container" ]
        [ div [ class "centered-list" ]
            [ titleHeader
            , div 
                [ style 
                    [ ( "max-width", "500px" ) ]
                ] 
                [ text (instructionText model.mode) ]
            , div
                [ style
                    [ ( "flex-direction", "column" )
                    , ("align-items", "center")
                    , ("margin", "1em 0 0 0")
                    ]
                ]
                (wordInputList model ++ blankEndInput model)
            , actionButtons model
            -- , div [] [ button [ onClick ShuffleIt ] [ text "Shuffle" ] ]
            ]
        ]

titleHeader : Html Msg
titleHeader =
    Html.h3 [ style [ ( "text-align", "center" ) ] ] [ text "Spelling Test" ]


instructionText : Mode -> String
instructionText mode =
    case mode of
        Edit ->
            "Enter the list of words, and optional sentences to put them in context."
        
        Test ->
            "Listen for the words and example sentence to be spoken, and then enter the correct spelling.  Good Luck!"

        Check ->
            "Green words were spelled correctly!  Red words were not.  Feel free to edit the words until you are confident you know the correct spelling."


inputStyle : List (Html.Attribute Msg)
inputStyle = 
    [ class "form-control"
    , style 
        [ ( "margin", "0 3px 3px 0" )
        , ( "max-width", "300px" )
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
    let
        visibility =
            case index of
                -1 -> "hidden"
                
                _ -> "unset"

    in
    div []
        [ input
            ([ value word.entry
            , onInput (InputWord index)
            , style [ ("width", "35%")]
            ] ++ inputStyle)
            []
        , input
            ([ value word.sentence 
            , onInput (InputSentence index)
            , class "form-control"
            , style [ ("width", "65%")]
            , style [ ("visibility", visibility) ]
            ] ++ inputStyle)
            []
        ]


wordTest : Model -> Int -> Word -> Html Msg
wordTest model index word =
    div []
        [ input
            ([ onFocus (Speak model index)
            , onClick (Speak model index)
            , onInput (InputTest index)
            , style [ ("max-width", "300px")]
            ] ++ inputStyle)
            []
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
            ([ value word.test
            , onFocus (Speak model index)
            , onInput (InputTest index)
            , style [ ( "background-color", bgColor ) ]
            ] ++ inputStyle)
            []
        , div [ style [ ("width", "150px") ] ] [ text word.entry ]
        ]


blankEndInput : Model -> (List (Html Msg))
blankEndInput model =
    case model.mode of
        Edit ->
            [ wordEdit model -1 (emptyWord) ]

        _ ->
            []


actionButtons : Model -> Html Msg
actionButtons model =
    let
        actionTuples =
            case model.mode of
                Edit ->
                    [ (StartTest, "Start Test")
                    , (ClearList, "Clear List")
                    ]

                Test ->
                    [(StartCheck, "Check Answers")]

                Check ->
                    [(StartEdit, "Back to Edit")]
    
    in
    div
        [ style
            [ ("justify-content", "center")
            , ("flex-direction", "row")
            , ("margin", "1em 0 0 0")
            ]
        ]
        (List.map createButton actionTuples)
        
createButton : (Msg, String) -> Html Msg
createButton actionTuple =
    let
        (action, aText) = actionTuple
    in
    button 
        [ onClick action
        , class "btn btn-outline-success"
        , style [ ( "margin-bottom", "3px" ) ]
        ] [ text aText ]
    


port speak : String -> Cmd msg