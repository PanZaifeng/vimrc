" An example for a vimrc file.
"
" Maintainer:   Bram Moolenaar <Bram@vim.org>
" Last change:  2008 Dec 17
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"             for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"           for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50          " keep 50 lines of command line history
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set incsearch           " do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

"call pathogen#infect()"
"call pathogen#runtime_append_all_bundles()"

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
  autocmd Filetype c,cpp,tex map <F5> :call Compile()<CR>

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

      set autoindent            " always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                  \ | wincmd p | diffthis
endif

set shiftwidth=2
"set tabstop=2
set softtabstop=2
set expandtab

autocmd FileType python setlocal shiftwidth=4
autocmd FileType python setlocal softtabstop=4

set nu
let Tlist_Use_Right_Window = 1

"set ignorecase

" Compile and Run
func! Compile()
    exec "w"
    exec "!clear && make"
endfunc

set background=dark
"set backup

map <F9> :TagbarToggle<cr>
map <F8> :NERDTreeToggle<cr>

au BufNewFile,BufRead *.cl set filetype=c

set noignorecase

func! ToggleCopyMode()
  let w:copymode = exists('w:copymode') ? !w:copymode : 1 
  if w:copymode == 1
    if has('mouse')
      set mouse-=a
    endif
    set nonumber
    echo 'copymode=1'
  else
    if has('mouse')
      set mouse=a
    endif
    set number
    echo 'copymode=0'
  endif
endfunc

":command ToggleCopy call ToggleCopyMode()
nmap <silent> ;c :call ToggleCopyMode()<CR>

func! TogglePasteMode()
  let w:pastemode = exists('w:pastemode') ? !w:pastemode : 1 
  if w:pastemode == 1
    set paste
    echo 'pastemode=1'
  else
    set nopaste
    echo 'pastemode=0'
  endif
endfunc

nmap <silent> ;p :call TogglePasteMode()<CR>

vnoremap * y/\<<c-r>"\><cr>
vnoremap # y?\<<c-r>"\><cr>
vnoremap // y/\V<c-r>"<cr>

"           Scroll Wheel = Up/Down 1 lines
"   Shift + Scroll Wheel = Up/Down 1 page
" Control + Scroll Wheel = Up/Down 1/2 page
"    Meta + Scroll Wheel = Up/Down 1 line
 noremap <ScrollWheelUp>     1<C-Y>
 noremap <ScrollWheelDown>   1<C-E>
 noremap <S-ScrollWheelUp>   <C-B>
 noremap <S-ScrollWheelDown> <C-F>
 noremap <C-ScrollWheelUp>   <C-U>
 noremap <C-ScrollWheelDown> <C-D>
 noremap <M-ScrollWheelUp>   <C-Y>
 noremap <M-ScrollWheelDown> <C-E>
inoremap <ScrollWheelUp>     <C-O>4<C-Y>
inoremap <ScrollWheelDown>   <C-O>4<C-E>
inoremap <S-ScrollWheelUp>   <C-O><C-B>
inoremap <S-ScrollWheelDown> <C-O><C-F>
inoremap <C-ScrollWheelUp>   <C-O><C-U>
inoremap <C-ScrollWheelDown> <C-O><C-D>
inoremap <M-ScrollWheelUp>   <C-O><C-Y>
inoremap <M-ScrollWheelDown> <C-O><C-E>

vnoremap y y`]

highlight Pmenu ctermbg=gray guibg=gray
highlight PmenuSel ctermbg=lightblue guibg=lightblue

" Use a line cursor within insert mode and a block cursor everywhere else.
"
" Reference chart of values:
"   Ps = 0  -> blinking block.
"   Ps = 1  -> blinking block (default).
"   Ps = 2  -> steady block.
"   Ps = 3  -> blinking underline.
"   Ps = 4  -> steady underline.
"   Ps = 5  -> blinking bar (xterm).
"   Ps = 6  -> steady bar (xterm).
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
set ttimeout
set ttimeoutlen=1
set ttyfast

set cul 
highlight clear CursorLine
highlight LineNr ctermfg=darkgray guifg=darkgray
highlight CursorLineNr ctermfg=white guifg=white
highlight CursorLine ctermbg=black guibg=black

" status bar colors
au InsertEnter * hi statusline guifg=black guibg=#d7afff ctermfg=black ctermbg=magenta
au InsertLeave * hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan
hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan

" Status line
" default: set statusline=%f\ %h%w%m%r\ %=%(%l,%c%V\ %=\ %P%)

" Status Line Custom
let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'no' : 'Normal·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ '^V' : 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ '^S' : 'S·Block',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \}

" Function: return current mode
" abort -> function will abort soon as error detected
function! ModeCurrent() abort
    let l:modecurrent = mode()
    " use get() -> fails safely, since ^V doesn't seem to register
    " 3rd arg is used when return of mode() == 0, which is case with ^V
    " thus, ^V fails -> returns 0 -> replaced with 'V Block'
    let l:modelist = toupper(get(g:currentmode, l:modecurrent, 'V·Block '))
    let l:current_status_mode = l:modelist
    return l:current_status_mode
endfunction

set laststatus=2
set noshowmode
set statusline=
set statusline+=%0*\ %n\                                 " Buffer number
" set statusline+=%0*\ %{toupper(g:currentmode[mode()])}\  " The current mode
set statusline+=%0*\ %{ModeCurrent()}\ %{&paste?'(PASTE)':''}
" set statusline+=%0*\ %{mode()} 
set statusline+=%1*\ %<%F%m%r%h%w\                       " File path, modified, readonly, helpfile, preview
set statusline+=%3*│                                     " Separator
set statusline+=%2*\ %Y\                                 " FileType
" set statusline+=%3*│                                     " Separator
" set statusline+=\ (%{&ff})                               " FileFormat (dos/unix..)
set statusline+=%=                                       " Right Side
set statusline+=%2*\ col:\ %02v\                         " Colomn number
set statusline+=%3*│                                     " Separator
set statusline+=%1*\ ln:\ %02l/%L\ (%3p%%)\              " Line number / total lines, percentage of document
set statusline+=%2*\ %{''.(&fenc!=''?&fenc:&enc).''}     " Encoding

hi User1 ctermfg=007 ctermbg=239 guibg=#4e4e4e guifg=#adadad
hi User2 ctermfg=007 ctermbg=236 guibg=#303030 guifg=#adadad
hi User3 ctermfg=236 ctermbg=236 guibg=#303030 guifg=#303030
hi User4 ctermfg=239 ctermbg=239 guibg=#4e4e4e guifg=#4e4e4e

hi MatchParen ctermbg=darkgray guibg=darkgray

autocmd FileType c,cpp,cuda setlocal equalprg=clang-format
nmap <A-F> gg=G
imap <A-F> <Esc>gg=G                                                                                                                                                                                                                                          
" for mac
nmap Ï gg=G
imap Ï <Esc>gg=G
