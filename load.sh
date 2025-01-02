#!/bin/bash

TARGET_BASHRC="$HOME/.bashrc"

SOURCE='
if [ -f ~/.config/.mybashrc ]; then
    . ~/.config/.mybashrc
fi
eval "$(starship init bash)"
eval "$(zoxide init bash)"
'

if ! command -v exa &>/dev/null; then
  echo "Exa is not installed. Installing..."
  sudo pacman -S exa
else
  echo "Exa is already installed."
fi

if ! command -v starship &>/dev/null; then
  echo "Starship is not installed. Installing..."
  curl -sS https://starship.rs/install.sh | sh
else
  echo "Starship is already installed."
fi

if [[ -f "$HOME/.config/starship.toml" ]]; then
  read -p "Starship config found, replace? [y/n]: " response
  if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    rm "$HOME/.config/starship.toml"
    cp starship.toml "$HOME/.config"
  fi
else
  cp starship.toml "$HOME/.config"
fi

if [[ -f "$HOME/.config/.mybashrc" ]]; then
  read -p "$HOME/.config/.mybashrc found, replace? [y/n]: " response
  if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    rm "$HOME/.config/.mybashrc"
    cp .mybashrc "$HOME/.config"
  fi
else
  cp .mybashrc "$HOME/.config"
fi

while IFS= read -r line; do
  if ! grep -Fq "$line" "$TARGET_BASHRC"; then
    echo "$SOURCE" >> "$TARGET_BASHRC"
    echo "Custom bashrc appended."
    exit 0
  fi
done <<< "$SOURCE"

echo "Custom bashrc appended already."
exit 0
