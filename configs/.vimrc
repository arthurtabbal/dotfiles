" ========== CONFIGURAÇÕES BÁSICAS ==========
set nocompatible
set encoding=utf-8
set fileencoding=utf-8
set path+=**
filetype plugin on

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
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25

" ========== MAPPINGS ==========
let mapleader = ","

nnoremap <silent> <C-h> :bprevious<CR>
nnoremap <silent> <C-l> :bnext<CR>
nnoremap <silent> <leader>bd :bd<CR>

nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" --- Navegação rápida no insert ---
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-a> <Home>
inoremap <C-e> <End>

" --- Edição essencial no insert ---
inoremap <C-h> <BS>
inoremap <C-d> <Del>

" ========== FUNÇÃO PARA NETRW INTELIGENTE ==========
function! SmartNetrw()
  " Se já existe um buffer do netrw aberto, vai para ele
  let netrw_buf = bufnr('^' . getcwd() . '$')
  if netrw_buf != -1
    execute 'buffer ' . netrw_buf
  else
    Lexplore
  endif
endfunction

" Mapeamento corrigido
nnoremap <silent> <leader>e :call SmartNetrw()<CR>

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
