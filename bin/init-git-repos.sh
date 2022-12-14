#!/bin/bash
#
# execute this script with bash, not with zsh

set -Eeuo pipefail
die() { echo -e "$0" ERROR: "$@" >&2; exit 1; }
# shellcheck disable=2154
trap 's=$?; die "line $LINENO - $BASH_COMMAND"; exit $s' ERR

repos_dir=$HOME/git

# Associative array, repo name -> directory.
declare -A repos
repos=(
    ["pass"]="$XDG_DATA_HOME/password-store"
    ["tea"]="$repos_dir/tea"
    ["Bash-lang"]="$repos_dir/bash"
    ["elisp"]="$repos_dir/elisp"
    ["archive"]="$repos_dir/archive"
    ["vim"]="$repos_dir/vim"
    ["tea"]="$repos_dir/tea"
)

for repo in "${!repos[@]}"; do
    destination=${repos[$repo]}
    echo "$(tput bold setaf 6)Checking $destination"
    if [[ ! -e "$destination" ]]; then
        # Make sure parent directory exists first.
        mkdir -p "$(dirname "$destination")"
        repo_url="git@github.com:seme4eg/$repo.git"
        echo "$(tput bold setaf 6)Cloning repo $repo_url to $destination"
        git clone "$repo_url" "$destination"
    fi
done

# key that you exported from prev machine with
# `gpg2 --export-secret-keys > secret.gpg` and copied here from harddrive
[[ -f ~/secret.gpg ]] && gpg2 --import ~/secret.gpg
