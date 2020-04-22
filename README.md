## appendics

- aleは非同期実行されないlinterもあるよ(https://github.com/dense-analysis/ale/blob/master/supported-tools.md)
- vim-lspのローカルインストールされないランゲージサーバはここを参照されたし(https://github.com/mattn/vim-lsp-settings#user-content-supported-languages)
- pylsはpipでグローバルインストールしないとmodule読み込んでくれない
- colorscheme_mod.txt内の修正をcolorschemeに加えると幸せになれる→その後~/.vim/colorsにコピーしないと反映されない

## requirements

(ignore)
- neovim0.4.3
- pip install neovim
- `:UpdateRemotePlugins` after launching nvim

## commands
- exa
- bat
- fd
- procs
- rg
- hexyl
- vtop(npm)
- fzf
- tmux (2.5~)
- diff-so-fancy(npm)
- tig

## lsp
- pip install 'python-language-server[all]'

## iceberg (ANSI)
! special
*.foreground:   #c6c8d1
*.background:   #121319
*.cursorColor:  #c6c8d1

! black
*.color0:       #161722
*.color8:       #373757

! red
*.color1:       #e27878
*.color9:       #f29b9e

! green
*.color2:       #b4be82
*.color10:      #ccdba0

! yellow
*.color3:       #e2a478
*.color11:      #edbe9d

! blue
*.color4:       #84a0c6
*.color12:      #a3bee3

! magenta
*.color5:       #a093c7
*.color13:      #c8b5e6

! cyan
*.color6:       #89b8c2
*.color14:      #b6d8de

! white
*.color7:       #d0d2db
*.color15:      #e9ebf5

## for Linux(Debian)
cp ./fonts.conf ~/.config/fontconfig/fonts.conf
fc-cache
reboot
