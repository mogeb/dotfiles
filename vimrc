"
" F2: Copy text in visual mode - across terminals
" F3: Paste text in insertion mode - across terminals
" F4: Show list of functions in file
" F5: Show/hide trailing white spaces
" F6: Show/hide NERDTree (actually using NERDTreeTabs)
"
" F9: Enable/disable highlight for search
" 
" -- Ctrl-t: new tab -- deprecated: ctrl-t takes you to last position
" Tab: next tab
" Shift-Tab: previous tab
"
" q: toggle comment
"
" ---------
" Disbaled:
" In insertion mode, write an empty C main
" :imap <F6> #include <stdio.h><cr><cr>int main()<cr>{<cr><cr>return 0;<cr>}
"
" Toggle between tabdwidth using F7 and F8
" :map <F7> :set tabstop=2<cr>:set shiftwidth=2<cr>
" :map <F8> :set tabstop=4<cr>:set shiftwidth=4<cr>

"##### Startup #####
" Highlight
syntax enable
" autocmd VimEnter * NERDTreeTabsToggle

" Make Ctrl-Up and Ctrl-Down move faster
:noremap <C-Up> 5k
:noremap <C-Down> 5j
:imap <C-Up> <ESC>5ki
:imap <C-Down> <ESC>5ji

" Make Ctrl-PageUp and Ctrl-PageDown scroll (not working)
":map <C-PageUp> <C-Y>

" Makge PageUp and PageDown move only half a page
:map <PageUp> <C-U>
:map <PageDown> <C-D>
:imap <PageUp> <ESC><C-U>i
:imap <PageDown> <ESC><C-D>i

" Go to first and last line of file
:map h 1G
:map g G

"line number"
set number

filetype plugin indent on

"### Keybinding ###
" New tab
":nmap <C-t>        :tabnew<cr>
":imap <C-t>        <ESC>:tabnew<cr>

" switch tab
:nmap <Tab>	:tabn<cr>
:nmap <S-Tab>	:tabp<cr>

:map <F2> :w! ~/.swp<cr>
:map <F3> :r ~/.swp<cr>
" Default tab width
autocmd FileType python,xml set tabstop=4|set shiftwidth=4
autocmd FileType c,cpp,h,hpp,java set tabstop=2|set shiftwidth=2
set tabstop=2
set shiftwidth=2
nnoremap <F9> :set hlsearch!<CR>

"https://github.com/Rafiot/dotfiles/blob/15fd87919f616e67507b6320974a16d10c86e1d3/_vimrc 
" Seriously, guys. It's not like :W is bound to anything anyway.
command! W :w
command! Q :q
" sudo write this
cmap W! w !sudo tee % >/dev/null
" " for when we forget to use sudo to open/edit a file
cmap w!! w !sudo tee % >/dev/null
set hlsearch " Highlight searches by default.

