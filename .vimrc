"マウス無効化
set mouse=

"起動時にカーソル形状を問い合わせるシーケンスが出ないようにする（for mac "iterm2）
set t_RC=

"tab間の移動
nmap <silent><Space>t :tabe<CR>
nmap <silent><Space>j :tabprevious<CR>
nmap <silent><Space>k :tabnext<CR>

"行番号のハイライト
set cursorline

"横のスクロールを細かく
set sidescroll=1

" 折り返さない
" set nowrap

"バッファ移動
nnoremap <silent>gb :bnext<CR>
nnoremap <silent>gB :bprev<CR>

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
set ignorecase
set smartcase
"set noignorecase " 検索パターンに大文字小文字を区別する
"set smartcase " 検索パターンに大文字を含んでいたら大文字小文字を区別する
set hlsearch " 検索結果をハイライト
 " ESC2回でハイライト消す
nnoremap <silent> <Esc><Esc> :nohl<CR>

set whichwrap=b,s,h,l,<,>,[,],~ " カーソルの左右移動で行末から次の行の行頭への移動が可能になる
set number " 行番号を表示

" 行が折り返し表示されていた場合、行単位ではなく表示行単位でカーソルを移動する
" nnoremap j gj
" nnoremap k gk
" nnoremap <down> gj
" nnoremap <up> gk

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
set tabstop=2 " 画面上でタブ文字が占める幅(この値のみ変更)
set cindent
set cinoptions+=:0,N-s "switch内のcaseのインデント幅(:h cinoptions-values)
set shiftwidth=0 " smartindentで増減する幅(0の場合tabstopに従う)
set softtabstop=-1 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅(負の場合shiftwidthに従う)

".s拡張子をnasmとして読み込み
autocmd BufNewFile,BufRead *.s set filetype=nasm

"数行余裕を持たせてスクロールする
:set scrolloff=7

"クリップボードをつかえるようにする
set clipboard=unnamedplus

"backspaceを有効に
set backspace=indent,eol,start

set termguicolors

"一般ユーザ権限でもsudo保存可能に
function! s:sudo_write_current_buffer() abort
    if has('nvim')
        let s:askpass_path = '/tmp/askpass'
        let s:password     = inputsecret("Enter Password: ")
        let $SUDO_ASKPASS  = s:askpass_path

        try
            call delete(s:askpass_path)
            call writefile(['#!/bin/sh'],                 s:askpass_path, 'a')
            call writefile(["echo '" . s:password . "'"], s:askpass_path, 'a')
            call setfperm(s:askpass_path, "rwx------")
            write ! sudo -A tee % > /dev/null
        finally
            unlet s:password
            call delete(s:askpass_path)
        endtry
    else
        write ! sudo tee % > /dev/null
    endif
endfunction
command! SudoWriteCurrentBuffer call s:sudo_write_current_buffer()

"ale
let g:ale_disable_lsp = 1
let g:ale_sign_highlight_linenrs = 1

"plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

