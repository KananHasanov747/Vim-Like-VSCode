" ========================================================================================
"     MacBook Air M1
"     Architecture: ARM
"     OS: MacOS 12.2.1
"     NVIM version ($ nvim -v): 0.6.1 (Compiled by HomeBrew)
" ========================================================================================

" Vim Configuration
" ======================================================================================== 
set number

set smarttab
set cindent
"set tabstop=4
set shiftwidth=4
" always uses spaces instead of tab characters
set expandtab
syntax on
set termguicolors

set statusline=\ %F\ %m\ %r\ %=\ %{&fileencoding?&fileencoding:&encoding}\ \|\ %{&ff}\ \|\ %y\ \|\ l:%l,c:%c\ \|\ total\ line:\ %L\ 

filetype plugin indent on

" Other Conf
"========================================================================================

" turn off the search highlight
nnoremap ,<space> :nohlsearch <CR>

"if $TERM_PROGRAM =~ "iTerm"
    "let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
    "let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
"endif

" Run files
"========================================================================================
let ext = {
            \'c' : 'tabe | term cd "$dir" && gcc "$fileName" -o "$fileNameWithoutExt" && "./$fileNameWithoutExt"',
            \'cpp' : 'tabe | term cd "$dir" && g++ -std=c++2b "$fileName" -o "$fileNameWithoutExt" && "./$fileNameWithoutExt"',
            \'python' : 'tabe | term python3 -u "$fileName"',
            \'javascript' : 'tabe | term node "$fileName"',
            \'cs' : 'tabe | term cd "$dir" && dotnet run $fileName',
            \'haskell' : 'tabe | term runhaskell "$fileName"',
            \'php' : 'tabe | term php "$fileName"',
            \}

map <C-b> :let $dir = expand ('%:p:h') <CR> :let $fileName = expand ('%:p') <CR> :let $fileNameWithoutExt = expand ('%:t:r') <CR> :exe get (ext, &ft)<CR><Insert>

" Specify a dir for plugin {{{1
"========================================================================================
call plug#begin ('~/.config/nvim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle'}
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'ctrlpvim/ctrlp.vim' " fuzzy find files

"Plug 'morhetz/gruvbox'
"Plug 'joshdick/onedark.vim'

Plug 'olimorris/onedarkpro.nvim'
Plug 'nvim-treesitter/nvim-treesitter'

Plug 'scrooloose/nerdcommenter'
"Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

Plug 'christoomey/vim-tmux-navigator'

Plug 'HerringtonDarkholme/yats.vim' " TS Syntax

"Plug 'fladson/vim-kitty'

call plug#end ()

" NERDTree {{{1
"========================================================================================

nmap <C-n> :NERDTreeToggle<CR>
vmap ++ <plug>NERDCommenterToggle
nmap ++ <plug>NERDCommenterToggle

" open NERDTree automatically
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * NERDTree

let g:NERDTreeGitStatusWithFlags = 1
"let g:WebDevIconsUnicodeDecorateFolderNodes = 1
"let g:NERDTreeGitStatusNodeColorization = 1
let g:NERDTreeColorMapCustom = {
    \ "Staged"    : "#0ee375",  
    \ "Modified"  : "#d9bf91",  
    \ "Renamed"   : "#51C9FC",  
    \ "Untracked" : "#FCE77C",  
    \ "Unmerged"  : "#FC51E6",  
    \ "Dirty"     : "#FFBD61",  
    \ "Clean"     : "#87939A",   
    \ "Ignored"   : "#808080"   
    \ }                         

let g:NERDTreeIndicatorMapCustom = {                                                                                                    
    \ "Modified"  : "✹",                                                                                            
    \ "Staged"    : "✚",                                                                                            
    \ "Untracked" : "✭",                                                                                            
    \ "Renamed"   : "➜",                                                                                            
    \ "Unmerged"  : "═",                                                                                            
    \ "Deleted"   : "✖",                                                                                            
    \ "Dirty"     : "✗",                                                                                            
    \ "Clean"     : "✔",                                                                                            
    \ "Ignored"   : "☒",                                                                                            
    \ "Unknown"   : "?"
    \ }

let g:NERDTreeIgnore = ['^node_modules$']

" vim-prettier
"let g:prettier#quickfix_enabled = 0
"let g:prettier#quickfix_auto_focus = 0
" prettier command for coc
command! -nargs=0 Prettier :CocCommand prettier.formatFile
" run prettier on save
"let g:prettier#autoformat = 0
"autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync


" ctrlp
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" j/k will move virtual lines (lines that wrap)
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" sync open file with NERDTree
" " Check if NERDTree is open or active
function! IsNERDTreeOpen()        
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" Highlight currently open buffer in NERDTree
autocmd BufRead * call SyncTree()

let g:DevIconsEnableFoldersOpenClose = 1

" auto refresh NERDTree tree structure in focusing window
autocmd BufEnter NERD_tree_* | execute 'normal R'

" let NERDTree show hidden files

let NERDTreeShowHidden = 1

" NERDTree syntax highlighter {{{1
"========================================================================================

let g:NERDTreeExtensionHighlightColor = {} " this line is needed to avoid error
let g:NERDTreeExtensionHighlightColor['java'] = '5c86a1' " java colour

let g:WebDevIconsDefaultFolderSymbolColor = 'fcb503' " folders colour

" Theme {{{1
"========================================================================================

"colorscheme gruvbox
"colorscheme onedark

lua << EOF

vim.o.background = "dark"
require("onedarkpro").load()

EOF

"lua require ('basic')

" Coc Configuration {{{1
"========================================================================================

" coc config
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint', 
  \ 'coc-prettier', 
  \ 'coc-json', 
  \ ]

" from readme
" if hidden is not set, TextEdit might fail.
set hidden " Some servers have issues with backup files, see #649 set nobackup set nowritebackup " Better display for messages set cmdheight=2 " You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <F2> <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
