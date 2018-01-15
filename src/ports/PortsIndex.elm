port module PortsIndex exposing 
    ( speak
    , swal
    , swalWithResult
    , SwalParams
    , swalResultOkCancel
    )

type alias SwalParams = 
    { title : String
    , text : String
    , swalType : String
    }

port speak : String -> Cmd msg
port swal : SwalParams -> Cmd msg
port swalWithResult : SwalParams -> Cmd msg

-- SUBSCRIPTIONS

port swalResultOkCancel : (Bool -> msg) -> Sub msg