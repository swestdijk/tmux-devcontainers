# Get Tmux option value, if not set, use default value
# checks for local, then global options
#
# Usage
# get_tmux_option <option> <default_value>
get_tmux_option() {
    local option
    local default_value
    local option_value
    option="$1"
    default_value="$2"
    option_value="$(tmux show-option -qv "$option")"

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

