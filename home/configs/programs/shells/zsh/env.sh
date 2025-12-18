autoload -U colors && colors

# shellcheck disable=SC2154
PS1="%{${fg[yellow]}%}[%n@%m]%~%% %{${reset_color}%}"
