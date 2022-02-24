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
set cindent
set shiftwidth=4 " smartindentで増減する幅

"インデント幅デフォルト2
augroup c
    autocmd!
    autocmd BufNewFile,BufRead *.c,*.cpp,*.md setl softtabstop=2
    autocmd BufNewFile,BufRead *.c,*.cpp,*.md setl shiftwidth=2
    autocmd FileType dbui setlocal shiftwidth=2
augroup END

".s拡張子をnasmとして読み込み
autocmd BufNewFile,BufRead *.s set filetype=nasm

"goのときはハードタブに
au BufNewFile,BufRead *.go set noexpandtab

"数行余裕を持たせてスクロールする
:set scrolloff=7

"クリップボードをつかえるようにする
set clipboard+=unnamedplus

"backspaceを有効に
set backspace=indent,eol,start

set termguicolors

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
Plug 'nvim-lua/plenary.nvim' " for telescope, gitsigns
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'embear/vim-localvimrc'
Plug 'w0rp/ale'
"Plug 'scrooloose/nerdtree'
"Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons' " for telescope
Plug 'lewis6991/gitsigns.nvim'
"Plug 'airblade/vim-gitgutter'
Plug 'sheerun/vim-polyglot'
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
Plug 'pbondoer/vim-42header'
"Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'honza/vim-snippets'
Plug 'Xuyuanp/scrollbar.nvim'
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'Pocco81/DAPInstall.nvim'
Plug 'nvim-telescope/telescope-dap.nvim'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'onsails/lspkind-nvim'
" For vsnip users.
"Plug 'hrsh7th/cmp-vsnip'
"Plug 'hrsh7th/vim-vsnip'

" For luasnip users.
" Plug 'L3MON4D3/LuaSnip'
" Plug 'saadparwaiz1/cmp_luasnip'

" For ultisnips users.
" Plug 'SirVer/ultisnips'
" Plug 'quangnguyen30192/cmp-nvim-ultisnips'

" For snippy users.
" Plug 'dcampos/nvim-snippy'
" Plug 'dcampos/cmp-snippy'

" Initialize plugin system
call plug#end()

let g:tokyonight_style = 'storm'
colorscheme iceberg
syntax on
let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"

"popup透過
if has('nvim')
    "透過すると補完のアイコン右半分にに文字が被る
    set pumblend=0
endif

"scrollbar
augroup ScrollbarInit
  autocmd!
  autocmd WinScrolled,VimResized,QuitPre * silent! lua require('scrollbar').show()
  autocmd WinEnter,FocusGained           * silent! lua require('scrollbar').show()
  autocmd WinLeave,BufLeave,BufWinLeave,FocusLost            * silent! lua require('scrollbar').clear()
augroup end
let g:scrollbar_shape = {
            \ 'head': '▏',
            \ 'body': '▏',
            \ 'tail': '▏',
            \ }
let g:scrollbar_highlight = {
            \ 'head': 'Normal',
            \ 'body': 'Normal',
            \ 'tail': 'Normal',
            \ }

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
                  {'diagnostics', sources={'nvim_diagnostic', 'nvim_lsp', 'ale'}}},
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
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_sign_info = ''
let g:ale_sign_style_error = ''
let g:ale_sign_style_warning = ''
"エラー間の移動
nmap <silent> [a <Plug>(ale_previous_wrap)
nmap <silent> ]a <Plug>(ale_next_wrap)
nmap <silent> <Space>F :ALEFix<CR>

" coc
"let g:coc_global_extensions = ['coc-db', 'coc-json', 'coc-texlab', 'coc-sql', 'coc-sh', 'coc-pyright', 'coc-phpls', 'coc-html', 'coc-htmlhint', 'coc-css', 'coc-cssmodules', 'coc-go', 'coc-clangd', 'coc-pairs', 'coc-emoji', 'coc-vimlsp', 'coc-spell-checker', 'coc-yaml', 'coc-yank', 'coc-markdownlint', 'coc-snippets', 'coc-highlight', 'coc-explorer', 'coc-tsserver', 'coc-vetur']
"'coc-word', 'coc-translator', 'coc-xml', 'coc-graphql'

"signatuer表示
"inoremap <silent> <C-h> <C-r>=CocActionAsync('showSignatureHelp')<CR>

"color picker
"nnoremap <silent><Space>p :call CocAction('pickColor')<CR>

