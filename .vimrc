"行番号のハイライト
set cursorline

"起動時メッセージ出さない
set shortmess+=I

"みため
syntax on


"nomalに戻る時の遅延をなくす
set ttimeoutlen=50

" 編集箇所のカーソルを記憶
if has("autocmd")
    augroup redhat
        " In text files, always limit the width of text to 78 characters
        autocmd BufRead *.txt set tw=78
        " When editing a file, always jump to the last cursor position
        autocmd BufReadPost *
                    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
                    \   exe "normal! g'\"" |
                    \ endif
    augroup END
endif

" ファイルタイプ検出を有効にする
filetype on

"c/c++/javaインデント設定
augroup vimrc
    " 以前の autocmd コマンドをクリア
    autocmd!

    " C/C++/Java 言語系のファイルタイプが設定されたら cindent モードを有効にする
    autocmd FileType c,cpp,java  setl cindent
    autocmd FileType c,cpp,java  setl expandtab tabstop=4 shiftwidth=4 softtabstop=4 shiftround
augroup END

"行番号表示
set number

set fileencoding=utf-8 " 保存時の文字コード
set fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac " 改行コードの自動判別. 左側が優先される
"set ambiwidth=double " □や○文字が崩れる問題を解決

set incsearch " インクリメンタルサーチ. １文字入力毎に検索を行う
set noignorecase " 検索パターンに大文字小文字を区別する
"set smartcase " 検索パターンに大文字を含んでいたら大文字小文字を区別する
set hlsearch " 検索結果をハイライト

set whichwrap=b,s,h,l,<,>,[,],~ " カーソルの左右移動で行末から次の行の行頭への移動が可能になる
set number " 行番号を表示

" 行が折り返し表示されていた場合、行単位ではなく表示行単位でカーソルを移動する
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk

set showmatch " 括弧の対応関係を一瞬表示する
source $VIMRUNTIME/macros/matchit.vim " Vimの「%」を拡張する(タグジャンプ)

set wildmenu "コマンドモードのタブ補完

"ペースト時、インデントが崩れないようにする    let &t_SI .=
if &term =~ "xterm"
let &t_ti .= "\e[?2004h"
let &t_te .= "\e[?2004l"
let &pastetoggle = "\e[201~"

function XTermPasteBegin(ret)
    set paste
    return a:ret
endfunction

