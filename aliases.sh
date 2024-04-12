alias ..="cd .."
alias ...="cd ../.."
alias ll="ls -l"
alias la="ls -la"
alias ~="cd ~"

# Git
alias gaa="git add -A"
alias gc='$DOTLY_PATH/bin/dot git commit'
alias gca="git add --all && git commit --amend --no-edit"
alias gco="git checkout"
alias gd='$DOTLY_PATH/bin/dot git pretty-diff'
alias gs="git status -sb"
alias gf="git fetch --all -p"
alias gps="git push"
alias gpsf="git push --force"
alias gpl="git pull --rebase --autostash"
alias gb="git branch"
alias gl='$DOTLY_PATH/bin/dot git pretty-log'

# Utils
alias k='kill -9'
alias i.='(idea $PWD &>/dev/null &)'
alias c.='(code $PWD &>/dev/null &)'
alias o.='open .'
alias up='dot package update_all'
alias c="ssh ${DEFAULT_USER_SSH}@${DEV_HOST}"
alias setclip="xclip -selection c"

alias getclip="xclip -selection c -o"

# Custom to clipboard
alias custom_reroute_email='printf "drush vset --yes reroute_email_enable 1 \n drush vset --yes reroute_email_address ${EMAIL_ENTERPRISE} \n drush vset --yes reroute_email_enable_message 1 \n" | xclip -selection c';
alias custom_dis_modules='printf "drush dis autologout --y \n" | xclip -selection c';
alias custom_after_migrate='printf "drush en reroute_email --y \n drush vset --yes reroute_email_enable 1 \n drush vset --yes reroute_email_address ${EMAIL_ENTERPRISE} \n drush vset --yes reroute_email_enable_message 1 \n drush dis autologout --y \n drush en dblog --y \n drush dis --y session_expire \n drush dis --y session_limit \n drush sqlq --file=~/static/scripts/disable_emails.sql \n" \n drush upwd root --password=${PASSWORD_DRUPAL_DEFAULT} \n | xclip -selection c';
alias custom_after_migrate_d9='printf "drush  drush pm-uninstall autologout --y \n | xclip -selection c';
alias custom_change_password_root='printf "drush upwd root --password=${PASSWORD_DRUPAL_DEFAULT}" | xclip -selection c';
alias custom_change_password_ruben='printf "drush upwd ruben --password=${PASSWORD_DRUPAL_RUBEN}" | xclip -selection c';
alias custom_new_user='printf "drush user-create newuser --mail=${EMAIL_ENTERPRISE} --password=${PASSWORD_DRUPAL_RUBEN}" | xclip -selection c '
alias custom_aegir_path='printf "/data/disk/rpineda/static/" | xclip -selection c';
alias custom_drush_make='printf "drush make site.make --no-core --contrib-destination=. -y " | xclip -selection c';

alias custom_password="openssl rand -base64 32 | xclip -selection c"
alias custom_get_ip_vpn="ip addr show tun0 | grep -Po 'inet \K[\d.]+'"
alias custom_phpcbf="phpcbf --standard=Generic,Squiz,PEAR,PSR2 --sniffs=Generic.Arrays.DisallowLongArraySyntax"
alias custom_find_last_modified_files="find . -mtime -2 -ls"

# Alias to avoid issues with snap install code
alias code="/snap/bin/code"
alias custom_squash_two_commits="git reset --soft HEAD~2 && git commit"


# Docker Compose alias
alias dcu="docker-compose up -d"
alias dcd="docker-compose down -v"
alias dcr="docker-compose restart"
alias dcl="docker-compose logs -f"
alias dcs="docker-compose stop"

alias grep="grep --color"
alias ll="ls -al"

alias dk_tr_u='docker-compose --file $HOME/repositories/docker/docker_traeffik/docker-compose.yml up -d'
alias dk_tr_s='docker-compose --file $HOME/repositories/docker/docker_traeffik/docker-compose.yml stop'

alias rr='konsoleprofile colors=Solarized'

## Required a parameter with the connection in the directory /etc/vpnc/
alias vpnc="sudo vpnc-connect --local-port 0 "
alias vpnd="sudo vpnc-disconnect"

alias get_enviroment="python3 ~/extra_bash/get_enviroment.py"