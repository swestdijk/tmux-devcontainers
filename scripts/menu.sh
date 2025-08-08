#! /usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

# Run devcontainer up command in a new tmux window
run_up() {
    tmux display-message "Starting devcontainer..."
    tmux new-window -n "devcontainer_build" -c "$(get_workspace_dir)" "tmux set-option remain-on-exit failed; devcontainer up --workspace-folder ."
}

# tmux new-window -c "your-directory" "your-command; tmux set-option -t $TMUX_PANE remain-on-exit off"

# Run docker compose down command in a new tmux window
run_down() {
    tmux display-message "Stopping devcontainer..."
    tmux new-window -n "devcontainer_down" -c "$(get_workspace_dir)" "tmux set-option remain-on-exit failed; docker compose down"
}

run_rebuild() {
    tmux display-message "Rebuilding devcontainer..."
    run_down
    run_up
}

show_menu() {
    local project_name=$(get_devcontainer_config ".configuration.name")

    tmux display-menu -T " Devcontainers " \
        "" \
        "-Workspace: #[fg=white]${project_name}" "" "" \
        "" \
        "Up"                    u "run -b 'source $CURRENT_DIR/menu.sh && run_up'" \
        "Down (docker compose)" d "run -b 'source $CURRENT_DIR/menu.sh && run_down'" \
        "ReBuild"               r "run -b 'source $CURRENT_DIR/menu.sh && run_rebuild'" \
        "Exec in popup"         e "display-popup -EE 'devcontainer exec --workspace-folder $(get_workspace_dir) /bin/bash'" \
        "Exec in new window"    E "new-window 'devcontainer exec --workspace-folder $(get_workspace_dir) /bin/bash'" \
        "" \
        "-All commands work with the devcontainers cli," "" "" \
        "-except commands specified with 'docker compose'" "" "" \
        "-Exec commands assume bash is available in the container" "" ""
}
