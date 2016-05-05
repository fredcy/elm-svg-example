module View exposing (..)

import Html exposing (Html)
import Html.App as Html
import Svg exposing (Svg)
import Svg.Attributes exposing (..)
import Model exposing (Model)
import Piece.Model as Piece
import Piece.View as Piece
import Types exposing (..)


view : Model -> Html.Html Msg
view model =
  Html.div
    []
    [ Html.h1 [] [ Html.text "SVG drag and drop" ]
    , Html.div [] [ Html.text "Drag to move, shift-drag to rotate" ]
    , scene model
      --, debugInfo model
    ]


scene : Model -> Html.Html Msg
scene model =
  Svg.svg
    [ width <| toString model.size.width
    , height <| toString model.size.height
    ]
    (background (cursorVal model) model.size.width model.size.height :: (List.map pieceView model.pieces))


pieceView : ( Name, Piece.Model ) -> Svg.Svg Msg
pieceView ( name, piece ) =
  Piece.view piece |> Html.map (PieceMsg name)


background : String -> Int -> Int -> Svg.Svg Msg
background cursorV w h =
  Svg.rect
    [ width <| toString w
    , height <| toString h
    , fill "#EEEEEE"
    , cursor <| cursorV
    ]
    []


cursorVal model =
  if List.any (Piece.rotating << snd) model.pieces then
    "crosshair"
  else
    "default"


debugInfo : Model -> Html.Html Msg
debugInfo model =
  Html.div
    []
    [ Html.text <| "size = " ++ toString model.size
    , Html.text <| "shift = " ++ toString model.shift
    , Html.ul
        []
        (List.map (\item -> Html.li [] [ (Html.text << toString) item ]) model.pieces)
    ]