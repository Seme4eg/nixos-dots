# export PATH="$HOME/.emacs.d/bin:$HOME/.config/nvm/versions/node/v16.16.0/bin/:$PATH"
# typeset -U path PATH
# path=(~/.local/bin $path) # (~/.local/bin .. .. $path)
# export PATH

# zsh-vi-mode
export ZVM_INIT_MODE=sourcing
export ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

## ZSH configuration
# Treat these characters as part of a word.
WORDCHARS='_-*?[]~&.;!#$%^(){}<>'

setopt RC_QUOTES          # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'

## History
HISTFILE="$XDG_CACHE_HOME/zhistory"
HISTSIZE=100000   # Max events to store in internal history.
SAVEHIST=100000   # Max events to store in history file.

setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Remove old events if new event is a duplicate
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.

## Directories
DIRSTACKSIZE=9
unsetopt AUTO_CD            # Implicit CD slows down plugins
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
