module Main exposing (..)

import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (attribute, value, type_, placeholder)
import Html.Styled.Events exposing (on, onInput, onSubmit)
import Json.Decode as Decode
import Styled exposing (board, column, taskList, task, inputTask, formBoard)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = model
        , update = update
        , view = view >> toUnstyled
        }



-- MODEL


type TaskStatus
    = Backlog
    | InProgress
    | Done


type alias Task =
    { id : Int
    , title : String
    , status : TaskStatus
    }


type alias Model =
    { currentId : Int
    , currentTask : String
    , tasks : List Task
    , dragging : Maybe Task
    }


model : Model
model =
    { currentId = 0
    , currentTask = ""
    , tasks = []
    , dragging = Nothing
    }



-- UPDATE


type Msg
    = Drag Task
    | Drop TaskStatus
    | CreateTask
    | InputChange String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Drag task ->
            { model | dragging = Just task }

        Drop taskStatus ->
            { model
                | dragging = Nothing
                , tasks = switchBoard taskStatus model.tasks model.dragging
            }

        InputChange title ->
            { model | currentTask = title }

        CreateTask ->
            { model
                | currentId = model.currentId + 1
                , tasks = Task model.currentId model.currentTask Backlog :: model.tasks
                , currentTask = ""
            }


switchBoard : TaskStatus -> List Task -> Maybe Task -> List Task
switchBoard newStatus tasks desiredTask =
    List.map
        (\task ->
            case desiredTask of
                Just dtask ->
                    if task.id == dtask.id then
                        { dtask | status = newStatus }
                    else
                        task

                _ ->
                    task
        )
        tasks



-- VIEW


view : Model -> Html Msg
view model =
    let
        filterTasks status tasks =
            List.filter (\task -> task.status == status) tasks

        backlogTasks =
            filterTasks Backlog model.tasks

        inProgressTasks =
            filterTasks InProgress model.tasks

        doneTasks =
            filterTasks Done model.tasks
    in
        formBoard [ onSubmit CreateTask ]
            [ inputTask
                [ onInput InputChange
                , value model.currentTask
                , placeholder "Create a task"
                ]
                []
            , input [ type_ "button" ] [ text "Create Task" ]
            , board []
                [ columnView "backlog" Backlog (List.map taskView backlogTasks)
                , columnView "in progress" InProgress (List.map taskView inProgressTasks)
                , columnView "done" Done (List.map taskView doneTasks)
                ]
            ]


taskView : Task -> Html Msg
taskView taskModel =
    task
        [ attribute "data-task" (toString taskModel.id)
        , attribute "draggable" "true"
        , onDragStart <| Drag taskModel
        ]
        [ h3 []
            [ taskModel
                |> .title
                |> text
            ]
        ]


columnView : String -> TaskStatus -> List (Html Msg) -> Html Msg
columnView name status tasks =
    column
        [ attribute "data-column" name
        , attribute "ondragover" "return false"
        , onDrop <| Drop status
        ]
        [ header []
            [ text name
            , tasks
                |> List.length
                |> toString
                |> text
            ]
        , taskList [] tasks
        ]


onDragStart : Msg -> Attribute Msg
onDragStart msg =
    on "dragstart" (Decode.succeed msg)


onDrop : Msg -> Attribute Msg
onDrop msg =
    on "drop" (Decode.succeed msg)
