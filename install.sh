DOT_DIRECTORY=~/.dotfiles
FT_DIRECTORY=~/42tokyo
cd ${DOT_DIRECTORY}

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
  fi
done
echo $(tput setaf 2)Deploy dotfiles complete!. ✔︎$(tput sgr0)

ln -snfv ${DOT_DIRECTORY}/norminette.vim ~/.cache/dein/repos/github.com/w0rp/ale/ale_linters/c/
ln -snfv ${DOT_DIRECTORY}/norminette.vim ~/.cache/dein/.cache/.vimrc/.dein/ale_linters/c
echo $(tput setaf 4)Deploy norminette.vim complete!. ✔︎$(tput sgr0)
#ln -s ~/.vim $XDG_CONFIG_HOME/nvim
#ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim
#echo $(tput setaf 4)neovim config file linkage complete!. ✔︎$(tput sgr0)
