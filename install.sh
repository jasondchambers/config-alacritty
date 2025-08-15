#!/usr/bin/env sh

# Installation script for config-alacritty

point_alacritty_to_this_config() {
  config_file=$1
  echo "Pointing alacritty to this config"
  if [ -L ~/.config/alacritty ]; then
    echo "Alacritty config already set - verifying it points to this config"
    local actual_resolved_path
    actual_resolved_path=$(readlink -f ~/.config/alacritty)
    if [ "$actual_resolved_path" = "$(pwd)" ]; then
      echo "Alacritty is already pointing to this config"
    else
      echo "Alacritty is pointing to another config: ${actual_resolved_path}"
      exit 1
    fi
    if [ -L alacritty.toml ]; then
      rm alacritty.toml
    fi
    ln -s ${config_file} alacritty.toml
  else
    if [ -d ~/.config/alacritty ]; then
      echo "Alacritty config already exists - moving it to backup"
      mv ~/.config/alacritty{,.bak}
    fi
    echo "Linking Alacritty to this config"
    ln -s $(pwd) ~/.config/alacritty
  fi
}

main() {

  if [ -f alacritty.toml.omarchy ]; then
    if [ -f /etc/arch-release ]; then
      if [ -f ~/.config/omarchy/current/theme/alacritty.toml ]; then
        echo "Installing for Omarchy"
        point_alacritty_to_this_config alacritty.toml.omarchy
      fi
    else
      echo "Installing for macOS"
      point_alacritty_to_this_config alacritty.toml.macos
    fi
  else
    echo "You need to run this script from within the config-alacritty directory"
  fi
}

main
