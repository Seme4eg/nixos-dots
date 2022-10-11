alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# du -h --max-depth=1 ~/ | sort -h # make an alias?
alias 0x0="curl -F 'file=@-' 0x0.st" # < file
# alias hypru="cd ~/utils/Hyprland && git pull origin main && sudo make install"

alias reb="nixos-rebuild switch --flake /etc/dotfiles --use-remote-sudo"

alias q=exit
alias clr=clear
alias sudo='sudo '
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'
alias wget='wget -c'
alias path='echo -e ${PATH//:/\\n}'

alias shutdown='sudo shutdown'
alias reboot='sudo reboot'

# alias y='xclip -selection clipboard -in'
# alias p='xclip -selection clipboard -out'

alias jc='journalctl -xe'
alias sc=systemctl
alias ssc='sudo systemctl'

if (( $+commands[exa] )); then
  alias exa="exa --group-directories-first --git";
  alias l="exa -blF";
  alias ll="exa -abghilmu";
  alias llm='ll --sort=modified'
  alias la="LC_COLLATE=C exa -ablF";
  alias tree='exa --tree'
fi

if (( $+commands[fasd] )); then
  # fuzzy completion with 'z' when called without args
  unalias z 2>/dev/null
  function z {
    [ $# -gt 0 ] && _z "$*" && return
    cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
  }
fi

# REVIEW
function zman {
  PAGER="less -g -I -s '+/^       "$1"'" man zshall;
}
