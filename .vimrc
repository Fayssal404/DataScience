
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
let path='~/.vim/bundle'

call vundle#begin()
" Plugin Manager
Plugin 'gmarik/Vundle.vim'

" Config
Plugin 'morhetz/gruvbox'
Plugin 'jnurmine/Zenburn'
" Line numbering
Plugin 'jeffkreeftmeijer/vim-numbertoggle'

" Align
Plugin 'godlygeek/tabular'

" Highlight
Plugin 'sheerun/vim-polyglot'
" Select & Move lines
Plugin 'matze/vim-move'

"" Power line
Plugin 'Lokaltog/powerline-fonts'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'powerline/fonts'

"" Power line +
Plugin 'kien/ctrlp.vim'
Plugin 'shougo/denite.nvim'
" Plugin 'vim-ctrlspace/vim-ctrlspace'
Plugin 'edkolev/promptline.vim'


" File system explorer
Plugin 'preservim/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
" Read files
Plugin 'chrisbra/csv.vim'

" Code completion
Plugin 'Valloric/YouCompleteMe'
" Syntastic styles 
Plugin 'tmhedberg/SimpylFold'
"  Indentation 
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'Vimjas/vim-python-pep8-indent'

" Git Plugins
Plugin 'tpope/vim-fugitive'

" Syntastic checker
Plugin 'vim-syntastic/syntastic'
" Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'



"" Snippets
" Track the engine.
Plugin 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'



"" Syntax

" PHP
Plugin 'StanAngeloff/php.vim'
Plugin 'phpactor/phpactor'

" HTML
Plugin 'mattn/emmet-vim'
Plugin 'othree/html5.vim'

" Markdown
Plugin 'plasticboy/vim-markdown'
Plugin 'maksimr/vim-jsbeautify'

" Latex
Plugin 'LaTeX-Box-Team/LaTeX-Box'
Plugin 'lervag/vimtex'

" C Plugins
Plugin 'c.vim'
Plugin 'xavierd/clang_complete'

" Python
" Pandoc
Plugin 'vim-pandoc/vim-pandoc' 
Plugin 'vim-pandoc/vim-pandoc-syntax' 

" Commenting
Plugin 'ddollar/nerdcommenter'


call vundle#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""" General Configuration """"""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""

" display ctags
let g:ctags_regenerate = 0
" keep 10 lines visible after cursor
set scrolloff=20
filetype plugin indent on
set smartindent
set nocompatible " required
filetype plugin on " required
syntax enable
set encoding=utf-8
set number relativenumber
set scrolloff=6 "Display 10 lines before & after cursor
" Shortcuts
" Selecting lines, words, paragraphs
" Find & Replace
" Copy
" Paste
let g:move_key_modifier = 'C'

" Move lines

" Error symbols 
let g:syntastic_error_symbol = "✗"
let syntastic_style_error_symbol = "✗"
let g:syntastic_warning_symbol = "∙∙"
let syntastic_style_warning_symbol = "∙∙"

" Nerdtree Files system
map <C-n> :NERDTreeToggle<CR>
"" Open NerdTree automatically no files specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"" Open Saved Session (deactivate nerdtree)
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") && v:this_session == "" | NERDTree | endif
"" Open Nerdtree Automatically with directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
"" Close vim when only Nerdtree Windows
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" let g:nerdtree_tabs_open_on_console_startup=1

" Markdown
let g:vim_markdown_folding_disabled = 0
let g:vim_markdown_folding_style_pythonic = 1 "Pythonic folding
let g:vim_markdown_override_foldtext = 0
let g:vim_markdown_folding_level = 2  " folding level
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_emphasis_multiline = 0
let g:vim_markdown_new_list_item_indent = 2 " numbe of spaces of indent

" markdown conceal 
let g:vim_markdown_conceal=0 " enable concealing
let g:vim_markdown_math = 1 " turn on latex math syntax
let g:vim_markdown_conceal_code_blocks=0

" YAML front matter
let g:vim_markdown_frontmatter = 1

