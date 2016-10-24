# VIM plugin for highlighting words under cursor

----------

## About

This script highlights words under the cursor everywhere in the opened buffer. This doesn't provide scope-aware highlighting nor language specific one.

This is forked from [#4306](http://www.vim.org/scripts/script.php?script_id=4306 "http://www.vim.org/scripts/script.php?script_id=4306") by [Shuhei Kubota](http://www.vim.org/account/profile.php?user_id=7032 "Shuhei Kubota")

With contributions from [荒野无灯](http://ihacklog.com "荒野无灯@iHacklog")

没错，这就是你要找的vim **高亮与当前光标下单词相同的所有单词** 的功能。

2016-10-24: the highlighting-style is now configurable via `let g:HiCursorWords_linkStyle` or `g:HiCursorWords_style`

## Configuration

**highlight configuration**

Configurable within your .vimrc:

Either by defining a style:

    let g:HiCursorWords_style='term=reverse cterm=reverse gui=reverse'

or linking to an existing one

    let g:HiCursorWords_linkStyle='VisualNOS'

**default config**

	let g:HiCursorWords_delay = 200
	let g:HiCursorWords_hiGroupRegexp = ''
	let g:HiCursorWords_debugEchoHiName = 0
    let g:HiCursorWords_linkStyle='Underlined'

**Other variables**

(A right hand side value is a default value.)

	g:HiCursorWords_delay = 200

A delay for highlighting in milliseconds.
Smaller value may cause your machine slow down.

    g:HiCursorWords_hiGroupRegexp = ''

If empty, all words are highlighted.
If not empty, only the specified highlight group is highlighted.
(my memo: 'Identifier\|vimOperParen')

To investigate highlight group name, the next variable may help you.

	g:HiCursorWords_debugEchoHiName = 0

If not 0, echoes the highlight group name under the cursor.


## Installation details

Just put this file into the **plugin** directory.

Or clone it into your bundle-path and use with pathogen.

    git clone https://github.com/pboettch/vim-highlight-cursor-words.git ~/.vimrc/bundle/vim-highlight-cursor-words

or a submodule

    cd ~/vim.rc
    git submodule add https://github.com/pboettch/vim-highlight-cursor-words.git bundle/vim-highlight-cursor-words

----------

That's all. Have fun `/*_*/`
