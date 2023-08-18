# vimrc
my simple vim configuration

fix colorscheme in tmux:
1. setup alias in `.bashrc`:
  ```bash
  alias tmux="TERM=screen-256color-bce tmux"
  ```
2. set default terminal in `.tmux.conf`:
  ```bash
  set -g default-terminal "screen-256color"
  ```
reference: https://stackoverflow.com/questions/10158508/lose-vim-colorscheme-in-tmux-mode

fix colorscheme in different terminals:
```bash
set t_Co=256
```
reference: https://stackoverflow.com/questions/45581242/why-is-vim-syntax-highlighting-on-different-terminals
