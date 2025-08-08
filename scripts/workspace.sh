#! /usr/bin/env bash

#####################################################################
#
# Globals
#
#####################################################################
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

echo $(get_devcontainer_config ".configuration.name")
