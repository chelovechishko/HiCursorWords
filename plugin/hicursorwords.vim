" HiCursorWords -- Highlights words under the cursor.
"
" Description:
"   This script highlights words under the cursor like many IDEs.
"
"   This doesn't provide scope-aware highlighting nor language specific one.
"   You can control highlighting by highlighting group names.
"
" Variables:
"
"   (A right hand side value is a default value.)
"
"   g:HiCursorWords_delay = 200
"       A delay for highlighting in milliseconds.
"       Smaller value may cause your machine slow down.
"
"   g:HiCursorWords_hiGroupRegexp = ''
"       If empty, all words are highlighted.
"       If not empty, only the specified highlight group is highlighted.
"       (my memo: 'Identifier\|vimOperParen')
"
"       To investigate highlight group name, the next variable may help you.
"
"   g:HiCursorWords_debugEchoHiName = 0
"       If not 0, echoes the highlight group name under the cursor.
"
"   g:HiCursorWords_visible = 1
"       Set to 0 in vimrc to startup with HiCursorWords disabled
"
" Hightlight groups:
"
"   WordUnderTheCursor
"
"   To set cursor-word style add to your vimrc:
"   highlight! link WordUnderTheCursor Underlined
"
" Source this file and put the following line in your vimrc to
" toggle auto-highlighting of the word under the cursor.
"map <F5> :call HiCursorWords_toggle()<cr>


if exists("g:loaded_HiCursorWords")
    finish
endif

let g:loaded_HiCursorWords = 1

let g:HiCursorWords_delay = get(g:, 'HiCursorWords_delay', 200)
let g:HiCursorWords_hiGroupRegexp = get(g:, 'HiCursorWords_hiGroupRegexp', '')
let g:HiCursorWords_debugEchoHiName = get(g:, 'HiCursorWords_debugEchoHiName', 0)
let g:HiCursorWords_visible = get(g:, 'HiCursorWords_visible', 1)

if !hlexists('WordUnderTheCursor')
    highlight default link WordUnderTheCursor Underlined
endif


function! s:HiCursorWords__setHCWAutocmd()
    augroup HiCursorWords
        autocmd!
        autocmd CursorMoved,CursorMovedI
                    \ * call s:HiCursorWords__addTimer()
        autocmd WinLeave * call s:HiCursorWords__clearHighlighting()
    augroup END
endfunction

if g:HiCursorWords_visible
    call s:HiCursorWords__setHCWAutocmd()
endif


function! s:HiCursorWords__addTimer()
    if exists('b:timer')
        call timer_stop(b:timer)
    endif
    let b:timer = timer_start(g:HiCursorWords_delay,
                \ function('s:HiCursorWords__highlight'), {'repeat': 1})
endfunction

function! s:HiCursorWords__highlight(timer)
    unlet! b:timer
    call s:HiCursorWords__execute()
endfunction

function! s:HiCursorWords__getHiName(linenum, colnum)
    let hiname = synIDattr(synID(a:linenum, a:colnum, 0), "name")
    return s:HiCursorWords__resolveHiName(hiname)
endfunction

function! s:HiCursorWords__resolveHiName(hiname)
    redir => resolved
    silent execute 'highlight ' . a:hiname
    redir END

    if stridx(resolved, 'links to') == -1
        return a:hiname
    endif

    return substitute(resolved, '\v.* links to ([^ ]+).*$', '\1', '')
endfunction

function! s:HiCursorWords__getWordUnderTheCursor(linestr, linenum, colnum)
    "let word = substitute(a:linestr, '.*\(\<\k\{-}\%' . a:colnum . 'c\k\{-}\>\).*', '\1', '') "expand('<word>')
    let word = matchstr(a:linestr, '\k*\%' . a:colnum . 'c\k\+')
    if empty(word)
        return ''
    endif
    return '\V\<' . word . '\>'
endfunction

function! s:HiCursorWords__execute()
    call s:HiCursorWords__clearHighlighting()

    let linestr = getline('.')
    let linenum = line('.')
    let colnum = col('.')

    if g:HiCursorWords_debugEchoHiName
        echo s:HiCursorWords__getHiName(linenum, colnum)
    endif

    let word = s:HiCursorWords__getWordUnderTheCursor(linestr, linenum, colnum)
    if strlen(word) != 0
        if strlen(g:HiCursorWords_hiGroupRegexp) != 0
                    \ && match(s:HiCursorWords__getHiName(linenum, colnum),
                    \ g:HiCursorWords_hiGroupRegexp) == -1
            return
        endif
        let w:HiCursorWords__matchId = matchadd('WordUnderTheCursor', word, 0)
    endif
endfunction

" Steven Lu: Add functionality to prevent the HCW styles being present in
" a vim window that is out of focus. For example, it confuses and interferes
" with vim-mark styles
function! s:HiCursorWords__clearHighlighting()
    if exists('b:timer')
        unlet! b:timer
    endif

    if exists("w:HiCursorWords__matchId")
        call matchdelete(w:HiCursorWords__matchId)
        unlet w:HiCursorWords__matchId
    endif
endfunction

function! HiCursorWords_toggle()
    if g:HiCursorWords_visible == 0
        call s:HiCursorWords__setHCWAutocmd()
        let g:HiCursorWords_visible = 1
    else
        autocmd! HiCursorWords
        call s:HiCursorWords__clearHighlighting()
        let g:HiCursorWords_visible = 0
    endif
endfunction

" vim: set et ft=vim sts=4 sw=4 ts=4 tw=78 :