"Plug 'tpope/vim-scriptease'
"Plug 'itchyny/lightline.vim'
Plug 'nvim-lualine/lualine.nvim'
"Plug 'cohama/lexima.vim'
Plug 'nvim-lua/plenary.nvim' " for telescope, gitsigns, todo-comments
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'embear/vim-localvimrc'
Plug 'w0rp/ale'
"Plug 'scrooloose/nerdtree'
"Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons' " for telescope, bufferline
Plug 'lewis6991/gitsigns.nvim'
"Plug 'airblade/vim-gitgutter'
"Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
"Plug 'gorodinskiy/vim-coloresque'
Plug 'mattn/emmet-vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vista.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'dhruvasagar/vim-table-mode'
"Plug 'Yggdroot/indentLine'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug '4nm1tsu/iceberg.vim'
"Plug 'ghifarit53/tokyonight-vim'
"Plug 'kyazdani42/blue-moon'
"Plug 'pbondoer/vim-42header'
"Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'
Plug 'antoinemadec/coc-fzf' " cocListの結果をfzfに噛ませる
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'honza/vim-snippets'
"Plug 'dstein64/nvim-scrollview'
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui', {'commit': '6b6081ad244ae5aa1358775cc3c08502b04368f9'}
Plug 'Pocco81/DAPInstall.nvim', {'commit': '24923c3', 'branch': 'dev'}
Plug 'nvim-telescope/telescope-dap.nvim'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'rcarriga/nvim-notify'
Plug 'jsborjesson/vim-uppercase-sql'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'kevinhwang91/nvim-hlslens'
Plug 'petertriho/nvim-scrollbar'
Plug 'danymat/neogen'
Plug 'windwp/nvim-ts-autotag'
Plug 'unblevable/quick-scope'
Plug 'folke/todo-comments.nvim', {'branch': 'neovim-pre-0.8.0'}
Plug 'akinsho/bufferline.nvim', { 'tag': 'v3.*' }
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'MunifTanjim/nui.nvim' "for neo-tree noice.nvim
"Plug 'folke/noice.nvim'
Plug 'rafamadriz/friendly-snippets'
Plug 'yioneko/nvim-yati'
Plug 'MTDL9/vim-log-highlighting'
Plug 'axelvc/template-string.nvim'

" Initialize plugin system
call plug#end()

colorscheme iceberg
hi! link DiagnosticError ALEErrorSign
hi! link DiagnosticWarning ALEWarningSign
hi! link DiagnosticInfo ALEInfoSign
hi! link DiagnosticHint Label

"let g:tokyonight_style = 'storm'
"colorscheme tokyonight

syntax on
let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"

"popup透過
if has('nvim')
    "透過すると補完のアイコン右半分にに文字が被る
    set pumblend=0
endif

"nvim-scrollview
hi! link ScrollView Pmenu

"lualine
lua <<EOF
require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff',
                  {'diagnostics', sources={'nvim_diagnostic', 'coc', 'ale'}}},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
--  tabline = {
--    lualine_a = {'buffers'},
--    lualine_b = {},
--    lualine_c = {},
--    lualine_x = {},
--    lualine_y = {},
--    lualine_z = {'tabs'}
--  },
  extensions = {}
}
EOF

"ステータスラインの設定
set laststatus=2 " ステータスラインを常に表示
set showmode " 現在のモードを表示
set showcmd " 打ったコマンドをステータスラインの下に表示
set ruler " ステータスラインの右側にカーソルの現在位置を表示する

"ale
let g:ale_linters_explicit=1
let g:ale_linters = {
    \ }
let g:ale_fixers = {
    \ }

" virtualtextにエラー表示
let g:ale_virtualtext_cursor = 1
let g:ale_fix_on_save = 0
let g:ale_virtualtext_prefix = '>'
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_sign_info = ''
let g:ale_sign_style_error = ''
let g:ale_sign_style_warning = ''
"エラー間の移動
nmap <silent> [a <Plug>(ale_previous_wrap)
nmap <silent> ]a <Plug>(ale_next_wrap)
nmap <silent> <Space>F :ALEFix<CR>

" coc
let g:coc_global_extensions = ['coc-db', 'coc-json', 'coc-texlab', 'coc-sql', 'coc-sh', 'coc-pyright', 'coc-pydocstring', 'coc-phpls', 'coc-html', 'coc-htmlhint', 'coc-css', 'coc-cssmodules', 'coc-go', 'coc-clangd', 'coc-pairs', 'coc-emoji', 'coc-vimlsp', 'coc-spell-checker', 'coc-yaml', 'coc-yank', 'coc-markdownlint', 'coc-snippets', 'coc-highlight', 'coc-explorer', 'coc-tsserver', 'coc-vetur', 'coc-lightbulb', 'coc-java', 'coc-haxe', 'coc-lua', 'coc-eslint', 'coc-toml', 'coc-diagnostic', 'coc-prettier', 'coc-lua']
"'coc-word', 'coc-translator', 'coc-xml', 'coc-graphql'

