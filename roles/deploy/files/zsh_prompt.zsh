#!/bin/zsh

# Main file generating the prompt.

################################################################################
#                                    CONFIG                                    #
################################################################################

# Set of chars used in prompt
prompt_tlc='┌'    # Top left
prompt_mlc='├─'   # Medium left (for heredocs & co)
prompt_blc='└'    # Bottom left
prompt_hyphen='─' # Horizontal separations
prompt_newline='
'

######################### Set of colors used in prompt #########################

if [[ -n $GLOBALRC_256_COLORS ]]; then
  # We have 256-color support \o/

  if [ -x /usr/bin/bc ]; then
    # We are doing a md5 hash of hostname to determine this color.
    # This way it is different on every machine
    prompt_color1=$(echo "ibase=16; `echo $HOST | md5sum | cut -b 1-2`" | bc) # hyphens
  else
    prompt_color1='green'
  fi
  prompt_color2='green'   # current directory
  prompt_color3='yellow'  # user@host
  prompt_color5='yellow'  # date

  # If we are root
  if [ $UID = 0 ] ; then
    prompt_color3='red'
    prompt_color5='red'
  fi

else
  # We have no 256-color support
  prompt_color1='green'   # hyphens
  prompt_color2='green'   # current directory
  prompt_color3='yellow'  # user@host
  prompt_color5='red'     # date

  # If we are over ssh
  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] ; then
    prompt_color1='cyan'
  fi

  # If we are root
  if [ $UID = 0 ] ; then
    prompt_color1='red'
  fi
fi

################################################################################

# see man zshmisc for explanation about %B, %F, %b…
prompt_tbox="%b%F{$prompt_color1}${prompt_tlc}%b%F{$prompt_color1}${prompt_hyphen}"
prompt_bbox="%b%F{$prompt_color1}${prompt_blc}%b%F{$prompt_color1}"

# This is basically a hack. It allows you to write characters on the line
# ABOVE the cursor.
prompt_bbox_to_mbox=$'%{\e[A\r'"%}%b%F{$prompt_color1}${prompt_mlc}%{"$'\e[B%}'

# left and right parenthesis
prompt_l_paren="%B%F{black}("
prompt_r_paren="%B%F{black})"

# User : %n, host : %M
prompt_user_host="%b%F{$prompt_color3}%n%B%F{$prompt_color3}@%b%F{$prompt_color3}%M"

# line 1 is pwd, username, host, hour…
prompt_line_1a="$prompt_tbox$prompt_l_paren$prompt_user_host$prompt_r_paren%b%F{$prompt_color1}$prompt_hyphen$prompt_l_paren%B%F{$prompt_color2}%~$prompt_r_paren%b%F{$prompt_color1}"
prompt_line_1b="$prompt_l_paren%B%F{$prompt_color5}%*$prompt_r_paren%b%F{$prompt_color1}${prompt_hyphen}"

# line 2 is prompt
prompt_line_2="$prompt_bbox${prompt_hyphen}%B%F{white}"
prompt_char="%(!.#.>)"
prompt_opts=(cr subst percent)

# Built using /usr/share/zsh/functions/Prompts/prompt_adam2…
EXITCODE="%(?..[%?]%1v)"

# This function is called before each prompt regenation
# NB : it's better to give it an arbitrary name, and add it to precmd_functions than directly
# calling it precmd (no conflicts)
function prompt_precmd () {
    setopt noxtrace localoptions extendedglob
    local prompt_line_1

    if [[ $TERM == screen* ]] ; then
        if [[ -n ${VCS_INFO_message_1_} ]] ; then
            ESC_print ${VCS_INFO_message_1_}
        else
            ESC_print "zsh"
        fi
    fi

    # adjust title of xterm
    # see http://www.faqs.org/docs/Linux-mini/Xterm-Title.html
#    [[ ${NOTITLE} -gt 0 ]] && return 0
#    case $TERM in
#        (xterm*|rxvt*)
#            set_title ${(%):-"%n@%m: %~"}
#            ;;
#    esac

    local prompt_line_1a_width=${#${(S%%)prompt_line_1a//(\%([KF1]|)\{*\}|\%[Bbkf])}}
    local prompt_line_1b_width=${#${(S%%)prompt_line_1b//(\%([KF1]|)\{*\}|\%[Bbkf])}}

    local prompt_padding_size=$(( COLUMNS - prompt_line_1a_width - prompt_line_1b_width - 2 ))

    # Try to fit in long path and time, and vcs_info
    if (( prompt_padding_size > 0 )); then
      local prompt_padding
      eval "prompt_padding=\${(l:${prompt_padding_size}::${prompt_hyphen}:)_empty_zz}"
      prompt_line_1="$prompt_line_1a$prompt_padding$prompt_hyphen%F{$prompt_color1}$prompt_hyphen$prompt_line_1b"
    else
        prompt_padding_size=$(( COLUMNS - prompt_line_1a_width - 2 ))

        # Didn't fit; try to fit in long path and vcs_info
        if (( prompt_padding_size > 0 )); then
            local prompt_padding
            eval "prompt_padding=\${(l:${prompt_padding_size}::${prompt_hyphen}:)_empty_zz}"
            prompt_line_1="$prompt_line_1a$prompt_padding$prompt_hyphen%F{$prompt_color1}$prompt_hyphen"
        else
            prompt_padding_size=$(( COLUMNS - prompt_line_1a_width ))

            # Didn't fit; try to fit in just long path
            if (( prompt_padding_size > 0 )); then
                eval "prompt_padding=\${(l:${prompt_padding_size}::${prompt_hyphen}:)_empty_zz}"
                prompt_line_1="$prompt_line_1a$prompt_padding"
            else
                # Still didn't fit; truncate
                local prompt_pwd_size=$(( COLUMNS - 5 ))
                prompt_line_1="$prompt_tbox$prompt_l_paren%B%F{$prompt_color2}%$prompt_pwd_size<...<%~%<<$prompt_r_paren%b%F{$prompt_color1}$prompt_hyphen"
            fi
        fi
    fi

    # Main prompt
    PS1="$prompt_line_1$prompt_newline$prompt_line_2%B%F{red}${EXITCODE}%b%F{$prompt_color1}$prompt_hyphen%B%F{white}$prompt_char %b%f%k"
    # secondary prompt, printed when the shell needs more information to
    # complete a command.
    PS2="$prompt_line_2$prompt_bbox_to_mbox%B%F{white}%_> %b%f%k"
    # Selection prompt used within a select loop
    PS3="$prompt_line_2$prompt_bbox_to_mbox%B%F{white}?# %b%f%k"

}
precmd_functions+=( prompt_precmd )

# preexec() => a function running before every command
function prompt_preexec () {
    # set hostname if not running on host with name 'grml'
    if [[ -n "$HOSTNAME" ]] && [[ "$HOSTNAME" != $(hostname) ]] ; then
       NAME="@$HOSTNAME"
    fi
    # get the name of the program currently running and hostname of local machine
    # set screen window title if running in a screen
    if [[ "$TERM" == screen* ]] ; then
        # local CMD=${1[(wr)^(*=*|sudo|ssh|-*)]}       # don't use hostname
        local CMD="${1[(wr)^(*=*|sudo|ssh|-*)]}$NAME" # use hostname
        ESC_print ${CMD}
    fi
preexec_functions+=( prompt_preexec )
#    # adjust title of xterm
#    [[ ${NOTITLE} -gt 0 ]] && return 0
#    case $TERM in
#        (xterm*|rxvt*)
#            set_title "${(%):-"%n@%m:"}" "$1"
#            ;;
#    esac
}
