set nocompatible              " be iMproved, required
filetype off                  " required

" basic setting
set rnu
set tabstop=4
set shiftwidth=4
set cot+=preview
syntax on

" enable mouse support
set mouse=a

" enable tab complete in command
set wildmode=longest,list,full
set wildmenu

" vim-plug
call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

" Install the vim-lsp language server
Plug 'prabirshrestha/vim-lsp'
" auto-config vim-lsp
Plug 'mattn/vim-lsp-settings'

" Install supertab
Plug 'ervandew/supertab'

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting

" config systemverilog language server (svls)
if executable('svls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'svls',
        \ 'cmd': {server_info->['svls']},
        \ 'whitelist': ['systemverilog'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
	setlocal omnifunc=lsp#complete
	setlocal signcolumn=yes
	if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