:nnoremap p p=`]

" Status Bar
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%03v][%p%%]\ [LC=%L]
set laststatus=2
set bg=dark
set incsearch
set autoindent
set history=50
set showcmd
set showmatch
set ai
" for Babeltrace
set ts=2
set shiftwidth=2
set encoding=utf8
set fileencoding=utf8

set t_Co=256

"### Highlight ###
"hi StatusLine term=reverse ctermfg=DarkGrey gui=undercurl guisp=White
"hi Comment ctermfg=Cyan
"hi Constant ctermfg=Green
"hi String ctermfg=Green
"hi link Number Special

" F4: Show the list of functions in the file
let Tlist_Ctags_Cmd = "/usr/bin/ctags-exuberant"
let Tlist_WinWidth = 50
map <F4> :TlistToggle<cr>
map <M-Left> <C-o>
map <M-Right> <C-]>
map <M-Down> g]
map F {gq}
"map <M-Up> <C-wi>

" F5: Show/hide NERDTree (NERDTreeTabs)
map <F6>	:NERDTreeTabsToggle<cr>

" Highlight whitespace problems, use with \ws
" flags is '' to clear highlighting, or is a string to
" specify what to highlight (one or more characters):
"   e  whitespace at end of line
"   i  spaces used for indenting
"   s  spaces before a tab
"   t  tabs not at start of line
function! ShowWhitespace(flags)
  let bad = ''
  let pat = []
  for c in split(a:flags, '\zs')
    if c == 'e'
      call add(pat, '\s\+$')
    elseif c == 'i'
      call add(pat, '^\t*\zs \+')
    elseif c == 's'
      call add(pat, ' \+\ze\t')
    elseif c == 't'
      call add(pat, '[^\t]\zs\t\+')
    else
      let bad .= c
    endif
  endfor
  if len(pat) > 0
    let s = join(pat, '\|')
    exec 'syntax match ExtraWhitespace "'.s.'" containedin=ALL'
  else
    syntax clear ExtraWhitespace
  endif
  if len(bad) > 0
    echo 'ShowWhitespace ignored: '.bad
  endif
endfunction

function! ToggleShowWhitespace()
  if !exists('b:ws_show')
    let b:ws_show = 0
  endif
  if !exists('b:ws_flags')
    let b:ws_flags = 'est'  " default (which whitespace to show)
  endif
  let b:ws_show = !b:ws_show
  if b:ws_show
    call ShowWhitespace(b:ws_flags)
  else
    call ShowWhitespace('')
  endif
endfunction

nnoremap <Leader>ws :call ToggleShowWhitespace()<CR>
map <F5> :call  ToggleShowWhitespace()<CR>
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen


" Happy cscoping,
"
" Jason Duell       jduell@alumni.princeton.edu     2002/3/7
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" This tests to see if vim was configured with the '--enable-cscope' option
" when it was compiled.  If it wasn't, time to recompile vim... 
if has("cscope")

    """"""""""""" Standard cscope/vim boilerplate

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0

    " add any cscope database in current directory
    if filereadable("cscope.out")
        cs add cscope.out  
    " else add the database pointed to by environment variable 
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif

    " show msg when any other cscope db added
    set cscopeverbose  


    """"""""""""" My cscope/vim key mappings
    "
    " The following maps all invoke one of the following cscope search types:
    "
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
    "
    " Below are three sets of the maps: one set that just jumps to your
    " search result, one that splits the existing vim window horizontally and
    " diplays your search result in the new window, and one that does the same
    " thing, but does a vertical split instead (vim 6 only).
    "
    " I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
    " unlikely that you need their default mappings (CTRL-\'s default use is
    " as part of CTRL-\ CTRL-N typemap, which basically just does the same
    " thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
    " If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
    " of these maps to use other keys.  One likely candidate is 'CTRL-_'
    " (which also maps to CTRL-/, which is easier to type).  By default it is
    " used to switch between Hebrew and English keyboard mode.
    "
    " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
    " that searches over '#include <time.h>" return only references to
    " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
    " files that contain 'time.h' as part of their name).


    " To do the first type of search, hit 'CTRL-\', followed by one of the
    " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
    " search will be displayed in the current window.  You can use CTRL-T to
    " go back to where you were before the search.  
    "

    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>	


    " Using 'CTRL-spacebar' (intepreted as CTRL-@ by vim) then a search type
    " makes the vim window split horizontally, with search result displayed in
    " the new window.
    "
    " (Note: earlier versions of vim may not have the :scs command, but it
    " can be simulated roughly via:
    "    nmap <C-@>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>	

    nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
    nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>	


    " Hitting CTRL-space *twice* before the search type does a vertical 
    " split instead of a horizontal one (vim 6 and up only)
    "
    " (Note: you may wish to put a 'set splitright' in your .vimrc
    " if you prefer the new window on the right instead of the left

    nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
    nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>


    """"""""""""" key map timeouts
    "
    " By default Vim will only wait 1 second for each keystroke in a mapping.
    " You may find that too short with the above typemaps.  If so, you should
    " either turn off mapping timeouts via 'notimeout'.
    "
    "set notimeout 
    "
    " Or, you can keep timeouts, by uncommenting the timeoutlen line below,
    " with your own personal favorite value (in milliseconds):
    "
    "set timeoutlen=4000
    "
    " Either way, since mapping timeout settings by default also set the
    " timeouts for multicharacter 'keys codes' (like <F1>), you should also
    " set ttimeout and ttimeoutlen: otherwise, you will experience strange
    " delays as vim waits for a keystroke after you hit ESC (it will be
    " waiting to see if the ESC is actually part of a key code like <F1>).
    "
    "set ttimeout 
    "
    " personally, I find a tenth of a second to work well for key code
    " timeouts. If you experience problems and have a slow terminal or network
    " connection, set it higher.  If you don't set ttimeoutlen, the value for
    " timeoutlent (default: 1000 = 1 second, which is sluggish) is used.
    "
    "set ttimeoutlen=100

endif

colorscheme monokai