"signatuer表示
inoremap <silent> <C-h> <C-r>=CocActionAsync('showSignatureHelp')<CR>

"neo-tree
nmap <silent><c-n> :Neotree toggle float reveal_force_cwd <cr>
lua <<EOF
require("neo-tree").setup({
filesystem = {
    bind_to_cwd = true, -- true creates a 2-way binding between vim's cwd and neo-tree's root
    cwd_target = {
        sidebar = "tab",   -- sidebar is when position = left or right
        current = "window" -- current is when position = current
        },
    },
    window = {
        mappings = {
            ["<esc>"] = "close_window",
        },
    },
})
EOF

" noice.nvim
"lua <<EOF
"require("noice").setup()
"EOF

"coc-explorer
let g:coc_explorer_global_presets = {
\   '.vim': {
\     'root-uri': '~/.vim',
\   },
\   'cocConfig': {
\      'root-uri': '~/.config/coc',
\   },
\   'tab': {
\     'position': 'tab',
\     'quit-on-open': v:true,
\   },
\   'floating': {
\     'position': 'floating',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingTop': {
\     'position': 'floating',
\     'floating-position': 'center-top',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingLeftside': {
\     'position': 'floating',
\     'floating-position': 'left-center',
\     'floating-width': 60,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingRightside': {
\     'position': 'floating',
\     'floating-position': 'right-center',
\     'floating-width': 50,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'simplify': {
\     'file-child-template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
\   },
\   'buffer': {
\     'sources': [{'name': 'buffer', 'expand': v:true}]
\   },
\ }

" Use preset argument to open it
"nmap <space>ed :CocCommand explorer --preset .vim<CR>
"nmap <space>ef :CocCommand explorer --preset floating<CR>
"nmap <space>ec :CocCommand explorer --preset cocConfig<CR>
"nmap <space>eb :CocCommand explorer --preset buffer<CR>

"nmap <silent><c-n> :CocCommand explorer
"    \ --toggle
"    \ --sources=buffer-,file+
"    \ --width 40
"    \ --preset floatingLeftside
"    \ <CR>

" List all presets
"nmap <space>el :CocList explPresets

"coc-highlight
nnoremap <silent><Space>p :call CocAction('pickColor')<CR>

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=100

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <C-n>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<C-n>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [e <Plug>(coc-diagnostic-prev)
nmap <silent> ]e <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> ]d <Plug>(coc-definition)
nmap <silent> ]t <Plug>(coc-type-definition)
nmap <silent> ]i <Plug>(coc-implementation)
nmap <silent> <Space>r <Plug>(coc-references)
nmap <silent><C-h> :call CocActionAsync('doHover')<CR>

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <Space>n <Plug>(coc-rename)

" Formatting selected code.
nmap <Space>f  <Plug>(coc-format)
xmap <Space>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
"xmap <silent><Space>a  <Plug>(coc-codeaction-selected)
"nmap <silent><Space>a  <Plug>(coc-codeaction-selected)
"#2914
nmap <silent><Space>a <Plug>(coc-codeaction-cursor)

" Remap keys for applying codeAction to the current buffer.
"nmap <silent><Space>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <Space>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-j> and <C-k> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Mappings for CoCList
" Show all diagnostics.
"nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
"nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
"nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
"nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
"nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
"nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
"nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
"nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"coc-markdownlint
autocmd BufNewFile,BufRead *.md nnoremap <buffer><silent> <Space>f :call CocAction('runCommand', 'markdownlint.fixAll')<CR>

"coc-fzf
nnoremap <silent><nowait> <space>s :<C-u>CocFzfList symbols<CR>
nnoremap <silent><nowait> <space>e :<C-u>CocFzfList diagnostics --current-buf<CR>

"coc-lightbulb
"hi! link LightBulbDefaultVirtualText ALEWarningSign
"hi! link LightBulbDefaultSign ALEWarningSign

