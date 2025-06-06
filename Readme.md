# Readme

## Environment variables

Variables required:

- `source "$HOME/.env"`
  - Exported from: `serverstats.json`
- `db/servers.json`

## Extra steps

- Install [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)
- Install [zsh-fzf-history-search](https://github.com/joshskidmore/zsh-fzf-history-search)
- Install [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- Install [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md)
- Install [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md)
- Configure plugins in `~/.zshrc`
  - `plugins=(git zsh-fzf-history-search compleat zsh-autosuggestions zsh-syntax-highlighting)`

## Docker Utility Functions (`docker_functions.sh`)

This repository includes a set of utility functions to simplify common Docker operations. These functions are defined in `docker_functions.sh` and are loaded automatically if you're using the `init.sh` script.

### Available Functions:

*   **`dkc`**: Interactively connect to a running Docker container's shell.
*   **`dki`**: Inspect a Docker container and copy its working directory to the clipboard.
*   **`dkg`**: Change the current directory to the working directory of a selected Docker container.
*   **`dk-stop-ixiam`**: Stops all running Docker containers except those named "portainer" and "traefik" (useful for specific development environments).
*   **`dk-help`**: Lists available `dk-*` commands (this list).
*   **`dk-ps`**: Alias for `docker ps`.
*   **`dk-start <container_name_or_id>`**: Starts a stopped container.
*   **`dk-stop <container_name_or_id>`**: Stops a running container.
*   **`dk-stop-all`**: Stops all currently running containers.
*   **`dk-php <script.php>`**: Runs a PHP script using a `php:cli-alpine` container, mounting the current directory.
*   **`dk-gulp <task(s)>`**: Executes Gulp tasks using a `node:alpine` container, mounting the current directory.
*   **`dk-npm-install <package(s)>`**: Installs Node.js packages using a `node:alpine` container, mounting the current directory.
*   **`dk-npx <command>`**: Executes an npx command using a `node:alpine` container, mounting the current directory.
*   **`dk-composer <command>`**: Executes a Composer command using the official `composer` image, mounting the current directory.
*   **`dk-rm`**: Interactively remove stopped container(s).
*   **`dk-rmi`**: Interactively remove Docker image(s) using fzf for selection.
*   **`dk-logs`**: Interactively select a running container and follow its logs (`docker logs -f`).
*   **`dk-ip`**: Interactively select a running container and display its IP address.
*   **`dk-exec`**: Interactively select a running container and execute a specified command within it. If no command is given, it attempts to connect to `sh` or `bash`.

### Docker Compose Aliases (from `aliases.sh`)

Note: The following Docker Compose aliases are still present in `aliases.sh`:

*   `dcu`: `docker-compose up -d`
*   `dcd`: `docker-compose down -v`
*   `dcr`: `docker-compose restart`
*   `dcl`: `docker-compose logs -f`
*   `dcs`: `docker-compose stop`

These may be moved to `docker_functions.sh` in the future for better organization.
