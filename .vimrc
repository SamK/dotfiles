" VIM Configuration -- Samuel Krieg
"
" Sources:
" Vincent Jousse
" https://github.com/sd65/MiniVim
" http://www.oualline.com/vim/10/top_10.html

" 1. General configuration
" 2. Insertion
" 2. Display
" 3. Theme
" 4. coloration syntaxique
" 5. Programming
" 6. Plugins

" 1. General configuration
" ------------------------

" Annuel la compat. avec l'ancetre Vi.
set nocompatible

set encoding=utf-8
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
"autocmd FileType yml,yaml,python,c,cpp,java,php autocmd BufWritePre <buffer> :%s/\s\+$//e

"set linebreak
" note trailing space at end of next line
set showbreak=>\ \ \

" Remove trailing spaces with "F5"
nnoremap <silent> <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" 2. Insertion
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

" auto comment, voir ":help fo-table" pour la doc
set formatoptions=tcqr

" map key F10 for paste toggle
set pastetoggle=<F10>

" disable automatic end of line (be friendly with windows users)
set nofixendofline

" 2. Display
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

" 3. Theme
" ------------------------

" I want to user Solarized
set t_Co=256
let g:solarized_termcolors=16
set background=dark
colorscheme solarized

" 4. coloration syntaxique
" ------------------------

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

" 5. Programming
" ------------------------

" configure expanding of tabs 
au BufRead,BufNewFile *.py set expandtab
au BufRead,BufNewFile *.pp set expandtab tabstop=2 softtabstop=2 shiftwidth=2 smarttab
au BufRead,BufNewFile *.json set foldmethod=syntax
"au BufRead,BufNewFile *.bats set filetype=bash
"au BufRead,BufNewFile {Jenkinsfile,*.jenkinsfile,*.jenkins,*.jk} set expandtab tabstop=2 softtabstop=2 shiftwidth=2 smarttab

" yaml
au BufRead,BufNewFile *.{yaml,yml} set expandtab tabstop=2 softtabstop=2 shiftwidth=2 smarttab
" indentLine plugin
"let g:indentLine_char = '·' # smal dot

" folding
set nofoldenable
"set foldmethod=indent
"set foldnestmax=2

" Highlight trailing spaces http://stackoverflow.com/a/13795287
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()


let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_lint_on_text_changed = 'never'
" funny cursor
highlight ALEWarning ctermbg=DarkMagenta


" 6. Plugins
" ------------------------

call plug#begin('~/.vim/plugged')
" Ansible
Plug 'pearofducks/ansible-vim'
" Ansible alternative
"Plug 'chase/vim-ansible-yaml'
" Python syntax highlight
Plug 'hdima/python-syntax'
Plug 'samk/vim-puppet', { 'branch': 'colon-is-not-a-keyword' }
Plug 'kaarmu/typst.vim'
Plug 'terrastruct/d2-vim'
Plug 'Yggdroot/indentLine'
" https://www.arthurkoziel.com/setting-up-vim-for-yaml/
" https://github.com/dense-analysis/ale
Plug 'dense-analysis/ale'

call plug#end()

"
" 7. Git commits

" do not remember last cursor position https://stackoverflow.com/a/26808971
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])

"  Git commit Summary
"  ---------------------
"highlight commit subject
highlight gitcommitSummary ctermfg=darkblue
"wrap subject at 72 characters
autocmd FileType gitcommitSummary set textwidth=72
" highlight if longer than 50
autocmd FileType gitcommitSummary set colorcolumn=50

" Git commit message

"wrap message at 72 characters
autocmd FileType gitcommit set textwidth=72
" highlight if longer
autocmd FileType gitcommit set colorcolumn=73

:set list
:set listchars=tab:>-,trail:~,extends:>,precedes:<
