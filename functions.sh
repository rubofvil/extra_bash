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

_custom_drush_uli() {
  site_alias=$(fc -rl 1 | ssh ${DEFAULT_USER_SSH}@${DEV_HOST} drush sa | fzf)
  uli=$(ssh ${DEFAULT_USER_SSH}@${DEV_HOST} drush ${site_alias} uli )
  st_site=$(ssh ${DEFAULT_USER_SSH}@${DEV_HOST} drush ${site_alias} st)
  echo $st_site
  root_path=$(echo $st_site | grep  'Drupal root'  | awk '{print $4}')
  root_site=$(echo $st_site | grep  'Site path'  | awk '{print $4}')
  echo $root_path'/'$root_site | xclip -selection c
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

oo() {
  PROJECT_PATH=$(ls -1 ~/Documents/workspaces/ | fzf | awk '{print $1}')
  code ~/Documents/workspaces/$PROJECT_PATH
}

_clipboard() {
  CLIPBOARD_RESPONSE=$(gpaste-client history | fzf | awk '{print $2}')
  echo -n $CLIPBOARD_RESPONSE | xclip -selection c
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