"gitsigns
lua <<EOF
require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  keymaps = {
    -- Default keymap options
    noremap = true,

    ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
    ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

    ['n <space>ga'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    ['v <space>ga'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <space>gu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ['n <space>gr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ['v <space>gr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <space>gR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
    ['n <space>gp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    ['n <space>gB'] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
    ['n <space>gA'] = '<cmd>lua require"gitsigns".stage_buffer()<CR>',
    ['n <space>gU'] = '<cmd>lua require"gitsigns".reset_buffer_index()<CR>',

    -- Text objects
    ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
  },
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = false,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 150,
    ignore_whitespace = false,
  },
  current_line_blame_formatter_opts = {
    relative_time = false
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },
}
EOF

"git-fugitive
"nnoremap <Space>gs :tab sp<CR>:Git<CR>:only<CR>
"nnoremap <Space>ga :Gwrite<CR>
nnoremap <Space>gc :Git commit<CR>
nnoremap <Space>gb :Git blame<CR>
"nnoremap <Space>gl :Git log<CR>
"nnoremap <Space>gh :tab sp<CR>:0Gclog<CR>
"nnoremap <Space>gp :Git push<CR>
"nnoremap <Space>gf :Git fetch<CR>
nnoremap <Space>gd :Gvdiff<CR>
"nnoremap <Space>gr :Git rebase -i<CR>
"nnoremap <Space>gg :Ggrep
"nnoremap <Space>gm :Git merge

"GitGutter
"nnoremap <Space>gu :GitGutterUndoHunk<CR>

"fzf
"nnoremap <silent> <C-f> :Files<CR>
"autocmd! FileType fzf tnoremap <buffer> <C-f> <c-c>
"ファイル名が指定されなかったらfzf起動できるようにしたい
"escでタブが閉じるのが遅いので追加
"autocmd FileType fzf tnoremap <buffer> <Esc> <Esc>

"telescope
"nnoremap <silent> <C-f> <cmd>Telescope find_files hidden=true layout_config={"prompt_position":"top"}<cr> " hidden=trueいれないほうがいいかも
nnoremap <silent> <C-f> <cmd>Telescope find_files layout_config={"prompt_position":"top"}<cr>
nnoremap <silent> <Space>l <cmd>Telescope live_grep layout_config={"prompt_position":"top"}<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
"esc一回で抜ける
lua <<EOF
local actions = require("telescope.actions")

require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close,
            },
        },
        sorting_strategy = "ascending",
        layout_strategy = "flex",
        layout_config = {
            flex = {
                flip_columns = 161, -- half 27" monitor, scientifically calculated
            },
            horizontal = {
                preview_cutoff = 0,
                preview_width = { padding = 27 },
            },
            vertical = {
                preview_cutoff = 0,
                preview_height = { padding = 7 },
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
    },
})
EOF

"vista
let g:vista_default_executive = 'coc'
let g:vista_sidebar_width = 40
let g:vista_echo_cursor = 0
nnoremap <silent> <Space>v :Vista!!<CR>

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
let g:vim_markdown_new_list_item_indent = 0

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
let g:localvimrc_sandbox = 0

"起動時メッセージ出さない
set shortmess+=I

"時刻によってbackground colorを変更
"let g:time_to_set_background = str2nr(strftime("%H%M%S"))
"if (g:time_to_set_background >= 70000 && g:time_to_set_background < 160000)
"    set background=light
"else
"    set background=dark
"endif

"自動改行させない
autocmd FileType * setlocal textwidth=0

"indentLine
let g:indent_blankline_space_char=' '
let g:indent_blankline_char='▏'
let g:indent_blankline_filetype_exclude = ['help', 'coc-explorer', 'fzf']
let g:indent_blankline_char_highlight_list = ['Comment']
"let g:indentLine_showFirstIndentLevel=1 "現時点で機能しない
lua <<EOF
require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = false,
}
EOF

