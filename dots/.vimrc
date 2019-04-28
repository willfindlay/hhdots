filetype plugin on
set nocompatible

let mapleader=","

let g:jsx_ext_required = 0
let g:pandoc#syntax#conceal#use = 0
let g:acp_completeOption = '.,w,b,k,t'
let g:acp_ignorecaseOption = 0
let g:gutentags_ctags_tagfile = '.git/tags'

" air-line
let g:airline_theme='onedark'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline#extensions#tabline#buffer_idx_mode = 1

" nerdtree
autocmd vimenter COMMIT_EDITMSG let b:commit_editmsg=1
" we don't want to display NERDTree for github commit messages
" and we don't want it in focus when we open vim
autocmd vimenter *
            \ if !exists("b:commit_editmsg") |
            \ NERDTree |
            \ wincmd w |
            \ endif
nnoremap <silent> <Leader>t :NERDTreeFocus<CR>
" we don't want to close the nerdtree buffer
autocmd FileType nerdtree cnoreabbrev <buffer> bd <nop>
" we don't want to overwrite nerdtree
autocmd FileType nerdtree cnoreabbrev <buffer> e wincmd p<CR>:e
" close if nerdtree is the only window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" closing in nerdtree should close the previously opened window instead
autocmd FileType nerdtree cnoreabbrev <buffer> q wincmd p<CR>:q<CR>

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

execute pathogen#infect()

" Indent settings
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set nosmarttab

" blinking cursor
set guicursor=a:blinkwait700-blinkon400-blinkoff250

" path settings
set path+=**

" netrw stuff
let g:netrw_banner=0
let g:netrw_liststyle=3

" open splits below and to the right
set splitbelow
set splitright

" only do this part when compiled with support for autocommands.
if has("autocmd")
    " use filetype detection and file-based automatic indenting.
    filetype plugin indent on

    " remove trailing whitespace
    autocmd BufWritePre * let _save_pos=getpos(".") | let _s=@/ | silent! %s/\s\+$//e | let @/=_s | unlet _s | call setpos('.', _save_pos) | unlet _save_pos | noh

    " use actual tab chars in Makefiles.
    autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab

    autocmd BufEnter * :syntax sync fromstart

    " syntax: autocmd BufNewFile *.rmd r /home/$(USER)/.vimskeletons/$(FILE)
    autocmd FileType rmd set spell
    autocmd FileType rmd set spelllang=en_us
    autocmd FileType markdown set spell
    autocmd FileType markdown set spelllang=en_us

    " rmarkdown stuff
    autocmd BufNewFile *.rmd :silent execute "r $HOME/.vimskeletons/rmd" | :silent execute "w"
    " autocompile
    autocmd BufWritePost *.rmd :silent execute "!(echo \"require(rmarkdown); render('\<afile>')\" | R --vanilla -q > /dev/null 2> /dev/null ; killall -SIGHUP mupdf > /dev/null 2> /dev/null) &"
    " automagically open mupdf for previewing (and compile once)
    autocmd FileType rmd :silent execute "!(echo \"require(rmarkdown); render('\<afile>')\" | R --vanilla -q > /dev/null 2> /dev/null ; mupdf $(basename -s .rmd \<afile>).pdf > /dev/null 2> /dev/null) &"
    " start cursor in the appropriate part of the skeleton
    autocmd BufReadPost,BufNewFile *.rmd :normal /--- nj}zz
    autocmd FileType rmd map <F5> :!echo<space>"require(rmarkdown);<space>render('<c-r>%');"<space>\|<space>R<space>--vanilla<enter>

    "" markdown stuff
    "" autocompile
    "autocmd BufWritePost *.md :silent execute "!(pandoc % -f gfm -o /tmp/%:t:r.pdf; killall -SIGHUP mupdf > /dev/null 2> /dev/null) &"
    "" automagically open mupdf for previewing (and compile once)
    "autocmd FileType markdown :silent execute "!(pandoc % -f gfm -o /tmp/%:t:r.pdf ; mupdf /tmp/%:t:r.pdf > /dev/null 2> /dev/null) &"
    "autocmd FileType markdown map <F5> :!(pandoc % -f gfm -o /tmp/%:t:r . '.pdf')

    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

    " RMS for age of empires ii
    autocmd BufNewFile *.rms execute "r $HOME/.vimskeletons/rms" | execute "w"| execute "redraw!"

    " C++ stuff
   " autocmd BufNewFile *.cc if @% != 'main.cc' | execute "r $HOME/.vimskeletons/cpp" | execute "%s/HEADERNAME/\\=expand('%:t:r') . '.h'/g" | execute "%s/CLASSNAME/\\=expand('%:t:r')/g" | execute "w" | execute "edit ".expand('%:t:r').'.h' | execute "r $HOME/.vimskeletons/cpph" | execute "%s/INCLUSIONGUARD/\\=toupper(expand('%:t:r')) . '\_H'/g" | execute "%s/CLASSNAME/\\=expand('%:t:r')/g" | execute "1d" | execute "w" | execute "edit ".expand('%:t:r').'.cc' | else | execute "r $HOME/.vimskeletons/maincpp" | endif | execute "1d" | execute "w" | execute "redraw!" | if @% == 'main.cc' | execute "call cursor(3,0)"
   " " Qt stuff
   " autocmd BufNewFile *.pro execute "r $HOME/.vimskeletons/pro" | execute "%s/APPNAME/\\=expand('%:t:r')" | execute "w" | execute "1d" | execute "w" | execute "redraw!" | execute "edit ".expand('%:t:r').'.qrc' | execute "r $HOME/.vimskeletons/qrc" | execute "1d" | execute "w" | execute "edit ".expand('%:t:r').'.pro' | execute "redraw!"

    " prolog
    autocmd BufEnter *.pl set syntax=prolog

    " autocompletion
    au FileType * execute 'setlocal dict+=~/.vim/words/'.&filetype.'.txt'
    "au TextChangedI * :silent execute "normal a\<C-n>\<C-p>\<Esc>"
