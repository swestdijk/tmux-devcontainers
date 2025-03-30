#! /usr/bin/env bash

if [ -f ./.devcontainer/devcontainer.json ]; then
    # Workspace has devcontainers
    # workspace_name=$(devcontainer read-configuration --workspace-folder . | jq ".configuration.name")
    # workspace_name=${workspace_name//\"/} # remove quotes

    echo $(docker compose ps --format json | jq -r '. | "\(.Service):\(.State)"')
else
    # Workspace does not have devcontainers
    echo "N/A"
fi
