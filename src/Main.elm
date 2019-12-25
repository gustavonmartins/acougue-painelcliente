module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Http

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


type Msg =
    NewEntries (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewEntries (Ok jsonString) ->
            let
                _= Debug.log "It worked! " jsonString
            in
                ({model | ultimasSenhas = jsonString :: model.ultimasSenhas}, Cmd.none)

        NewEntries (Err error) ->
            let
                _ = Debug.log "Oops, not as we wished! " error
            in
                (model, Cmd.none)



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
    

---- COMMANDS ---    

getEntries : Cmd Msg
getEntries = 
    Http.get{url = "http://localhost:8080/ultimas-senhas"
    ,expect = Http.expectString NewEntries}

---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> (initialModel, getEntries)
        , update = update
        , subscriptions = always Sub.none
        }
