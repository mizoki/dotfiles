#!/bin/sh

[ ! -s "$HOME/.zshrc" ] && ln -s $PWD/.zshrc $HOME/.zshrc
[ ! -s "$HOME/.alias_common" ] && ln -s $PWD/.alias_common $HOME/.alias_common
[ ! -s "$HOME/.functions_common" ] && ln -s $PWD/.functions_common $HOME/.functions_common
[ ! -s "$HOME/.zsh_completion_common" ] && ln -s $PWD/.zsh_completion_common $HOME/.zsh_completion_common

[ ! -s "$HOME/.gitignore" ] && ln -s $PWD/.gitignore_global $HOME/.gitignore

[ ! -s "$HOME/.vimrc" ] && ln -s $PWD/.vimrc $HOME/.vimrc
[ ! -s "$HOME/.gvimrc" ] && ln -s $PWD/.gvimrc $HOME/.gvimrc
[ ! -s "$HOME/.tigrc" ] && ln -s $PWD/.tigrc $HOME/.tigrc
[ ! -s "$HOME/.gemrc" ] && ln -s $PWD/.gemrc $HOME/.gemrc
[ ! -s "$HOME/.tmux.conf" ] && ln -s $PWD/.tmux.conf $HOME/.tmux.conf
[ ! -s "$HOME/.vimperatorrc" ] && ln -s $PWD/.vimperatorrc $HOME/.vimperatorrc
[ ! -s "$HOME/.pryrc" ] && ln -s $PWD/.pryrc $HOME/.pryrc

if [ ! -d "$HOME/.alias" ]; then
  mkdir $HOME/.alias
fi
[ ! -s "$HOME/.alias/git" ] && ln -s $PWD/.alias/git $HOME/.alias/git
[ ! -s "$HOME/.alias/ruby" ] && ln -s $PWD/.alias/ruby $HOME/.alias/ruby
if [ `uname` = 'Darwin' ]; then
  [ ! -s "$HOME/.alias/mac" ] && ln -s $PWD/.alias/mac $HOME/.alias/mac
fi
if [ `uname` = 'Linux' ]; then
  [ ! -s "$HOME/.alias/linux" ] && ln -s $PWD/.alias/linux $HOME/.alias/linux
fi

if [ ! -d "$HOME/.functions" ]; then
  mkdir $HOME/.functions
fi
[ ! -s "$HOME/.functions/peco_function.sh" ] && ln -s $PWD/.functions/peco_function.sh $HOME/.functions/peco_function.sh

[ ! -d "$HOME/local/bin" ] && mkdir -p $HOME/local/bin
[ ! -s "$HOME/local/bin/git-wip" ] && ln -s $PWD/git-subcommand/git-wip $HOME/local/bin/git-wip
[ ! -s "$HOME/local/bin/git-vi" ] && ln -s $PWD/git-subcommand/git-vi $HOME/local/bin/git-vi

if [ ! -d "$HOME/.peco" ]; then
  mkdir $HOME/.peco
fi
[ ! -s "$HOME/.peco/config.json" ] && ln -s $PWD/.peco/config.json $HOME/.peco/config.json

if [ ! -d "$HOME/.config/powerline" ]; then
  mkdir -p $HOME/.config/powerline
  ln -s $PWD/config/powerline/config.json $HOME/.config/powerline/config.json
fi

[ ! -d "$HOME/.config/powerline/themes/tmux" ] && mkdir -p $HOME/.config/powerline/themes/tmux
[ ! -s "$HOME/.config/powerline/themes/tmux/default.json" ] && ln -s $PWD/config/powerline/themes/tmux/default.json $HOME/.config/powerline/themes/tmux/default.json

[ ! -d "$HOME/.config/powerline/themes/vim" ] && mkdir -p $HOME/.config/powerline/themes/vim
for f in \
  __main__.json \
  cmdwin.json \
  default.json \
  help.json \
  plugin_commandt.json \
  plugin_gundo-preview.json \
  plugin_gundo.json \
  plugin_nerdtree.json \
  quickfix.json \
  tabline.json \

do
  [ ! -s "$HOME/.config/powerline/themes/vim/$f" ] && ln -s $PWD/config/powerline/themes/vim/$f $HOME/.config/powerline/themes/vim/$f
done

[ ! -d "$HOME/.config/powerline/themes/shell" ] && mkdir -p $HOME/.config/powerline/themes/shell
for f in \
  __main__.json \
  continuation.json \
  default.json \
  default_leftonly.json \
  select.json \

do
  [ ! -s "$HOME/.config/powerline/themes/shell/$f" ] && ln -s $PWD/config/powerline/themes/shell/$f $HOME/.config/powerline/themes/shell/$f
done

[ ! -d "$HOME/.w3m" ] && mkdir -p $HOME/.w3m
[ ! -s "$HOME/.w3m/keymap" ] && ln -s $PWD/.w3m/keymap $HOME/.w3m/keymap
