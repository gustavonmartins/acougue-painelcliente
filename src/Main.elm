module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)

---- MODEL ----


type alias Model =
    {emAtendimento: List Senha
    , ultimasSenhas: List Senha}

type alias Senha = String

init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )

initialModel : Model
initialModel = 
    {emAtendimento = ["P002", "C003"]
    , ultimasSenhas = ["P003", "P004"]}

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
        , viewultimasSenhas model
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

viewultimasSenhas : Model -> Html Msg
viewultimasSenhas model =
    div [] [
            text "Senhas solicitadas"
            ,div []
                    (List.map (\senha -> p [] [text senha]) model.ultimasSenhas)
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
