module Subs exposing (subscriptions)

import Models exposing (Word, Model, emptyWord, startingWords, wordGet)
import Msgs exposing (Msg(..))
import PortsIndex exposing (swalResultOkCancel)            

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg                                                                                                                                                                                                                                                                                                        
subscriptions model =
  swalResultOkCancel SwalResultOkCancel