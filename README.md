# tmux-devcontainers
A Tmux plugin for working with [devcontainers](https://containers.dev) featuring:

- Status bar placeholders to show the status of the devcontainers for the current workspace.
- Key binding to create a new login shell in the devcontainer (via devcontainer exec).
- A menu to interact with the devcontainers in the current workspace.

### Status bar integration

![Status information](https://github.com/phil/tmux-devcontainers/blob/main/resources/status-bar-integration.png?raw=true)

tmux-devcontainers provides a status bar placeholder to show the status of the devcontainers from your docker-compose file:

```bash
set -g status-right '#{devcontainers_workspace} #{devcontainers_status}'
```

- `#{devcontainers_workspace}`: shows the name of the devcontainer workspace.
- `#{devcontainers_status}`: shows the status of each container in the workspace.

### Menu commands

![Status information](https://github.com/phil/tmux-devcontainers/blob/main/resources/menu-commands.png?raw=true)

Commands to manage devcontainers. Commands run in new windows and try to be unintrusive by automatically closing on success.

### Key bindings

tmux-devcontainers provides a key bindings to interact with the devcontainers:
- prefix + E: creates a new tmux pane with a login shell in the devcontainer.
- prefix + (Ctrl + e): shows a menu to interact with the devcontainers in the current workspace.

Key bindings can be customized by setting the following options in your `~/.tmux.conf` file:

```bash
set-option -g @devcontainers_exec_key 'T' # default: 'E'
set-option -g @devcontainers_menu_key 'M' # default: 'Ctrl + e'
```

## Installation

### Pre-requisites

- docker (version 28 or later)
- [devcontainer CLI](https://github.com/devcontainers/cli)
- [jq](https://jqlang.org)

### Installation Using Tmux Plugin Manager (TPM)

Add the following line to your `~/.tmux.conf` file:

```bash
set -g @plugin 'phil/tmux-devcontainers'
```

## About

tmux-devcontainers is designed to be as flexible as possible, allowing you to interact with devcontainers in your workspace directly from Tmux. It provides a simple way to manage and monitor the status of your devcontainers without leaving your terminal. Commands and status updates are scoped to the current Tmux pane, so you can easily switch between different devcontainer workspaces within Tmux sessions.


## Contributing

Check out how to contribute to the CLI in [CONTRIBUTING.md](CONTRIBUTING.md).

## License

This project is under an [MIT license](LICENSE.txt).
