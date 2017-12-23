module Styled exposing (..)

import Html.Styled exposing (Html, Attribute, styled, div, form, ul, li, input)
import Css exposing (..)
import Css.Colors exposing (..)
import Css.Foreign exposing (global, body)


colors : { titles : Color, text : Color, border : Color }
colors =
    { titles = rgb 93 99 107
    , text = rgb 190 191 201
    , border = rgb 215 213 228
    }


globalStyle : Html msg
globalStyle =
    global
        [ body
            [ backgroundColor (rgb 245 244 252) ]
        ]


typography : Style
typography =
    Css.batch
        [ fontFamilies [ "Lucida Grande", "Helvetica Neue", "sans-serif" ]
        , fontSize (px 14)
        , fontWeight normal
        , color colors.text
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
        , borderRight3 (px 1) solid colors.border
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
        , backgroundColor white
        , boxShadow4 (px 0) (px 1) (px 3) (rgb 233 230 255)
        , border3 (px 1) solid (colors.border)
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
