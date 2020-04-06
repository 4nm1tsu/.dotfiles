# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### added by myself
#git auto-completion
if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
    source ~/.git-completion.bash
fi

if type "exa" > /dev/null 2>&1; then
    alias ll='exa -labgh --icons'
    alias la='exa -abgh --icons'
    alias ls='exa -bgh --icons'
    alias lt='exa -T --icons'
    alias lg='exa -labgh --icons --git'
fi
if type "bat" > /dev/null 2>&1; then
    alias cat='bat'
fi
if type "fd" > /dev/null 2>&1; then
    alias find='fd'
fi
if type "procs" > /dev/null 2>&1; then
    alias ps='procs'
fi
if type "rg" > /dev/null 2>&1; then
    alias grep='rg'
fi
#if type "nvim" > /dev/null 2>&1; then
#    alias vim='nvim'
#    alias vi='nvim'
#fi
#if type "gomi" > /dev/null 2>&1; then
#    alias rm='gomi'
#fi

#for42
export MAIL=hokada@student.42tokyo.jp

export PATH=$HOME/.composer/vendor/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/anaconda3/bin:$PATH
export PATH=$HOME/nh/install/games:$PATH
export TERM='xterm-256color'
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:$PATH"
eval "$(pyenv init -)"

# rbenv PATH
if type "rbenv" > /dev/null 2>&1; then
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
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
zplugin load zsh-users/zsh-syntax-highlighting

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#vim keymap
bindkey -v
