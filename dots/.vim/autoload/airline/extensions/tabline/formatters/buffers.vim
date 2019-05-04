function! airline#extensions#tabline#formatters#buffers#format(bufnr, buffers)
  return fnamemodify(bufname(a:bufnr), ':t')
endfunction
