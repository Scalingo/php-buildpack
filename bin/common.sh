error() {
  echo " !     $*" >&2
  exit 1
}

status() {
  echo "-----> $*"
}

protip() {
  echo
  echo "TIP: $*" | indent
  echo
}

# sed -l basically makes sed replace and buffer through stdin to stdout
# so you get updates while the command runs and dont wait for the end
# e.g. npm install | indent
indent() {
  c='s/^/       /'
  case $(uname) in
    Darwin) sed -l "$c";; # mac/bsd sed: -l buffers on line boundaries
    *)      sed -u "$c";; # unix/gnu sed: -u unbuffered (arbitrary) chunks of data
  esac
}

cat_npm_debug_log() {
  test -f $build_dir/npm-debug.log && cat $build_dir/npm-debug.log
}

unique_array() {
  echo "$*" | tr ' ' '\n' | sort -u | tr '\n' ' '
}

init_log_plex() {
  for log_file in $*; do
    echo "mkdir -p `dirname ${log_file}`"
  done
  for log_file in $*; do
    echo "touch ${log_file}"
  done
}

tail_log_plex() {
  for log_file in $*; do
    echo "tail -n 0 -qF --pid=\$\$ ${log_file} &"
  done
}

export_env_dir() {
    env_dir=$1
    blacklist_regex=${3:-'^(PATH|GIT_DIR|CPATH|CPPATH|LD_PRELOAD|LIBRARY_PATH|LD_LIBRARY_PATH)$'}
    if [ -d "$env_dir" ]; then
        for e in $(ls $env_dir); do
            echo "$e" | grep -qvE "$blacklist_regex" &&
            export "$e=$(cat $env_dir/$e)"
            :
        done
    fi
}

function mktmpdir() {
    dir=$(mktemp -t php-$1-XXXX)
    rm -rf $dir
    mkdir -p $dir
    echo $dir
}

