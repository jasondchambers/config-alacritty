#!/usr/bin/env sh

# Installation script for config-alacritty

omarchy_install() {
  # With Omarchy, it is possible to switch the theme so we just
  # need to point the theme.lua to whatever Omarchy is using
  echo "This is Arch Linux."
  if [ -f ~/.config/omarchy/current/theme/alacritty.toml ]; then
    echo "This is Omarchy"
  else
    echo "It looks like Omarchy has not been installed"
  fi
}

non_omarchy_install() {
  echo "I only use Alacritty on Omarchy for now - exiting"
  exit 1
}

point_alacritty_to_this_config() {
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
  else
    if [ -d ~/.config/alacritty ]; then
      echo "Alacritty config already exists - moving it to backup"
      mv ~/.config/alacritty{,.bak}
    fi
    echo "Linking Alacritty to this config"
    ln -s ~/repos/config-alacritty ~/.config/alacritty
  fi
}

main() {

  if [ -f alacritty.toml ]; then
    if [ -f /etc/arch-release ]; then
      omarchy_install
    else
      non_omarchy_install
    fi
    point_alacritty_to_this_config
  else
    echo "You need to run this script from within the config-alacritty directory"
  fi
}

main
