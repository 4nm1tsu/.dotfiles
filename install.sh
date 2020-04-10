DOT_DIRECTORY=~/.dotfiles
cd ${DOT_DIRECTORY}

for f in .??*
do
  [ ${f} = ".git" ] && continue
  [ ${f} = ".gitignore" ] && continue
  ln -snfv ${DOT_DIRECTORY}/${f} ${HOME}/${f}
done
echo $(tput setaf 2)Deploy dotfiles complete!. ✔︎$(tput sgr0)

#ln -s ~/.vim $XDG_CONFIG_HOME/nvim
#ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim
#echo $(tput setaf 4)neovim config file linkage complete!. ✔︎$(tput sgr0)
