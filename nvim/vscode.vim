call plug#begin(stdpath('data') . '/plugged')
" Plug 'skippi/vim-sneak'
Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-commentary'
Plug 'wellle/targets.vim'
call plug#end()

set rtp+=~/src/github.com/skippi/vim-sneak

nnoremap <BS> <Cmd>call VSCodeCall('workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup') <bar> call VSCodeCall('list.select')<CR>
nnoremap <Tab> <Cmd>Find<CR>
nnoremap gws <Cmd>Split<CR>
nnoremap gwv <Cmd>Vsplit<CR>

nnoremap <silent> <Space>fd <Cmd>Quit<CR>
nnoremap <silent> <Space>fl <Cmd>Edit%<CR>
nnoremap <silent> <Space>fo <Cmd>Find<CR>
nnoremap <silent> <Space>q <Cmd>Quit<CR>
nnoremap <silent> <Space>w <Cmd>Write<CR>
nnoremap <silent> - <Cmd>call VSCodeCall('workbench.view.explorer')<CR>
nnoremap <silent> _ <Cmd>call VSCodeCall('workbench.view.explorer')<CR>
nnoremap <silent> g/ m'<Cmd>call VSCodeCall('workbench.action.findInFiles')<CR>
nnoremap <silent> gC *``<Cmd>call VSCodeCall('editor.action.rename')<CR>
nnoremap <silent> gd *``<Cmd>call VSCodeCall('editor.action.revealDefinition')<CR>
nnoremap <silent> gr m'<Cmd>call VSCodeCall('editor.action.goToReferences')<CR>

nnoremap <silent> <Space>lf <Cmd>call VSCodeCall('leetcode.searchProblem') <bar>sl 250m<bar>call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>
nnoremap <silent> <Space>ll <Cmd>call VSCodeCall('leetcode.switchDefaultLanguage')<bar>sl 250m<bar>call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>
nnoremap <silent> <Space>ls <Cmd>call VSCodeCall('leetcode.submitSolution')<bar>sl 250m<bar>call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>
nnoremap <silent> <Space>lt <Cmd>call VSCodeCall('leetcode.testSolution')<bar>sl 250m<bar>call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>
