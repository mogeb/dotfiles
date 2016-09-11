#!/bin/bash

mv .bashrc .bashrc.old
ln -s git/dotfiles/bashrc .bashrc
[ -f .vimrc ] && mv .vimrc .vimrc.old
ln -s git/dotfiles/vimrc .vimrc
[ -d .vim ] && mv .vim .vim.old
ln -s git/dotfiles/vim .vim
ln -s git/dotfiles/git-completion.bash .git-completion.bash

