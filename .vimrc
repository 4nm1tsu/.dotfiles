"起動時にカーソル形状を問い合わせるシーケンスが出ないようにする（for mac "iterm2）
set t_RC=

"tab間の移動
nmap <silent><Space>t :tabe<CR>
nmap <silent><Space>j :-tabmove<CR>
nmap <silent><Space>k :+tabmove<CR>
nmap <silent><C-k> :tabnext<CR>
nmap <silent><C-j> :tabprevious<CR>

"行番号のハイライト
"set cursorline
augroup vimrc-auto-cursorline
  autocmd!
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
  autocmd WinEnter * call s:auto_cursorline('WinEnter')
  autocmd WinLeave * call s:auto_cursorline('WinLeave')

  let s:cursorline_lock = 0
  function! s:auto_cursorline(event)
    if a:event ==# 'WinEnter'
      setlocal cursorline
      let s:cursorline_lock = 2
    elseif a:event ==# 'WinLeave'
      setlocal nocursorline
    elseif a:event ==# 'CursorMoved'
      if s:cursorline_lock
        if 1 < s:cursorline_lock
          let s:cursorline_lock = 1
        else
          setlocal nocursorline
          let s:cursorline_lock = 0
        endif
      endif
    elseif a:event ==# 'CursorHold'
      setlocal cursorline
      let s:cursorline_lock = 1
    endif
  endfunction
augroup END

"起動時メッセージ出さない
set shortmess+=I

"横のスクロールを細かく
set sidescroll=1

"nomalに戻る時の遅延をなくす
"set ttimeoutlen=50

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
filetype plugin indent on

""c/c++/javaインデント設定
"augroup vimrc
"    " 以前の autocmd コマンドをクリア
"    autocmd!
"
"    " C/C++/Java 言語系のファイルタイプが設定されたら cindent モードを有効にする
"    autocmd FileType c,cpp,java  setl cindent
"augroup END

"行番号表示
set number

set fileencoding=utf-8 " 保存時の文字コード
set fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac " 改行コードの自動判別. 左側が優先される
"set ambiwidth=double " □や○文字が崩れる問題を解決

set incsearch " インクリメンタルサーチ. １文字入力毎に検索を行う
"set noignorecase " 検索パターンに大文字小文字を区別する
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

"----------------------------------------------------------
" タブ・インデント
"----------------------------------------------------------
set expandtab " タブ入力を複数の空白入力に置き換える
set tabstop=4 " 画面上でタブ文字が占める幅
set softtabstop=4 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent " 改行時に前の行のインデントを継続する
set smartindent " 改行時に前の行の構文をチェックし次の行のインデントを増減する
set shiftwidth=4 " smartindentで増減する幅
"c,cppのインデント幅デフォルトは2
augroup c
    autocmd!
    autocmd BufNewFile,BufRead *.c,*.cpp setl softtabstop=2
    autocmd BufNewFile,BufRead *.c,*.cpp setl shiftwidth=2
augroup END

augroup vimrc-42
    autocmd!
    autocmd BufNewFile,BufRead ~/42tokyo/*/*.c set noexpandtab
    autocmd BufNewFile,BufRead ~/42tokyo/*/*.c set tabstop=2
augroup END
"goのときはハードタブに
au BufNewFile,BufRead *.go set noexpandtab

"数行余裕を持たせてスクロールする
:set scrolloff=7

"クリップボードをつかえるようにする
set clipboard+=unnamed

"backspaceを有効に
set backspace=indent,eol,start

" deinの設定
if &compatible
  set nocompatible
endif
" dein自体の自動インストール
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('itchyny/lightline.vim')
  call dein#add('cohama/lexima.vim')
  call dein#add('w0rp/ale')
  call dein#add('scrooloose/nerdtree')
  call dein#add('tiagofumo/vim-nerdtree-syntax-highlight')
  call dein#add('Xuyuanp/nerdtree-git-plugin')
  call dein#add('ryanoasis/vim-devicons')
  call dein#add('airblade/vim-gitgutter')
  call dein#add('tpope/vim-fugitive')
  call dein#add('gorodinskiy/vim-coloresque')
  call dein#add('mattn/emmet-vim')
  call dein#add('sheerun/vim-polyglot')
  call dein#add('prabirshrestha/async.vim')
  call dein#add('prabirshrestha/vim-lsp', { 'depends': 'async.vim' })
  call dein#add('mattn/vim-lsp-settings')
  call dein#add('prabirshrestha/asyncomplete.vim')
  call dein#add('prabirshrestha/asyncomplete-lsp.vim')
  call dein#add('prabirshrestha/asyncomplete-file.vim')
  call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
  call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })
  call dein#add('liuchengxu/vista.vim', { 'depends': 'prabirshrestha/vim-lsp' })
  call dein#add('SirVer/ultisnips')
  call dein#add('thomasfaingnaert/vim-lsp-snippets')
  call dein#add('thomasfaingnaert/vim-lsp-ultisnips', { 'depends': [
              \'prabirshrestha/vim-lsp',
              \'thomasfaingnaert/vim-lsp-snippets',]})
