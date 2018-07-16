#!/bin/zsh

# See https://github.com/unixorn/awesome-zsh-plugins for zsh plugins

# location of oh-my-zsh
# TODO: Maybe something cleaner should be done with ansible variables
export ZPLUG_HOME="$GLOBALRC/../zplug"

# source zplug
source "$ZPLUG_HOME/init.zsh"

###############################################################################
# Plugins pre-configuration                                                   #
###############################################################################

### zsh-syntax-highlighting ###
# Choose enabled highlighters
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)


### powerlevel9k ###
# based on https://github.com/tonylambiris/dotfiles/blob/master/dot.zshrc

DEFAULT_FOREGROUND=006 DEFAULT_BACKGROUND=235
DEFAULT_COLOR=$DEFAULT_FOREGROUND

POWERLEVEL9K_MODE="nerdfont-complete"

POWERLEVEL9K_HOME_ICON=''
POWERLEVEL9K_HOME_SUB_ICON=''
POWERLEVEL9K_FOLDER_ICON=''

# Temporary disable directory shortening due to a bug
# TODO: Fix that
# POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
# POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_unique"

POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER=false

# Note : we use this segment only to display the username, but conditionally
DEFAULT_USER="toadjaune" # TODO : make this include root, and be configurable
POWERLEVEL9K_CONTEXT_TEMPLATE="\uF415 %n" # 
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"
POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"

POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="\uE0B4" # 
POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="%F{}|%f"
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="\uE0B6" # 
POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="%F{$(( $DEFAULT_BACKGROUND - 2 ))}|%f"

POWERLEVEL9K_PROMPT_ON_NEWLINE=true

POWERLEVEL9K_STATUS_VERBOSE=true
POWERLEVEL9K_STATUS_OK=false
POWERLEVEL9K_STATUS_HIDE_SIGNAME=true

POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="╭"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="╰\uF460 "

# NB : kubecontext module is sloooooow, so we execute it only when required
custom_kube(){
  if [[ $PWD =~ 'nestor' ]]; then
    local kubectl_version="$(kubectl version --client 2>/dev/null)"

    if [[ -n "$kubectl_version" ]]; then
      # Get the current Kubernetes config context's namespaece
      local k8s_namespace=$(kubectl config get-contexts --no-headers | grep '*' | awk '{print $5}')
      # Get the current Kuberenetes context
      local k8s_context=$(kubectl config current-context)

      if [[ -z "$k8s_namespace" ]]; then
        k8s_namespace="default"
      fi

      local k8s_final_text=""

      if [[ "$k8s_context" == "k8s_namespace" ]]; then
        # No reason to print out the same identificator twice
        k8s_final_text="$k8s_context"
      else
        k8s_final_text="$k8s_context/$k8s_namespace"
      fi

      echo "$k8s_final_text ⎈"
    fi
  fi
}
POWERLEVEL9K_CUSTOM_KUBE="custom_kube"
POWERLEVEL9K_CUSTOM_KUBE_BACKGROUND="magenta"
POWERLEVEL9K_CUSTOM_KUBE_FOREGROUND="white"

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator host context dir_writable dir vcs rbenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(custom_kube command_execution_time background_jobs virtualenv status time ssh)

POWERLEVEL9K_VCS_CLEAN_BACKGROUND="green"
POWERLEVEL9K_VCS_CLEAN_FOREGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="yellow"
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="magenta"
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="$DEFAULT_BACKGROUND"

POWERLEVEL9K_DIR_HOME_BACKGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_DIR_HOME_FOREGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND="$DEFAULT_BACKGROUND"

POWERLEVEL9K_STATUS_OK_FOREGROUND="green"
POWERLEVEL9K_STATUS_OK_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"

POWERLEVEL9K_STATUS_ERROR_FOREGROUND="red"
POWERLEVEL9K_STATUS_ERROR_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"

POWERLEVEL9K_HISTORY_FOREGROUND="$DEFAULT_FOREGROUND"

POWERLEVEL9K_TIME_FORMAT="%D{%T \uF017}" #  15:29:33
POWERLEVEL9K_TIME_FOREGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_TIME_BACKGROUND="$DEFAULT_BACKGROUND"

POWERLEVEL9K_VCS_GIT_GITHUB_ICON=""
POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON=""
POWERLEVEL9K_VCS_GIT_GITLAB_ICON=""
POWERLEVEL9K_VCS_GIT_ICON=""

POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_EXECUTION_TIME_ICON="\u23F1" # ⏱

POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND="$DEFAULT_FOREGROUND"

POWERLEVEL9K_USER_ICON="\uF415" # 
POWERLEVEL9K_USER_DEFAULT_FOREGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_USER_DEFAULT_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"
POWERLEVEL9K_USER_ROOT_FOREGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_USER_ROOT_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"

POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND="red"
POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND="$(( $DEFAULT_BACKGROUND - 2 ))"
POWERLEVEL9K_ROOT_ICON=$'\uF198' # 

POWERLEVEL9K_SSH_FOREGROUND="yellow"
POWERLEVEL9K_SSH_BACKGROUND="$(( $DEFAULT_BACKGROUND - 2 ))"
POWERLEVEL9K_SSH_ICON="\uF489" # 

POWERLEVEL9K_HOST_LOCAL_FOREGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_HOST_LOCAL_BACKGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_HOST_REMOTE_FOREGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_HOST_REMOTE_BACKGROUND="$DEFAULT_BACKGROUND"

POWERLEVEL9K_HOST_ICON_FOREGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_HOST_ICON_BACKGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_HOST_ICON="\uF109" # 

POWERLEVEL9K_OS_ICON_FOREGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_OS_ICON_BACKGROUND="$DEFAULT_BACKGROUND"

POWERLEVEL9K_LOAD_CRITICAL_BACKGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_LOAD_WARNING_BACKGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_LOAD_NORMAL_BACKGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND="red"
POWERLEVEL9K_LOAD_WARNING_FOREGROUND="yellow"
POWERLEVEL9K_LOAD_NORMAL_FOREGROUND="green"
POWERLEVEL9K_LOAD_CRITICAL_VISUAL_IDENTIFIER_COLOR="red"
POWERLEVEL9K_LOAD_WARNING_VISUAL_IDENTIFIER_COLOR="yellow"
POWERLEVEL9K_LOAD_NORMAL_VISUAL_IDENTIFIER_COLOR="green"

POWERLEVEL9K_BATTERY_LEVEL_BACKGROUND_COLOR="$DEFAULT_BACKGROUND"
POWERLEVEL9K_BATTERY_CHARGING_BACKGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_BATTERY_CHARGED_BACKGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_BATTERY_DISCONNECTED_BACKGROUND="$DEFAULT_BACKGROUND"

###############################################################################

### Zplug list of plugins ###

# Fish-like history-based suggestions
# zplug "zsh-users/zsh-autosuggestions"
# Waiting for the fork to be merged
# zplug "toadjaune/zsh-autosuggestions", at:compatibility-syntax-hl
zplug "toadjaune/zsh-autosuggestions", at:fix-vi-partial-accept # temporary

# Fish-like syntax highlighting
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# Community packaging of completions for common programs
zplug 'zsh-users/zsh-completions'

# We assume that if a prompt does not support 256 colors, it's probably
# a tty or some sort of prompt without proper support for glyphs
# It's not necessarily true but it's a good heuristic
if [[ $TERM =~ '256color' ]]; then
  # Powerlevel9k, prompt configuration
  zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme
else
  # Just load legacy prompt
  source zsh_prompt.zsh
fi

#############################

# TODO : Make this and update at deploy-time rather than run-time
# Needs https://github.com/zplug/zplug/issues/393
# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

###############################################################################
# Plugins post-configuration                                                  #
###############################################################################

### zsh-autosggestions ###
# Shift-Tab accepts current autosuggestion
bindkey '^[[Z' autosuggest-accept


### zsh-syntax-highlighting ###
# Main highlight configuration (not all available options)
ZSH_HIGHLIGHT_STYLES+=(
  unknown-token         'fg=red,bold'
  reserved-word         'fg=yellow'
  alias                 'fg=green,bold'
  builtin               'fg=green,bold'
  function              'fg=green,bold'
  command               'fg=green,bold'
  precommand            'fg=green'
  hashed-command        'fg=green'
  path                  'fg=blue,bold'
  path_prefix           'fg=blue'
  path_approx           'fg=blue,underlined'
  globbing              'fg=yellow,underlined'
  single-hyphen-option  'fg=purple,bold'
  double-hyphen-option  'fg=purple,bold'
  back-quoted-argument  'fg=purple,bold'
  default               'fg=cyan,bold'
)
###############################################################################