let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_json_frontmatter = 1 " highligh json front matter
let g:vim_markdown_auto_insert_bullets = 0 " don't insrt bulletpoints
let g:pandoc#filetypes#handled = ["pandoc", "markdown"]
let g:pandoc#filetypes#pandoc_markdown=0

" Python Highlighting
let g:python_highlight_all=1
let g:python_highlight_builtins=1
let g:python_highlight_builtin_objs=1 
let g:python_highlight_builtin_types=1
let g:python_highlight_builtin_funcs=1
let g:python_highlight_exceptions=1
let g:python_highlight_string_formatting=1
let g:python_highlight_indent_errors=1
let g:python_highlight_space_errors=1

" Latex
let g:LatexBox_completion_commands=''
let g:LatexBox_completion_close_braces='{}'
let g:LatexBox_Folding = 1
let g:tex_flavor='latex'

"""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""" Powerline Configuration """"""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Promptline

let g:promptline_preset = {
        \'a' : [ promptline#slices#host({'only_if_ssh':2})],
        \'b' : [ promptline#slices#user() ],
        \'c' : [ promptline#slices#cwd({'dir_limit':4})],
        \'y' : [ promptline#slices#vcs_branch() ],
        \'warn' : [ promptline#slices#last_exit_code() ]}



" Power line Settings
let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts=1
let g:airline_theme='molokai'

if !exists('g:airline_symbols')
   let g:airline_symbols = {}
endif

if has('gui_running')
    "set guifont=DejaVu Sans Mono for Powerline
    set guifont=Droid\ Sans\ Mono\ Slashed\ for\ Powerline
endif
set linespace=0
let g:airline_symbols.branch = '⎇'
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.crypt = '🔒'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter='unique_tail_improved'
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#buffer_idx_mode = 1

" let g:airline#extensions#tabline#formatter = 'default'
" Gruvbox Settings
colorscheme gruvbox
let g:gruvbox_bold=1
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_contrast_light='hard'
set background=dark

" Managing Multiple Windows


" Folding Settings
"let g:SimpylFold_docstring_preview=1
set foldmethod=indent 	
" Space to fold
nnoremap <space> za 

" Pep8 format 
let g:python_pep8_indent_multiline_string = 1 
let g:python_pep8_indent_hang_closing = 1 " Control closing brackets

" Hanling error settings
let g:syntastic_python_checker=['pylint']

" C config
let  g:C_UseTool_cmake    = 'yes'
let  g:C_UseTool_doxygen  = 'yes' 
" path to directory where library can be found
let g:clang_library_path='/usr/lib/llvm-3.8/lib'


" Emmet-vim html
" auto tag complete
" TODO: check emmet balance
let g:user_emmet_leader_key='<Tab>' " remap the default <C-Y> leader


" Php config
let g:php_syntax_extensions_enabled= ["bcmath", "bz2", "core", "curl", "date", "dom", "ereg", "gd", "gettext", "hash", "iconv", "json", "libxml", "mbstring", "mcrypt", "mhash", "mysql", "mysqli", "openssl", "pcre", "pdo", "pgsql", "phar", "reflection", "session", "simplexml", "soap", "sockets", "spl", "sqlite3", "standard", "tokenizer", "wddx", "xml", "xmlreader", "xmlwriter", "zip", "zlib"]


let g:php_var_selector_is_identifier=1 " include $ as part of the highlighting grp
let g:php_html_load=1 " enable embedding HTML in PHP
let g:php_sql_query=1 " Enable SQL syntax in PHP


" Put this function at the very end of your vimrc file.
function! PhpSyntaxOverride()
  " Put snippet overrides in this function.
  hi! link phpDocTags phpDefine
  hi! link phpDocParam phpType
endfunction

augroup phpSyntaxOverride
  autocmd!
  autocmd FileType php call PhpSyntaxOverride()
augroup END

" Colourising parentheses
syn match phpParentOnly "[()]" contained containedin=phpParent
hi phpParentOnly guifg=#f08080 guibg=NONE gui=NONE



" snippets config
let g:UltiSnipsExpandTrigger="<s>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"