"markdown-preview.nvim
" set to 1, nvim will open the preview window after entering the markdown buffer
"let g:mkdp_auto_start = 1

" set to 1, preview server available to others in your network
" by default, the server listens on localhost (127.0.0.1)
let g:mkdp_open_to_the_world = 1

" set to 1, echo preview page url in command line when open preview page
" default is 0
let g:mkdp_echo_preview_url = 1

" options for markdown render
" mkit: markdown-it options for render
" katex: katex options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: if disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: mean the cursor position alway show at the middle of the preview page
"   top: mean the vim top viewport alway show at the top of the preview page
"   relative: mean the cursor position alway show at the relative positon of the preview page
" hide_yaml_meta: if hide yaml metadata, default is 1
" sequence_diagrams: js-sequence-diagrams options
" content_editable: if enable content editable for preview page, default: v:false
" disable_filename: if disable filename header for preview page, default: 0
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0
    \ }

" use a custom markdown style must be absolute path
" like '/Users/username/markdown.css' or expand('~/markdown.css')
let g:mkdp_markdown_css = ''

" use a custom highlight style must absolute path
" like '/Users/username/highlight.css' or expand('~/highlight.css')
let g:mkdp_highlight_css = ''

" use a custom port to start server or random for empty
let g:mkdp_port = ''

" preview page title
" ${name} will be replace with the file name
let g:mkdp_page_title = '「${name}」'

" recognized filetypes
" these filetypes will have MarkdownPreview... commands
let g:mkdp_filetypes = ['markdown']

nmap <silent><Space>m <Plug>MarkdownPreview

"coc-snippets
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet. 選択したテキストをスニペットに埋め込み
"vmap <C-j> <Plug>(coc-snippets-select)

" Use <leader>x for convert visual selected code to snippet
xmap <C-x>  <Plug>(coc-convert-snippet)

" C-lで確定(enter一発で改行したい)←tabだと副作用が大きい
inoremap <silent><expr> <C-l> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()

" キャンセルはデフォルトでC-e
" inoremap <silent><expr> <C-e> coc#pum#visible() ? coc#pum#cancel() : "\<C-e>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'
let g:coc_snippet_prev = '<S-tab>'

"nvim-dap
lua << EOF
local dap = require('dap')
dap.defaults.fallback.force_external_terminal = true

dap.defaults.fallback.terminal_win_cmd = 'belowright new'

dap.defaults.fallback.external_terminal = {
    -- command = '/usr/bin/alacritty';
    command = 'alacritty';
    args = {'-e'};
}
vim.fn.sign_define('DapBreakpoint', {text='', texthl='DapBreakpoint', linehl='NONE', numhl='NONE'})
vim.fn.sign_define('DapStopped', {text='', texthl='DapStopped', linehl='NONE', numhl='NONE'})
vim.fn.sign_define('DapLogPoint', {text='', texthl='DapLogPoint', linehl='NONE', numhl='NONE'})
vim.fn.sign_define('DapBreakpointRejected', {text='', texthl='DapBreakpointRejected', linehl='NONE', numhl='NONE'})
EOF
nnoremap <silent><space>db <cmd>lua require"dap".toggle_breakpoint()<CR>
nnoremap <silent><space>dc <cmd>lua require"dap".continue()<CR>
nnoremap <silent><space>ds <cmd>lua require"dap".disconnect()<CR>
nnoremap <silent><C-j> <cmd>lua require"dap".step_over()<CR>
nnoremap <silent><C-k> <cmd>lua require"dap".step_out()<CR>
nnoremap <silent><C-l> <cmd>lua require"dap".step_into()<CR>

"dapui
lua << EOF
require("dapui").setup()
EOF
nnoremap <silent><space>du <cmd>lua require"dapui".toggle()<CR>

"dapinstall
lua << EOF
local dap_install = require("dap-install")

dap_install.setup({
	installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
    verbosely_call_debuggers = true,
})

local dbg_list = require("dap-install.api.debuggers").get_installed_debuggers()
for _, debugger in ipairs(dbg_list) do
	dap_install.config(debugger)
