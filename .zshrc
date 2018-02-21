# 環境変数の設定

export LANG="ja_JP.UTF-8"
export LANGUAGE="ja_JP"
export LC_ALL="ja_JP.UTF-8"

##### zsh の設定 #####

#プロンプトの設定
PROMPT="%n%% "
#RPROMPT="[%~]"
setopt transient_rprompt

# 色を使用出来るようにする
# ${fg[...]} や $reset_color をロード
autoload -U colors; colors

# gitのブランチの情報を表示
autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null

function rprompt-git-current-branch {
  local name st color gitdir action cntbranch cntallbranch
  if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
    return
  fi

  name=`git rev-parse --abbrev-ref=loose HEAD 2> /dev/null`
  if [[ -z $name ]]; then
    return
  fi

  gitdir=`git rev-parse --git-dir 2> /dev/null`
  action=`VCS_INFO_git_getaction "$gitdir"` && action="($action)"

  if [[ -e "$gitdir/rprompt-nostatus" ]]; then
    echo "[$name$action]"
    return
  fi

  st=`git status 2> /dev/null`
  if [[ "$st" =~ "(?m)^nothing to" ]]; then
    color=%F{green}
  elif [[ "$st" =~ "(?m)^nothing added" ]]; then
    color=%F{yellow}
  elif [[ "$st" =~ "(?m)^# Untracked" ]]; then
    color=%B%F{red}
  else
    color=%F{red}
  fi

  cntbranch=`git log --oneline --no-merges | wc -l | tr -d ' ' 2> /dev/null`
  cntallbranch=`git log --oneline --all --no-merges | wc -l | tr -d ' ' 2> /dev/null`

  echo "[$color$name$action%f%b : $cntbranch($cntallbranch)]"
}

# PCRE 互換の正規表現を使う
setopt re_match_pcre

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

RPROMPT='`rprompt-git-current-branch`[%~][${HOST}]'

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# set emacs keybinding
bindkey -e

# history search
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /opt/local/bin/ /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# 2つ以上、候補があるときにメニュー選択モードに切り替える
zstyle ':completion:*:default' menu select=2

# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# cd を入力しなくてもディレクトリを移動する
setopt auto_cd
# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# = の後はパス名として補完する
setopt magic_equal_subst

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# ヒストリファイルに保存するとき、すでに重複したコマンドがあったら古い方を削除する
setopt hist_save_nodups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 補完候補が複数あるときに自動的に一覧表示する
setopt auto_menu

# 高機能なワイルドカード展開を使用する
setopt extended_glob

# 補完時に濁点・半濁点を <3099> <309a> のように表示させない
setopt COMBINING_CHARS

# Disable stop and restart of terminal output
stty stop undef
stty start undef

# エイリアスの読み込み
[[ -s "$HOME/.alias_common" ]] && source $HOME/.alias_common

# 関数の読み込み
[[ -s "$HOME/.functions_common" ]] && source $HOME/.functions_common

# サブコマンドの補完
[[ -s "$HOME/.zsh_completion_common" ]] && source $HOME/.zsh_completion_common

# Powerline (Mac OSX)
[[ -s "/usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh" ]] && source "/usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh"
# Powerline (Arch Linux)
[[ -s "/usr/lib/python3.4/site-packages/powerline/bindings/zsh/powerline.zsh" ]] && source "/usr/lib/python3.4/site-packages/powerline/bindings/zsh/powerline.zsh"

# PATHの重複項目を削除して、PATHの長さ順に並び替える
export PATH=`echo $PATH | tr ':' '\n' | awk '{print length($0), $0}' | sort -nr | uniq | cut -d' ' -f2- | paste -d: -s -`
