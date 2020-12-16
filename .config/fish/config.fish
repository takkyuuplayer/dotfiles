fish_vi_key_bindings

if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

if type -q colordiff
  alias diff='colordiff -u'
else
  alias diff='diff -u'
end

if type -q gdate
  alias date='gdate'
end

bind \c] '__ghq_repository_search'
if bind -M insert >/dev/null 2>/dev/null
    bind -M insert \c] '__ghq_repository_search'
end

bind \cp 'history-search-backward'
if bind -M insert >/dev/null 2>/dev/null
    bind -M insert \cp 'history-search-backward'
end

bind \cn 'history-search-forward'
if bind -M insert >/dev/null 2>/dev/null
    bind -M insert \cn 'history-search-forward'
end

bind \cn 'history-search-forward'
if bind -M insert >/dev/null 2>/dev/null
    bind -M insert \cn 'history-search-forward'
end

bind \t complete
if bind -M insert >/dev/null 2>/dev/null
    bind -M insert \t complete
end

set -U fish_color_normal normal
set -U fish_color_command c397d8
set -U fish_color_quote b9ca4a
set -U fish_color_redirection 70c0b1
set -U fish_color_end c397d8
set -U fish_color_error d54e53
set -U fish_color_param 7aa6da
set -U fish_color_comment e7c547
set -U fish_color_match --background=brblue
set -U fish_color_selection white --bold --background=brblack
set -U fish_color_search_match bryellow --background=brblack
set -U fish_color_history_current --bold
set -U fish_color_operator 00a6b2
set -U fish_color_escape 00a6b2
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_valid_path --underline
set -U fish_color_autosuggestion 969896
set -U fish_color_user brgreen
set -U fish_color_host normal
set -U fish_color_cancel -r
set -U fish_pager_color_completion normal
set -U fish_pager_color_description B3A06D yellow
set -U fish_pager_color_prefix white --bold --underline
set -U fish_pager_color_progress brwhite --background=cyan

[ -f ~/.fishrc_mine ]; and source ~/.fishrc_mine

eval (direnv hook fish)
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths
status --is-interactive; and source (anyenv init -|psub)
alias awslocal="aws --endpoint-url=http://localhost:4566"
