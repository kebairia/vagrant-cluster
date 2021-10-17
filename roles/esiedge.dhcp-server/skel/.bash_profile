#!/bin/bash
# Profile file. Runs on login.

# Adds `~/bin` and all subdirectories to $PATH
export PATH="$PATH:$HOME/bin"
export PAGER="less"
export EDITOR="vim"

# less/man colors
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;34m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[38;5;215m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[4;35m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

#[[ -f ~/.bashrc ]] && . ~/.bashrc
