" General
set nocompatible
syntax on
filetype plugin indent on

"" Tabstops/Search/...
set expandtab
set softtabstop=4
set shiftwidth=4
set hlsearch
set incsearch
set showcmd
set number
set laststatus=2
set textwidth=0
set splitbelow
set splitright
set bs=2
set whichwrap+=<,>,[,]
set noeol
set scrolloff=3
set secure
set exrc
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
    set undodir=~/.vim/undo
endif
if $TMUX != ''
    set clipboard=unnamed
endif
set wildmenu
set wildmode=longest:full,full
set updatetime=300
set mouse=

" Characters
set lcs=tab:▸\ ,nbsp:·
set list
inoremap   <space>

" Mappings
nnoremap <C-Space> :nohl<CR>
nnoremap <F6> :set number!<CR>
noremap <leader>ss :w !sudo tee % > /dev/null<CR>
noremap q: :q

" Navigate Splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Appearance
if (has('termguicolors'))
    set termguicolors
endif

if (exists('+colorcolumn'))
    set colorcolumn=80
    highlight link ColorColumn LineNr
endif

" Clojure
let g:iced_enable_default_key_mappings = v:true
let g:iced_enable_auto_indent = v:false
aug VimIced
  au!
  au FileType clojure nmap <buffer> <leader>e! <Plug>(iced_eval_and_comment)<Plug>(sexp_outer_list)
  au FileType clojure nmap <buffer> <leader>gtt <Plug>(iced_cycle_src_and_test)
  au FileType clojure nmap <buffer> <leader>gt :vs<CR><Plug>(iced_cycle_src_and_test)
aug end
