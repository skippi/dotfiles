compiler python

set formatexpr=
set wildignore+=*.pyc
setlocal formatprg=python\ -m\ black\ -q\ --fast\ -
setlocal path=,,**
