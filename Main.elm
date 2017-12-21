module Main exposing (..)

import Html
import Css exposing (..)
import Css.Colors exposing (..)
import Json.Decode as Decode
import Html.Styled exposing (..)
import Html.Styled.Events exposing (on)
import Html.Styled.Attributes exposing (css, attribute)


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
    , tasks : List Task
    , dragging : Maybe Task
    }


type Msg
    = Drag Task
    | Drop TaskStatus


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


update : Msg -> Model -> Model
update msg model =
    case msg of
        Drag task ->
            Debug.log "task" { model | dragging = Just task }

        Drop taskStatus ->
            Debug.log "drop"
                { model
                    | dragging = Nothing
                    , tasks = switchBoard taskStatus model.tasks model.dragging
                }


board : List (Attribute msg) -> List (Html msg) -> Html msg
board =
    styled div
        [ displayFlex
        , flexDirection row
        , height (pct 100)
        ]


column : List (Attribute msg) -> List (Html msg) -> Html msg
column =
    styled ul
        [ flex (int 1)
        , padding (px 0)
        , margin (px 10)
        , width (px 270)
        , height (pct 100)
        , border3 (px 1) solid gray
        ]


taskList : List (Attribute Msg) -> List (Html Msg) -> Html Msg
taskList =
    styled ul
        [ padding (px 0)
        , margin (px 0)
        ]


task : List (Attribute msg) -> List (Html msg) -> Html msg
task =
    styled li
        [ border3 (px 1) solid black
        , padding (px 0)
        , margin (px 0)
        , listStyle none
        , cursor move
        ]


taskView : Task -> Html Msg
taskView taskModel =
    task
        [ attribute "data-task" ""
        , attribute "draggable" "true"
        , onDragStart <| Drag taskModel
        ]
        [ h3 []
            [ taskModel
                |> .title
                |> text
            ]
        ]


columnView : String -> TaskStatus -> List Task -> Html Msg
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
        , taskList [] (List.map taskView tasks)
        ]


filterTaskByStatus : TaskStatus -> List Task -> List Task
filterTaskByStatus status tasks =
    List.filter (\task -> task.status == status) tasks


view : Model -> Html Msg
view model =
    board []
        [ columnView "backlog" Backlog (filterTaskByStatus Backlog model.tasks)
        , columnView "in progress" InProgress (filterTaskByStatus InProgress model.tasks)
        , columnView "done" Done (filterTaskByStatus Done model.tasks)
        ]


onDragStart : Msg -> Attribute Msg
onDragStart msg =
    on "dragstart" (Decode.succeed msg)


onDrop : Msg -> Attribute Msg
onDrop msg =
    on "drop" (Decode.succeed msg)


model : Model
model =
    { currentId = 0
    , tasks =
        [ Task 1 "Hello World 1" Backlog
        , Task 2 "Hello World 2" InProgress
        , Task 3 "Hello World 3" Done
        ]
    , dragging = Nothing
    }


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = model
        , update = update
        , view = view >> toUnstyled
        }
