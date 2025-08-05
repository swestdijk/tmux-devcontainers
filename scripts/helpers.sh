log() {
    echo "$1" >&2
}


# Get Tmux option value, if not set, use default value
# checks for local, then global options
#
# Usage
# get_tmux_option <option> <default_value>
get_tmux_option() {
    local option="$1"
    local default_value="$2"
    local option_value="$(tmux show-option -qv "$option")"

    if [ -z "$option_value" ]; then
        option_value="$(tmux show-option -gqv "$option")"
    fi

    if [ -z "$option_value" ]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

# Set Tmux option value
#
# Usage
# set_tmux_option <option> <value>
set_tmux_option() {
    local option=$1
    local value=$2
    tmux set-option -gq "$option" "$value"
}

# Get the current pane's path
get_current_pane_path() {
    local current_pane_path=$(tmux display-message -p -F "#{pane_current_path}")
    echo "$current_pane_path"
}

# Get devcontainer configuration value from the current pane's devcontainer.json
# expects the key_path to be a valid jq path
#
# Usage
# get_devcontainer_config <key_path>
# Example: get_devcontainer_config ".configuration.name"
get_devcontainer_config() {
    local key_path="$1"
    local current_pane_path=$(tmux display-message -p -F "#{pane_current_path}")
    local devcontainer_json_file="${current_pane_path}/.devcontainer/devcontainer.json"
    local json=$(devcontainer read-configuration --workspace-folder "${current_pane_path}" 2>/dev/null)
    local value=$(echo "$json" | jq -r "${key_path}")

    echo "$value"
}

