module Styled exposing (..)

import Html.Styled exposing (..)
import Css exposing (..)
import Css.Colors exposing (..)


board : List (Attribute msg) -> List (Html msg) -> Html msg
board =
    styled div
        [ displayFlex
        , height (pct 100)
        ]


formBoard : List (Attribute msg) -> List (Html msg) -> Html msg
formBoard =
    styled form [ height (pct 100) ]


column : List (Attribute msg) -> List (Html msg) -> Html msg
column =
    styled ul
        [ flex (int 1)
        , padding (px 0)
        , margin (px 10)
        , width (px 270)
        , border3 (px 1) solid gray
        ]


taskList : List (Attribute msg) -> List (Html msg) -> Html msg
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


inputTask : List (Attribute msg) -> List (Html msg) -> Html msg
inputTask =
    styled input
        [ border3 (px 1) solid purple ]
