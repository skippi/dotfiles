function! chunk#visual_a() abort
  let [minline, maxline] = s:grab('a')
  call setpos(".", [0, minline, 0, 0])
  normal! V
  call setpos(".", [0, maxline, 0, 0])
  normal! $
endfunction

function! chunk#visual_i() abort
  let [minline, maxline] = s:grab('i')
  call setpos(".", [0, minline, 0, 0])
  normal! V
  call setpos(".", [0, maxline, 0, 0])
  normal! $
endfunction

function! s:grab(op) abort
  let curline = line(".")
  if match(getline(curline), "^\\s*\\S") == -1
    echom "FADLKJDF"
    return [curline, curline]
  endif
  let base_indent = matchstr(getline(curline), "^\\s*")
  let start = s:findlast(base_indent, curline, -1)
  let end = s:findlast(base_indent, curline, 1)
  exec "echom " . start . end
  for i in range(v:count1 - 1)
    let end = s:findlast("^\\s*$", end, 1)
    let end = s:findlast(base_indent, end, 1)
  endfor
  if a:op == "a"
    let upwards = s:findlast("^\\s*$", start, -1)
    let downwards = s:findlast("^\\s*$", end, 1)
    if downwards == end
      let start = upwards
    else
      let end = downwards
    endif
  endif
  return [start, end]
endfunction

function! s:findlast(pattern, start, step) abort
  let result = a:start
  let end = s:linelimit(a:step)
  while result != end && match(getline(result + a:step), a:pattern) != -1
    let result += a:step
  endwhile
  return result
endfunction

function! s:linelimit(direction) abort
  if a:direction < 0
    return 1
  else
    return line('$')
  endif
endfunction
