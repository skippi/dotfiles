call plug#begin(stdpath('data') . '/plugged')
" Plug 'skippi/vim-sneak'
Plug 'machakann/vim-sandwich'
Plug 'tommcdo/vim-lion'
Plug 'tpope/vim-commentary'
Plug 'wellle/targets.vim'
call plug#end()

set rtp+=~/src/github.com/skippi/vim-sneak

nnoremap <BS> :call VSCodeCall('workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup') <bar> call VSCodeCall('list.select')<CR>
nnoremap <Tab> :Find<CR>
nnoremap gws :Split<CR>
nnoremap gwv :Vsplit<CR>

nnoremap <silent> ,ve :exec ":Edit! " . stdpath('config') . "/vscode.vim"<CR>
nnoremap <silent> <Space>fd :Quit<CR>
nnoremap <silent> <Space>fl :Edit %<CR>
nnoremap <silent> <Space>fo :Find<CR>
nnoremap <silent> <Space>q :Quit<CR>
nnoremap <silent> <Space>re :call VSCodeCall('editor.action.rename')<CR>
nnoremap <silent> <Space>w :Write<CR>
nnoremap <silent> _ :call VSCodeCall('workbench.view.explorer')<CR>
nnoremap <silent> g/ :call VSCodeCall('workbench.action.findInFiles')<CR>
nnoremap <silent> gD :call VSCodeCall('editor.action.goToImplementation')<CR>
nnoremap <silent> gd :call VSCodeCall('editor.action.revealDefinition')<CR>
nnoremap <silent> gr :call VSCodeCall('editor.action.goToReferences')<CR>

nnoremap <silent> <Space>lf :call VSCodeCall('leetcode.searchProblem') <bar>sl 250m<bar>call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>
nnoremap <silent> <Space>ll :call VSCodeCall('leetcode.switchDefaultLanguage')<bar>sl 250m<bar>call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>
nnoremap <silent> <Space>ls :call VSCodeCall('leetcode.submitSolution')<bar>sl 250m<bar>call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>
nnoremap <silent> <Space>lt :call VSCodeCall('leetcode.testSolution')<bar>sl 250m<bar>call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>
