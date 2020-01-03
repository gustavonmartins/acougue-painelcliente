module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Time
import Json.Decode exposing (Decoder, int, list, string, succeed)
import Json.Decode.Pipeline exposing (required)


---- MODEL ----


type alias Model = {senhas: List Senha}

type alias Senha = {codigo: String, status: String}

senhaDecoder : Json.Decode.Decoder Senha
senhaDecoder =
    Json.Decode.succeed Senha
    |> Json.Decode.Pipeline.required "codigo" string
    |> Json.Decode.Pipeline.required "status" string

init : ( Model, Cmd Msg )
init =
    ( {senhas = []}, getEntries )

---- UPDATE ----


type Msg =
    NewEntries (Result Http.Error (List Senha))
    | Tick Time.Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewEntries (Ok jsonString) ->
            let
                _= Debug.log "It worked! " jsonString
            in
                ({model | senhas = jsonString}, Cmd.none)

        NewEntries (Err error) ->
            let
                _ = Debug.log "Oops, not as we wished! " error
            in
                (model, Cmd.none)

        Tick _ ->
            (model, getEntries)



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ viewSenhas model
        , viewultimasSenhas model
        , viewSenhasFinalizadas model
        ]

viewSenhas : Model -> Html Msg
viewSenhas model =
    div [] [
            text "Todas as senhas"
        , div [] [
                    div []
        (List.map (\senha -> p [] [text (senha.codigo ++ " "++ senha.status)]) model.senhas)
                ]
    ]

viewEmAtendimento : Model -> Html Msg
viewEmAtendimento model =
    div [] [
            text "Em atendimento"
        , div [] [
                    div []
                        (List.map 
                            (\senha -> 
                                if senha.status == "EMATENDIMENTO" then
                                    p [] [text (senha.codigo ++ " "++ senha.status)]
                                else
                                    text ""
                            ) 
                            model.senhas)
                ]
    ]

viewultimasSenhas : Model -> Html Msg
viewultimasSenhas model =
    div [] [
            text "Senhas solicitadas"
        , div [] [
                    div []
                        (List.map 
                            (\senha -> 
                                if senha.status == "ENCAMINHADA" then
                                    p [] [text (senha.codigo ++ " "++ senha.status)]
                                else
                                    text ""
                            ) 
                            model.senhas)
                ]
    ]    

viewSenhasFinalizadas : Model -> Html Msg
viewSenhasFinalizadas model =
    div [] [
            text "Senhas finalizadas"
        , div [] [
                    div []
                        (List.map 
                            (\senha -> 
                                if senha.status == "FINALIZADA" then
                                    p [] [text (senha.codigo ++ " "++ senha.status)]
                                else
                                    text ""
                            ) 
                            model.senhas)
                ]
    ]  

---- COMMANDS ---    

getEntries : Cmd Msg
getEntries = 
    Http.get{
        url = "http://localhost:8080/senhas"
        ,expect = Http.expectJson NewEntries (Json.Decode.list senhaDecoder)}
---- SUBSCRPTIONS ----
subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 2000 Tick

---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = subscriptions
        }
