set -U fish_prompt_pwd_dir_length 0

set -g __fish_git_prompt_showdirtystate true
set -g __fish_git_prompt_showuntrackedfiles true
set -g __fish_git_prompt_showstashstate true
set -g __fish_git_prompt_color green
set -g __fish_git_prompt_color_flags red

function fish_prompt
  set last_status $status

  set_color $fish_color_user
  printf "%s@%s" $USER (hostname)

  set_color $fish_color_command
  printf ' [%s]' (date +"%F %T%:z (%Z)")

  set_color $fish_color_cwd
  printf ' [%s]' (prompt_pwd)

  printf '%s ' (__fish_git_prompt)

  echo

  set_color $fish_color_command
  echo -n "\$ "
end
