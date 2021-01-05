set -o vi
alias ls='ls -G'
alias ll='ls -al'

export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:$PATH"
eval "$(pyenv init -)"

alias man='env LANG=C man'

export PS1="[\[\e[1;34m\]\u\[\e[00m\]@\h:\W]\$ "
#---
#brew doctor でconfigに関するwarningを消す
#alias brew="PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin brew"
#---
#hyperでアイコンを表示する際の調整
function title {
    export TITLE_OVERRIDDEN=1
    PROMPT_COMMAND=''
    echo -ne "\033]0;"$*"\007"
}

case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${PWD##*/}\007"'
    show_command_in_title_bar()
    {
        if [[ "$TITLE_OVERRIDDEN" == 1 ]]; then return; fi
        case "$BASH_COMMAND" in
            *\033]0*)
                ;;
            *)
                echo -ne "\033]0;${BASH_COMMAND} - ${PWD##*/}\007"
                ;;
        esac
    }
    trap show_command_in_title_bar DEBUG
    ;;
*)
    ;;
esac
#---
# rbenv PATH
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
#---
#openssl for compiler
export PATH=/usr/local/opt/openssl/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/opt/openssl/lib:$LD_LIBRARY_PATH
export CPATH=/usr/local/opt/openssl/include:$CPATH
export LDFLAGS=-L/usr/local/opt/openssl/lib
export CPPFLAGS=-I/usr/local/opt/openssl/include
export PKG_CONFIG_PATH=/usr/local/opt/openssl/lib/pkgconfig:$PKG_CONFIG_PATH

#for java
export PATH=$PATH:/Library/Java/JavaVirtualMachines/openjdk-11.0.2.jdk/Contents/Home/bin
export JAVA_HOME=/Library/Java/JavaVirtualMachines/openjdk-11.0.2.jdk/Contents/Home

#for The Sleuth Kit
export LDFLAGS="-L/usr/local/opt/libpq/lib"
export CPPFLAGS="-I/usr/local/opt/libpq/include"
export PKG_CONFIG_PATH="/usr/local/opt/libpq/lib/pkgconfig"

export PATH=~/.composer/vendor/bin:/usr/local/opt/openssl/bin:/Users/hibiki/.rbenv/shims:/Users/hibiki/.rbenv/bin:/Users/hibiki/.rbenv/shims:/Users/hibiki/.pyenv/shims:/Users/hibiki/.pyenv/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/TeX/texbin:/Applications/Wireshark.app/Contents/MacOS:/Library/Java/JavaVirtualMachines/openjdk-11.0.2.jdk/Contents/Home/bin
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
source "$HOME/.cargo/env"