"  call dein#add('honza/vim-snippets', { 'depends': 'SirVer/ultisnips' })
  call dein#add('alvan/vim-closetag')
  call dein#add('Yggdroot/indentLine')
  call dein#add('cocopon/iceberg.vim')
  call dein#add('pbondoer/vim-42header')
"  if !has('nvim')
"    call dein#add('roxma/nvim-yarp')
"    call dein#add('roxma/vim-hug-neovim-rpc')
"  endif

  call dein#end()
  call dein#save_state()
endif
" 不足プラグインの自動インストール
if has('vim_starting') && dein#check_install()
  call dein#install()
endif

colorscheme iceberg
syntax on
let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
set termguicolors
if has('nvim')
    set pumblend=20
endif
"if !has('nvim')
"    set term=xterm-256color
"endif

"'gitbranch'は長くなるので非推奨
"lightLineの設定
let g:lightline = {
      \ 'colorscheme': 'iceberg',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'gitstatus', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'gitstatus': 'MyGitGutter',
      \   'filetype' : 'MyFiletype',
      \   'fileformtat' : 'MyFileformat',
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

  function! MyFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
  endfunction
  
  function! MyFileformat()
    return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
  endfunction

"ステータスラインの設定
set laststatus=2 " ステータスラインを常に表示
set showmode " 現在のモードを表示
set showcmd " 打ったコマンドをステータスラインの下に表示
set ruler " ステータスラインの右側にカーソルの現在位置を表示する

""ファイル名が指定されてVIMが起動した場合はNERDTreeを表示しない
autocmd StdinReadPre * let s:std_in=1
""ファイル名が指定されなかったらNERDTreeを起動
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"他のバッファをすべて閉じた時にNERDTreeが開いていたらNERDTreeも一緒に閉じる。
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
""NERDTreeを表示するコマンドを設定する
"map <C-n> :NERDTreeToggle<CR>
map <silent><C-n> :call ToggleNERDTreeFind()<CR>

"uをUの動作にremap
let g:NERDTreeMapUpdirKeepOpen='u'

let NERDTreeWinSize=40
let NERDTreeQuitOnOpen=1
let NERDTreeMinimalUI=1

"iterm2でhighlightが効かなかったり、bracketsが消えない場合に対応
"nerd-syntax-highlightが効かなくなったのでコメントアウト
"augroup nerdtreeconcealbrackets
"      autocmd!
"      autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\]" contained conceal containedin=ALL
"      autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\[" contained conceal containedin=ALL
"      autocmd FileType nerdtree setlocal conceallevel=3
"      autocmd FileType nerdtree setlocal concealcursor=nvic
"augroup END

function! ToggleNERDTreeFind()
    if g:NERDTree.IsOpen()
        execute ':NERDTreeClose'
    else
        "無名バッファ
        if @% == '' && s:GetBufByte() == 0
            execute ':NERDTreeToggle'
        "すでにファイルを開いている
        else
            execute ':NERDTreeFind'
        endif
    endif
endfunction
"標準入力にも対応
function! s:GetBufByte()
    let byte = line2byte(line('$') + 1)
    if byte == -1
        return 0
    else
        return byte - 1
    endif
endfunction

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
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "~",
    \ "Staged"    : "+",
    \ "Untracked" : "*",
    \ "Renamed"   : "»",
    \ "Unmerged"  : "=",
    \ "Deleted"   : "-",
    \ "Dirty"     : "×",
    \ "Clean"     : "ø",
    \ "Ignored"   : "!",
    \ "Unknown"   : "?"
    \ }
let g:NERDTreeShowIgnoredStatus = 1

"nerdtree-syntax-highlighting
"let g:NERDTreeHighlightFolders = 1 "完全一致を使用してフォルダーアイコンの強調表示を有効にします
"let g:NERDTreeLimitedSyntax = 1
let g:WebDevIconsDefaultFolderSymbolColor = "F5C06F" " sets the color for folders that did not match any rule
let g:WebDevIconsDefaultFileSymbolColor = "689FB6" " sets the color for files that did not match any rule

"devicons
set encoding=UTF-8
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
let g:DevIconsEnableFoldersOpenClose = 1
let NERDTreeDirArrowExpandable = "\u00a0"
let NERDTreeDirArrowCollapsible = "\u00a0"
let NERDTreeNodeDelimiter = "\x07"
"for indetation alignment
let g:indentLine_fileTypeExclude = ["nerdtree"]
"let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol = ''
"let g:DevIconsDefaultFolderOpenSymbol = ''
set statusline=%f\ %{WebDevIconsGetFileTypeSymbol()}\ %h%w%m%r\ %=%(%l,%c%V\ %Y\ %=\ %P%)

"git-gutter
set updatetime=100

let g:ale_linters = {
    \ 'c': [],
    \ 'cpp': [],
    \ 'php': ['phpcs', 'php', 'phpstan'],
    \ 'python': [],
    \ 'ruby': [],
    \ 'go': ['golangci-lint'],
    \ }
