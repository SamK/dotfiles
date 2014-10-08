" VIM Configuration -- Samuel Krieg
" Sources: Vincent Jousse

" Annuel la compat. avec l'ancetre Vi.
set nocompatible


" -- development
" --------------
" configure expanding of tabs for various file types
au BufRead,BufNewFile *.py set expandtab
"au BufRead,BufNewFile *.c set noexpandtab
"au BufRead,BufNewFile *.h set noexpandtab
"au BufRead,BufNewFile Makefile* set noexpandtab


" tabs + indentation
" ------------------
set expandtab           " enter spaces when tab is pressed
set tabstop=4           " use 4 spaces to represent tab
set softtabstop=4
set shiftwidth=4        " number of spaces to use for auto indent
set autoindent          " copy indent from current line when starting a new line

" display
" ---------------------------
" display line numbers
set title               " met a jour le titre de la fenetre/terminal
se nu                   " (number)
set ruler               " show line and column number
set showcmd             " show (partial) command in status line

"set wrap               " Affiche les lignes trop longues sur plusieurs lignes

" themes
" ------------
set t_Co=256
let g:solarized_termcolors=16
set background=dark
colorscheme solarized

" coloration syntaxique
" ---------------

syntax enable          " (sy on) syntax highlighting
" Active les comportements specifiques aux types de fichiers comme
" la syntaxe et l’indentation
filetype on
filetype plugin on
filetype indent on

" Displays characters in red when line lenghts goes over 80
" http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%80v.\+/    " 80
match OverLength /\%120v.\+/   " 120


" Cache les fichiers lors de l’ouverture d’autres fichiers
set hidden

" recherche
" ---------
set ignorecase " Ignore la casse lors d’une recherche
set smartcase  " Si une recherche contient une majuscule,
               " re-active la sensibilite a la casse
set incsearch  " Surligne les resultats de recherche pendant la
               " saisie
set hlsearch   " Surligne les resultat

" keyboard
" -------------------

" make backspaces usable
set backspace=indent,eol,start

" Remove trailing spaces on save
"http://vim.wikia.com/wiki/Remove_unwanted_spaces
autocmd FileType python,c,cpp,java,php autocmd BufWritePre <buffer> :%s/\s\+$//e

"set linebreak
" note trailing space at end of next line
set showbreak=>\ \ \
