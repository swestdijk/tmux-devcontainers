# tmux-devcontainers
A Tmux plugin for working with [devcontainers](https://containers.dev)

## Features

- Status bar placeholder to show the status of the devcontainers for the current workspace.
- Key binding to create a new login shell in the devcontainer (via devcontainer exec).

### Status bar integration

tmux-devcontainers provides a status bar placeholder to show the status of the devcontainers from your docker-compose file:

```bash
set -g status-right '#{devcontainers_status}'
```

### Key bindings

tmux-devcontainers provides a key bindings to interact with the devcontainers:
- prefix + E: creates a new tmux pane with a login shell in the devcontainer.

## Installation

### Pre-requisites

- docker (version 28 or later)
- [devcontainer CLI](https://github.com/devcontainers/cli)
- [jq](https://jqlang.org)

### Using Tmux Plugin Manager (TPM)

Add the following line to your `~/.tmux.conf` file:

```bash
set -g @plugin 'phil/tmux-devcontainers'
```

## About

This plugin is a work in progress and reflects my personal development environment. It is assumed that you are using a devcontainer setup with a root level docker-compose file that describes all the services in your workspace. It is also assumed that your tmux configuration is setup to as a workspace for your project (I use tmuxinator to set a root directory). 

## Contributing

Check out how to contribute to the CLI in [CONTRIBUTING.md](CONTRIBUTING.md).

## License

This project is under an [MIT license](LICENSE.txt).