end
EOF

lua <<EOF
require("nvim-dap-virtual-text").setup()
EOF

"telescope-extensions
lua << EOF
require('telescope').setup()
require('telescope').load_extension('fzf')
require('telescope').load_extension('dap')
EOF

"nvim-treesitter-context
lua << EOF
require'treesitter-context'.setup{
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        -- For all filetypes
        -- Note that setting an entry here replaces all other patterns for this entry.
        -- By setting the 'default' entry below, you can control which nodes you want to
        -- appear in the context window.
        default = {
            'class',
            'function',
            'method',
            -- 'for', -- These won't appear in the context
            -- 'while',
            -- 'if',
            -- 'switch',
            -- 'case',
        },
        -- Example for a specific filetype.
        -- If a pattern is missing, *open a PR* so everyone can benefit.
        --   rust = {
        --       'impl_item',
        --   },
    },
    exact_patterns = {
        -- Example for a specific filetype with Lua patterns
        -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
        -- exactly match "impl_item" only)
        -- rust = true,
    },

    -- [!] The options below are exposed but shouldn't require your attention,
    --     you can safely ignore them.

    zindex = 20, -- The Z-index of the context window
}
EOF

"nvim-scrollbar
lua <<EOF
require("scrollbar").setup({
    show = true,
    show_in_active_only = false,
    set_highlights = true,
    folds = 1000, -- handle folds, set to number to disable folds if no. of lines in buffer exceeds this
    max_lines = false, -- disables if no. of lines in buffer exceeds this
    handle = {
        text = " ",
        color = nil,
        cterm = nil,
        highlight = "Pmenu",
        hide_if_all_visible = true, -- Hides handle if all lines are visible
    },
    marks = {
        Search = {
            text = { "-", "=" },
            priority = 0,
            color = nil,
            cterm = nil,
            highlight = "Title",
        },
        Error = {
            text = { "-", "=" },
            priority = 1,
            color = nil,
            cterm = nil,
            highlight = "DiagnosticVirtualTextError",
        },
        Warn = {
            text = { "-", "=" },
            priority = 2,
            color = nil,
            cterm = nil,
            highlight = "DiagnosticVirtualTextWarn",
        },
        Info = {
            text = { "-", "=" },
            priority = 3,
            color = nil,
            cterm = nil,
            highlight = "DiagnosticVirtualTextInfo",
        },
        Hint = {
            text = { "-", "=" },
            priority = 4,
            color = nil,
            cterm = nil,
            highlight = "DiagnosticVirtualTextHint",
        },
        Misc = {
            text = { "-", "=" },
            priority = 5,
            color = nil,
            cterm = nil,
            highlight = "Normal",
        },
    },
    excluded_buftypes = {
        "terminal",
    },
    excluded_filetypes = {
        "prompt",
        "TelescopePrompt",
    },
    autocmd = {
        render = {
            "BufWinEnter",
            "TabEnter",
            "TermEnter",
            "WinEnter",
            "CmdwinLeave",
            "TextChanged",
            "VimResized",
            "WinScrolled",
        },
        clear = {
            "BufWinLeave",
            "TabLeave",
            "TermLeave",
            "WinLeave",
        },
    },
    handlers = {
        diagnostic = true,
        search = true, -- Requires hlslens to be loaded, will run require("scrollbar.handlers.search").setup() for you
    },
})
EOF

