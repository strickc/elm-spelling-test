module Views.WordList exposing (wordList)

import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (class, style, value)
import Html.Events exposing (onBlur, onClick, onFocus, onInput)
import Array

import Models exposing (Model, Word, Mode(..), Route(..), emptyWord, wordGet)
import Msgs exposing (Msg(..))
import Routing exposing (paths)

type alias Path = String

type alias WordListParams = 
  { title : String
  , instructions : String
  , wordDisplayFunc : Model -> Int -> Word -> Html Msg
  , actionButtons : List ( Maybe Path, Maybe Msg, String )
  , model : Model
  }

inputStyle : List (Html.Attribute Msg)
inputStyle = 
    [ class "form-control"
    , style 
        [ ( "margin", "0 3px 3px 0" )
        , ( "max-width", "300px" )
        ]
    ]

wordList : Model -> Html Msg
wordList model =
  case model.route of
    EditRoute ->
      makeWordList
        { title = "Spelling Test"
        , instructions = "Enter the list of words, you can also add an example sentence or phrase to put them in context."
        , wordDisplayFunc = wordEdit
        , actionButtons = 
          [ (Just paths.test, Nothing, "Start Test")
          , (Nothing, Just ClearList, "Clear List")
          ]
        , model = model
        }
    

    TestRoute ->
      makeWordList  
        { title = "Spelling Test"
        , instructions = "Listen for the words and example sentence to be spoken, and then enter the correct spelling.  Good Luck!"
        , wordDisplayFunc = wordTest
        , actionButtons = [(Just paths.check, Nothing, "Check Answers")]
        , model = model
        }

    _ ->
      makeWordList  
        { title = "Spelling Test"
        , instructions = "Green words were spelled correctly!  Red words were not.  Feel free to edit the words until you are confident you know the correct spelling."
        , wordDisplayFunc = wordCheck
        , actionButtons = [(Just paths.edit, Nothing, "Start at Beginning!")]
        , model = model
        }
        

makeWordList : WordListParams -> Html Msg
makeWordList params =
  div [ class "centered-list" ]
    [ titleHeader params.title
    , div 
        [ style 
            [ ( "max-width", "500px" )
            , ( "display", "flex" ) ]
        ] 
        [ text params.instructions ]
    , div
        [ style
            [ ( "flex-direction", "column" )
            , ( "display", "flex" )
            , ("align-items", "center")
            , ("margin", "1em 0 0 0")
            ]
        ]
        (wordInputList params ++ blankEndInput params.model)
    , actionButtons params.actionButtons
    -- , div [] [ button [ onClick ShuffleIt ] [ text "Shuffle" ] ]
    ]

titleHeader : String -> Html Msg
titleHeader title =
    Html.h3 [ style [ ( "text-align", "center" ) ] ] [ text title ]

wordInputList : WordListParams -> List (Html Msg)
wordInputList params =
    let
      inputGen i w =
        params.wordDisplayFunc params.model i w
    in
    Array.indexedMap inputGen params.model.words |> Array.toList

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
    case model.route of
        EditRoute ->
            [ wordEdit model -1 (emptyWord) ]

        _ ->
            []


actionButtons : (List ( Maybe Path, Maybe Msg, String )) -> Html Msg
actionButtons actionList =
    div
        [ style
            [ ("justify-content", "center")
            , ("flex-direction", "row")
            , ("margin", "1em 0 0 0")
            , ( "display", "flex" )
            ]
        ]
        (List.map createButton actionList)
        
createButton : (Maybe Path, Maybe Msg, String) -> Html Msg
createButton buttonTuple =
    let
      (mPath, mMsg, aText) = buttonTuple

      hrefAtts =
        case mPath of
          Just path ->
            [ Html.Attributes.href path
            , Routing.onLinkClick (ChangeLocation path)
            ]

          Nothing ->
            []

      clickAtts =
        case mMsg of
          Just m ->
            [ onClick m ]

          Nothing ->
            []
    in
    button 
        (hrefAtts ++ clickAtts ++
        [ class "btn btn-outline-success"
        , style [ ( "margin-bottom", "3px" ) ]
        ])
        [ text aText ]
