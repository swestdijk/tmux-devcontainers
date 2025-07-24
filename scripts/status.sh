#! /usr/bin/env bash

#####################################################################
#
# Globals
#
#####################################################################
CURRENT_PANE_PATH=$(tmux display-message -p -F "#{pane_current_path}")
JSON_FILE="${CURRENT_PANE_PATH}/.devcontainer/devcontainer.json"
BASE_COMMAND="docker compose"

#####################################################################
#
# get_project_name
#
# Try to get the project name for devcontainers with or whithout
# docker compose
#
#####################################################################
get_project_name() {
    local -r compose_file="$1"
    local project_name=""

    if [[ -n "${COMPOSE_PROJECT_NAME}" ]]; then
        project_name=${COMPOSE_PROJECT_NAME}
    elif [[ -z "${compose_file}" ]]; then
        project_name=$(devcontainer read-configuration --workspace-folder "${CURRENT_PANE_PATH}" 2>/dev/null | jq -r '.configuration.name')
    fi

    if [[ -z "${project_name}" ]] || [[ "${project_name}" == "null" ]]; then
        if [[ -n "${compose_file}" ]]; then
            project_name="${CURRENT_PANE_PATH##*/}_devcontainer"
        else
            project_name="${CURRENT_PANE_PATH##*/}"
        fi
    fi

    echo "${project_name}"
}

#####################################################################
#
# get_compose_config
#
# Try to get the the docker compose file
#
#####################################################################
get_compose_config() {
    local compose_file=""
    compose_file=$(grep -i -e 'dockerComposeFile' "${JSON_FILE}")
    compose_file=$(tmp=${compose_file##* }; tmp=${tmp//\"/}; echo "${tmp/,/}")

    if [[ -n "${compose_file}" ]]; then
        compose_file="${CURRENT_PANE_PATH}/.devcontainer/${compose_file}"
    fi

    echo "${compose_file}"
}

#####################################################################
#
# get_docker_config
#
# Try to get the the Dockerfile
#
#####################################################################
get_docker_config() {
    local docker_file=""
    docker_file=$(grep -i -e 'dockerFile' "${JSON_FILE}")
    docker_file=$(tmp=${docker_file##* }; tmp=${tmp//\"/}; echo "${tmp/,/}")

    if [[ -n "${docker_file}" ]]; then
        docker_file="${CURRENT_PANE_PATH}/.devcontainer/${compose_file}"
    fi

    echo "${docker_file}"
}

#####################################################################
#
# compose_status
#
# return devcontainer status when using docker compose
#
#####################################################################
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
            image=$(docker images -q --filter reference="*${project_name}-${service}*:*")
            if [[ -n "${image}" ]]; then
                docker_status="${docker_status} ${service}: built"
            else
                docker_status="${docker_status} ${service}: unknown"
            fi
        done
    fi

    echo "${docker_status}"
}

#####################################################################
#
# plain_status
#
# return devcontainer status when using a Dockerfile or none
#
#####################################################################
plain_status() {
    local -r project_name="$1"
    local docker_status=""

    status=$(docker ps -a --format json | jq -r ". | select(.Names | contains(\"${project_name}\")) | .State")
    if [[ -z "${status}" ]]; then
        status=$(docker ps -all --format json | jq -r ". | select(.Image | contains(\"${project_name}\")) | .State")
    fi

    if [[ -n "${status}" ]]; then
        docker_status="${project_name}: ${status} "
    else
        #image=$(docker images -q --filter reference="*${project_name}*:*")
        image=$(docker images -a | grep -E ".*(${CURRENT_PANE_PATH##*/}|${project_name}).*")
        if [[ -n "${image}" ]]; then
            docker_status="${project_name}: built"
        else
            docker_status="${project_name}: unkown"
        fi
    fi

    echo "${docker_status}"
}

#####################################################################
#
# Main code
#
#####################################################################
if [ -f "${JSON_FILE}" ]; then
    compose_file=$(get_compose_config)
    docker_file=$(get_docker_config)
    project_name=$(get_project_name "${compose_file}")

    if [[ -n "${compose_file}" ]]; then
        docker_status=$(compose_status "${compose_file}" "${project_name}")
    else
        docker_status=$(plain_status "${project_name}")
    fi

    # shellcheck disable=SC2086
    echo ${docker_status}
else
    # Workspace does not have devcontainers
    echo "N/A"
fi
