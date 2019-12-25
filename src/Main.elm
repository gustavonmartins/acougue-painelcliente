module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)


---- MODEL ----


type alias Model =
    {emAtendimento: List Senha
    , ultimaSenha: Maybe Senha}

type alias Senha = String

init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )

initialModel : Model
initialModel = 
    {emAtendimento = ["P002", "C003"]
    , ultimaSenha = Just "P003"}

---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ viewEmAtendimento model
        , viewUltimaSenha model
        ]

viewEmAtendimento : Model -> Html Msg
viewEmAtendimento model =
    div [] [
        text "Em atendimento"
        , div [] [
                    div []
        (List.map (\senha -> p [] [text senha]) model.emAtendimento)
                ]
    ]

viewUltimaSenha : Model -> Html Msg
viewUltimaSenha model =
    let
        header = p[] [text "Ultima senha: "]
        content = 
            case model.ultimaSenha of
                Nothing -> text ""

                Just ultimaSenha ->
                    div [] [
                            p [] [text ultimaSenha]
                            ]
    in
        div [] [
            header
            ,content
        ]
    

---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
