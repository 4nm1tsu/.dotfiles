if &compatible
  set nocompatible
endif

"起動時にカーソル形状を問い合わせるシーケンスが出ないようにする（for mac "iterm2）
set t_RC=

"tab間の移動
nmap <silent><Space>t :tabe<CR>
nmap <silent><Space>j :-tabmove<CR>
nmap <silent><Space>k :+tabmove<CR>
nmap <silent><C-k> :tabnext<CR>
nmap <silent><C-j> :tabprevious<CR>

"行番号のハイライト
set cursorline

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

"行番号表示
" set number
set relativenumber

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

"goのときはハードタブに
au BufNewFile,BufRead *.go set noexpandtab

"数行余裕を持たせてスクロールする
:set scrolloff=7

"クリップボードをつかえるようにする
set clipboard+=unnamed

"backspaceを有効に
set backspace=indent,eol,start

"plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'cohama/lexima.vim'
Plug 'embear/vim-localvimrc'
Plug 'w0rp/ale'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'gorodinskiy/vim-coloresque'
Plug 'mattn/emmet-vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vista.vim'
Plug 'SirVer/ultisnips'
Plug 'thomasfaingnaert/vim-lsp-snippets'
Plug 'thomasfaingnaert/vim-lsp-ultisnips'
Plug 'dhaiibfiukkiu/previm'
Plug 'dhruvasagar/vim-table-mode'
Plug 'alvan/vim-closetag'
Plug 'Yggdroot/indentLine'
Plug 'cocopon/iceberg.vim'
Plug 'pbondoer/vim-42header'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Initialize plugin system
call plug#end()

colorscheme iceberg
syntax on
let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
set termguicolors

"popup透過
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
      \ 'tab_component_function': {
      \   'tabnum': 'LightlineWebDevIcons',
      \ }
      \ }

function! LightlineWebDevIcons(n)
  let l:bufnr = tabpagebuflist(a:n)[tabpagewinnr(a:n) - 1]
  return WebDevIconsGetFileTypeSymbol(bufname(l:bufnr))
endfunction

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
"    deprecated
let g:NERDTreeGitStatusIndicatorMapCustom = {
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

let g:NERDTreeGitStatusShowIgnored = 1

"nerdtree-syntax-highlighting
let g:WebDevIconsDefaultFolderSymbolColor = "F5C06F"
let g:WebDevIconsDefaultFileSymbolColor = "689FB6"

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
    \ 'html': ['eslint'],
    \ 'c': ['gcc'],
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
    \ 'javascript': ['eslint'],
    \ 'sql': ['sqlfmt'],
    \ }
" virtualtextにエラー表示
let g:ale_virtualtext_cursor = 1
let g:ale_virtualtext_prefix = '>>'
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_sign_info = ''
let g:ale_sign_style_error = ''
let g:ale_sign_style_warning = ''
let g:ale_php_phpcs_standard = 'PSR12'
let g:ale_c_clang_options = "-std=c11 -Wall -Werror -Wextra"
let g:ale_c_gcc_options = "-std=c11 -Wall -Werror -Wextra"
let g:ale_cpp_clang_options = "-std=c++14 -Wall -Werror -Wextra"
let g:ale_cpp_gcc_options = "-std=c++14 -Wall -Werror -Wextra"
let g:ale_sql_sqlfmt_options = '-u'
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
let g:lsp_virtual_text_prefix = '>'
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

"GitGutter
nnoremap <Space>gu :GitGutterUndoHunk<CR>

"fzf
nnoremap <silent> <C-f> :Files<CR>
"ファイル名が指定されなかったらfzf起動できるようにしたい
"escでタブが閉じるのが遅いので追加
autocmd FileType fzf tnoremap <buffer> <Esc> <Esc>

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

"modifyOtherKeysの問題で制御文字4;2mが出るのを抑制
let &t_TI = ""
let &t_TE = ""

"markdown
"Tex記法のみconcealする場合→微妙にうまくいかない
"let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_math = 1
"全てconcealしない場合
let g:vim_markdown_conceal=0
let g:vim_markdown_conceal_code_blocks = 0
let g:tex_conceal=''

"previm
if has('linux')
    let g:previm_open_cmd="google-chrome"
elseif has('mac')
    let g:previm_open_cmd="open -a safari"
endif
let g:previm_enable_realtime=1

"vim-table-mode
function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
          \ <SID>isAtStartOfLine('__') ?
          \ '<c-o>:silent! TableModeDisable<cr>' : '__'

"localvimrc
let g:localvimrc_ask=0

"起動時メッセージ出さない
set shortmess+=I

"時刻によってbackground colorを変更
let g:time_to_set_background = str2nr(strftime("%H%M%S"))
if (g:time_to_set_background >= 70000 && g:time_to_set_background < 160000)
    set background=light
else
    set background=dark
endif
