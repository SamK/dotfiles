" configure expanding of tabs for various file types
au BufRead,BufNewFile *.py set expandtab
"au BufRead,BufNewFile *.c set noexpandtab
"au BufRead,BufNewFile *.h set noexpandtab
"au BufRead,BufNewFile Makefile* set noexpandtab

" --------------------------------------------------------------------------------
" configure editor with tabs and nice stuff...
" --------------------------------------------------------------------------------
set expandtab           " enter spaces when tab is pressed
set tabstop=4           " use 4 spaces to represent tab
set softtabstop=4
set shiftwidth=4        " number of spaces to use for auto indent
set autoindent          " copy indent from current line when starting a new line

" display line numbers
se nu

" make backspaces more powerfull
set backspace=indent,eol,start

set ruler                           " show line and column number
sy on                       " syntax highlighting
set showcmd                     " show (partial) command in status line

" Displays characters in red when line lenghts goes over 80
" http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" en fait 120 lol
"match OverLength /\%80v.\+/
match OverLength /\%120v.\+/

" Remove trailing spaces on save
"http://vim.wikia.com/wiki/Remove_unwanted_spaces
autocmd FileType python,c,cpp,java,php autocmd BufWritePre <buffer> :%s/\s\+$//e


"set wrap
"set linebreak
" note trailing space at end of next line
set showbreak=>\ \ \
