command! -buffer -nargs=1 -complete=buffer Pydoc call <SID>pydoc(<f-args>)
func! s:pydoc(...) abort
endfunc

command! -buffer -nargs=1 -complete=shellcmd Pych call <SID>pych(<f-args>)
func! s:pych(...) abort
  let pypath = join(a:000)
  set formatexpr=
  let &l:formatprg = pypath . " -m black -q --fast -"
  let &l:keywordprg = pypath . " -m pydoc"
endfunc

Pych python

set wildignore+=*.pyc
setlocal path=,,**
