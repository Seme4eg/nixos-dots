# Other conveniences
bindkey -M viins '^a' beginning-of-line
bindkey -M viins '^d' push-line-or-edit

# Up arrow:
bindkey '\e[A' history-substring-search-up
bindkey '\eOA' history-substring-search-up
# Down arrow:
bindkey '\e[B' history-substring-search-down
bindkey '\eOB' history-substring-search-down

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

bindkey -s '^o' '^ulfcd\n'
bindkey -s '^a' '^ubc -lq\n'
bindkey -s '^f' '^ucd "$(dirname "$(fzf)")"\n'
bindkey '^[[P' delete-char

# C-z to toggle current process (background/foreground)
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

if (( $+commands[fzf] )); then
  bindkey '^R' fzf-history-widget
fi

# Omni-Completion
if (( $+commands[fasd] )); then
  bindkey -M viins '^x^f' fasd-complete-f  # C-x C-f to do fasd-complete-f (only files)
  bindkey -M viins '^x^d' fasd-complete-d  # C-x C-d to do fasd-complete-d (only directories)
fi

# enable history search (bound to C-k & C-j)

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -s '^p' up-line-or-beginning-search
bindkey -s '^n' down-line-or-beginning-search

# Vim's C-x C-l in zsh
# history-beginning-search-backward-then-append() {
#   zle history-beginning-search-backward
#   zle vi-add-eol
# }
# zle -N history-beginning-search-backward-then-append
# bindkey -M viins '^x^l' history-beginning-search-backward-then-append
