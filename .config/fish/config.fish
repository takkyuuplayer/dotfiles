fish_vi_key_bindings

if not test -f $HOME/.config/fish/functions/fisher.fish
  echo "==> Fisherman not found. Installing."
  curl -sLo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
  fisher
end

[ -f ~/.fishrc_mine ]; and source ~/.fishrc_mine