let g:ale_fix_on_save = 0
let g:ale_fixers = {
    \ 'go': ['gofmt', 'goimports'],
    \ 'php': ['php_cs_fixer'],
    \ }
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_sign_info = ''
let g:ale_sign_style_error = ''
let g:ale_sign_style_warning = ''
let g:ale_php_phpcs_standard = 'PSR12'
let g:ale_cpp_clang_options = "-std=c++14 -Wall"
let g:ale_cpp_gcc_options = "-std=c++14 -Wall"
"eslint,phpcsは特に設定しなくてもローカルのものが動く
".gitが存在すればphpstanはローカルで動く
let g:ale_php_phpstan_executable = system('if ! type git &> /dev/null; then echo -n phpstan; else PSE=`git rev-parse --show-toplevel 2> /dev/null`/vendor/bin/phpstan; if [ -x "$PSE" ]; then echo -n $PSE; else echo -n phpstan; fi; fi')
"let g:ale_php_phpstan_level = 4
"エラー間の移動
nmap <silent> [a <Plug>(ale_previous_wrap)
nmap <silent> ]a <Plug>(ale_next_wrap)
"ale

"vim-lsp
let g:lsp_async_completion = 1
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
"バーチャルテキストとしてエラーなどを表示
let g:lsp_virtual_text_enabled = 0
let g:lsp_signs_error = {'text': ''}
let g:lsp_signs_warning = {'text': ''}
let g:lsp_signs_information = {'text': ''}
let g:lsp_signs_hint = {'text': ''}
nnoremap <silent> ]e  :LspNextError<CR>
nnoremap <silent> [e  :LspPreviousError<CR>
nmap <silent> ]dd :LspDefinition <CR>
nmap <silent> ]ds :leftabove LspDefinition <CR>
nmap <silent> ]dv :rightbelow vertical LspDefinition <CR>
nmap <silent> [dd :LspTypeDefinition <CR>
nmap <silent> [ds :leftabove LspTypeDefinition <CR>
nmap <silent> [dv :rightbelow vertical LspTypeDefinition <CR>
nmap <silent> <C-h> :LspHover <CR>
nmap <silent> <Space>r :LspReferences <CR>
nmap <silent> <Space>f :LspDocumentFormat<CR>
nmap <silent> <Space>F :ALEFix<CR>
vmap <silent> <Space>f :LspDocumentRangeFormat <CR>

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

"fzf
nnoremap <silent> <C-f> :Files<CR>
"ファイル名が指定されなかったらfzf起動できるようにしたい

"vista
let g:vista_default_executive = 'vim_lsp'
let g:vista_sidebar_sidth = 80
let g:vista_echo_cursor = 0
nnoremap <silent> <Space>v :Vista!!<CR>

let g:vista_icon_indent = ["󳄀󳄂 ", "󳄁󳄂 "]
let g:vista#renderer#icons = {
            \ 'func':           "\Uff794",
            \ 'function':       "\Uff794",
            \ 'functions':      "\Uff794",
            \ 'var':            "\Uff71b",
            \ 'variable':       "\Uff71b",
            \ 'variables':      "\Uff71b",
            \ 'const':          "\Uff8ff",
            \ 'constant':       "\Uff8ff",
            \ 'method':         "\Uff6a6",
            \ 'package':        "\Ufe612",
            \ 'packages':       "\Ufe612",
            \ 'enum':           "\Uff8bc",
            \ 'enumerator':     "\Uff8bc",
            \ 'module':         "\Uff668",
            \ 'modules':        "\Uff668",
            \ 'type':           "\Uff779",
            \ 'typedef':        "\Uff779",
            \ 'types':          "\Uff779",
            \ 'field':          "\Uff93d",
            \ 'fields':         "\Uff93d",
            \ 'macro':          "\Uff8a3",
            \ 'macros':         "\Uff8a3",
            \ 'map':            "\Uffb44",
            \ 'class':          "\Uff9a9",
            \ 'augroup':        "\Uffb44",
            \ 'struct':         "\Uffb44",
            \ 'union':          "\Uffacd",
            \ 'member':         "\Uffa55",
            \ 'target':         "\Uff893",
            \ 'property':       "\Uffab6",
            \ 'interface':      "\Uffa52",
            \ 'namespace':      "\Uff954",
            \ 'subroutine':     "\Uff915",
            \ 'implementation': "\Uff87a",
            \ 'typeParameter':  "\Uff950",
            \ 'default':        "\Uff923"
            \ }
"asyncomplete-file
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'whitelist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))

"pylsのlinter
"if executable('pyls')
"    au User lsp_setup call lsp#register_server({
"        \ 'name': 'pyls',
"        \ 'cmd': {server_info->['pyls']},
"        \ 'whitelist': ['python'],
"        \ 'workspace_config': {'pyls': {'plugins': {
"        \ 'pydocstyle': {'enabled': v:false},
"        \ 'pylint': {'enabled': v:true},
"        \ 'flake8': {'enabled': v:true},
"        \ 'pycodestyle': {'enabled': v:false},
"        \ 'autopep8': {'enabled': v:false},
"        \ 'yapf': {'enabled': v:false},
"        \ 'pyflakes': {'enabled': v:false},
"        \ 'mccabe': {'enabled': v:false},
"        \ }}}
"        \ })
"endif
