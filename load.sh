#!/bin/bash

TARGET_BASHRC="$HOME/.bashrc"

SOURCE='if [ -f ~/.config/.mybashrc ]; then
    . ~/.config/.mybashrc
fi
'

if [[ -f "$HOME/.config/.mybashrc" ]]; then
  read -p "$HOME/.config/.mybashrc found, replace? [y/n]: " response
  if ! [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    echo "Ok, goodbye!"
    exit 1
  fi
  rm "$HOME/.config/.mybashrc"
fi

cp .mybashrc ~/.config

if grep -Fq "$SOURCE" "$TARGET_BASHRC"; then
  echo "Custom bashrc sourced already."
  exit 1
fi

echo "$SOURCE" >>"$TARGET_BASHRC"
echo "Custom bashrc appended."
exit 0
