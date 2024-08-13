#!/bin/sh
if [ -d "$XDG_CONFIG_HOME/nvim" ] && [ ! -d "$XDG_CONFIG_HOME/nvim.bak" ] ; then
  mv $XDG_CONFIG_HOME/nvim $XDG_CONFIG_HOME/nvim.bak
fi

if [ -d "$HOME/.local/share/nvim" ] && [ ! -d "$HOME/.local/share/nvim.bak" ] ; then
  mv ~/.local/share/nvim ~/.local/share/nvim.bak
fi

if [ -d "$HOME/.local/state/nvim" ] && [ ! -d "$HOME/.local/state/nvim.bak" ] ; then
  mv ~/.local/state/nvim ~/.local/state/nvim.bak
fi

if [ -d "$HOME/.cache/nvim" ] && [ ! -d "$HOME/.cache/nvim" ] ; then
  mv ~/.cache/nvim ~/.cache/nvim.bak
fi
