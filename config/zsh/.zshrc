# -*- mode: sh; sh-shell: zsh -*-

# NOTE: to get keys for defining binding: cat -v , sir

. $ZDOTDIR/config.zsh

# Install & source grml-zsh-config
if [[ ! -f $ZDOTDIR/.grmlrc ]]; then
  echo "Fetching grml"
  wget -O $ZDOTDIR/.grmlrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
fi
. $ZDOTDIR/.grmlrc

# XXX: todo
# if [ -f "/usr/share/nvm/init-nvm.sh" ]; then
#   # init-nvm.sh contents with bash_completion excluded and nvm dir changed
#   [ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.config/nvm"
#   source /usr/share/nvm/nvm.sh
#   source /usr/share/nvm/install-nvm-exec
# fi

###############################################################################
#                  Antidote (https://getantidote.github.io/)                  #
###############################################################################

# run 'antidote update' to update plugins

# NOTE ANTIDOTE_DIR is forward-declared in modules/home/shell-zsh.nix
if [[ ! -d $ANTIDOTE_DIR ]]; then
  echo "Installing mattmc3/antidote"
  git clone https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
fi
. $ANTIDOTE_DIR/antidote.zsh
# HACK: i don't know where from, but on initial setup plugins.zsh (empty one)
# appears in zdotdir and when trying to load plugins file it loads that empty
# file instaed, so i remoev it if it exist and is empty
# [ ! -s $ZDOTDIR/plugins.zsh ] && rm $ZDOTDIR/plugins.zsh
antidote load $ZDOTDIR/plugins

###############################################################################
#                              End Antidote setup                             #
###############################################################################

# FIXME: doess't seem to work, like half of this file
# search history based on what's typed in the prompt
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# FIXME: doesn't work as well, running this 'bindkey' manually in shell works
# https://github.com/zsh-users/zsh-autosuggestions
# autosuggestions provided by home-manager's programs.zsh.enableAutosuggestions
# '^ ' is ctrl+space
bindkey '^ ' autosuggest-accept
ZSH_AUTOSUGGEST_STRATEGY=(completion)
ZSH_AUTOSUGGEST_HIGLIGHT_STYLE="fg=5"

# Theming
# for now using powerlevel10k instead
# [ -f "~/.config/zsh/theming.zsh" ] && . "~/.config/zsh/theming.zsh"
# TODO: move that theme file in theme folder when i set this up
# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh

eval "$(zoxide init zsh)" # z / zi[nteractive] (using fzf if u have it)
stty stop undef # disable C-s to freeze terminal
# Nobody needs flow control anymore. Troublesome feature.
#stty -ixon
setopt noflowcontrol

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
  tmp="$(mktemp -uq)"
  trap 'rm -f $tmp >/dev/null 2>&1' HUP INT QUIT TERM PWR EXIT
  lf -last-dir-path="$tmp" "$@"
  if [ -f "$tmp" ]; then
  dir="$(cat "$tmp")"
  [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
  fi
}
zle -N lfcd
bindkey '^O' lfcd # FIXME: works once, then stops firing

zle -N fzf-history-widget
# FIXME: works once, then you need to retun 'zsh' to get it working again
bindkey '^_' fzf-history-widget

# source $ZDOTDIR/completion.zsh # Redundant for now cuz using grml
source $ZDOTDIR/aliases.zsh

function _source {
  for file in "$@"; do
    [ -r $file ] && source $file
  done
}
# Auto-generated by nixos
_source $ZDOTDIR/extra.zshrc
# If you have host-local configuration, put it here
_source $ZDOTDIR/local.zshrc