"neogen
lua <<  EOF
require('neogen').setup {
    enabled = true,             --if you want to disable Neogen
    input_after_comment = true, -- (default: true) automatic jump (with insert mode) on inserted annotation
    -- jump_map = "<C-e>"       -- (DROPPED SUPPORT, see [here](#cycle-between-annotations) !) The keymap in order to jump in the annotation fields (in insert mode)
}
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<space>G", ":lua require('neogen').generate()<CR>", opts)
EOF

"nvim-ts-autotag
lua << EOF
require('nvim-ts-autotag').setup()
EOF

" quick-scope
let g:qs_highlight_on_keys = ['f', 'F']
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline

"todo-comments
lua << EOF
require("todo-comments").setup {
    signs = true, -- show icons in the signs column
    sign_priority = 8, -- sign priority
    -- keywords recognized as todo comments
    keywords = {
        FIX = {
            icon = " ", -- icon used for the sign, and in search results
            color = "error", -- can be a hex color, or a named color (see below)
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
            -- signs = false, -- configure signs for some keywords individually
            },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        },
    merge_keywords = true, -- when true, custom keywords will be merged with the defaults
    -- highlighting of the line containing the todo comment
    -- * before: highlights before the keyword (typically comment characters)
    -- * keyword: highlights of the keyword
    -- * after: highlights after the keyword (todo text)
    highlight = {
        before = "", -- "fg" or "bg" or empty
        keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
        after = "fg", -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
        },
    -- list of named colors where we try to extract the guifg from the
    -- list of hilight groups or use the hex color if hl not found as a fallback
    --colors = {
    --    error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
    --    warning = { "DiagnosticWarning", "WarningMsg", "#FBBF24" },
    --    info = { "DiagnosticInfo", "#2563EB" },
    --    hint = { "DiagnosticHint", "#10B981" },
    --    default = { "Identifier", "#7C3AED" },
    --    },
    search = {
        command = "rg",
        args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            },
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
        },
    }
EOF

" bufferline
lua <<EOF
vim.opt.termguicolors = true
require("bufferline").setup{
options = {
    diagnostics = "coc",
    --    diagnostics_indicator = function(count, level, diagnostics_dict, context)
    --    local icon = level:match("error") and " " or " "
    --    return " " .. icon .. count
    --    end
    }
}
EOF
" These commands will navigate through buffers in order regardless of which mode you are using
" e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
nnoremap <silent>]b :BufferLineCycleNext<CR>
nnoremap <silent>[b :BufferLineCyclePrev<CR>

" These commands will move the current buffer backwards or forwards in the bufferline
" nnoremap <silent><mymap> :BufferLineMoveNext<CR>
" nnoremap <silent><mymap> :BufferLineMovePrev<CR>

"インデント
augroup c
    autocmd!
    "autocmd BufNewFile,BufRead *.c,*.cpp,*.md setl tabstop=2
    "
    "au FileType c,cpp setl tabstop=2
    "au FileType dbui setl tabstop=2
    "au FileType json,jsonc setl tabstop=2 " shiftwidth=2
    "au FileType markdown setl tabstop=2
    au FileType go set noexpandtab tabstop=2
    au FileType python set tabstop=4
augroup END

"markdownのインデント幅(デフォルト4)を無視
let g:markdown_recommended_style = 0

"pythonのデフォルト設定無視 :h ft-python-plugin
let g:python_recommended_style = 0

"template-string
lua << EOF
require('template-string').setup({
  filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'python' }, -- filetypes where the plugin is active
  jsx_brackets = true, -- must add brackets to jsx attributes
  remove_template_string = false, -- remove backticks when there are no template string
  restore_quotes = {
    -- quotes used when "remove_template_string" option is enabled
    normal = [[']],
    jsx = [["]],
  },
})
EOF

"treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {
        'php',
    }
  },
  yati = {
    enable = true,
    -- Disable by languages, see `Supported languages`
    disable = { "python" },

    -- Whether to enable lazy mode (recommend to enable this if bad indent happens frequently)
    default_lazy = true,

    -- Determine the fallback method used when we cannot calculate indent by tree-sitter
    --   "auto": fallback to vim auto indent
    --   "asis": use current indent as-is
    --   "cindent": see `:h cindent()`
    -- Or a custom function return the final indent result.
    default_fallback = "auto"
  },
  indent = {
    enable = false,
  },
  ensure_installed = 'all',
  additional_vim_regex_highlighting = false,
}
EOF
