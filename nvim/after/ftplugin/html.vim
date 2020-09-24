set expandtab shiftwidth=2 tabstop=2

aug html
  au!
  au BufLeave <buffer> norm! mH
aug END
