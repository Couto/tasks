module Styled exposing (..)

import Html.Styled exposing (Html, Attribute, styled, div, form, ul, li, input)
import Css exposing (..)
import Css.Colors exposing (..)


typography : Style
typography =
    Css.batch
        [ fontFamilies [ "Lucida Grande", "Helvetica Neue", "sans-serif" ]
        , fontSize (px 14)
        , fontWeight normal
        , color (hex "333")
        ]


board : List (Attribute msg) -> List (Html msg) -> Html msg
board =
    styled div
        [ typography
        , displayFlex
        , height (pct 100)
        ]


column : List (Attribute msg) -> List (Html msg) -> Html msg
column =
    styled ul
        [ flex (int 1)
        , padding (px 0)
        , border3 (px 1) solid (hex "eee")
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
        [ typography
        , border3 (px 1) solid (hex "eee")
        , borderRadius (px 4)
        , margin2 (Css.rem 0.5) (Css.rem 1)
        , padding2 (Css.rem 0.5) (Css.rem 1)
        , listStyle none
        , cursor move
        ]


inputTask : List (Attribute msg) -> List (Html msg) -> Html msg
inputTask =
    styled input
        [ border3 (px 1) solid purple ]


formBoard : List (Attribute msg) -> List (Html msg) -> Html msg
formBoard =
    styled form []
