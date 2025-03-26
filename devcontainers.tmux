#! /usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"

devcontainer_output="FOOBAR"

# interpolation format string for replacement
devcontainer_interpolation="\#{devcontainer_status}"

do_interpolation() {
  local output="$1"
  local output="${output/$devcontainer_interpolation/$devcontainer_output}"
  echo "$output"
}

update_tmux_devcontainers() {
  local option="$1"
  local option_value="$(get_tmux_option "$option")"
  local new_option_value="$(do_interpolation "$option_value")"
  set_tmux_option "$option" "$new_option_value"
}

main() {
  update_tmux_devcontainers "status-right"
  update_tmux_devcontainers "status-left"
}

main
