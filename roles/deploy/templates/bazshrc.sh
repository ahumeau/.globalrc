#!/bin/bash

# This file is sourced by both bash and zsh, so it should be compatible with both.

### Begin test of terminal capabilities and configuration ###

# For terminal capabilities, we shouldn't rely on $TERM, instead, make a lookup in the terminfo database, cf :
# - https://unix.stackexchange.com/a/9960/293790
# - http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x405.html
# - man terminfo
# - termcap is an older mechanism for this, use terminfo when possible
# (And obviously, changing $TERM yourself is TERRIBLY WRONG)
# TODO: Forward the terminal capabilities over ssh (forwarding $TERM ?)

# Test for 256colors support
# NB : I'm not certain if `tput colors` can output a value higher than 256, which would break this test
# run `for code in {000..255}; do print -P -- "$code: %F{$code}Test%f"; done` to see possible colors
# tput can generally do a lot of capability testing and cursor movement, cf `man tput` and `man terminfo`
if [[ $(tput colors) == '256' ]] ; then
  export GLOBALRC_256_COLORS='1'
fi

### End test of terminal capabilities and configuration ###

### Begin definitions ###

# Use Volta (https://github.com/volta-cli/volta) as node version manager (instead of NVM)
# Reasons include :
# * NVM is a big ball of shell scripts that need sourcing at shell startup, which takes a lot of time
#   * We previously worked around this by setting up lazy-loading
#   * The shim-based architecture of Volta is much cleanly isolated
# * NVM behaves very pooly when dealing with multiple Node versions. Even if you have a `.nvmrc` in each repo, you either have to
#   run `nvm use` whenever changing directory, or set a global default (that won't honor .nvmrc in all directories)
#
# NB : Volta is not currently installed automatically, install it with https://docs.volta.sh/advanced/installers#skipping-volta-setup
# TODO : Automatically install Volta.
# TODO : Add completions for Volta
export VOLTA_HOME="{{ volta_home }}"

# RELEASE_BLOCKER Python with uv
# Redefine $PATH to the following stuff (in this order) :
# * $GLOBALRC/local_bin       : custom executables installed manually by the user
# * $GLOBALRC/files/scripts/  : custom executables installed with ansible
# * ~/.volta/bin              : node versions and associated programs, managed via volta
# * ~/.cargo/bin              : Programs user-installed through `cargo install`
# * ~/go/bin                  : Programs user-installed through `go install`
# * ~/.local/bin              : Programs user-installed through pipx
# * $PATH                     : Default OS search path
#
# Please note that this is only applied in a shell environment, not anything started graphically or by the OS
export PATH="{{ remote_directory }}/local_bin/:{{ remote_directory }}/files/scripts/:{{ volta_home }}/bin:{{ userspace_bin_path_cargo }}:{{ userspace_bin_path_go }}:{{ ansible_user_dir }}/.local/bin:$PATH"

if command -v most >/dev/null 2>&1 ; then
  export PAGER="most"
fi

# Use custom inputrc
export INPUTRC="{{ remote_directory }}/templates/inputrc"

# RELEASE_BLOCKER understand what this does
# SSH-agent setup, cf ssh-agent.service file
# NB : on MacOS, the OS starts an agent automatically, do not override it with an invalid path
{% if ansible_system != "Darwin" %}
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
{% endif %}

### End definitions ###

### Begin aliases & alias functions ###

# add coloring
alias grep='grep --color=auto'

# Movements to parent directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Create a temporary directory and move to it
alias cdtmp='pushd $(mktemp -d)'

# Way too long commands
alias tf="terraform" # RELEASE_BLOCKER autocomplete?
# RELEASE_BLOCKER my aliases

### End aliases & alias functions ###
