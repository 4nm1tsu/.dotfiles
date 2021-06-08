# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### added by myself
#history
# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history
# メモリに保存される履歴の件数
export HISTSIZE=1000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000
# 重複を記録しない
setopt hist_ignore_dups
# 開始と終了を記録
setopt EXTENDED_HISTORY

autoload -Uz compinit
compinit

#代替コマンドのエイリアス
if type "exa" > /dev/null 2>&1; then
    alias ll='exa -labgh --icons --color-scale'
    alias la='exa -abgh --icons'
    alias ls='exa -bgh --icons'
    alias lt='exa -T --icons'
    alias lg='exa -labgh --icons --git --color-scale'
else
    echo "'exa' is not installed."
fi
if type "bat" > /dev/null 2>&1; then
    #alias cat='bat'
else
    echo "'bat' is not installed."
fi
#if type "fd" > /dev/null 2>&1; then
#    #alias find='fd'
#else
#    echo "'fd' is not installed."
#fi
#if type "procs" > /dev/null 2>&1; then
#    #alias ps='procs'
#else
#    echo "'procs' is not installed."
#fi
if type "rg" > /dev/null 2>&1; then
    #alias grep='rg'
else
    echo "'ripgrep(rg)' is not installed."
fi
#if type "nvim" > /dev/null 2>&1; then
#    alias vim='nvim'
#    alias vi='nvim'
#fi

#xclipのエイリアス
alias xclip='xclip -sel clip'

#for42
#alias norminette=$HOME/.norminette/norminette.rb

export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/anaconda3/bin:$PATH
export PATH=$HOME/nh/install/games:$PATH
#export TERM='xterm-256color'
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

#export PYENV_ROOT="${HOME}/.pyenv"
#export PATH="${PYENV_ROOT}/bin:$PATH"
#if type "pyenv" > /dev/null 2>&1; then
#    eval "$(pyenv init -)"
#fi
#
## rbenv PATH
#export PATH="$HOME/.rbenv/bin:$PATH"
#if type "rbenv" > /dev/null 2>&1; then
#    eval "$(rbenv init -)"
#fi
#
#GOENV_DISABLE_GOPATH=1
#export GOENV_ROOT="$HOME/.goenv"
#export PATH="$GOENV_ROOT/bin:$PATH"
#if type "goenv" > /dev/null 2>&1; then
#    eval "$(goenv init -)"
#    export PATH="$GOROOT/bin:$PATH"
#    export PATH="$PATH:$GOPATH/bin"
#fi
#
#export PATH="$HOME/.phpenv/bin:$PATH"
#if type "phpenv" > /dev/null 2>&1; then
#    eval "$(phpenv init -)"
#fi

export PATH="$HOME/.anyenv/bin:$PATH"
if type "anyenv" > /dev/null 2>&1; then
    # === #1906 pyenv v1.2.27
    export PYENV_ROOT="$HOME/.anyenv/envs/pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    if command -v pyenv 1>/dev/null 2>&1; then
        eval "$(pyenv init -)"
    fi
    # ===
    export GOENV_DISABLE_GOPATH=1
    export GOPATH=$HOME/go
    export GOBIN=$GOPATH/bin
    export PATH=$PATH:$GOPATH/bin

    eval "$(anyenv init - --no-rehash)"
fi

#openssl for compiler
export PATH=/usr/local/opt/openssl/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/opt/openssl/lib:$LD_LIBRARY_PATH
export CPATH=/usr/local/opt/openssl/include:$CPATH
export LDFLAGS=-L/usr/local/opt/openssl/lib
export CPPFLAGS=-I/usr/local/opt/openssl/include
export PKG_CONFIG_PATH=/usr/local/opt/openssl/lib/pkgconfig:$PKG_CONFIG_PATH

#symfony
export PATH="$HOME/.symfony/bin:$PATH"

#poetry
export PATH=${HOME}/.poetry/bin:${PATH}

export PATH="/usr/local/sbin:$PATH"
alias brew="env PATH=${PATH//Users/username/.anyenv/envs/phpenv/shims:} brew"

### End of chunk by myself

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk

zplugin light zsh-users/zsh-autosuggestions
zplugin light romkatv/powerlevel10k
zplugin light zsh-users/zsh-completions
zplugin load zsh-users/zsh-syntax-highlighting

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#vim keymap
bindkey -v

#fzf関係
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if type "fzf" > /dev/null 2>&1; then
    if type "bat" > /dev/null 2>&1; then
        export FZF_DEFAULT_OPTS="--height 80% --layout=reverse --border --inline-info --preview 'bat  --color=always --style=header,grid --line-range :100 {}'"
    else
        export FZF_DEFAULT_OPTS="--height 80% --layout=reverse --border --inline-info --preview 'head -100 {}'"
    fi
    if type "rg" > /dev/null 2>&1; then
        export  FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
    fi
else
    echo "'fzf' is not installed."
fi
#git branch
alias -g B='`git branch --all | grep -v HEAD | fzf -m --preview "" | sed "s/.* //" | sed "s#remotes/[^/]*/##"`'
#file alias
alias -g F='`fzf`'
#cd
fcd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m --preview 'ls -al {} | head -200') &&
  cd "$dir"
}

alias glNoGraph='git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@"'
_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
_viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"

# fcoc_preview - checkout git commit with previews
fcoc() {
  local commit
  commit=$( glNoGraph |
    fzf --no-sort --reverse --tiebreak=index --no-multi \
        --ansi --preview="$_viewGitLogLine" ) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

# fshow_preview - git commit browser with previews
fshow() {
    glNoGraph |
        fzf --no-sort --reverse --tiebreak=index --no-multi \
            --ansi --preview="$_viewGitLogLine" \
                --header "enter to view, alt-y to copy hash" \
                --bind "enter:execute:$_viewGitLogLine   | less -R" \
                --bind "alt-y:execute:$_gitLogLineToHash | xclip"
			}

# man page culorize
man() {
        env \
                LESS_TERMCAP_mb=$(printf "\e[1;94m") \
                LESS_TERMCAP_md=$(printf "\e[1;94m") \
                LESS_TERMCAP_me=$(printf "\e[0m") \
                LESS_TERMCAP_se=$(printf "\e[0m") \
                LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
                LESS_TERMCAP_ue=$(printf "\e[0m") \
                LESS_TERMCAP_us=$(printf "\e[1;35m") \
                man "$@"
}

function ranger() {
    if [ -z "$RANGER_LEVEL" ]; then
        /usr/local/bin/ranger $@
    else
        exit
    fi
}
