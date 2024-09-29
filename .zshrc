# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### added by myself
#history
if [[ -z $TMUX ]]; then
    # 履歴ファイルの保存先
    export HISTFILE=${HOME}/.zsh_history
    # メモリに保存される履歴の件数
    export HISTSIZE=1000
    # 履歴ファイルに保存される履歴の件数
    export SAVEHIST=100000
fi
# 重複を記録しない
setopt hist_ignore_dups
# 開始と終了を記録
setopt EXTENDED_HISTORY
# historyの共有
setopt share_history
# 余分な空白を削除
setopt hist_reduce_blanks

autoload -Uz compinit
compinit

#代替コマンドのエイリアス
if type "lsd" > /dev/null 2>&1; then
    alias ll='lsd -lga -S'
    alias la='lsd -a'
    alias ls='lsd'
    alias lt='lsd --tree'
    # alias lg='exa -labgh --icons --git --color-scale' # lsdのリリースを待つ<https://github.com/lsd-rs/lsd/pull/822>
else
    echo "'exa' is not installed."
fi
if type "rg" > /dev/null 2>&1; then
    #alias grep='rg'
else
    echo "'ripgrep(rg)' is not installed."
fi

# ac-library
if [[ -z $TMUX ]]; then
    export CPLUS_INCLUDE_PATH="$CPLUS_INCLUDE_PATH:$HOME/ac-library"
fi

function G() {
    [[ $1 ]] && filename=$1 || filename="main.cpp"
    command g++ -g -std=gnu++17 -Wall -Wextra -Wshadow -Wconversion -Wno-sign-conversion -Wfloat-equal -Wno-char-subscripts -ftrapv -fstack-protector-all -fsanitize=address,undefined ./$filename
}


#xclipのエイリアス
alias xclip='xclip -sel clip'

if [[ -z $TMUX ]]; then
    # cargo
    export PATH=$HOME/.cargo/bin:$PATH
    # XDG_BASE_DIRECTORY
    export XDG_CONFIG_HOME="$HOME/.config"
    export XDG_CACHE_HOME="$HOME/.cache"
fi

# anyenv
if [[ -z $TMUX ]]; then
    export PATH="$HOME/.anyenv/bin:$PATH"
fi
if type "anyenv" > /dev/null 2>&1; then
    if [[ -z $TMUX ]]; then
        export GOENV_DISABLE_GOPATH=1
        export GOPATH=$HOME/go
        export GOBIN=$GOPATH/bin
        export PATH=$PATH:$GOPATH/bin
    fi

    eval "$(anyenv init - --no-rehash)"
fi

#openssl for compiler
if [[ -z $TMUX ]]; then
    export PATH=/usr/local/opt/openssl/bin:$PATH
    export LD_LIBRARY_PATH=/usr/local/opt/openssl/lib:$LD_LIBRARY_PATH
    export CPATH=/usr/local/opt/openssl/include:$CPATH
    export LDFLAGS=-L/usr/local/opt/openssl/lib
    export CPPFLAGS=-I/usr/local/opt/openssl/include
    export PKG_CONFIG_PATH=/usr/local/opt/openssl/lib/pkgconfig:$PKG_CONFIG_PATH
fi

#symfony
if [[ -z $TMUX ]]; then
    export PATH="$HOME/.symfony/bin:$PATH"
fi

#poetry
if [[ -z $TMUX ]]; then
    export PATH=${HOME}/.poetry/bin:${PATH}
fi

if [[ -z $TMUX ]]; then
    export PATH="/usr/local/sbin:$PATH"
fi
alias brew="env PATH=${PATH//Users/username/.anyenv/envs/phpenv/shims:} brew"

### End of chunk by myself

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#vim keymap
bindkey -v

#fzf関係
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if type "fzf" > /dev/null 2>&1; then
    export RUNEWIDTH_EASTASIAN=0
    if [[ -z $TMUX ]]; then
        if type "bat" > /dev/null 2>&1; then
            export FZF_DEFAULT_OPTS="--height 80% --layout=reverse --border --inline-info --preview 'bat  --color=always --style=header,grid --line-range :100 {}'"
        else
            export FZF_DEFAULT_OPTS="--height 80% --layout=reverse --border --inline-info --preview 'head -100 {}'"
        fi
        if type "rg" > /dev/null 2>&1; then
            export  FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
        fi
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

# fco - checkout git branch/tag
fco() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi) || return
  git checkout $(awk '{print $2}' <<<"$target" )
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

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-completions
zinit load zsh-users/zsh-syntax-highlighting
