" Skandix's Vim Conf

set nocompatible
filetype plugin on

call plug#begin('~/.vim/plugged')

""" PLUGIN LIST START
"" NERD Tree Syntax
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

"" deoplete for python
Plug 'zchee/deoplete-jedi'

"" NERD tree Tabs
Plug 'jistr/vim-nerdtree-tabs'

"" NERD tree
Plug 'scrooloose/nerdtree'

"" fuzzy file finder
Plug 'kien/ctrlp.vim'

"" Vim JSON
Plug 'elzr/vim-json'

"" Vim Go
Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}

"" Better Whitespace
Plug 'ntpeters/vim-better-whitespace'

"" Ligth version of Powerline
Plug 'itchyny/lightline.vim'

"" Async lint engine
Plug 'w0rp/ale'

"" python autocomplete 
Plug 'davidhalter/jedi-vim'

"" Vim Gitgutter, shows diff in Vim
Plug 'airblade/vim-gitgutter'

"" Syntax highligth for common filetypes
Plug 'pearofducks/ansible-vim'

"" Colorscheme 
Plug 'liuchengxu/space-vim-dark'

"" Auto close brackets
Plug 'cohama/lexima.vim'

" deoplete plugin stuff
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

""" PLUGIN LIST END
call plug#end()            " end of plugin section
filetype plugin indent on    " required

""" Lettings
let mapleader="-"
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
let g:ycm_autoclose_preview_window_after_completion=1

""" KEYBINDS
map <C-g>  :YcmCompleter GoToDefinitionElseDeclaration<CR>
map <C-d> :NERDTreeToggle<CR>
map  <C-f> :tabn<CR>
map  <C-t> :tabnew<CR>
nnoremap <F1> :set hlsearch!<CR>
nnoremap <silent> <F2> :!clear;python %<CR>
nnoremap <silent> <F3> :!clear;python3 %<CR>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <BS> X

"" deoplet stuff.... 
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources={}
let g:deoplete#sources._=['buffer', 'member', 'tag', 'file', 'omni', 'ultisnips']
let g:deoplete_ignore_sources = [ "buffer", "*.wiki" ]


let g:deoplete#omni#input_patterns={}
let g:deoplete#enable_at_startup = 1
let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.scala = '[^. *\t]\.\w*\|: [A-Z]\w*'
"let g:deoplete#omni#input_patterns.scala = ['[^. *\t0-9]\.\w*',': [A-Z]\w', '[\[\t\( ][A-Za-z]\w*']
"call deoplete#custom#source('_', 'converters',
"      \ ['converter_auto_paren',
"      \  'converter_auto_delimiter',
"      \ 'converter_remove_overlap']) "]
let g:deoplete#enable_at_startup = 1

""" COLORSCHEME
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }
syntax enable
colorscheme space-vim-dark
hi Normal     ctermbg=NONE guibg=NONE
hi LineNr     ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE


if &term =~ '256color'
  set t_ut=
endif
""" BEHAVE

set wildmode=list:longest,full	" Show vim completion menu
set encoding=utf-8				" encoding
set undolevels=256				" how many times one can undo
set updatetime=250				" Faster update of internals
set numberwidth=6				" with of the 'gutter' col for numbering
set foldmethod=indent
set foldlevel=99
set splitright
set backspace=indent,eol,start
set matchpairs+=<:>
set splitbelow
set textwidth=128				" 
set shiftwidth=4				" 
set laststatus=2				" Display statusline
set cmdheight=1					" Height of the command bar
set history=256					" How much history to save.
set noshowmode 					" Lightline handle this
set autoindent					" copies indent from prev line, to next new line
set cursorline          		" highlight current line
set ignorecase					" Ignore case when searching.
set smartcase					" Dont ignore case if there is capitals in the search pattern
set showmatch           		" highlight matching [{()}]
set incsearch           		" search as characters are entered
set smarttab
set wildmenu            		" visual autocomplete for command men
set hlsearch            		" highlight matches
set autoread 					" checks if file has changed externally
set ttyfast tf						" faster redrawing
set showcmd             		" show command in bottom bar
set number              		" show line numbers
set rnu							" Relative line numbering


""" COMMMANDS (taken from lasseh .vimrc)
command! Q q
command! W w

""" NERDTREE SETTINGS (taken from lasseh .vimrc)
" Open Nerdtree if no files specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Close vim if nerdtree is only buffer left when :q
function! s:CloseIfOnlyControlWinLeft()
	if winnr("$") != 1
		return
	endif
	if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
				\ || &buftype == 'quickfix'
		q
	endif
endfunction
augroup CloseIfOnlyControlWinLeft
	au!
	au BufEnter * call s:CloseIfOnlyControlWinLeft()
augroup END

""" ALE (taken from lasseh .vimrc)
let g:ale_sign_warning = '▲'
let g:ale_sign_error = '✗'
let g:ale_use_deprecated_neovim = 1
highlight link ALEWarningSign String
highlight link ALEErrorSign Title