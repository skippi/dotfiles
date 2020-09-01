call plug#begin(stdpath('data') . '/plugged')
" Plug 'skippi/vim-sneak'
Plug 'machakann/vim-sandwich'
Plug 'tommcdo/vim-lion'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'wellle/targets.vim'
call plug#end()

set rtp+=~/src/github.com/skippi/vim-sneak

command! Test call VSCodeSetTextDecorations("Search", [[3, [[10, "te"]]]])

nnoremap <BS> :call VSCodeCall('workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup') <bar> call VSCodeCall('list.select')<CR>
nnoremap <Tab> :Find<CR>
nnoremap gws :Split<CR>
nnoremap gwv :Vsplit<CR><C-w>p

nnoremap <silent> ,ve :exec ":Edit! " . stdpath('config') . "/vscode.vim"<CR>
nnoremap <silent> ,vf :exec ":Edit! " . stdpath('config') . '/ftplugin/' . &filetype . '.vim'<CR>
nnoremap <silent> ,vs :exec ":source " . stdpath('config') . "/vscode.vim"<CR>:echom "init.vim reloaded"<CR>
nnoremap <silent> <Space>fd :Quit<CR>
nnoremap <silent> <Space>fe :call VSCodeCall('workbench.view.explorer')<CR>
nnoremap <silent> <Space>fl :Edit %<CR>
nnoremap <silent> <Space>fo :Find<CR>
nnoremap <silent> <Space>q :Quit<CR>
nnoremap <silent> <Space>re :call VSCodeCall('editor.action.rename')<CR>
nnoremap <silent> <Space>w :Write<CR>
nnoremap <silent> g/ :call VSCodeCall('workbench.action.findInFiles')<CR>
nnoremap <silent> gD :call VSCodeCall('editor.action.goToImplementation')<CR>
nnoremap <silent> gd :call VSCodeCall('editor.action.revealDefinition')<CR>
nnoremap <silent> gr :call VSCodeCall('editor.action.goToReferences')<CR>

nnoremap <silent> <Space>le :call VSCodeCall('leetCodeExplorer.focus')<CR>
nnoremap <silent> <Space>lf :call VSCodeCall('leetcode.searchProblem') <bar> sleep 200m <bar> call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>
nnoremap <silent> <Space>ls :call VSCodeCall('leetcode.submitSolution') <bar> sleep 200m <bar> call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>
nnoremap <silent> <Space>lt :call VSCodeCall('leetcode.testSolution') <bar> sleep 200m <bar> call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>

" augroup CodeOverwrites
"   autocmd!
"   autocmd BufReadPost * nmap <buffer> <silent> - :call VSCodeExtensionCall('vscode-neovim.escape')<CR>:call VSCodeExtensionCall('insert-line', 'before')<CR>
"   autocmd BufReadPost * nmap <buffer> <silent> + <ESC>:call VSCodeExtensionCall('insert-line', 'after')<CR>
" augroup END
