dkc() {
  if docker ps >/dev/null 2>&1; then
    container=$(docker ps | awk '{if (NR!=1) print $1 ": " $(NF)}' | fzf --height 40%)

    if [[ -n $container ]]; then
      container_id=$(echo $container | awk -F ': ' '{print $1}')
      docker exec -it $container_id sh
      # || docker exec -it $container_id /bin/bash
    else
      echo "You haven't selected any container! ༼つ◕_◕༽つ"
    fi
  else
    echo "Docker daemon is not running! (ಠ_ಠ)"
  fi
}

dki() {
  containerId=$(docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" | tail -n +2 | fzf | awk '{print $1}')
  containerInfo=$(docker inspect $containerId | grep com.docker.compose)

  # Copy into clipboard the working directory of the container
  containerIdPath=$(echo $containerInfo | grep '"com.docker.compose.project.working_dir":' | awk -F ': ' '{print $2}' | tr -d '",')
  containerIdPath=$(echo $containerIdPath | sed 's/\\//g')
  echo $containerInfo
  echo $containerIdPath | xclip -selection c
  cd $containerIdPath
}

dkg() {
  containerId=$(docker ps | tail -n +2 | fzf | awk '{print $1}')
  containerIdPath=$(docker inspect $containerId | grep working_dir | awk '{print $2}' |  sed 's/\"//g' |  sed 's/,//g')
  cd $containerIdPath
}

dk-stop-ixiam() {
  echo -e $(ssh ${USER_DEV_DOCKER}@${DEV_DOCKER} docker ps -a --filter "status=running" | grep -v "portainer" | grep -v "traefik")
  if ask "Do you want stop the containers?"; then
    ssh ${USER_DEV_DOCKER}@${DEV_DOCKER} docker stop $(docker ps -a --filter "status=running" | grep -v "portainer" | grep -v "traefik" | awk 'NR>1 {print $1}')
  else
    echo "No"
  fi
  firefox "$URL_ODOO"
}

ask() {
  local prompt default reply
  if [ "${2:-}" = "Y" ]; then
    prompt="Y/n"
    default=Y
  elif [ "${2:-}" = "N" ]; then
    prompt="y/N"
    default=N
  else
    prompt="y/n"
    default=
  fi
  while true; do
    # Ask the question (not using "read -p" as it uses stderr not stdout)
    echo -n "$1 [$prompt] "
    # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
    read reply </dev/tty
    # Default?
    if [ -z "$reply" ]; then
      reply=$default
    fi
    # Check if the reply is valid
    case "$reply" in
      Y*|y*) return 0 ;;
      N*|n*) return 1 ;;
  esac
  done
}

dk-help() {
  echo "Docker Custom Commands"
  echo "======================"
  echo "dk-help         List custom Docker commands"
  echo "dk-ps           docker ps"
  echo "dk-start        Starts container                  \"> dk-start httpd-web\""
  echo "dk-stop         Stops container                   \"> dk-stop httpd-web\""
  echo "dk-stop-all     Stops all active containers       \"> dk-stop-all\""
  echo ""
  echo "dk-php          Executes php-cli script           \">  dk-php script.php\""
  echo "dk-npm-install  Install Node.js package locally   \">  dk-npm-install gulp\""
  echo "dk-npx          Execute local Node.js command     \">  dk-npx <command> \""
  echo "dk-gulp         Executes gulp tasks               \">  dk-gulp myTask1 myTask2\""
  echo "dk-composer     Executes composer                 \">  dk-composer install \""
  echo ""
  echo ""
  echo "Docker-Compose Custom Commands"
  echo "=============================="
  echo "dcu             docker-compose up -d"
  echo "dcd             docker-compose down -v"
  echo "dcr             docker-compose restart"
  echo "dcl             docker-compose logs -f"
  echo "dcs             docker-compose stop"
}

dk-ps() {
  docker ps
}
dk-start() {
  docker start "$1"
}
dk-stop() {
  docker stop "$1"
}
dk-stop-all() {
  docker stop $(docker ps -q)
}
dk-php() {
  docker run --rm -v $(pwd):/app -w /app php:7.2.29-cli-alpine php "$1"
}
dk-gulp() {
  docker run --rm --user $(id -u):$(id -g) -v $PWD:/app -v $PWD/.npm:/.npm -v $PWD/.config:/.config -w /app node:15.3.0-alpine npx gulp "$@"
}
dk-npm-install() {
  docker run --rm --user $(id -u):$(id -g) -v $PWD:/app -v $PWD/.npm:/.npm -v $PWD/.config:/.config -w /app node:15.3.0-alpine npm install "$@"
}
dk-npx() {
  docker run --rm --user $(id -u):$(id -g) -v $PWD:/app -v $PWD/.npm:/.npm -v $PWD/.config:/.config -w /app node:15.3.0-alpine npx "$@"
}
dk-composer() {
  docker run -it --rm -v $(pwd):/app composer "$1"
}

# Remove one or more stopped containers
dk-rm() {
  docker ps -a -f status=exited -f status=created -q | xargs -r docker rm
}

# Remove one or more images
dk-rmi() {
  docker images -q | fzf -m | xargs -r docker rmi
}

# Follow logs of a container
dk-logs() {
  local container_id
  container_id=$(docker ps -q | fzf)
  if [[ -n "$container_id" ]]; then
    docker logs -f "$container_id"
  else
    echo "No container selected."
  fi
}

# Get the IP address of a container
dk-ip() {
  local container_id
  container_id=$(docker ps -q | fzf)
  if [[ -n "$container_id" ]]; then
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$container_id"
  else
    echo "No container selected."
  fi
}

# Execute a command in a running container
dk-exec() {
  local container_id
  local command_to_run
  container_id=$(docker ps --format "{{.ID}}: {{.Names}}" | fzf | awk -F ':' '{print $1}')
  if [[ -n "$container_id" ]]; then
    read -r -p "Enter command to execute in $container_id: " command_to_run
    if [[ -n "$command_to_run" ]]; then
      docker exec -it "$container_id" $command_to_run
    else
      echo "No command entered. Connecting to sh/bash..."
      if docker exec -it "$container_id" sh -c "true" 2>/dev/null; then
        docker exec -it "$container_id" sh
      else
        docker exec -it "$container_id" bash
      fi
    fi
  else
    echo "No container selected."
  fi
}
