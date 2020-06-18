
# https://gist.github.com/dayne/a97a258b487ed4d5e9777b61917f0a72

# toggle between true and false when debugging this
# debugging between linux flavors, mac, and other systems can be fun

ssh_agent_debug=false

function chat() {
  if [ "${ssh_agent_debug}" = true ]; then
    echo "info: ${1}"
  fi
}

function check_forward_ssh_agent() {
  chat "check_forward_ssh_agent()"
  if [[ ! -S ${SSH_AUTH_SOCK} ]]; then
    chat "no: agent forward detected"
    return 1
  else
    chat "detected agent forward"
    ssh-add -L > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      chat "verified agent auth sock is valid"
      return 0
    else
      chat "ssh auth sock invalid"
      return 1
    fi
  fi
}

function check_ssh_agent() {
  chat "check_ssh_agent()"
  if [ -f $HOME/.ssh-agent ]; then
    source $HOME/.ssh-agent > /dev/null
  else
    # no agent file
    return 1
  fi

  # thanks to @craighurley for this improvement that works on OSX & Ubuntu fine
  lsof -p $SSH_AGENT_PID | grep -q ssh-agent
  return $?
}

function launch_ssh_agent() {
  chat "launch_ssh_agent()"
  ssh-agent > $HOME/.ssh-agent
  source $HOME/.ssh-agent
}

function add_keys_to_agent() {
  chat "add_keys_to_agent()"
  ssh-add -l > /dev/null
  if [ $? -eq 0 ]; then
    # ssh-agent already has keys loaded - skipping scan & load logic
    return 0
  fi
  # add ~/.ssh/id_rsa-${HOSTNAME} otherwise add all keys in .ssh
  echo "adding ssh keys"
  test -f $HOME/.ssh/id_rsa-${HOSTNAME}.pub && ssh-add ${_/.pub}
  if [ $? -ne 0 ]; then
    for I in $HOME/.ssh/*.pub ; do
      echo "adding ${I/.pub/}"
      ssh-add ${I/.pub/}
    done
  fi
}

function find_existing_or_launch_new_agent() {
  chat "finding existing or launching new ssh agent"
  check_forward_ssh_agent
  if [ $? -ne 0 ]; then
    chat "no forwarded agent found - look locally"
    check_ssh_agent
    if [ $? -ne 0 ];then
      chat "no local or forward agent found"
      chat "killing existing agents"
      killall ssh-agent # verify there aren't any error state/lost agents running
      launch_ssh_agent
    fi

    # add keys (only if interactive terminal) 
    if [[ $- = *i* ]];then
      # interactive terminal .. but make sure it isn't tmux first
      if [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; then
        # tmux session - lets avoid key adding magic here
        return 0
      else
        chat "adding keys to agent"
        add_keys_to_agent
      fi
    else
      # non-interactive
      return 0
    fi
  fi
}

find_existing_or_launch_new_agent