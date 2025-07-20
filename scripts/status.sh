#! /usr/bin/env bash

CURRENT_PANE_PATH=$(tmux display-message -p -F "#{pane_current_path}")
JSON_FILE="${CURRENT_PANE_PATH}/.devcontainer/devcontainer.json"
BASE_COMMAND="docker compose"

get_project_name() {
    local project_name=""

    if [[ -n "${COMPOSE_PROJECT_NAME}" ]]; then
        project_name=${COMPOSE_PROJECT_NAME}
    elif [[ "$(grep -e '^name:' ${JSON_FILE} | awk '{print $2}')" != "" ]]; then
        project_name=$(grep -i -e '^name:' ${JSON_FILE} | awk '{print $2}')
    else
        project_name="$(basename ${CURRENT_PANE_PATH})_devcontainer"
    fi

    echo "${project_name}"
}

get_compose_config() {
    local compose_file=$(grep -i -e 'dockerComposeFile' ${JSON_FILE} | awk '{print $2}' | sed -e 's/"\(.*\)",$/\1/' )

    if [[ -n "${compose_file}" ]]; then
        compose_file="${CURRENT_PANE_PATH}/.devcontainer/${compose_file}"
    fi

    echo "${compose_file}"
}

compose_status() {
    local -r compose_file="$1"
    local -r project_name="$2"
    local docker_status=""
    local docker_command=${BASE_COMMAND}

    if [[ -n "${project_name}" ]]; then
        docker_command="${docker_command} -p ${project_name}"
    fi

    if [[ -n "${compose_file}" ]]; then
        docker_command="${docker_command} -f ${compose_file}"
    fi

    docker_status=$(${docker_command} ps --all --format json | jq -r '. | "\(.Service):\(.State)"')
    
    if [[ -z "${docker_status}" ]]; then
        services=$(${docker_command} config --services)
        docker_status=""
        for service in ${services}
        do
            image=$(docker images | grep "${project_name}-${service}")
            if [[ -n "${image}" ]]; then
                docker_status="${docker_status} ${service}: built"
            else
                docker_status="${docker_status} ${service}: unknown"
            fi
        done
    fi

    echo "${docker_status}"
}

plain_status() {
    local docker_status=""

    project_name="$(basename ${CURRENT_PANE_PATH})"
    status=$(docker ps -a --format json | jq ". | select(.Image | contains(\"${project_name}\")) | .State" | sed -e 's/"//g')
    if [[ -n "${status}" ]]; then
        docker_status="${project_name}: ${status} "
    else
        image=$(docker images | grep "${project_name}")
        if [[ -n "${image}" ]]; then
            docker_status="${project_name}: built"
        else
            docker_status="${project_name}: unkown"
        fi
    fi

    echo "${docker_status}"
}

if [ -f "${JSON_FILE}" ]; then
    # Workspace has devcontainers
    # workspace_name=$(devcontainer read-configuration --workspace-folder . | jq ".configuration.name")
    # workspace_name=${workspace_name//\"/} # remove quotes
    compose_file=$(get_compose_config)
    project_name=$(get_project_name)

    if [[ -n "${compose_file}" ]]; then
        docker_status=$(compose_status "${compose_file}" "${project_name}")
    else
        docker_status=$(plain_status)
    fi

    echo ${docker_status}
else
    # Workspace does not have devcontainers
    echo "N/A"
fi
