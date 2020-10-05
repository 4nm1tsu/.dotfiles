DOT_DIRECTORY=~/.dotfiles
FT_DIRECTORY=~/42tokyo
cd ${DOT_DIRECTORY}

failed=0
for f in .??*
do
  [ ${f} = ".git" ] && continue
  [ ${f} = ".gitignore" ] && continue
  if [[ ${f} =~ .*42$ ]]; then
    ln -snfv ${DOT_DIRECTORY}/${f} ${FT_DIRECTORY}/${f}
  elif [ ${f} = '.lvimrc' ]; then
    ln -snfv ${DOT_DIRECTORY}/${f} ${FT_DIRECTORY}/${f}
  else
    ln -snfv ${DOT_DIRECTORY}/${f} ${HOME}/${f}
    if [ $? -ne 0 ]; then
      failed=1
    fi
  fi
done
if [ $failed -eq 0 ]; then
  echo $(tput setaf 2)Deploy dotfiles complete!. ✔︎$(tput sgr0)
fi

failed=0
ln -snfv ${DOT_DIRECTORY}/norminette.vim ~/.cache/dein/repos/github.com/w0rp/ale/ale_linters/c/
if [ $? -ne 0 ]; then
  failed=1
fi
ln -snfv ${DOT_DIRECTORY}/norminette.vim ~/.cache/dein/.cache/.vimrc/.dein/ale_linters/c
if [ $? -ne 0 ]; then
  failed=1
fi
if [ $failed -eq 0 ]; then
  echo $(tput setaf 4)Deploy norminette.vim complete!. ✔︎$(tput sgr0)
fi
#ln -s ~/.vim $XDG_CONFIG_HOME/nvim
#ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim
#echo $(tput setaf 4)neovim config file linkage complete!. ✔︎$(tput sgr0)