endif

" autocompletion stuff
set completeopt=menuone,longest
set tags += ".git/tags"
set complete+=k
set complete+=t
set pumheight=5
if has("autocmd") && exists("+omnifunc")
  autocmd Filetype *
          \	if &omnifunc == "" |
          \		setlocal omnifunc=syntaxcomplete#Complete |
          \	endif
endif

" cause undos to go back to autocomplete acceptance
" autocomplete menu interaction with arrow keys
inoremap <expr> <down> ((pumvisible())?("\<C-n>"):("\<C-o>gj"))
inoremap <expr> <up> ((pumvisible())?("\<C-p>"):("\<C-o>gk"))
inoremap <expr> <left> ((pumvisible())?("\<C-e>\<left>"):("\<left>"))
inoremap <expr> <right> ((pumvisible())?("\<C-e>\<right>"):("\<right>"))
" autocomplete enter to select
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" auto highlight the menu
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" allow buffers to switch when modified
set hidden

" set line numbers to be on by default (I don't know why this isn't a default setting lol)
set number

" set line wrapping
set breakindent
set wrap lbr

" add filename at bottom
"set statusline=%<%F\ %h%m%r%=%-14.(%l,%c%V%)\ %P
"set ls=2

" better tabs
inoremap <S-Tab> <C-d>
inoremap <Tab> <C-t>
nnoremap <S-Tab> <<
nnoremap <Tab> >>
vnoremap <S-Tab> <
vnoremap <Tab> >

" move up and down by visual line
nmap <silent> <Down> gj
nmap <silent> <Up> gk

" get rid of annoying behavior on up and down arrow keys
inoremap <S-UP>   <UP>
nnoremap <S-UP>   <UP>
vnoremap <S-UP>   <UP>
inoremap <S-DOWN> <DOWN>
nnoremap <S-DOWN> <DOWN>
vnoremap <S-DOWN> <DOWN>

" get rid of annoying jump by word behavior on arrow keys
inoremap <S-RIGHT> <RIGHT>
nnoremap <S-RIGHT> <RIGHT>
vnoremap <S-RIGHT> <RIGHT>
inoremap <S-LEFT>  <LEFT>
nnoremap <S-LEFT>  <LEFT>
vnoremap <S-LEFT>  <LEFT>
inoremap <C-RIGHT> <RIGHT>
nnoremap <C-RIGHT> <RIGHT>
vnoremap <C-RIGHT> <RIGHT>
inoremap <C-LEFT>  <LEFT>
nnoremap <C-LEFT>  <LEFT>
vnoremap <C-LEFT>  <LEFT>

