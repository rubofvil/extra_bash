export path=(
  "$HOME/bin"
  "/usr/local/bin"
  "/usr/local/sbin"
  "/bin"
  "/usr/bin"
  "/usr/sbin"
  "/sbin"
)

export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH="$PATH:$HOME/.composer/vendor/bin"

PATH="$(composer config -g home)/vendor/bin:$PATH"

PROMPT='%{$fg[green]%}%~%{$fg_bold[blue]%}$(git_prompt_info)%{$reset_color%} '

## Get the time
RPROMPT='%{$fg[green]%}[%D{%H:%M:%S}]%{$reset_color%}'
