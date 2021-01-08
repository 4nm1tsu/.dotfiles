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
- bashtop
- fzf
- tmux (2.5~)
- diff-so-fancy(npm)
- tig
- jq

## lsp
- 各lspのsettingの書き方は（どのlinterをonにするとか）lsp clientに依存する(https://github.com/prabirshrestha/vim-lsp/wiki/Servers)
- clangd
    - compile_flags.txtにオプションを`-std=c++17`のように改行区切りで羅列すれば反映される
- pip install 'python-language-server[all]'
- gem install solargraph
    - 各プロジェクトでbundlerで管理するgemは`bundle install --path ./vendor/bandler`とかしてから`solargraph config .`をしてやれば補完が効く
    - globalなgemはまず`yard gems`
    - `yard config --gem-install-yri`しておけば新しいgem入れた時に自動でやってくれる
    - デフォルトのsettingはこれ(https://solargraph.org/guides/configuration)

## ale
- golangci-lintはgo getじゃなくて各環境にあったbinaryをinstall
- norminette:`gem install --user --pre norminette`
    - pluginインストール後に`bash install.sh`(norminette.vimのシンボリックリンクを貼る)

## previm
- `~/.cache/dein/repos/github.com/previm/previm/preview/_/index.html`
- `~/.cache/dein/.cache/.vimrc/.dein/preview/_/index.html`
    - in `<head></head>`
    ```html
    <link type="text/css" href="../_/css/lib/mermaid.min.css" rel="stylesheet" media="all" />
    <!-- START -->
    <script src='https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML' async></script>
    <!-- END -->
    <style>
    ```
- `~/.cache/dein/repos/github.com/previm/previm/preview/_/js/previm.js`
- `~/.cache/dein/.cache/.vimrc/.dein/preview/_/js/previm.js`
    - in `function loadPreview()`
    ```js
      autoScroll('body', beforePageYOffset);
      style_header();
      // START
      MathJax.Hub.Config({ tex2jax: { inlineMath: [['$','$'], ["\\(","\\)"]] } });
      MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
      autoScroll('body');
      // END
    ```

## anyenv
- git clone https://github.com/znz/anyenv-update.git ~/.anyenv/plugins/anyenv-update
    - `anyenv update`で*envのupdateができるようになる
    - `goenv rehash`で~/go/{version}下のgo getしたbinaryのパスが通る(pathは`~/.anyenv/envs/goenv/shims`に通ってる)

## iceberg (ANSI)
! special
*.foreground:   #c6c8d1
*.background:   #161821
*.cursorColor:  #c6c8d1

! black
*.color0:       #272c42
*.color8:       #3d425b

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
*.color7:       #6b7089
*.color15:      #c6c8d1

## for Linux(Debian)
cp ./fonts.conf ~/.config/fontconfig/fonts.conf
fc-cache
reboot
