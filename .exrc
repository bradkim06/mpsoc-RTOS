if &cp | set nocp | endif
nmap  h
let s:cpo_save=&cpo
set cpo&vim
nmap <NL> j
nmap  k
nmap  l
nmap gx <Plug>NetrwBrowseX
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#NetrwBrowseX(expand("<cWORD>"),0)
map <F4> :w^M
map <F2> :tprevious^M
map <F3> :tnext^M
nmap <F8> :SrcExplToggle
nmap <F9> :NERDTreeToggle
nmap <F7> :TlistToggle
let &cpo=s:cpo_save
unlet s:cpo_save
set backspace=indent,eol,start
set cindent
set fileencodings=ucs-bom,utf-8,default,latin1
set helplang=ko
set history=50
set hlsearch
set ignorecase
set nomodeline
set printoptions=paper:a4
set ruler
set runtimepath=~/.vim,/var/lib/vim/addons,/usr/share/vim/vimfiles,/usr/share/vim/vim73,/usr/share/vim/vimfiles/after,/var/lib/vim/addons/after,~/.vim/after
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set tabstop=4
set tags=tags
" vim: set ft=vim :
