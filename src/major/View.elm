module View exposing (..)

import Models exposing (..)
import Msgs exposing (Msg(..))


import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (class, style, value)
import Html.Events exposing (onBlur, onClick, onFocus, onInput)
import Array exposing (Array)


view : Model -> Html Msg
view model =
    div [ class "main-container" ]
        [ div [ class "centered-list" ]
            [ titleHeader
            , div 
                [ style 
                    [ ( "max-width", "500px" )
                    , ( "display", "flex" ) ]
                ] 
                [ text (instructionText model.mode) ]
            , div
                [ style
                    [ ( "flex-direction", "column" )
                    , ( "display", "flex" )
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
    div [ style [ ( "display", "flex" ) ]
        ]
        [ input
            ([ value word.entry
            , onInput (InputWord index)
            , Html.Attributes.id (toString index ++ "word")
            , style
                [ ("width", "35%")
                ]
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
    div [ style [ ( "display", "flex" ) ]
        ]
        [ input
            ([ onFocus (Speak model index)
            , onClick (Speak model index)
            , onInput (InputTest index)
            , Html.Attributes.id (toString index ++ "word")
            , style
                [ ("max-width", "300px")
                , ( "display", "flex" )
                ]
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
    div [ style [ ( "display", "flex" ) ] ]
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
                    [(StartEdit, "Start at Beginning")]
    
    in
    div
        [ style
            [ ("justify-content", "center")
            , ("flex-direction", "row")
            , ("margin", "1em 0 0 0")
            , ( "display", "flex" )
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