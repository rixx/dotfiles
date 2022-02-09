" Name:       monorixx.vim
" Version:    0.1
" Maintainer: github.com/rixx
" License:    The MIT License (MIT)
"
" Based on
"
"   https://github.com/sdothum/vim-colors-duochrome
"
" which in turn based on
"
"   https://github.com/andreypopp/vim-colors-plain
"
" which in turn based on
"
"   https://github.com/pbrisbin/vim-colors-off (MIT License)
"
" which in turn based on
"
"   https://github.com/reedes/vim-colors-pencil (MIT License)
"
"""
hi clear

if exists('syntax on')
    syntax reset
endif

let g:colors_name='duochrome'

" My black is kinda fucked, so we use default here instead of 0
let s:black           = {"gui": "#222222", "cterm": "NONE"}
let s:medium_gray     = { "gui": "#767676", "cterm": "243" }
let s:white           = { "gui": "#f7f3ee", "cterm": "15"  }  " flatwhite bg
" My white is kinda equally fucked, so we use default here instead of 0
let s:bg              = { "gui": "#f7f3ee", "cterm": "NONE" }
let s:orange          = { "gui": "#c18401", "cterm": "208" }  " one color orange 2
let s:dark_orange     = { "gui": "#ff5f00", "cterm": "202" }
let s:light_black     = { "gui": "#424242", "cterm": "8"   }
let s:lighter_black   = { "gui": "#545454", "cterm": "240" }
let s:subtle_black    = { "gui": "#303030", "cterm": "236" }
let s:light_gray      = { "gui": "#999999", "cterm": "249" }
let s:lighter_gray    = { "gui": "#CCCCCC", "cterm": "251" }
let s:lightest_gray   = { "gui": "#E5E5E5", "cterm": "251" }
let s:dark_red        = { "gui": "#C30771", "cterm": "1"   }
let s:light_red       = { "gui": "#E32791", "cterm": "1"   }
let s:dark_blue       = { "gui": "#008EC4", "cterm": "4"   }
let s:light_blue      = { "gui": "#B6D6FD", "cterm": "153" }
let s:dark_cyan       = { "gui": "#20A5BA", "cterm": "6"   }
let s:light_cyan      = { "gui": "#4FB8CC", "cterm": "14"  }
let s:dark_green      = { "gui": "#10A778", "cterm": "2"   }
let s:light_green     = { "gui": "#5FD7A7", "cterm": "10"  }
let s:dark_purple     = { "gui": "#523C79", "cterm": "5"   }
let s:light_purple    = { "gui": "#6855DE", "cterm": "13"  }
let s:light_yellow    = { "gui": "#F3E430", "cterm": "11"  }
let s:dark_yellow     = { "gui": "#A89C14", "cterm": "3"   }
let s:iawriter        = { "gui": "#20fccf", "cterm": "51"  }  " iA writer cursor


"" HI FUTURE ME
" If you're trying to go back to a dark theme: I'm sorry for throwing out
" all the dark theme stuff – probably best to grab the original theme at this
" point, and to modify that as needed.

let s:bg_subtle        = s:lighter_gray
let s:bg_very_subtle   = s:light_gray
let s:norm             = s:black
let s:norm_subtle      = s:lighter_black
let s:norm_very_subtle = s:medium_gray
let s:red              = s:dark_red
let s:yellow           = s:dark_yellow
let s:visual           = s:light_blue
let s:cursor_line      = s:bg  " no highlight
let s:constant         = s:dark_blue
let s:comment          = s:orange
let s:selection        = s:light_yellow
let s:selection_fg     = s:black
let s:ok               = s:light_green
let s:warning          = s:yellow
let s:error            = s:dark_red

" unlet s:black
" unlet s:medium_gray
" unlet s:white
" unlet s:orange
" unlet s:light_black
" unlet s:lighter_black
" unlet s:subtle_black
" unlet s:light_gray
" unlet s:lighter_gray
" unlet s:lightest_gray
" unlet s:dark_red
" unlet s:light_red
" unlet s:dark_blue
" unlet s:light_blue
" unlet s:dark_cyan
" unlet s:light_cyan
" unlet s:dark_green
" unlet s:light_green
" unlet s:dark_purple
" unlet s:light_purple
" unlet s:light_yellow
" unlet s:dark_yellow

" https://github.com/noahfrederick/vim-hemisu/
function! s:h(group, style)
  execute "highlight" a:group
    \ "guifg="   (has_key(a:style, "fg")    ? a:style.fg.gui   : "NONE")
    \ "guibg="   (has_key(a:style, "bg")    ? a:style.bg.gui   : "NONE")
    \ "guisp="   (has_key(a:style, "sp")    ? a:style.sp.gui   : "NONE")
    \ "gui="     (has_key(a:style, "gui")   ? a:style.gui      : "NONE")
    \ "ctermfg=" (has_key(a:style, "fg")    ? a:style.fg.cterm : "NONE")
    \ "ctermbg=" (has_key(a:style, "bg")    ? a:style.bg.cterm : "NONE")
    \ "cterm="   (has_key(a:style, "cterm") ? a:style.cterm    : "NONE")
endfunction

" __Normal__
if has("gui")
    call s:h("Normal",    {"fg": s:norm_subtle, "bg": s:bg})
    call s:h("Cursor",    {"fg": s:black, "bg": s:iawriter})  " iA writer cursor
else
    call s:h("Normal",    {"fg": s:norm_subtle})
    hi! link Cursor       Identifier
endif

call s:h("Identifier",    {"fg": s:black, "cterm": "italic"})
hi! link Function         Identifier
hi! link Type             Identifier
hi! link StorageClass     Type
hi! link Structure        Type
hi! link Typedef          Type
hi! link Special          Normal
hi! link SpecialChar      Special
hi! link Tag              Special
hi! link Delimiter        Special
hi! link SpecialComment   Special
hi! link Debug            Special
hi! link VertSplit        Normal
hi! link PreProc          Normal
hi! link Define           PreProc
hi! link Macro            PreProc
hi! link PreCondit        Comment  " highlight code sections

" __Operator__
call s:h("Noise",         {"fg": s:norm_very_subtle, "gui": "NONE"})
hi! link Operator         Noise
call s:h("LineNr",        {"fg": s:norm_very_subtle, "gui": "italic", "cterm": "italic"})
call s:h("CursorLineNr",  {"fg": s:dark_orange, "gui": "italic", "cterm": "italic"})
hi! link FoldColumn       LineNr
hi! link SignColumn       LineNr

" __Comment__
call s:h("Comment",       {"fg": s:comment, "gui": "italic", "cterm": "italic"})
call s:h("Todo",          {"bg": s:selection, "fg": s:black, "gui": "bold,italic", "cterm": "bold,italic"})

" __Constant__
call s:h("Constant",      {"fg": s:constant})
hi! link Character        Constant
hi! link Number           Constant
hi! link Boolean          Constant
hi! link Float            Constant
hi! link String           Constant
hi! link Directory        Constant
hi! link Title            Constant

" __Statement__
call s:h("Statement",     {"fg": s:black, "gui": "bold", "cterm": "bold"})
hi! link Include          Statement
hi! link Conditonal       Statement
hi! link Repeat           Statement
hi! link Label            Statement
hi! link Keyword          Statement
hi! link Exception        Statement

" __ErrorMsg__
call s:h("ErrorMsg",      {"fg": s:error})
hi! link Error            ErrorMsg
hi! link Question         ErrorMsg
" __WarningMsg__
call s:h("WarningMsg",    {"fg": s:warning})
" __MoreMsg__
call s:h("MoreMsg",       {"fg": s:norm_subtle, "cterm": "bold", "gui": "bold"})
hi! link ModeMsg          MoreMsg

" __NonText__
call s:h("NonText",       {"fg": s:norm_very_subtle})
hi! link Folded           NonText
hi! link qfLineNr         NonText

" __Search__
call s:h("Search",        {"bg": s:selection, "fg": s:selection_fg})
call s:h("IncSearch",     {"bg": s:selection, "fg": s:selection_fg, "gui": "bold"})

" __Visual__
call s:h("Visual",        {"bg": s:visual})
" __VisualNOS__
call s:h("VisualNOS",     {"bg": s:bg_subtle})

call s:h("Ignore",        {"fg": s:bg})

" __DiffAdd__
call s:h("DiffAdd",       {"fg": s:dark_green})
" __DiffDelete__
call s:h("DiffDelete",    {"fg": s:red})
" __DiffChange__
call s:h("DiffChange",    {"fg": s:yellow})
" __DiffText__
call s:h("DiffText",      {"fg": s:constant})

call s:h("SpellBad",    {"cterm": "underline", "fg": s:red, "gui": "underline"})
call s:h("SpellCap",    {"cterm": "underline", "fg": s:ok, "gui": "underline"})
call s:h("SpellRare",   {"cterm": "underline", "fg": s:error, "gui": "underline"})
call s:h("SpellLocal",  {"cterm": "underline", "fg": s:ok, "gui": "underline"})

hi! link helpHyperTextEntry Title
hi! link helpHyperTextJump  String

" __StatusLine__
call s:h("StatusLine",        {"gui": "underline", "bg": s:bg, "fg": s:norm_very_subtle})
call s:h("StatusLineOk",      {"gui": "underline", "bg": s:bg, "fg": s:ok})
call s:h("StatusLineError",   {"gui": "underline", "bg": s:bg, "fg": s:error, "cterm": "underline"})
call s:h("StatusLineWarning", {"gui": "underline", "bg": s:bg, "fg": s:warning, "cterm": "underline"})

" __Pmenu__
" This is the suggestions/popup menu
call s:h("Pmenu",         {"fg": s:norm, "bg": s:white})
hi! link PmenuSbar        Pmenu
hi! link PmenuThumb       Pmenu
" __PmenuSel__
call s:h("PmenuSel",      {"fg": s:norm, "bg": s:lightest_gray, "gui": "bold", "cterm": "bold"})

hi! link TabLine          Normal
hi! link TabLineSel       Keyword
hi! link TabLineFill      Normal

" __CursorLine__
call s:h("CursorLine",    {"bg": s:cursor_line})

" __MatchParen__
call s:h("MatchParen",    {"bg": s:bg_subtle, "fg": s:red})

hi! link htmlH1 Normal
hi! link htmlH2 Normal
hi! link htmlH3 Normal
hi! link htmlH4 Normal
hi! link htmlH5 Normal
hi! link htmlH6 Normal

hi link diffRemoved       DiffDelete
hi link diffAdded         DiffAdd

" Signify, git-gutter
hi link SignifySignAdd              LineNr
hi link SignifySignDelete           LineNr
hi link SignifySignChange           LineNr
hi link GitGutterAdd                LineNr
hi link GitGutterDelete             LineNr
hi link GitGutterChange             LineNr
hi link GitGutterChangeDelete       LineNr

hi link jsFlowTypeKeyword Statement
hi link jsFlowImportType Statement
hi link jsFunction Statement
hi link jsGlobalObjects Normal
hi link jsGlobalNodeObjects Normal
hi link jsArrowFunction Noise
hi link StorageClass Statement

hi link xmlTag Constant
hi link xmlTagName xmlTag
hi link xmlEndTag xmlTag
hi link xmlAttrib xmlTag

hi link markdownH1 Statement
hi link markdownH2 Statement
hi link markdownH3 Statement
hi link markdownH4 Statement
hi link markdownH5 Statement
hi link markdownH6 Statement
hi link markdownListMarker Constant
hi link markdownCode Constant
hi link markdownCodeBlock Constant
hi link markdownCodeDelimiter Constant
hi link markdownHeadingDelimiter Constant

hi link yamlBlockMappingKey Statement
hi link pythonOperator Statement
