# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
compinit

#
#	In the user folder, we have the .bin folder where all the custom executables
#	are located, like bash scripts etc. And we add the folder to the global
#	path, so everything that goes there can be called anywhere in the system.
#
export PATH="$PATH:~/.bin"

#
#	Enable basic mouse support in nano, so we can scroll around.
#
alias nano='nano --mouse'

#
#	Add the functionality to hit ctrl+r to search CLI history
#
bindkey "^R" history-incremental-search-backward

#
#	If the PROMPT_SUBST option is set, the prompt string is first subjected to
#	parameter expansion, command substitution and arithmetic expansion.
#
setopt PROMPT_SUBST

#
#	This function will try to get the active branch if a git repo is found
#
function parse_git_branch {
   git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

#
#	Prompt customization.
#
PROMPT=' > [%F{yellow}%n%f] [%F{yellow}%m%f] [%F{yellow}%1~%f] [%F{yellow}$(parse_git_branch)%f]: '

#
#   Provide the path for NodeJS location.
#
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion