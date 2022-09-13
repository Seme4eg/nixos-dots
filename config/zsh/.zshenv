function _source {
  for file in "$@"; do
    [ -r $file ] && source $file
  done
}

# Be more restrictive with permissions; no one has any business reading things
# that don't belong to them.
if (( EUID != 0 )); then
  umask 027
else
  # Be even less permissive if root.
  umask 077
fi
