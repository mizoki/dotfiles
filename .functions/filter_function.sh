#!/bin/sh

FILTER_CMD='fzf'
FILTER_OPT=' --ansi --reverse --cycle'
FILTER_OPT_MULTI=' --multi'
FILTER_OPT_QUERY=' --query'

function filter-git-repository {
  local selected_dir="$(ghq list --full-path | eval $FILTER_CMD$FILTER_OPT)"
  if [ -d "$selected_dir" ]; then
      cd "$selected_dir"
      zle accept-line
  fi
  zle clear-screen
}
zle -N filter-git-repository
bindkey '^g' filter-git-repository

function filter-dfind() {
    local current_buffer=$BUFFER
    # .git系など不可視フォルダは除外
    local selected_dir="$(find . -maxdepth 5 -type d ! -path "*/.*"| eval $FILTER_CMD$FILTER_OPT)"
    if [ -d "$selected_dir" ]; then
        BUFFER="${current_buffer} \"${selected_dir}\""
        CURSOR=$#BUFFER
        # ↓決定時にそのまま実行するなら
        zle accept-line
    fi
    zle clear-screen
}
zle -N filter-dfind
bindkey '^d^f' filter-dfind

# ex. git branch B
alias -g B='`git branch | $FILTER_CMD$FILTER_OPT | sed -e "s/^\*[ ]*//g"`'

function filter-select-history() {
  typeset tac
  if which tac > /dev/null; then
    tac=tac
  else
    tac='tail -r'
  fi
  BUFFER=$(fc -l -n 1 | eval $tac | eval $FILTER_CMD$FILTER_OPT$FILTER_OPT_QUERY="$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N filter-select-history
bindkey '^r' filter-select-history

function filter-pkill() {
  for pid in `ps aux | eval $FILTER_CMD$FILTER_OPT$FILTER_OPT_MULTI | awk '{ print $2 }'`
  do
    kill $pid
    echo "Killed ${pid}"
  done
}
alias pk="filter-pkill"

### filter でSSH & Mosh
function filter-remote() {
  for host in `echo $(grep -iE '^host[[:space:]]+[^*]' ~/.ssh/config | awk '{print $2}' | eval $FILTER_CMD$FILTER_OPT$FILTER_OPT_MULTI)`
  do
    $1 $host
    return
  done
}
zle -N filter-ssh

alias s='filter-remote ssh'
alias m='filter-remote mosh'

function filter-tmux() {
  local i=$(tmux lsw 2>/dev/null | awk '/active.$/ {print NR-1}')
  if [ -n "$i" ]; then
    local f='#{window_index}: #{window_name}#{window_flags} #{pane_current_path}'
    local w="$(tmux lsw -F "$f" | eval $FILTER_CMD$FILTER_OPT | awk -F : 'NR == 1 {print $1}')"
    if [ -n "$w" ]; then
      tmux select-window -t $w
    fi
  fi
}
zle -N filter-tmux
bindkey '^w' filter-tmux
