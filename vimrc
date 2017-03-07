" VIM Configuration -- Samuel Krieg
"
" Sources:
" Vincent Jousse
" https://github.com/sd65/MiniVim
" http://www.oualline.com/vim/10/top_10.html

" 1. Plugins
" 2. General configuration
" 3. Insertion
" 4. Display
" 5. Theme
" 6. coloration syntaxique
" 7. Programming


" 1. Plugins
" ------------------------

" Annuel la compat. avec l'ancetre Vi.
set nocompatible              " be iMproved, required
filetype off                  " required

"Enable Vundle https://github.com/VundleVim/Vundle.vim
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

" Active les comportements specifiques aux types de fichiers comme
" la syntaxe et l’indentation
"filetype plugin on
"filetype indent on

" 2. General configuration
" ------------------------

" recherche
set ignorecase " Ignore la casse lors d’une recherche
set smartcase  " Si une recherche contient une majuscule,
               " re-active la sensibilite a la casse
set incsearch  " Surligne les resultats de recherche pendant la
               " saisie
set hlsearch   " Surligne les resultat
set ignorecase " Search insensitive
set smartcase " ... but smart

" Cache les fichiers lors de l’ouverture d’autres fichiers
set hidden

set history=100 " Keep 100 undo

" Remove trailing spaces on save
"http://vim.wikia.com/wiki/Remove_unwanted_spaces
autocmd FileType python,c,cpp,java,php autocmd BufWritePre <buffer> :%s/\s\+$//e

"set linebreak
" note trailing space at end of next line
set showbreak=>\ \ \


" 3. Insertion
" ------------------------

" tabs + indentation
set expandtab           " enter spaces when tab is pressed
set tabstop=4           " use 4 spaces to represent tab
set softtabstop=4
set shiftwidth=4        " number of spaces to use for auto indent

set showmatch " When a bracket is inserted, briefly jump to the matching one
set matchtime=3 " ... during this time

" make backspaces usable
set backspace=indent,eol,start

" 4. Display
" ------------------------

" display line numbers
set title               " met a jour le titre de la fenetre/terminal
se nu                   " (number)
set ruler               " show line and column number
set showcmd             " show (partial) command in status line
"set wrap               " Affiche les lignes trop longues sur plusieurs lignes
set scrolloff=10 " Always keep 10 lines after or before when scrolling
set sidescrolloff=5 " Always keep 5 lines after or before when side scrolling
set showtabline=2 " Always show tabs
set laststatus=2 " Always show status bar

" 5. Theme
" ------------------------

" I want to user Solarized
set t_Co=256
let g:solarized_termcolors=16
set background=dark
colorscheme solarized

" 6. coloration syntaxique
" ------------------------

syntax enable          " (sy on) syntax highlighting

" Displays characters in red when line lenghts goes over 80
" http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%80v.\+/    " 80
match OverLength /\%120v.\+/   " 120

" 7. Programming
" ------------------------

" configure expanding of tabs 
au BufRead,BufNewFile *.py set expandtab

" folding
set foldmethod=indent
set foldnestmax=2

" Highlight trailing spaces http://stackoverflow.com/a/13795287
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" END
