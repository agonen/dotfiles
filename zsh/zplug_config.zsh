source ~/.zplug/init.zsh

# Make sure to use double quotes
zplug "zsh-users/zsh-history-substring-search"

# Use the package as a command
# And accept glob patterns (e.g., brace, wildcard, ...)
zplug "MichaelAquilina/zsh-autoswitch-virtualenv"


# Load if "if" tag returns true
zplug "lib/clipboard", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"


zplug "zsh-users/zsh-syntax-highlighting", defer:2


# General ZSH Plugins
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", from:github
zplug "zsh-users/zsh-history-substring-search", from:github, defer:2
zplug "djui/alias-tips", from:github


# SSH
zplug "hkupty/ssh-agent", from:github


# Git Plugins
zplug "plugins/git", from:oh-my-zsh
zplug "Seinh/git-prune", from:github



# Directory Navigation
#zplug "b4b4r07/enhancd", use:init.sh
#zplug "mollifier/anyframe"



# Pure Theme
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

zplug "hlissner/zsh-autopair", defer:2
zplug "MichaelAquilina/zsh-auto-notify"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose

