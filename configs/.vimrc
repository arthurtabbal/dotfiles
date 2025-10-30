" ======== CONFIGURAÇÕES BÁSICAS ==========
set nocompatible
set encoding=utf-8
set fileencoding=utf-8
set mouse=a
set path+=**
set complete=.,w,b,u,t,i,kspell
filetype plugin on

" Detecta se está rodando dentro do tmux
if exists('$TMUX')
  " Se o Vim tiver suporte ao modo SGR (mais moderno), usa ele
  if has('mouse_sgr')
    set ttymouse=sgr
  else
    set ttymouse=xterm2
  endif
endif


" ========== INTERFACE ==========
syntax enable
set number
set showcmd
set wildmenu
set wildmode=full
set laststatus=2
set title
set cursorline
set scrolloff=10

" ========== TEMA E CORES ==========
set background=dark

" Cores principais
highlight Normal ctermfg=253 ctermbg=233
highlight Comment ctermfg=246
highlight EndOfBuffer ctermfg=236

" Tons pasteis
highlight Constant ctermfg=117
highlight String ctermfg=159
highlight Number ctermfg=117
highlight Identifier ctermfg=111
highlight Function ctermfg=111
highlight Type ctermfg=111
highlight Statement ctermfg=176
highlight PreProc ctermfg=141
highlight Special ctermfg=183

" Tons de azul pasteis
highlight Character ctermfg=159
highlight Float ctermfg=117

" Tons de roxo/rosa pasteis
highlight Conditional ctermfg=176
highlight Repeat ctermfg=176
highlight Label ctermfg=176
highlight Operator ctermfg=176
highlight Keyword ctermfg=176
highlight Exception ctermfg=176
highlight Include ctermfg=176
highlight Define ctermfg=176
highlight Macro ctermfg=176
highlight PreCondit ctermfg=141

" Destaques
highlight Error ctermfg=203 ctermbg=233
highlight Todo ctermfg=203 ctermbg=233 cterm=bold
highlight ColorColumn ctermbg=234
highlight CursorLine ctermbg=234 cterm=none
highlight CursorLineNr ctermfg=245 cterm=none
highlight LineNr ctermfg=240
highlight Pmenu ctermfg=253 ctermbg=235
highlight PmenuSel ctermfg=233 ctermbg=111
highlight Search ctermfg=NONE ctermbg=235
highlight Visual ctermbg=235

" ========== CORES PARA OS MAPPINGS ==========
" Destaque para conteúdo dentro de <>
highlight helpNote ctermfg=111 cterm=bold
highlight helpHyperTextJump ctermfg=176

" ========== STATUS LINE INVERTIDA ==========
highlight StatusLine ctermfg=235 ctermbg=247
highlight StatusLineNC ctermfg=235 ctermbg=240

"+++++++ Configurações básicas de diff
set diffopt+=vertical        " Abre diffs em vertical por padrão
set diffopt+=iwhite          " Ignora mudanças de whitespace
set diffopt+=hiddenoff       " Foca nas mudanças reais
set diffopt+=foldcolumn:1    " Adiciona uma coluna para folds

"+++++++ Cores para modo diff (terminal 256 cores)
highlight DiffAdd    ctermfg=Black ctermbg=Green guifg=#000000 guibg=#A6E3A1
highlight DiffChange ctermfg=Black ctermbg=Yellow guifg=#000000 guibg=#F9E2AF
highlight DiffDelete ctermfg=White ctermbg=Red    guifg=#FFFFFF guibg=#F38BA8
highlight DiffText   ctermfg=Black ctermbg=White  guifg=#000000 guibg=#FFFFFF

" ===== NETRW COLORS MINIMALISTAS =====

" Diretórios em azul pastel
hi netrwDir       ctermfg=111 cterm=none

" Arquivos executáveis em verde suave
hi netrwExe       ctermfg=117 cterm=none

" Links simbólicos em ciano claro
hi netrwLink      ctermfg=159 cterm=none
hi netrwSymLink   ctermfg=159 cterm=none

" Arquivos comuns em cinza claro
hi netrwPlain     ctermfg=253 cterm=none

" Sufixos de classificação (/ @ *) em lilás suave
hi netrwClassify  ctermfg=176 cterm=none

" Comentários do netrw em cinza médio
hi netrwComment   ctermfg=246 cterm=none

" Arquivos marcados em vermelho pastel
hi netrwMarkFile  ctermfg=203 cterm=bold

" Barras da árvore (|, -) em cinza escuro
hi netrwTreeBar   ctermfg=240 cterm=none

" Listagem no tree mode em cinza médio
hi netrwList      ctermfg=245 cterm=none

" Cor da linha de separação
hi VertSplit ctermfg=238 ctermbg=233 cterm=none

" Substitui tracejado por espaço vazio
set fillchars+=vert:.

" Status
set statusline=
set statusline+=%#StatusLine#
set statusline+=%f
set statusline+=%m
set statusline+=%r
set statusline+=%=
set statusline+=%y
set statusline+=\ │
set statusline+=%{&fileencoding}
set statusline+=\ │
set statusline+=%{&fileformat}
set statusline+=\ │
set statusline+=%3l:%2c
set statusline+=\ │
set statusline+=%3p%%

" ========== ARQUIVOS ==========
set nobackup
set nowritebackup
set noswapfile
set autoread

" ========== BUSCA ==========
set ignorecase
set smartcase
set hlsearch
set incsearch

" ========== IDENTAÇÃO ==========
set autoindent
set smartindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround

" ========== EDITING ==========
set whichwrap+=<,>,h,l
set nowrap
set hidden

" ========== PERFORMANCE ==========
set lazyredraw
set ttyfast
set synmaxcol=200

" ========== NETRW ==========
let g:netrw_banner = 1
let g:netrw_liststyle = 3
let g:netrw_winsize = 75
set splitright
let g:netrw_altv = 1
let g:netrw_browse_split = 4
let g:netrw_keepdir=0

" ========== MAPPINGS ==========
let mapleader = " "

nnoremap <silent> <C-h> :bprevious<CR>
nnoremap <silent> <C-l> :bnext<CR>
nnoremap <silent> <leader>bd :bd<CR>

nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

if executable('wl-copy')
  vnoremap <leader>y :w !wl-copy<CR><CR>
endif

" --- Navegação rápida no insert ---
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-a> <Home>
inoremap <C-e> <End>

" --- Edição essencial no insert ---
inoremap <C-h> <BS>
inoremap <C-d> <Del>

" --- COMMANDS ----
command! W execute 'w !sudo tee % > /dev/null' | edit!

" ========== AUTOCOMMANDS ==========
augroup vimrc
  autocmd!
  autocmd BufWritePre * %s/\s\+$//e
  autocmd FileType python setlocal shiftwidth=4 tabstop=4
  autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
  autocmd FileType html setlocal shiftwidth=2 tabstop=2
  autocmd FileType css setlocal shiftwidth=2 tabstop=2
  autocmd FileType json setlocal shiftwidth=2 tabstop=2
  autocmd FileType yaml setlocal shiftwidth=2 tabstop=2
augroup END

command! DiffOrig let g:diffline = line('.') | vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
nnoremap <leader>do :DiffOrig<cr>
nnoremap <leader>dc :q<cr>:diffoff<cr>:exe "norm! ".g:diffline."G"<cr>