"enterで改行
"C-nで再度表示
"inoremap <silent><expr> <C-n>
"      \ pumvisible() ? "\<C-n>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" lsp diagnostic表示
"nmap <silent> [e <Plug>(coc-diagnostic-prev)
"nmap <silent> ]e <Plug>(coc-diagnostic-next)

" go definition関連
"nmap <silent> ]dd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> <Space>r <Plug>(coc-references)
"nmap <silent><C-h> :call CocActionAsync('doHover')<CR>

" signature
"function! s:show_documentation()
"  if (index(['vim','help'], &filetype) >= 0)
"    execute 'h '.expand('<cword>')
"  elseif (coc#rpc#ready())
"    call CocActionAsync('doHover')
"  else
"    execute '!' . &keywordprg . " " . expand('<cword>')
"  endif
"endfunction

" Highlight the symbol and its references when holding the cursor.
"autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
"nmap <Space>n <Plug>(coc-rename)

" Formatting selected code.
"nmap <Space>f  <Plug>(coc-format)
"vmap <Space>f  <Plug>(coc-format-selected)

" code action
"xmap <silent><Space>a  <Plug>(coc-codeaction-selected)
"nmap <silent><Space>a  <Plug>(coc-codeaction-selected)

"nmap <silent><Space>ac  <Plug>(coc-codeaction)

" quick fix
"nmap <Space>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
"xmap if <Plug>(coc-funcobj-i)
"omap if <Plug>(coc-funcobj-i)
"xmap af <Plug>(coc-funcobj-a)
"omap af <Plug>(coc-funcobj-a)
"xmap ic <Plug>(coc-classobj-i)
"omap ic <Plug>(coc-classobj-i)
"xmap ac <Plug>(coc-classobj-a)
"omap ac <Plug>(coc-classobj-a)

" Remap <C-j> and <C-k> for scroll float windows/popups.
"if has('nvim-0.4.0') || has('patch-8.2.0750')
"  nnoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"  nnoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"  inoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"  inoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"  vnoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"  vnoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"endif

"coc-markdownlint
"autocmd BufNewFile,BufRead *.md nnoremap <buffer><silent> <Space>f :call CocAction('runCommand', 'markdownlint.fixAll')<CR>

"coc-fzf
"nnoremap <silent><nowait> <space>s :<C-u>CocFzfList symbols<CR>
"nnoremap <silent><nowait> <space>e :<C-u>CocFzfList diagnostics --current-buf<CR>

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
    },
})
EOF

"vista
let g:vista_default_executive = 'nvim_lsp'
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
" 新しいexplorer追加
let g:indent_blankline_filetype_exclude = ['help', 'fzf', 'lsp-installer']
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
"imap <C-l> <Plug>(coc-snippets-expand)

" C-lで確定(enter一発で改行したい)←tabだと副作用が大きい
"inoremap <silent><expr> <C-l>
"      \ pumvisible() ? coc#_select_confirm() :
"      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"      \ "\<C-l>"
""      \ <SID>check_back_space() ? "\<TAB>" :
""      \ coc#refresh()

"let g:coc_snippet_next = '<tab>'
"let g:coc_snippet_prev = '<S-tab>'

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

"telescope-dap
lua << EOF
require('telescope').setup()
require('telescope').load_extension('dap')
EOF

" nvim-lspconfig
lua << EOF
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
-- vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
-- vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-h>', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>r', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- nvim-lsp-installer
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
    local opts = {}
    server:setup(opts)
end)
EOF

" nvim-cmp
lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'
  local lspkind = require('lspkind')

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol_text', -- show only symbol annotations
          maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
    
          -- The function below will be called before any actual modifications from lspkind
          -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
    --       before = function (entry, vim_item)
    --         ...
    --         return vim_item
    --       end
        })
      },
    mapping = {
      ['<C-k>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-j>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-l>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<C-l>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
      { name = 'path' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it. 
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
--  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
--  require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--    capabilities = capabilities
--  }
EOF
hi! link CmpItemAbbrMatch Function
hi! link CmpItemAbbrMatchFuzzy Title
hi! link CmpItemKind Special

"treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {
        'php',
    }
  },
  indent = {
    enable = false,
  },
  ensure_installed = 'maintained',
  additional_vim_regex_highlighting = false,
}
EOF
