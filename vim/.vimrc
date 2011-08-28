filetype plugin on
filetype indent on



set expandtab
set shiftwidth=2
set tabstop=2
set smarttab

set lbr
set tw=500

set ai "Auto indent
set si "Smart indet
set wrap "Wrap lines

" tab settings
"set expandtab
"set autoindent
""set smartindent
"set shiftwidth=2
"set tabstop=2

set showmatch
syntax on
set number

autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
map <F8> :NERDTreeToggle<CR>

" easy tab navigation
map  <C-l> :tabn<CR>
map  <C-k> :tabp<CR>
map  <C-n> :tabnew<CR>
map  <F2> <Esc>:wqa<CR>

" run make and node
nmap <F4> :w<CR>:make<CR>:cw<CR>
map <F5> :w<CR>:!node %:p<CR>
imap <F5> <Esc>:w<CR>:!node %:p<CR>

" code formatting
map <F6> <Esc>gg=G<CR>:w<CR>
imap <F6> <Esc>gg=G<CR>:w<CR>

" shell
map <F7> <Esc>:w<CR>:sh<CR>

" Shortcuts with the leader
let mapleader = ","
nmap <leader>w :w!<CR>
map <leader>e :e! ~/.vimrc<cr>
map <leader>q :wq!<cr>

"experimental
set autoread " autoread if file is changed from outside
set wildmenu
set ruler
set cmdheight=2
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set nobackup
set nowb
set noswapfile

" Map auto complete of (, ", ', [
inoremap $1 ()<esc>i
inoremap $2 []<esc>i
inoremap $3 {}<esc>i
inoremap $4 {<esc>o}<esc>O
inoremap $q ''<esc>i
inoremap $e ""<esc>i
inoremap $t <><esc>i

