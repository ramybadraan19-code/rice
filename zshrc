# ~/.zsh/.zshrc

#==============================================================================

# ███████╗██╗  ██╗███████╗██╗         ███╗   ██╗██╗███╗   ██╗     ██╗ █████╗ 
# ██╔════╝██║  ██║██╔════╝██║         ████╗  ██║██║████╗  ██║     ██║██╔══██╗
# ███████╗███████║█████╗  ██║         ██╔██╗ ██║██║██╔██╗ ██║     ██║███████║
# ╚════██║██╔══██║██╔══╝  ██║         ██║╚██╗██║██║██║╚██╗██║██   ██║██╔══██╗
# ███████║██║  ██║███████╗███████╗    ██║ ╚████║██║██║ ╚████║╚█████╔╝██║  ██║
# ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝    ╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚════╝ ╚═╝  ╚═╝
                                                                            
#==============================================================================

# fastfetch
if command -v fastfetch &> /dev/null; then
    # Only run fastfetch if we're in an interactive shell
    if [[ $- == *i* ]]; then
        if [[ -d "$HOME/.local/share/fastfetch" ]]; then
            ffconfig=ascii-art
            fastfetch --config "$ffconfig"
            alias fastfetch='clr && fastfetch --config $ffconfig'
        else
            fastfetch
        fi
    fi

fi

# p10k cache config
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


############################################
# Download Zinit, if it's not there yet
############################################
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"


############################################
# Add in Powerlevel10k
############################################
zinit ice depth=1; zinit light romkatv/powerlevel10k

# قمة الـ Vi Mode إنه ملمسش الـ fzf
function zvm_after_init() {
  source /usr/share/fzf/key-bindings.zsh
}

############################################
# Add in zsh plugins
############################################
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light jeffreytse/zsh-vi-mode

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
# zinit snippet OMZP::tmuxinator
# zinit snippet OMZP::docker
zinit snippet OMZP::command-not-found

# Disable the cursor style feature
# ZVM_CURSOR_STYLE_ENABLED=false
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.zsh/.p10k.zsh ]] || source ~/.zsh/.p10k.zsh


#######################################################
# ZSH Basic Options
#######################################################
setopt autocd               # change directory just by typing its name
setopt correct               # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst      # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch            # hide error message if there is no match for the pattern
setopt notify               # report the status of background jobs immediately
setopt numericglobsort      # sort filenames numerically when it makes sense
setopt promptsubst          # enable command substitution in prompt


#######################################################
# Environment Variables
#######################################################
# export EDITOR=nvim
# export VISUAL=nvim
export EDITOR=nvim visudo
export VISUAL=nvim visudo
export SUDO_EDITOR=nvim
export FCEDIT=nvim
export BROWSER=com.brave.Browser

if [[ -x "$(command -v bat)" ]]; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export PAGER=bat
fi


#######################################################
# ZSH Keybindings
#######################################################
bindkey -v
# bindkey '^p' history-search-backward
# bindkey '^n' history-search-forward
# bindkey '^[w' kill-region
# bindkey ' ' magic-space                            # do history expansion on space
bindkey "^[[A" history-beginning-search-backward  # search history with up key
bindkey "^[[B" history-beginning-search-forward   # search history with down key


#######################################################
# History Configuration
#######################################################
HISTSIZE=10000
HISTFILE=~/.zsh/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


#######################################################
# Completion styling
#######################################################
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes


#######################################################
# ZSH Syntax highlighting
#######################################################
# source ~/.zsh/zsh-syntax-highlighting.zsh
# source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh


#######################################################
# eval functions
#######################################################
eval "$(thefuck --alias)" # thefu*k
eval "$(thefuck --alias hell)" # thefu*k
eval "$(thefuck --alias damn)" # thefu*k
eval "$(zoxide init zsh)"


#######################################################
# source alias and functions
#######################################################
source ~/.zsh/alias.zsh
source ~/.zsh/functions.zsh
source ~/.zsh/functions.sh

# --- FZF Integration Fix ---

# 1. التأكد من السورس
if [ -f /usr/share/fzf/key-bindings.zsh ]; then
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
fi

# 2. إجبار Ctrl+R إنه يشغل fzf (حتى لو فيه Vi Mode)
bindkey '^R' fzf-history-widget

# 3. التنسيق (عشان يظهر بالبرواز والألوان اللي بتحبها)
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded \
--color=fg:#c0caf5,bg:-1,hl:#bb9af7,fg+:#ffffff,bg+:#24283b,hl+:#7dcfff \
--color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff,marker:#9ece6a \
--color=border:#27a1b9"

# اختصار مخصص لـ zoxide عشان ميتخانقش مع zinit
alias zii='__zoxide_zi'

export LIBVA_DRIVER_NAME=i965

# opencode
export PATH=/home/ramy/.opencode/bin:$PATH

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
# <<< grok installer <<<
