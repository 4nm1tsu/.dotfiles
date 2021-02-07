DOT_DIRECTORY=~/.dotfiles
FT_DIRECTORY=~/42tokyo
cd ${DOT_DIRECTORY}

failed=0
for f in .??*
do
  [ ${f} = ".git" ] && continue
  [ ${f} = ".gitignore" ] && continue
  if [[ ${f} =~ .*42$ ]]; then
    ln -snfv ${DOT_DIRECTORY}/${f} ${FT_DIRECTORY}/${f/_42/}
  elif [ ${f} = '.lvimrc' ]; then
    ln -snfv ${DOT_DIRECTORY}/${f} ${FT_DIRECTORY}/${f}
  else
    ln -snfv ${DOT_DIRECTORY}/${f} ${HOME}/${f}
    if [ $? -ne 0 ]; then
      failed=1
    fi
  fi
done
ln -snfv ${DOT_DIRECTORY}/coc-settings.json $XDG_CONFIG_HOME/nvim/coc-settings.json
if [ $? -ne 0 ]; then
  failed=1
fi
if [ $failed -eq 0 ]; then
  echo $(tput setaf 2)Deploy dotfiles complete!. ✔︎$(tput sgr0)
fi

failed=0
#ln -snfv ${DOT_DIRECTORY}/norminette.vim ~/.cache/dein/repos/github.com/w0rp/ale/ale_linters/c/
ln -snfv ${DOT_DIRECTORY}/norminette.vim ~/.vim/plugged/ale/ale_linters/c
if [ $? -ne 0 ]; then
  failed=1
fi
#ln -snfv ${DOT_DIRECTORY}/norminette.vim ~/.cache/dein/.cache/.vimrc/.dein/ale_linters/c/
#ln -snfv ${DOT_DIRECTORY}/norminette.vim ~/.cache/dein/.cache/.vimrc/.dein/ale_linters/c/
#if [ $? -ne 0 ]; then
#  failed=1
#fi
#ln -snfv ${DOT_DIRECTORY}/norminette_cpp.vim ~/.cache/dein/repos/github.com/w0rp/ale/ale_linters/cpp/norminette.vim
ln -snfv ${DOT_DIRECTORY}/norminette_cpp.vim ~/.vim/plugged/ale/ale_linters/cpp/norminette.vim
if [ $? -ne 0 ]; then
  failed=1
fi
#ln -snfv ${DOT_DIRECTORY}/norminette_cpp.vim ~/.cache/dein/.cache/.vimrc/.dein/ale_linters/cpp/norminette.vim
#ln -snfv ${DOT_DIRECTORY}/norminette_cpp.vim ~/.cache/dein/.cache/.vimrc/.dein/ale_linters/cpp/norminette.vim
#if [ $? -ne 0 ]; then
#  failed=1
#fi
if [ $failed -eq 0 ]; then
  echo $(tput setaf 4)Deploy norminette.vim complete!. ✔︎$(tput sgr0)
fi

failed=0
ln -snfv ~/.vim $XDG_CONFIG_HOME/nvim
if [ $? -ne 0 ]; then
  failed=1
fi

ln -snfv ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim
if [ $? -ne 0 ]; then
  failed=1
fi

if [ $failed -eq 0 ]; then
  echo $(tput setaf 3)neovim config file linkage complete!. ✔︎$(tput sgr0)
fi

sed -i -e "s/call s:HL('CocHighlightText', s:palette.none, s:palette.bg1)/call s:HL('CocHighlightText', s:palette.none, s:palette.bg4)/g" ~/.vim/plugged/tokyonight-vim/colors/tokyonight.vim
