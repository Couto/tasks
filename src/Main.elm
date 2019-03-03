module Main exposing (main)

import Browser
import Element exposing (..)
import Element.Border as Border exposing (..)
import Element.Input as Input exposing (..)
import Html exposing (Html)
import Prng.Uuid as Uuid
import Random.Pcg.Extended exposing (Seed, initialSeed, step)


main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


type alias Task =
    { text : String
    , author : String
    , status : TaskStatus
    }


type TaskStatus
    = Backlog
    | InProgress
    | Done


type alias Model =
    { tasks : List Task
    , createTaskInputText : String
    }


filterTasks : TaskStatus -> List Task -> List Task
filterTasks status tasks =
    List.filter (\task -> task.status == status) tasks


type Msg
    = CreateTask
    | CreateTaskInputChanged String


update : Msg -> Model -> Model
update msg model =
    case msg of
        CreateTaskInputChanged text ->
            { model | createTaskInputText = text }

        CreateTask ->
            { model
                | tasks =
                    Task model.createTaskInputText
                        "Tyler Durden"
                        Backlog
                        :: model.tasks
                , createTaskInputText = ""
            }


viewCreateTask : Model -> Element Msg
viewCreateTask model =
    Element.row [ Element.width fill, spacing 10 ]
        [ Input.text []
            { onChange = CreateTaskInputChanged
            , text = model.createTaskInputText
            , placeholder = Just (Input.placeholder [] (Element.text "Create a task"))
            , label = Input.labelHidden "label"
            }
        , Input.button []
            { onPress = Just CreateTask
            , label = Element.text "submit"
            }
        ]


viewTask : Task -> Element Msg
viewTask task =
    task.text
        |> Element.text
        |> List.singleton
        |> Element.paragraph []
        |> Element.el
            [ Element.width fill
            , spacing 10
            ]


viewColumn : List Task -> Element Msg
viewColumn tasks =
    tasks
        |> List.map viewTask
        |> column
            [ Element.width fill
            , height fill
            , Border.color (rgb 0 0 0)
            , Border.widthEach
                { top = 0
                , right = 1
                , bottom = 0
                , left = 0
                }
            ]


view : Model -> Html Msg
view model =
    Element.layout [] <|
        column [ Element.width fill, height fill, spacing 10 ]
            [ viewCreateTask model
            , row [ Element.width fill, height fill ]
                [ viewColumn (filterTasks Backlog model.tasks)
                , viewColumn (filterTasks InProgress model.tasks)
                , viewColumn (filterTasks Done model.tasks)
                ]
            ]


init : Model
init =
    { tasks = [], createTaskInputText = "" }
