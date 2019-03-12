#!/bin/bash

# Thanks csdt !

# \[ and \] signal a non-printing character sequence
# It's used here as a security in case of poor color support in terminal
# See man bash, PROMPTING section

# Actual colors
Color_Off='\[\e[0m\]'      # Text Reset
Red='\[\e[0;31m\]'         # Red
BRed='\[\e[1;31m\]'        # Bold red
Green='\[\e[0;32m\]'       # Green
BGreen='\[\e[1;32m\]'      # Bold green
BYellow='\[\e[1;33m\]'     # Bold yellow
BBlue='\[\e[1;34m\]'       # Bold blue
BPurple='\[\e[1;35m\]'     # Bold purple
BCyan='\[\e[1;36m\]'       # Bold cyan

# Color configuration
username_color="$BYellow"
hostname_color="$BBlue"
ssh_hostname_color="$BCyan"
pwd_color="$BGreen"
root_color="$BRed"
true_color="$Green"
false_color="$Red"
end_color=$pwd_color

# Unicode glyphs
if [[ $UNICODE_VALID == 1 ]]; then
  True="\342\234\223"
  False="\342\234\227"
else
  True="y"
  False="n"
fi

# If root
if [ $EUID -eq 0 ]
then
  username_color=$root_color
  end_color=$root_color
fi

# Colors over ssh
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]
then
  hostname_color=$ssh_hostname_color
fi

# Colors in a screen
if [[ $TERMCAP =~ screen ]] || [[ $TERM == "screen" ]]
then
  pwd_color="$BPurple"
fi

execution="\$(if [[ \$? == 0 ]]; then echo \"$true_color$True\"; else echo \"$false_color$False\"; fi)"
user="$username_color\u$hostname_color@\h"
pwd="$pwd_color\w"
end="$end_color\\\$$Color_Off"

PS1="$execution $user $pwd $end "

unset pwd_color history_color root_color color execution user pwd end g true_color false_color end_color True False Red BRed Green BGreen Yellow BYellow BBlue BPurple BCyan