noremap <special> <expr> <Esc>[200~ XTermPasteBegin("0i")
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
cnoremap <special> <Esc>[200~ <nop>
cnoremap <special> <Esc>[201~ <nop>
endif

"以下、NeoBundle雛形
if has('vim_starting')
    " 初回起動時のみruntimepathにNeoBundleのパスを指定する
    set runtimepath+=~/.vim/bundle/neobundle.vim/

    " NeoBundleが未インストールであればgit cloneする・・・・・・①
    if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
        echo "install NeoBundle..."
        :call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
    endif
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" インストールするVimプラグインを以下に記述
" NeoBundle自身を管理
NeoBundleFetch 'Shougo/neobundle.vim'
"----------------------------------------------------------
" ここに追加したいVimプラグインを記述する・・・・・・②


" ステータスラインの表示内容強化
NeoBundle 'itchyny/lightline.vim'
"NeoBundle 'bronson/vim-trailing-whitespace'
NeoBundle 'cohama/lexima.vim'
NeoBundle 'w0rp/ale'
"NeoBundle 'scrooloose/nerdtree'
"NeoBundle 'tiagofumo/vim-nerdtree-syntax-highlight'
"NeoBundle 'Xuyuanp/nerdtree-git-plugin'
"NeoBundle 'ryanoasis/vim-devicons'
NeoBundle 'Shougo/defx.nvim'
"NeoBundle 'roxma/nvim-yarp'
"NeoBundle 'roxma/vim-hug-neovim-rpc'
NeoBundle 'kristijanhusak/defx-icons'
NeoBundle 'kristijanhusak/defx-git'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'gorodinskiy/vim-coloresque'
NeoBundle 'prabirshrestha/async.vim'
NeoBundle 'prabirshrestha/vim-lsp'
NeoBundle 'mattn/vim-lsp-settings'
NeoBundle 'prabirshrestha/asyncomplete.vim'
NeoBundle 'prabirshrestha/asyncomplete-lsp.vim'
"colorscheme
NeoBundle 'cocopon/iceberg.vim'
NeoBundle 'popkirby/lightline-iceberg'


"----------------------------------------------------------
call neobundle#end()

colorscheme iceberg

" ファイルタイプ別のVimプラグイン/インデントを有効にする
filetype plugin indent on

" 未インストールのVimプラグインがある場合、インストールするかどうかを尋ねてくれるようにする設定・・・・・・③
NeoBundleCheck

"lightLineの設定
let g:lightline = {
      \ 'colorscheme': 'iceberg',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'gitbranch', 'gitstatus', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'gitstatus': 'MyGitGutter'
      \ },
      \ }

function! MyGitGutter()
  if ! exists('*GitGutterGetHunkSummary')
        \ || ! get(g:, 'gitgutter_enabled', 0)
        \ || winwidth('.') <= 90
    return ''
  endif
  let symbols = [
        \ g:gitgutter_sign_added . '',
        \ g:gitgutter_sign_modified . '',
        \ g:gitgutter_sign_removed . ''
        \ ]
  let hunks = GitGutterGetHunkSummary()
  let ret = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(ret, symbols[i] . hunks[i])
    endif
  endfor
  return join(ret, ' ')
endfunction

"ステータスラインの設定
set laststatus=2 " ステータスラインを常に表示
set showmode " 現在のモードを表示
set showcmd " 打ったコマンドをステータスラインの下に表示
set ruler " ステータスラインの右側にカーソルの現在位置を表示する

" NERDTreeのように左に表示する。現在のファイルの階層を開く。
" Defx `expand('%:p:h')` -search=`expand('%:p')`
nnoremap <silent><C-n> :<C-u>Defx`expand('%:p:h')` -search=`expand('%:p')<CR>

call defx#custom#column('icon', {
      \ 'directory_icon': '▸',
      \ 'opened_icon': '▾',
      \ })
call defx#custom#option('_', {
      \ 'winwidth': 40,
      \ 'split': 'vertical',
      \ 'direction': 'topleft',
      \ 'show_ignored_files': 0,
      \ 'buffer_name': 'defxplorer',
      \ 'toggle': 1,
      \ 'columns': 'indent:git:icon:icons:filename',
      \ 'resume': 1,
      \ })
call defx#custom#column('git', 'indicators', {
      \ "Modified"  : "~",
      \ "Staged"    : "+",
      \ "Untracked" : "*",
      \ "Renamed"   : "»",
      \ "Unmerged"  : "=",
      \ "Deleted"   : "-",
      \ "Ignored"   : "!",
      \ "Unknown"   : "?",
  \ })
call defx#custom#column('git', 'show_ignored', 0)
call defx#custom#column('git', 'max_indicator_width', 1)

autocmd FileType defx call s:defx_my_settings()
    function! s:defx_my_settings() abort
     " Define mappings
      nnoremap <silent><buffer><expr> <CR>
     \ defx#do_action('open_or_close_tree')
      nnoremap <silent><buffer><expr> o
     \ defx#do_action('drop')
      nnoremap <silent><buffer><expr> c
     \ defx#do_action('copy')
      nnoremap <silent><buffer><expr> m
     \ defx#do_action('move')
      nnoremap <silent><buffer><expr> p
     \ defx#do_action('paste')
      nnoremap <silent><buffer><expr> l
     \ defx#do_action('drop')
      nnoremap <silent><buffer><expr> E
     \ defx#do_action('open', 'vsplit')
      nnoremap <silent><buffer><expr> P
     \ defx#do_action('open', 'pedit')
      nnoremap <silent><buffer><expr> K
     \ defx#do_action('new_directory')
      nnoremap <silent><buffer><expr> N
     \ defx#do_action('new_file')
      nnoremap <silent><buffer><expr> d
     \ defx#do_action('remove')
      nnoremap <silent><buffer><expr> r
     \ defx#do_action('rename')
      nnoremap <silent><buffer><expr> x
     \ defx#do_action('execute_system')
      nnoremap <silent><buffer><expr> yy
     \ defx#do_action('yank_path')
      nnoremap <silent><buffer><expr> .
     \ defx#do_action('toggle_ignored_files')
      nnoremap <silent><buffer><expr> h
     \ defx#do_action('cd', ['..'])
      nnoremap <silent><buffer><expr> ~
     \ defx#do_action('cd')
      nnoremap <silent><buffer><expr> q
     \ defx#do_action('quit')
      nnoremap <silent><buffer><expr> <Space>
     \ defx#do_action('toggle_select') . 'j'
      nnoremap <silent><buffer><expr> *
     \ defx#do_action('toggle_select_all')
      nnoremap <silent><buffer><expr> j
     \ line('.') == line('$') ? 'gg' : 'j'
      nnoremap <silent><buffer><expr> k
     \ line('.') == 1 ? 'G' : 'k'
      nnoremap <silent><buffer><expr> <C-l>
     \ defx#do_action('redraw')
      nnoremap <silent><buffer><expr> <C-g>
     \ defx#do_action('print')
      nnoremap <silent><buffer><expr> cd
     \ defx#do_action('change_vim_cwd')
    endfunction

""ファイル名が指定されてVIMが起動した場合はNERDTreeを表示しない
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
""NERDTreeを表示するコマンドを設定する
"map <C-n> :NERDTreeToggle<CR>

"nerdtree-git-plugin
"let g:NERDTreeIndicatorMapCustom = {
"    \ "Modified"  : "",
"    \ "Staged"    : "",
"    \ "Untracked" : "",
"    \ "Renamed"   : "",
"    \ "Unmerged"  : "",
"    \ "Deleted"   : "",
"    \ "Dirty"     : "",
"    \ "Clean"     : "",
"    \ "Ignored"   : "",
"    \ "Unknown"   : ""
"    \ }
"let g:NERDTreeIndicatorMapCustom = {
"    \ "Modified"  : "~",
"    \ "Staged"    : "+",
"    \ "Untracked" : "*",
"    \ "Renamed"   : "»",
"    \ "Unmerged"  : "=",
"    \ "Deleted"   : "-",
"    \ "Dirty"     : "×",
"    \ "Clean"     : "ø",
"    \ "Ignored"   : "!",
"    \ "Unknown"   : "?"
"    \ }
"let g:NERDTreeShowIgnoredStatus = 1
"
""nerdtree-syntax-highlighting
"let g:NERDTreeLimitedSyntax = 1

"devicons
set encoding=UTF-8

"git-gutter
set updatetime=100

"----------------------------------------------------------
" タブ・インデント
"----------------------------------------------------------
set expandtab " タブ入力を複数の空白入力に置き換える
set tabstop=4 " 画面上でタブ文字が占める幅
set softtabstop=4 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent " 改行時に前の行のインデントを継続する
set smartindent " 改行時に前の行の構文をチェックし次の行のインデントを増減する
set shiftwidth=4 " smartindentで増減する幅

"数行余裕を持たせてスクロールする
:set scrolloff=7

"クリップボードをつかえるようにする
set clipboard+=unnamed

"backspaceを有効に
set backspace=indent,eol,start

let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_sign_info = ''
let g:ale_sign_style_error = ''
let g:ale_sign_style_warning = ''
let g:ale_php_phpcs_standard = 'Symfony'
let g:ale_cpp_clang_options = "-std=c++14 -Wall"
let g:ale_cpp_gcc_options = "-std=c++14 -Wall"
"eslint,phpcsは特に設定しなくてもローカルのものが動く
".gitが存在すればphpstanはローカルで動く
let g:ale_php_phpstan_executable = system('if ! type git &> /dev/null; then echo phpstan; else PSE=`git rev-parse --show-toplevel 2> /dev/null`/vendor/bin/phpstan; if [ -x "$PSE" ]; then echo -n $PSE; else echo phpstan; fi; fi')
let g:ale_php_phpstan_level = 4
"エラー間の移動
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
"ale

"vim-lsp
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_signs_error = {'text': ''}
let g:lsp_signs_warning = {'text': ''}
let g:lsp_signs_information = {'text': ''}
let g:lsp_signs_hint = {'text': ''}
nnoremap <silent> ]e  :LspNextError<CR>
nnoremap <silent> [e  :LspPreviousError<CR>
nmap <silent> ]dd :LspDefinition <CR>
nmap <silent> ]ds :split \| :LspDefinition <CR>
nmap <silent> ]dv :vsplit \| :LspDefinition <CR>
nmap <silent> [dd :LspTypeDefinition <CR>
nmap <silent> [ds :split \| :LspTypeDefinition <CR>
nmap <silent> [dv :vsplit \| :LspTypeDefinition <CR>
nmap <silent> <C-h> :LspHover <CR>

"git-fugitive
nnoremap <Space>gs :tab sp<CR>:Gstatus<CR>:only<CR>
nnoremap <Space>ga :Gwrite<CR>
nnoremap <Space>gc :Gcommit<CR>
nnoremap <Space>gb :Gblame<CR>
nnoremap <Space>gl :Git log<CR>
nnoremap <Space>gh :tab sp<CR>:0Glog<CR>
nnoremap <Space>gp :Gpush<CR>
nnoremap <Space>gf :Gfetch<CR>
nnoremap <Space>gd :Gvdiff<CR>
nnoremap <Space>gr :Grebase -i<CR>
nnoremap <Space>gg :Ggrep
nnoremap <Space>gm :Gmerge
