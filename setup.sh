#!/bin/sh

ln -s $PWD/.zshrc $HOME/.zshrc
ln -s $PWD/.alias_common $HOME/.alias_common
ln -s $PWD/.functions_common $HOME/.functions_common

ln -s $PWD/.vimrc $HOME/.vimrc

mkdir $HOME/.alias

ln -s $PWD/.alias/git $HOME/.alias/git
ln -s $PWD/.alias/ruby $HOME/.alias/ruby

mkdir $HOME/.functions

ln -s $PWD/.functions/peco_function.sh $HOME/.functions/peco_function.sh
