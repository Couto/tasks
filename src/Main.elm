module Main exposing (..)

import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (attribute, value, type_, placeholder)
import Html.Styled.Events exposing (on, onInput, onSubmit, onClick)
import Json.Decode as Decode
import Styled exposing (..)


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
    | Create
    | InputChange String
    | Delete Task


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

        Create ->
            { model
                | currentId = model.currentId + 1
                , tasks =
                    if String.length model.currentTask > 0 then
                        Task model.currentId model.currentTask Backlog :: model.tasks
                    else
                        model.tasks
                , currentTask = ""
            }

        Delete task ->
            { model | tasks = List.filter (\t -> t /= task) model.tasks }


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
        div []
            [ globalStyle
            , formBoard [ onSubmit Create ]
                [ inputTask
                    [ onInput InputChange
                    , value model.currentTask
                    , placeholder "What needs to be done?"
                    ]
                    []
                , input [ type_ "submit", value "Create Task" ] []
                ]
            , board []
                [ columnView Backlog (List.map taskView backlogTasks)
                , columnView InProgress (List.map taskView inProgressTasks)
                , columnView Done (List.map taskView doneTasks)
                ]
            ]


taskView : Task -> Html Msg
taskView taskModel =
    task
        [ attribute "data-task" (toString taskModel.id)
        , attribute "draggable" "true"
        , onDragStart <| Drag taskModel
        ]
        [ closeButton [ onClick (Delete taskModel) ] [ text "Delete task" ]
        , p [] [ text taskModel.title ]
        ]


columnView : TaskStatus -> List (Html Msg) -> Html Msg
columnView status tasks =
    column
        [ attribute "ondragover" "return false", onDrop <| Drop status ]
        [ tasks
            |> List.length
            |> toString
            |> text
        , text " Task(s)"
        , taskList [] tasks
        ]


onDragStart : Msg -> Attribute Msg
onDragStart msg =
    on "dragstart" (Decode.succeed msg)


onDrop : Msg -> Attribute Msg
onDrop msg =
    on "drop" (Decode.succeed msg)
