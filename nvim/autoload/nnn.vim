func! nnn#bufopen() abort
  let path = expand("%:p")
  if !filereadable(path)
    let path = expand("%:p:h")
  endif
  return nnn#open(path)
endfunc

func! nnn#open(path) abort
  let s:nnn_tempfile = tempname()
  if has("win32")
    let tfilesub = '$(wslpath "' . s:nnn_tempfile . '")'
    let pathsub = '$(wslpath "' . a:path . '")'
    let cmd = 'wsl SHELL=/usr/bin/fish nnn -p ' . tfilesub . ' ' . pathsub
  else
    let cmd = 'SHELL=/usr/bin/fish nnn -p "' . s:nnn_tempfile . '" "' . a:path . '"'
  endif
  let opts = {'on_exit': funcref('s:nnn_exit')}
  enew
  set ft=nnn
  call termopen(cmd, opts)
endfunc

func! s:nnn_exit(...) abort
  if filereadable(s:nnn_tempfile)
    let paths = readfile(s:nnn_tempfile)
    if !empty(paths)
      " Disabled because we use Kwbd by default for terms
      " Kwbd
      for path in paths
        exe "e" fnamemodify(fnameescape(s:vimpath(path)), ":~:.")
      endfor
    endif
  endif
endfunc

func! s:clipath(path)
  if has("win32")
    return s:wslpath(a:path)
  else
    return a:path
  endif
endfunc

func! s:vimpath(path)
  if has("win32")
    return s:wslpath(a:path, 'ma')
  else
    return a:path
  endif
endfunc

func! s:wslpath(path, ...) abort
  let opts = get(a:, 1, 'u')
  let cmd = 'wsl wslpath -' . opts
  let fslash = substitute(a:path, '\', '/', 'g')
  let cmd = cmd . ' "' . fslash . '"'
  return trim(system(cmd))
endfunc
