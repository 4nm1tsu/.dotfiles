# .dotfiles

## appendics

- aleは非同期実行されないlinterもあるよ(<https://github.com/dense-analysis/ale/blob/master/supported-tools.md>)
- vim-lspのローカルインストールされないランゲージサーバはここを参照されたし(<https://github.com/mattn/vim-lsp-settings#user-content-supported-languages>)
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

- 各lspのsettingの書き方は（どのlinterをonにするとか）lsp clientに依存する(<https://github.com/prabirshrestha/vim-lsp/wiki/Servers>)
- clangd
  - compile_flags.txtにオプションを`-std=c++17`のように改行区切りで羅列すれば反映される
- pip install 'python-language-server[all]'
- gem install solargraph
  - 各プロジェクトでbundlerで管理するgemは`bundle install --path ./vendor/bandler`とかしてから`solargraph config .`をしてやれば補完が効く
  - globalなgemはまず`yard gems`
  - `yard config --gem-install-yri`しておけば新しいgem入れた時に自動でやってくれる
  - デフォルトのsettingはこれ(<https://solargraph.org/guides/configuration>)

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

- git clone <https://github.com/znz/anyenv-update.git> ~/.anyenv/plugins/anyenv-update
  - `anyenv update`で*envのupdateができるようになる
  - `goenv rehash`で~/go/{version}下のgo getしたbinaryのパスが通る(pathは`~/.anyenv/envs/goenv/shims`に通ってる)
  - `nodenv rehash`なら`~/.anyenv/envs/nodenv/shims`

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

## conky

`conky-colors --theme=wine --lang=en --cpu=4 --network --wlan=0 --hd=default  --nvidia --hd=default --proc=10 --nodata --dark`

- GPU2DClockFreqsをGPUCurrentClockFreqsに書き換え(<https://github.com/NVIDIA/nvidia-settings/blob/master/src/parse.c>)
  - その後パイプラインでcut -d ',' -f 1でGPUClockだけ取得
- wlan0をnmcli dev statusの結果に書き換え
- own_window_type dock とすればshow desktopしても消えない
- desktop sessionからからのセッションで開始を選択(もしくはconkyを除外)

```bash
#!/bin/bash
sleep 3
/usr/bin/conky -c /home/hibiki/.conkycolors/conkyrc&
```

## pulseaudio

`pulseaudio -k`でリセット
`/etc/pulse/default.pa`の`load-module module-switch-on-port-available`をコメントアウト?
> <https://askubuntu.com/questions/1199496/sound-breaking-on-wakeup-from-sleep>

## steam

基本的にppaで
公式からインストールすることもできるが、i386(32bit)版が結局はいらないのでppaのほうがらく
事前にdebパッケージでインストールしている場合はsudo nvidia-uninstallで消せます

```bash
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo dpkg --add-architecture i386
sudo dpkg --print-foreignarchitecture #→i386が出ることを確認
dpkg -l #とかして、事前にnvidia関係のパッケージが入っていないことを確認する
```

そうでないとi386版がインストールされない
`sudo apt install nvidia-driver-455`

断片的な情報は手に入るが、適当にやるとGUIが起動しなくなったりしてだるい
libgl-mesa-dri libgl-mesa-glxしてしまったときとか

> <https://github.com/ValveSoftware/steam-for-linux/issues/7382>
> <https://askubuntu.com/questions/206283/how-can-i-uninstall-a-nvidia-driver-completely>

アプリがコンポジターをブロックすることを許可しない→steamのゲーム起動中に描画がしょぼくなる

## acc

- template.json

```json
{
 "task": {
  "program": [
   "main.cpp"
  ],
  "submit": "main.cpp"
 }
}
```

- main.cpp

```cpp
#include <atcoder/all>
#include <bits/stdc++.h>
using namespace atcoder;
using namespace std;
typedef long long ll;

int main() {
}
```

を`acc config-dir`出力下に保存

`acc config default-template cpp`
`acc config default-test-dirname-format test`
でグローバルのコンフィグ設定可能

### Tips. <bits/stdc++.h> on mac
gcc -vしたときのインクルードパスに
```
-I/usr/local/Cellar/gcc/11.2.0_3/bin/../lib/gcc/11/gcc/x86_64-apple-darwin19/11/include
-I/usr/local/Cellar/gcc/11.2.0_3/bin/../lib/gcc/11/gcc/x86_64-apple-darwin19/11/include-fixed
```
が含まれるが、上のパスをcompile_commands.txtに含めると
clangdがbuiltin_functionありませんよ的なエラーを吐いてだるい
