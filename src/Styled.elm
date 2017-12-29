module Styled exposing (..)

import Html.Styled exposing (Html, Attribute, styled, div, form, ul, li, input, button)
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
            [ backgroundColor (rgb 245 244 252)
            , margin (Css.rem 0.5)
            ]
        ]


typography : Style
typography =
    Css.batch
        [ fontFamilies [ "Lucida Grande", "Helvetica Neue", "sans-serif" ]
        , fontSize (px 14)
        , lineHeight (em 1.5)
        , fontWeight normal
        , color colors.text
        ]


board : List (Attribute msg) -> List (Html msg) -> Html msg
board =
    styled div
        [ typography
        , displayFlex
        , margin (Css.rem 0.5)
        , height (pct 100)
        ]


column : List (Attribute msg) -> List (Html msg) -> Html msg
column =
    styled div
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


closeButton : List (Attribute msg) -> List (Html msg) -> Html msg
closeButton =
    styled button []


inputTask : List (Attribute msg) -> List (Html msg) -> Html msg
inputTask =
    styled input
        [ flex (int 1)
        , border3 (px 1) solid colors.border
        , height (Css.rem 2)
        , padding2 (Css.rem 0) (Css.rem 0.5)
        , outline none
        ]


formBoard : List (Attribute msg) -> List (Html msg) -> Html msg
formBoard =
    styled form [ displayFlex ]
