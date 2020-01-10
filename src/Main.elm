module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode exposing (fail, list, string, succeed)
import Json.Decode.Pipeline exposing (required)
import Time



---- MODEL ----


type alias Model =
    { senhas : List Senha }


type alias Senha =
    { codigo : String, status : Estado }


type Estado
    = Emitida
    | Encaminhada
    | EmAtendimento
    | Finalizada


senhaDecoder : Json.Decode.Decoder Senha
senhaDecoder =
    Json.Decode.succeed Senha
        |> Json.Decode.Pipeline.required "codigo" string
        |> Json.Decode.Pipeline.required "status" statusDecoder


statusDecoder : Json.Decode.Decoder Estado
statusDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\str ->
                case str of
                    "EMITIDA" ->
                        Json.Decode.succeed Emitida

                    "ENCAMINHADA" ->
                        Json.Decode.succeed Encaminhada

                    "EMATENDIMENTO" ->
                        Json.Decode.succeed EmAtendimento

                    "FINALIZADA" ->
                        Json.Decode.succeed Finalizada

                    _ ->
                        Json.Decode.fail "Nao consegui decodar a senha"
            )


init : ( Model, Cmd Msg )
init =
    ( { senhas = [] }, getEntries )



---- UPDATE ----


type Msg
    = NewEntries (Result Http.Error (List Senha))
    | Tick Time.Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewEntries (Ok jsonString) ->
            let
                _ =
                    Debug.log "It worked! " jsonString
            in
            ( { model | senhas = jsonString }, Cmd.none )

        NewEntries (Err error) ->
            let
                _ =
                    Debug.log "Oops, not as we wished! " error
            in
            ( model, Cmd.none )

        Tick _ ->
            ( model, getEntries )



---- VIEW ----


view : Model -> Html Msg
view model =
    div [ class "columns" ]
        [ div [ class "column is-one-third" ] <| viewSenha model Emitida "Senhas emitidas" :: []
        , div [ class "column is-one-third" ] <| viewSenha model Encaminhada "Dirigir-se ao balcao" :: []
        , div [ class "column is-one-third" ] <| viewSenha model EmAtendimento "Senhas em atendimento" :: []
        ]


viewSenha : Model -> Estado -> String -> Html Msg
viewSenha model estado texto =
    div []
        [ text texto
        , div []
            [ div []
                (List.map
                    (\senha ->
                        if senha.status == estado then
                            p [] [ text senha.codigo ]

                        else
                            text ""
                    )
                    model.senhas
                )
            ]
        ]



---- COMMANDS ---


getEntries : Cmd Msg
getEntries =
    Http.get
        { url = "http://localhost:8080/senhas"
        , expect = Http.expectJson NewEntries (Json.Decode.list senhaDecoder)
        }



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