" arrow keys to switch windows
nnoremap <C-W><LEFT> <C-W>h
nnoremap <C-W><RIGHT> <C-W>l
nnoremap <C-W><UP> <C-W>k
nnoremap <C-W><DOWN> <C-W>j
nnoremap <C-W><C-LEFT> <C-W>h
nnoremap <C-W><C-RIGHT> <C-W>l
nnoremap <C-W><C-UP> <C-W>k
nnoremap <C-W><C-DOWN> <C-W>j

" close buffer without window closing
command Bd
            \ bp |
            \ if len(getbufinfo({'buflisted':1})) > 1 |
            \ bd # |
            \ else |
            \ new |
            \ bd # |
            \ endif
cabbrev bd <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Bd' : 'bd')<CR>

" switch tabs/buffers
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>bn :bn<CR>
nmap <leader>bp :bp<CR>

" vim terminal stuff
tnoremap <Esc> <C-\><C-n>
tnoremap <C-W><C-W> <C-\><C-n><C-W><C-W>
tnoremap <C-W>W <C-\><C-n><C-W><C-W>
tnoremap <C-W><C-LEFT> <C-\><C-n><C-W>h
tnoremap <C-W><C-RIGHT> <C-\><C-n><C-W>l
tnoremap <C-W><C-UP> <C-\><C-n><C-W>k
tnoremap <C-W><C-DOWN> <C-\><C-n><C-W>j

" I hate shift-q
nnoremap <S-Q> <NOP>

" I hate shift-z-z
nnoremap <S-Z><S-Z> <NOP>

" rebind H M L to gH gM gL to prevent accidental presses
nnoremap g<s-H> <S-H>
nnoremap g<s-M> <S-M>
nnoremap g<s-L> <S-L>
nnoremap <S-H>  <NOP>
nnoremap <S-M>  <NOP>
nnoremap <S-L>  <NOP>

" syntax highlighting
syntax on

" sets default register to system clipboard
set clipboard=unnamedplus

" sudo writing
command W w !sudo tee "%" > /dev/null 2> /dev/null

" clear search on pressing escape
nnoremap <esc> :noh<return><esc>

" highlighting
hi StatusLine cterm=NONE ctermfg=15 ctermbg=NONE

" spellcheck underlines
hi Error cterm=underline ctermbg=NONE
hi SpellBad cterm=underline ctermbg=NONE
hi SpellCap cterm=underline ctermbg=NONE
hi SpellLocal cterm=underline ctermbg=NONE
hi SpellRare cterm=underline ctermbg=NONE

" links
hi Underlined cterm=underline ctermfg=4 ctermbg=NONE

" code highlighting
hi Type cterm=NONE ctermfg=6 ctermbg=NONE
hi PreProc cterm=NONE ctermfg=6 ctermbg=NONE
hi Constant cterm=NONE ctermfg=5 ctermbg=NONE
hi Comment cterm=NONE ctermfg=2 ctermbg=NONE
hi Identifier cterm=BOLD ctermfg=14 ctermbg=NONE
hi Special cterm=NONE ctermfg=7 ctermbg=NONE
hi Statement cterm=NONE ctermfg=3 ctermbg=NONE
hi Todo cterm=NONE ctermfg=0 ctermbg=3

" search menu
hi MatchParen cterm=NONE ctermfg=0 ctermbg=3
hi Search cterm=NONE ctermfg=0 ctermbg=4
hi IncSearch cterm=NONE ctermfg=0 ctermbg=4

" autocomplete menu
hi Pmenu ctermbg=0 ctermfg=15
hi PmenuSel ctermbg=3 ctermfg=0

" errors and warnings
hi ErrorMsg ctermbg=NONE ctermfg=1
hi WarningMsg ctermbg=NONE ctermfg=3

" splits and folds
hi VertSplit cterm=NONE ctermbg=NONE ctermfg=7

" highlighting for TODO, FIXME outside of comments
function! HighlightAnnotations()
    call matchadd('Todo','\<TODO\>')
    call matchadd('Todo','\<TODO:\>')
    call matchadd('Todo','\<FIXME\>')
    call matchadd('Todo','\<FIXME:\>')
endfunction
autocmd BufEnter * call HighlightAnnotations()
