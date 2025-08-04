#! /usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

# Run devcontainer up command in a new tmux window
run_up() {
    tmux new-window -n "devcontainer_build" -c $(get_current_pane_path) "devcontainer up --workspace-folder ."; set-option remain-on-exit failed
}

# Run docker compose down command in a new tmux window
run_down() {
    tmux new-window -n "devcontainer_down" -c $(get_current_pane_path) "docker compose down"; set-option remain-on-exit failed
}

show_menu() {
    local project_name=$(get_devcontainer_config ".configuration.name")

    tmux display-menu -T " Devcontainers " \
        "" \
        "-Namespace: #[fg=white]${project_name}" "" "" \
        "" \
        "Up"                    u "run -b 'source $CURRENT_DIR/menu.sh && run_up'" \
        "Down (docker compose)" d "run -b 'source $CURRENT_DIR/menu.sh && run_down'" \
        "Exec in popup"         e "display-popup -EE 'devcontainer exec --workspace-folder . /bin/bash'" \
        "Exec in new window"    E "new-window 'devcontainer exec --workspace-folder . /bin/bash'" \
        "" \
        "-All commands work with the devcontainers cli," "" "" \
        "-except commands specified with 'docker compose'" "" ""
}
