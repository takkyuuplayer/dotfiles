fish_vi_key_bindings

if not test -f $HOME/.config/fish/functions/fisher.fish
  echo "==> Fisherman not found. Installing."
  curl -sLo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
  fisher
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

[ -f ~/.fishrc_mine ]; and source ~/.fishrc_mine
