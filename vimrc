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
