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
" source $VIMRUNTIME/macros/matchit.vim " Vimの「%」を拡張する(タグジャンプ)

set wildmenu "コマンドモードのタブ補完

"ペースト時、インデントが崩れないようにする    let &t_SI .=
if &term =~ "xterm"
  let &t_ti .= "\e[?2004h"
  let &t_te .= "\e[?2004l"
  "let &pastetoggle = "\e[201~"

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
set scrolloff=7

"クリップボードをつかえるようにする(要xclip)
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
Plug 'nvim-lua/plenary.nvim' " for telescope, gitsigns, todo-comments avante.nvim mcphub
Plug 'nvim-telescope/telescope.nvim'
Plug 'stevearc/dressing.nvim' " for avante.nvim
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
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'dhruvasagar/vim-table-mode'
"Plug 'Yggdroot/indentLine'
Plug 'shellRaining/hlchunk.nvim'
Plug '4nm1tsu/iceberg.vim'
"Plug 'ghifarit53/tokyonight-vim'
"Plug 'kyazdani42/blue-moon'
"Plug 'pbondoer/vim-42header'
"Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate', 'branch': 'main'}
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
Plug 'akinsho/bufferline.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'MunifTanjim/nui.nvim' "for neo-tree noice.nvim avante.nvim
"Plug 'folke/noice.nvim'
Plug 'rafamadriz/friendly-snippets'
Plug 'MTDL9/vim-log-highlighting'
Plug 'axelvc/template-string.nvim'
Plug 'sindrets/diffview.nvim'
Plug 'fannheyward/telescope-coc.nvim'
Plug 'b0o/incline.nvim'
Plug 'neovim/nvim-lspconfig' " for nvim-navic
Plug 'SmiteshP/nvim-navic' " for incline.nvim
Plug 'hedyhli/outline.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'nosduco/remote-sshfs.nvim'
"Plug 'HakonHarnes/img-clip.nvim' "for avante.nvim
Plug 'MeanderingProgrammer/render-markdown.nvim' "for avante.nvim
Plug 'yetone/avante.nvim', {'branch': 'main', 'do': 'make'}
Plug 'ravitemer/mcphub.nvim', { 'do': 'npm install -g mcp-hub@latest && nodenv rehash' }
Plug 'nosduco/remote-sshfs.nvim'
Plug 'ravsii/tree-sitter-d2', { 'do': 'make nvim-install' }
Plug 'terrastruct/d2-vim'

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
    globalstatus = true,
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
set laststatus=3 " ステータスラインを一つだけ表示
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
let g:coc_global_extensions = ['coc-db', 'coc-json', 'coc-texlab', 'coc-sql', 'coc-sh', 'coc-pyright', 'coc-pydocstring', 'coc-phpls', 'coc-html', 'coc-htmlhint', 'coc-css', 'coc-cssmodules', 'coc-go', 'coc-clangd', 'coc-emoji', 'coc-vimlsp', 'coc-spell-checker', 'coc-yaml', 'coc-yank', 'coc-markdownlint', 'coc-snippets', 'coc-highlight', 'coc-tsserver', 'coc-vetur', 'coc-lightbulb', 'coc-java', 'coc-haxe', 'coc-lua', 'coc-eslint', 'coc-toml', 'coc-diagnostic', 'coc-prettier', 'coc-lua', 'coc-docker']
"'coc-word', 'coc-translator', 'coc-xml', 'coc-graphql'

nnoremap <leader>uu i<c-r>=trim(system('uuidgen'))<cr><esc>

"signatuer表示
inoremap <silent> <C-h> <C-r>=CocActionAsync('showSignatureHelp')<CR>

"neo-tree
nmap <silent><c-n> :Neotree toggle reveal_force_cwd <cr>
lua <<EOF
require("neo-tree").setup({
event_handlers = {
  {
      event = "file_open_requested",
      handler = function()
      -- auto close
      -- vim.cmd("Neotree close")
      -- OR
      require("neo-tree.command").execute({ action = "close" })
      end
  },
},
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
  set signcolumn=auto
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
"nmap <silent> ]d :<C-u>Telescope coc definitions layout_config={"prompt_position":"top"}<CR> "timeoutする
"nmap <silent> ]t <Plug>(coc-type-definition)
nmap <silent> ]t :<C-u>Telescope coc type_definitions layout_config={"prompt_position":"top"}<CR>
"nmap <silent> ]i <Plug>(coc-implementation)
nmap <silent> ]i :<C-u>Telescope coc implementations layout_config={"prompt_position":"top"}<CR>
"nmap <silent> ]r <Plug>(coc-references)
nmap <silent> ]r :<C-u>Telescope coc references layout_config={"prompt_position":"top"}<CR>
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
nmap <Space>i :call CocActionAsync('runCommand', 'editor.action.organizeImport')<CR>
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
xmap <silent><Space>a <Plug>(coc-codeaction-selected)
nmap <silent><Space>a <Plug>(coc-codeaction-selected)
nmap <silent><Space>A <Plug>(coc-codeaction-source)
nmap <silent><Space>a <Plug>(coc-codeaction-cursor)

