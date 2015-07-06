#!/usr/bin/env fish
set DOTFILES $HOME/.dotfiles

function nvim_config
  nvim +PlugInstall +qall
end

function symlinks
  mkdir -p "$HOME/.config/"
  ln -sf "$DOTFILES/fish" "$HOME/.config/fish"
  ln -sf "$DOTFILES/misc/latexmkrc" "$HOME/.latexmkrc"
  ln -sf "$DOTFILES/neovim/nvim" "$HOME/.nvim"
  ln -sf "$DOTFILES/neovim/nvimrc" "$HOME/.nvimrc"
  # XXX fix this bug
  rm $DOTFILES/fish/fish
  rm $DOTFILES/neovim/nvim/nvim
end

function chsh
  set FISH_PATH (which fish)
  if [ $SHELL != $FISH_PATH ]
    chsh -s $FISH_PATH
  end
end

function git_config
  git config --global push.default simple
  git config --global commit.template $DOTFILES/git/gitmessage
  git config --global core.editor (which nvim)
  git config --global core.excludesfile $DOTFILES/git/gitignore
  git submodule init
  git submodule update --init
end

if not type nvim > /dev/null ^&1
  echo "Please install nvim"
  exit 1
end

chsh
symlinks
git_config
nvim_config