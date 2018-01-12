module Ordinal exposing (makeOrdinal)

makeOrdinal : Int -> String
makeOrdinal n =
  let
      suffix =
        case ((n+90)%100-10)%10-1 of
          0 ->
            "st"

          1 ->
            "nd"

          2 ->
            "rd"
          
          _ ->
            "th"

  in
    toString n ++ suffix
      