xmap <silent> <Space>r <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <Space>r <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <Space>r <Plug>(coc-codeaction-refactor)

nmap <silent> <Space>L  <Plug>(coc-codelens-action)

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

"telescope-coc
nnoremap <silent><nowait> <space>s :<C-u>Telescope coc document_symbols layout_config={"prompt_position":"top"}<CR>
nnoremap <silent><nowait> <space>e :<C-u>Telescope coc diagnostics layout_config={"prompt_position":"top"}<CR>

"coc-lightbulb
"hi! link LightBulbDefaultVirtualText ALEWarningSign
"hi! link LightBulbDefaultSign ALEWarningSign

"gitsigns
lua <<EOF
require('gitsigns').setup {
  signs = {
    add          = {text = '│'},
    change       = {text = '│'},
    delete       = {text = '_'},
    topdelete    = {text = '‾'},
    changedelete = {text = '~'},
    untracked    = { text = '┆' },
  },
  signs = {
    add          = {text = '│'},
    change       = {text = '│'},
    delete       = {text = '_'},
    topdelete    = {text = '‾'},
    changedelete = {text = '~'},
    untracked    = { text = '┆' },
  },
  signs_staged_enable = false,
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  --  keymaps = {
    --    -- Default keymap options
    --    noremap = true,
    --
    --    ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
    --    ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},
    --
    --    ['n <space>ga'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    --    ['v <space>ga'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    --    ['n <space>gu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    --    ['n <space>gr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    --    ['v <space>gr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    --    ['n <space>gR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
    --    ['n <space>gp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    --    ['n <space>gB'] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
    --    ['n <space>gA'] = '<cmd>lua require"gitsigns".stage_buffer()<CR>',
    --    ['n <space>gU'] = '<cmd>lua require"gitsigns".reset_buffer_index()<CR>',
    --
    --    -- Text objects
    --    ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    --    ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
    --  },
    watch_gitdir = {
      interval = 1000,
      follow_files = true
    },
    auto_attach = true,
    attach_to_untracked = false,
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = false,
      virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      delay = 150,
      ignore_whitespace = false,
      virt_text_priority = 100,
    },
    current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
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
    on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
    if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
      end, {expr=true})

      map('n', '[c', function()
      if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
        end, {expr=true})

        -- Actions
        map('n', '<space>ga', gs.stage_hunk)
        map('n', '<space>gr', gs.reset_hunk)
        map('v', '<space>ga', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
        map('v', '<space>gr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
        map('n', '<space>gA', gs.stage_buffer)
        map('n', '<space>gu', gs.undo_stage_hunk)
        map('n', '<space>gR', gs.reset_buffer)
        map('n', '<space>gp', gs.preview_hunk)
        map('n', '<space>gB', function() gs.blame_line{full=true} end)
        --    map('n', '<space>gn', gs.toggle_current_line_blame)
        --    map('n', '<space>gm', gs.diffthis)
        --    map('n', '<space>go', function() gs.diffthis('~') end)
        map('n', '<space>gD', gs.toggle_deleted)

        -- Text object
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
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

"nvim-autopairs
lua << EOF
require("nvim-autopairs").setup {}
EOF

"telescope
"nnoremap <silent> <C-f> <cmd>Telescope find_files hidden=true layout_config={"prompt_position":"top"}<cr> " hidden=trueいれないほうがいいかも
nnoremap <silent> <C-f> <cmd>Telescope find_files hidden=true layout_config={"prompt_position":"top"} find_command={'rg','--files','--hidden','-g','!.git'}<cr>
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
      ["<esc>"] = {
        actions.close,
        type = 'action',
				opts = { nowait = true, silent = true },
      },
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
  coc = {
    theme = 'ivy',
    prefer_locations = true, -- always use Telescope locations to preview definitions/declarations/implementations etc
  }
  },
})
EOF


"outline
lua << EOF
require("outline").setup({})
EOF
nnoremap <silent> <Space>v :belowright Outline!<CR>

"modifyOtherKeysの問題で制御文字4;2mが出るのを抑制
let &t_TI = ""
let &t_TE = ""

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

lua <<EOF
require('hlchunk').setup({
chunk = {
  enable = true,
  priority = 15,
  --style = {
    --  { fg = "#806d9c" },
    --  { fg = "#c21f30" },
    --},
    use_treesitter = true,
    chars = {
      horizontal_line = "─",
      vertical_line = "│",
      left_top = "╭",
      left_bottom = "╰",
      right_arrow = ">",
    },
    textobject = "",
    max_file_size = 1024 * 1024,
    error_sign = false,
    -- animation related
    duration = 200,
    delay = 300,
},
indent = {
  enable = true,
  priority = 10,
  style = { vim.api.nvim_get_hl(0, { name = "Whitespace" }) },
  use_treesitter = false,
  chars = { "│" },
  ahead_lines = 5,
  delay = 100,
},
line_num = {
  enable = false,
  --style = "#806d9c",
  priority = 10,
  use_treesitter = false,
},
blank = {
  enable = false,
  priority = 9,
  chars = { "․" },
}
})
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
nnoremap <silent><C-Down> <cmd>lua require"dap".step_over()<CR>
nnoremap <silent><C-Up> <cmd>lua require"dap".step_out()<CR>
nnoremap <silent><C-Right> <cmd>lua require"dap".step_into()<CR>

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
require('telescope').load_extension('coc')
require('telescope').load_extension('dap')
require('telescope').load_extension('remote-sshfs')
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
hide_if_all_visible = false, -- Hides everything if all lines are visible
throttle_ms = 100,
handle = {
  text = " ",
  blend = 30, -- Integer between 0 and 100. 0 for fully opaque and 100 to full transparent. Defaults to 30.
  color = nil,
  color_nr = nil, -- cterm
  highlight = "Pmenu",
  hide_if_all_visible = true, -- Hides handle if all lines are visible
},
marks = {
  Cursor = {
    text = "•",
    priority = 0,
    gui = nil,
    color = nil,
    cterm = nil,
    color_nr = nil, -- cterm
    highlight = "Normal",
  },
  Search = {
    text = { "-", "=" },
    priority = 1,
    gui = nil,
    color = nil,
    cterm = nil,
    color_nr = nil, -- cterm
    highlight = "Title",
  },
  Error = {
    text = { "-", "=" },
    priority = 2,
    gui = nil,
    color = nil,
    cterm = nil,
    color_nr = nil, -- cterm
    highlight = "DiagnosticVirtualTextError",
  },
  Warn = {
    text = { "-", "=" },
    priority = 3,
    gui = nil,
    color = nil,
    cterm = nil,
    color_nr = nil, -- cterm
    highlight = "DiagnosticVirtualTextWarn",
  },
  Info = {
    text = { "-", "=" },
    priority = 4,
    gui = nil,
    color = nil,
    cterm = nil,
    color_nr = nil, -- cterm
    highlight = "DiagnosticVirtualTextInfo",
  },
  Hint = {
    text = { "-", "=" },
    priority = 5,
    gui = nil,
    color = nil,
    cterm = nil,
    color_nr = nil, -- cterm
    highlight = "DiagnosticVirtualTextHint",
  },
  Misc = {
    text = { "-", "=" },
    priority = 6,
    gui = nil,
    color = nil,
    cterm = nil,
    color_nr = nil, -- cterm
    highlight = "Normal",
  },
  GitAdd = {
    text = "┆",
    priority = 7,
    gui = nil,
    color = nil,
    cterm = nil,
    color_nr = nil, -- cterm
    highlight = "GitSignsAdd",
  },
  GitChange = {
    text = "┆",
    priority = 7,
    gui = nil,
    color = nil,
    cterm = nil,
    color_nr = nil, -- cterm
    highlight = "GitSignsChange",
  },
  GitDelete = {
    text = "▁",
    priority = 7,
    gui = nil,
    color = nil,
    cterm = nil,
    color_nr = nil, -- cterm
    highlight = "GitSignsDelete",
  },
},
excluded_buftypes = {
  "terminal",
},
excluded_filetypes = {
  "dropbar_menu",
  "dropbar_menu_fzf",
  "DressingInput",
  "cmp_docs",
  "cmp_menu",
  "noice",
  "prompt",
  "TelescopePrompt",
  "neo-tree",
  "neo-tree-popup",
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
  cursor = true,
  diagnostic = true,
  handle = true,
  search = true, -- Requires hlslens to be loaded, will run require("scrollbar.handlers.search").setup() for you
  gitsigns = true
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

" diffview
nnoremap <silent><space>h :DiffviewFileHistory %<CR>
" :tabclose to close

"mcphub
lua << EOF
require('mcphub').setup({
  auto_approve = true,
})
EOF

"avante.nvim
autocmd! User avante.nvim
lua << EOF
require('avante_lib').load()
require('avante').setup({
  disabled_tools = {
    "list_files",    -- Built-in file operations
    "search_files",
    "read_file",
    "create_file",
    "rename_file",
    "delete_file",
    "create_dir",
    "rename_dir",
    "delete_dir",
    "bash",         -- Built-in terminal access
  },
  -- system_prompt as function ensures LLM always has latest MCP server state
  -- This is evaluated for every message, even in existing chats
  system_prompt = function()
      local hub = require("mcphub").get_hub_instance()
      return hub and hub:get_active_servers_prompt() or ""
  end,
  -- Using function prevents requiring mcphub before it's loaded
  custom_tools = function()
      return {
          require("mcphub.extensions.avante").mcp_tool(),
      }
  end,

  provider = "openai",
  providers = {
    openai = {
      endpoint = "https://api.rdsec.trendmicro.com/prod/aiendpoint/v1/",
      model = "gpt-5.1",
      -- max_tokens = 16384,
    },

    ollama = {
      endpoint = "http://127.0.0.1:11434/v1",
      model = "Llama-3-ELYZA-JP-8B-q4_k_m.gguf:latest",
    },
  },
})
EOF
"nmap <silent> <leader>uc <Plug>(AvanteChat)
nmap <silent> <space>u <Plug>(AvanteToggle)
vmap <silent> <space>u <Plug>(AvanteAsk)

"render-markdown
lua << EOF
require('render-markdown').setup {
	file_types = { "markdown", "Avante" },
	enable = true,
}
EOF

"img-clip
"lua << EOF
"require('img-clip').setup({
"	-- recommended settings
"	default = {
"		embed_image_as_base64 = false,
"		prompt_for_file_name = false,
"		drag_and_drop = {
"			insert_mode = true,
"		},
"	},
"})
"EOF

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

""nvim-navic " navigation will work after migration to nvim-cmp completed.
"lua << EOF
"local on_attach = function(client, bufnr)
"  if client.server_capabilities.documentSymbolProvider then
"    navic.attach(client, bufnr)
"  end
"end
"
"require("lspconfig").clangd.setup {
"  on_attach = on_attach
"}
"EOF

"incline
lua << EOF
local helpers = require 'incline.helpers'
local navic = require 'nvim-navic'
local devicons = require 'nvim-web-devicons'
require('incline').setup {
  window = {
    padding = 0,
    margin = { horizontal = 0, vertical = 0 },
  },
  render = function(props)
  local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
  if filename == '' then
    filename = '[No Name]'
    end
    local ft_icon, ft_color = devicons.get_icon_color(filename)
    local modified = vim.bo[props.buf].modified
    local res = {
      ft_icon and { ' ', ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or '',
      ' ',
      { filename, gui = modified and 'bold,italic' or 'bold' },
      -- guibg = '#44406e',
    }
    if props.focused then
      for _, item in ipairs(navic.get_data(props.buf) or {}) do
        table.insert(res, {
          { ' > ', group = 'NavicSeparator' },
          { item.icon, group = 'NavicIcons' .. item.type },
          { item.name, group = 'NavicText' },
        })
      end
    end
    table.insert(res, ' ')
    return res
  end,
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

"remote-sshfs.nvim
" NOTE: :RemoteSSHFSConnect user@host:/home/user -p 22
" NOTE: To install `ripgrep` and `fd/fdfind` is recommended on remote server.
lua << EOF
require('remote-sshfs').setup{
connections = {
  ssh_configs = { -- which ssh configs to parse for hosts list
  vim.fn.expand "$HOME" .. "/.ssh/config",
  "/etc/ssh/ssh_config",
  -- "/path/to/custom/ssh_config"
  },
  -- NOTE: Can define ssh_configs similarly to include all configs in a folder
  -- ssh_configs = vim.split(vim.fn.globpath(vim.fn.expand "$HOME" .. "/.ssh/configs", "*"), "\n")
  sshfs_args = { -- arguments to pass to the sshfs command
  "-o reconnect",
  "-o ConnectTimeout=5",
  },
},
mounts = {
  base_dir = vim.fn.expand "$HOME" .. "/.sshfs/", -- base directory for mount points
  unmount_on_exit = true, -- run sshfs as foreground, will unmount on vim exit
},
handlers = {
  on_connect = {
    change_dir = true, -- when connected change vim working directory to mount point
  },
  on_disconnect = {
    clean_mount_folders = false, -- remove mount point folder on disconnect/unmount
  },
  on_edit = {}, -- not yet implemented
},
ui = {
  select_prompts = false, -- not yet implemented
  confirm = {
    connect = true, -- prompt y/n when host is selected to connect to
    change_dir = false, -- prompt y/n to change working directory on connection (only applicable if handlers.on_connect.change_dir is enabled)
  },
},
log = {
  enable = false, -- enable logging
  truncate = false, -- truncate logs
  types = { -- enabled log types
  all = false,
  util = false,
  handler = false,
  sshfs = false,
  },
},
}
EOF

" for docker-compose lang server(needs "npm i -g @microsoft/compose-language-service")
au FileType yaml if bufname("%") =~# "docker-compose.yml" | set ft=yaml.docker-compose | endif
au FileType yaml if bufname("%") =~# "compose.yml" | set ft=yaml.docker-compose | endif

let g:coc_filetype_map = {
      \ 'yaml.docker-compose': 'dockercompose',
      \ }

"treesitter
lua <<EOF
require("nvim-treesitter").setup({})

local group = vim.api.nvim_create_augroup("treesitter_all", {})

-- 起動時に全パーサーをチェックして不足分だけインストール
vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  once = true,
  callback = function()
    pcall(vim.cmd, "TSInstall all")
  end,
})

-- FileType ごとに Tree-sitter を有効化
vim.api.nvim_create_autocmd("FileType", {
  callback = function()

    -- highlight
    pcall(vim.treesitter.start)

    -- indent
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,

})
EOF

"temporary
highlight StatusLine term=None cterm=None gui=None " lualine
highlight StatusLineNC term=None cterm=None gui=None " lualine
highlight TabLineFill term=None cterm=None gui=None " bufferline
