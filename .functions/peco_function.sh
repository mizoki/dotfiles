function peco-git-repository {
  #local current_buffer=$BUFFER
  local selected_dir="$(ghq list --full-path | peco)"
  if [ -d "$selected_dir" ]; then
      #BUFFER="${current_buffer} \"${selected_dir}\""
      #CURSOR=$#BUFFER
      cd "$selected_dir"
      zle accept-line
  fi
  zle clear-screen
}
zle -N peco-git-repository
bindkey '^g' peco-git-repository

function peco-dfind() {
    local current_buffer=$BUFFER
    # .git系など不可視フォルダは除外
    local selected_dir="$(find . -maxdepth 5 -type d ! -path "*/.*"| peco)"
    if [ -d "$selected_dir" ]; then
        BUFFER="${current_buffer} \"${selected_dir}\""
        CURSOR=$#BUFFER
        # ↓決定時にそのまま実行するなら
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-dfind
bindkey '^d^f' peco-dfind

# ex. git branch B
alias -g B='`git branch | peco | sed -e "s/^\*[ ]*//g"`'

function peco-select-history() {
  typeset tac
  if which tac > /dev/null; then
    tac=tac
  else
    tac='tail -r'
  fi
  BUFFER=$(fc -l -n 1 | eval $tac | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N peco-select-history
bindkey '^r' peco-select-history

function peco-pkill() {
  for pid in `ps aux | peco | awk '{ print $2 }'`
  do
    kill $pid
    echo "Killed ${pid}"
  done
}
alias pk="peco-pkill"

### peco でSSH & Mosh
alias s='ssh $(grep -iE "^host[[:space:]]+[^*]" ~/.ssh/config|peco|awk "{print \$2}")'
alias m='mosh $(grep -iE "^host[[:space:]]+[^*]" ~/.ssh/config|peco|awk "{print \$2}")'
