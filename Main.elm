module Main exposing (..)

import Css exposing (..)
import Css.Colors exposing (..)
import Html exposing (programWithFlags)
import Json.Decode as Decode
import Html.Styled exposing (..)
import Html.Styled.Events exposing (on)
import Html.Styled.Attributes exposing (css, attribute)
import Uuid exposing (Uuid, uuidGenerator)
import Random.Pcg exposing (Seed, initialSeed, step)


type TaskStatus
    = Backlog
    | InProgress
    | Done


type alias Task =
    { id : Uuid
    , title : String
    , status : TaskStatus
    }


type alias Model =
    { currentSeed : Seed
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


board =
    styled div
        [ displayFlex
        , flexDirection row
        , height (pct 100)
        ]


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


createUuid currentSeed =
    let
        ( uuid, seed ) =
            step Uuid.uuidGenerator currentSeed
    in
        uuid


model =
    { currentSeed = initialSeed 1
    , tasks = []
    , dragging = Nothing
    }


main =
    programWithFlags
        { init = ( model, Cmd.none )
        , update = update
        , view = view >> toUnstyled
        , subscriptions = \_ -> Sub.none
        }
