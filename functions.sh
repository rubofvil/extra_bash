function custom_rsync() {
  source $2
  echo "rsync -uzva --no-links --ignore-errors -e ssh $1 $SSH_CONNECTION:$PATH_SITE$PATH_RELATIVE_EXT"
  # Ask if is correct and execute
  if ask "Do you want execute the command?"; then
    rsync -uzva --no-links --ignore-errors -e ssh $1 $SSH_CONNECTION:$PATH_SITE$PATH_RELATIVE_EXT
  else
    echo "No"
  fi
}

function cdd() {
  cd "$(ls -d -- */ | fzf)" || echo "Invalid directory"
}

function j() {
  fname=$(declare -f -F _z)
  [ -n "$fname" ] || source "$DOTLY_PATH/modules/z/z.sh"
  _z "$1"
}

function recent_dirs() {
  # This script depends on pushd. It works better with autopush enabled in ZSH
  escaped_home=$(echo $HOME | sed 's/\//\\\//g')
  selected=$(dirs -p | sort -u | fzf)

  cd "$(echo "$selected" | sed "s/\~/$escaped_home/")" || echo "Invalid directory"
}

# https://gist.github.com/davejamesmiller/1965569

custom_docker() {
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

_custom_drush_uli() {
  site_alias=$(fc -rl 1 | ssh ${DEFAULT_USER_SSH}@${DEV_HOST} drush sa | fzf)
  uli=$(ssh ${DEFAULT_USER_SSH}@${DEV_HOST} drush ${site_alias} uli )
  ssh ${DEFAULT_USER_SSH}@${DEV_HOST} drush sa ${site_alias} | awk '/site_path/ {print $3}' | head -c -3 | cut -c2- | xclip -selection c
  ssh ${DEFAULT_USER_SSH}@${DEV_HOST} drush sa ${site_alias}
  sa=$(ssh ${DEFAULT_USER_SSH}@${DEV_HOST} drush sa ${site_alias})
  $BROWSER ${uli}
}

_custom_drush_uli_staging() {
  site_alias=$(fc -rl 1  | ssh -i ~/ssh_ixiam/id_rsa ${DEFAULT_USER_SSH}@${STAGING_HOST} drush sa | fzf)
  uli=$(ssh -i ~/ssh_ixiam/id_rsa ${DEFAULT_USER_SSH}@${STAGING_HOST} drush ${site_alias} uli )
  ssh -i ~/ssh_ixiam/id_rsa ${DEFAULT_USER_SSH}@${STAGING_HOST} drush sa ${site_alias} | awk '/site_path/ {print $3}' | head -c -3 | cut -c2- | xclip -selection c
  sa=$(ssh -i ~/ssh_ixiam/id_rsa ${DEFAULT_USER_SSH}@${STAGING_HOST} drush sa ${site_alias})
  $BROWSER ${uli}
}

_custom_fix_permissions_aegir_ext() {
  $(ssh ${DEFAULT_USER_SSH}@${DEV_HOST} mv /data/disk/${USER_AEGIR_DEV}/static/repositories/ext /data/disk/${USER_AEGIR_DEV}/static/trash/ext$(date +%Y%m%d))
  $(ssh ${DEFAULT_USER_SSH}@${DEV_HOST} cp -r /data/disk/${USER_AEGIR_DEV}/static/trash/ext$(date +%Y%m%d) /data/disk/${USER_AEGIR_DEV}/static/repositories/ext)
}

_custom_fix_permissions_aegir_total() {
  $(ssh ${DEFAULT_USER_SSH}@${DEV_HOST} mv /data/disk/${USER_AEGIR_DEV}/static/repositories /data/disk/${USER_AEGIR_DEV}/static/trash/repositories$(date +%Y%m%d))
  $(ssh ${DEFAULT_USER_SSH}@${DEV_HOST} cp -r /data/disk/${USER_AEGIR_DEV}/static/trash/repositories$(date +%Y%m%d) /data/disk/${USER_AEGIR_DEV}/static/repositories)
}

# https://gist.github.com/davejamesmiller/1965569
_before_stop_work_ixiam() {
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

_docker_connect() {
  containerid=$(docker ps | tail -n +2 | fzf | awk '{print $1}')
  docker exec -it $containerid bash
}

_docker_inspect() {
  containerid=$(docker ps | tail -n +2 | fzf | awk '{print $1}')
  docker inspect $containerid | grep com.docker.compose
}

_docker_compose_go() {
  containerid=$(docker ps | tail -n +2 | fzf | awk '{print $1}')
  containeridpath=$(docker inspect $containerid | grep working_dir | awk '{print $2}' |  sed 's/\"//g' |  sed 's/,//g')
  cd $containeridpath
}

oo() {
  PROJECT_PATH=$(ls -1 ~/Documents/workspaces/ | fzf | awk '{print $1}')
  code ~/Documents/workspaces/$PROJECT_PATH
}

_clipboard() {
  CLIPBOARD_RESPONSE=$(gpaste-client history | fzf | awk '{print $2}')
  echo -n $CLIPBOARD_RESPONSE | xclip -selection c
}

# Docker
dk-help() {
  echo "Docker Custom Commands"
  echo "======================"
  echo "dk-help         List custom Docker commands"
  echo "dk-ps           docker ps"
  echo "dk-start        Starts container                  \"> dk-start httpd-web\""
  echo "dk-stop         Stops container                   \"> dk-stop httpd-web\""
  echo "dk-stopsall     Stops all active containers       \"> dk-stopall\""
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
dk-stopall() {
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

fkill() {
  local pid
  if [ "$UID" != "0" ]; then
    pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
  else
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  fi

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

ssh_c() {
  # ToDo generate a list of hosts with the path of the config file, more clear to select
  # Get path of the config file
  config=$(ls ~/.ssh/config_ssh/*.conf | fzf -m | xargs)
  # Get the host
  host=$(cat $config | grep "Host\ " | awk '{print $2}')
  # Print the host
  echo $host
  # Connect to the host
  ssh $host; rr;
}
