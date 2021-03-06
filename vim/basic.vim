"""""""""""""""""""""""
" General
"""""""""""""""""""""""
set nocompatible

set number

"Show incomplete cmds down the bottom
set showcmd

" Sets how many lines of history VIM has to remember
set history=1000

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
"set autoread

let mapleader = ","
let g:mapleader = ","

set timeoutlen=1000

" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

" Fast quit
nmap <leader>q :q<cr>
nmap <leader>Q :q!<cr>

" Fold
nnoremap <space> za
vnoremap <space> zf

" enable mouse
set mouse=a

""""""""""""""""""""""""""""
" VIM user interface
""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Turn on the WiLd menu
set wildmenu
set wildmode=longest:full,full

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*.pyo,*.class,*.swp
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Always show current position
set ruler

" Highlight current line
set cursorline

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Add a bit extra margin to the left
"set foldcolumn=1

"""""""""""""""""""""""""
" Colors and Fonts
"""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

set background=dark

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

"""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""
set nowritebackup
set nobackup
" auto create temp_dirs
for d in ['undo', 'swap']
    let p = '~/dotfiles/vim/temp_dirs/'.d
    if !isdirectory(p)
        execute 'silent !mkdir -p '.p.' > /dev/null 2>&1'
    endif
endfor
set undodir=~/dotfiles/vim/temp_dirs/undo//
set undofile
set directory=~/dotfiles/vim/temp_dirs/swap//

""""""""""""""""""""""""""""""""""
" Text, tab and indent related
""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


""""""""""""""""""""""""""""""""""""""""""""
" Moving around, tabs, windows and buffers
""""""""""""""""""""""""""""""""""""""""""""
" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" smart switch between windows or tabs
nnoremap <silent> <c-h> :call SwitchWindowOrTab('h')<cr>
nnoremap <silent> <c-l> :call SwitchWindowOrTab('l')<cr>
nnoremap <silent> <c-j> <c-w>j
nnoremap <silent> <c-k> <c-w>k

"switch buffers
map <leader>h :bprev<cr>
map <leader>l :bnext<cr>

" create new tab
map <leader>tn :tabnew<cr>

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


""""""""""""""""""""""""""""""
" Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c


""""""""""""""""""""""""""""""
" Editing mappings
""""""""""""""""""""""""""""""

" use register z for x and s
nnoremap x "zx
nnoremap X "zX
nnoremap s "zs

" Move a line of text
nmap <leader>j mz:m+<cr>`z
nmap <leader>k mz:m-2<cr>`z
vmap <leader>j :m'>+<cr>`<my`>mzgv`yo`z
vmap <leader>k :m'<-2<cr>`>my`<mzgv`yo`z
vmap <c-j> <leader>j
vmap <c-k> <leader>k

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
autocmd BufWrite * :call DeleteTrailingWS()

function! CopyToTmux() range
    let l:saved_reg = @"
    execute "silent normal! vgvy"
    let l:content = escape(@", '"')
    call system('echo -n "'.l:content.'" | tmux loadb -')
    let @" = l:saved_reg
    echo "Copied to tmux buffer"
endfunction
vnoremap <leader>y :call CopyToTmux()<cr>

" <leader>r to search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

""""""""""""""""""""""""""""""""""""""
" Cope displaying
"""""""""""""""""""""""""""""""""""""""
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>cn :cn<cr>
map <leader>cp :cp<cr>

""""""""""""""""""""""""""
" Spell checking
""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

"""""""""""""""""""""""""""
" Misc
"""""""""""""""""""""""""""
set diffopt=vertical
set shellpipe=>

""""""""""""""""""""""""""""
" Helper functions
""""""""""""""""""""""""""""
function! SwitchWindowOrTab(d)
    let l:cur=winnr()
    execute 'wincmd '.a:d
    if(l:cur==winnr())
        if(a:d=='h')
            let l:tabcmd='tabprev'
        else
            let l:tabcmd='tabnext'
        endif
        execute l:tabcmd
    endif
endfunction

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = @"
    let l:pattern = substitute(l:pattern, "\n", "", "g")

    if a:direction == 'gv'
        let l:pattern = escape(l:pattern, '"')
        call CmdLine("Ack -Q \"" . l:pattern . "\"")
    elseif a:direction == 'replace'
        call CmdLine("%sno/". l:pattern . "/")
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

" Make VIM remember position in file after reopen
" if has("autocmd")
"   au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

""""""""""""""""""""""""""""""
" Command mode related
""""""""""""""""""""""""""""""
" Smart mappings on the command line
cno $h tabe ~/
cno $d tabe ~/Desktop/
cno $j tabe ./
cno $c tabe <C-\>eCurrentFileDir("e")<cr>

" $q is super useful when browsing on the command line
" it deletes everything until the last slash
cno $q <C-\>eDeleteTillSlash()<cr>

" Bash like keys for the command line
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-K> <C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

"""""""""""""""""""""""""""""""
" => General abbreviations
"""""""""""""""""""""""""""""""
iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>

"""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""
func! DeleteTillSlash()
    let g:cmd = getcmdline()

    if has("win16") || has("win32")
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    else
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    endif

    if g:cmd == g:cmd_edited
        if has("win16") || has("win32")
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        else
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        endif
    endif

    return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
    return a:cmd . " " . expand("%:p:h") . "/"
endfunc

"""""""""""""""""""
" Fn keys
"""""""""""""""""""
" F2 to switch between number, relative_number, no_number
function! SwitchNumber()
    if(&relativenumber)
        set norelativenumber
        set nonumber
    elseif(&number)
        set relativenumber
        set nonumber
    else
        set norelativenumber
        set number
    endif
endfunc
noremap <F2> :call SwitchNumber()<CR>
" F3 to toggle wrap
noremap <F3> :set wrap! wrap?<CR>
" F4 to toggle paste
noremap <F4> :setlocal paste!<cr>
inoremap <F4> <esc>:setlocal paste!<cr>i

" F5 to toggle system clipboard
function! ToggleSystemClipboard()
    if(&clipboard=='unnamed')
        echo 'Using vim built-in clipboard'
        set clipboard=
    else
        echo 'Using system clipboard'
        set clipboard=unnamed
    endif
endfunc
noremap <F5> :call ToggleSystemClipboard()<cr>
