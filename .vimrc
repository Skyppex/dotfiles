let mapleader = " "
nmap <space> <leader>

nnoremap <silent> U <C-r>

nnoremap <silent> <C-c> <Esc>
inoremap <silent> <C-c> <Esc>
vnoremap <silent> <C-c> <Esc>

nnoremap <leader>. f.i<CR><Esc>l==

vnoremap K :m '<-2<CR>gv=gv
vnoremap J :m '>+1<CR>gv=gv

vnoremap <silent> < <gv
vnoremap <silent> > >gv
