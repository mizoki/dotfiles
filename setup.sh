#!/bin/sh

[ ! -s "$HOME/.zshrc" ] && ln -s $PWD/.zshrc $HOME/.zshrc
[ ! -s "$HOME/.alias_common" ] && ln -s $PWD/.alias_common $HOME/.alias_common
[ ! -s "$HOME/.functions_common" ] && ln -s $PWD/.functions_common $HOME/.functions_common

[ ! -s "$HOME/.vimrc" ] && ln -s $PWD/.vimrc $HOME/.vimrc
[ ! -s "$HOME/.tigrc" ] && ln -s $PWD/.tigrc $HOME/.tigrc
[ ! -s "$HOME/.gemrc" ] && ln -s $PWD/.gemrc $HOME/.gemrc
[ ! -s "$HOME/.tmux.conf" ] && ln -s $PWD/.tmux.conf $HOME/.tmux.conf
[ ! -s "$HOME/.vimperatorrc" ] && ln -s $PWD/.vimperatorrc $HOME/.vimperatorrc

if [ ! -d "$HOME/.alias" ]; then
  mkdir $HOME/.alias
  ln -s $PWD/.alias/git $HOME/.alias/git
  ln -s $PWD/.alias/ruby $HOME/.alias/ruby
fi

if [ ! -d "$HOME/.functions" ]; then
  mkdir $HOME/.functions
  ln -s $PWD/.functions/peco_function.sh $HOME/.functions/peco_function.sh
fi

if [ ! -d "$HOME/.peco" ]; then
  mkdir $HOME/.peco
  ln -s $PWD/.peco/config.json $HOME/.peco/config.json
fi
