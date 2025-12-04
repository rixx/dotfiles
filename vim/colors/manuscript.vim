" manuscript.vim - airline theme to match kitty manuscript palette

let g:airline#themes#manuscript#palette = {}

let g:airline#themes#manuscript#palette.accents = {
      \ 'red': [ '#a82818' , '' , 1 , '' , '' ],
      \ }

" warm parchment grays
let s:N1 = [ '#fdf6e3' , '#007171' , 15  , 6   ]
let s:N2 = [ '#302c26' , '#d4c8b4' , 236 , 250 ]
let s:N3 = [ '#302c26' , '#e4d8c4' , 236 , 252 ]
let g:airline#themes#manuscript#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#manuscript#palette.normal_modified = {
      \ 'airline_c': [ '#a82818' , '#e4d8c4' , 1 , 252 , 'bold' ] ,
      \ }

" insert: viridian
let s:I1 = [ '#fdf6e3' , '#187850' , 15  , 2   ]
let s:I2 = [ '#302c26' , '#d4c8b4' , 236 , 250 ]
let s:I3 = [ '#302c26' , '#e4d8c4' , 236 , 252 ]
let g:airline#themes#manuscript#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#manuscript#palette.insert_modified = {
      \ 'airline_c': [ '#a82818' , '#e4d8c4' , 1 , 252 , 'bold' ] ,
      \ }
let g:airline#themes#manuscript#palette.insert_paste = {
      \ 'airline_a': [ '#fdf6e3' , '#28a068' , 15 , 10 , '' ] ,
      \ }

" replace: vermillion
let g:airline#themes#manuscript#palette.replace = copy(g:airline#themes#manuscript#palette.insert)
let g:airline#themes#manuscript#palette.replace.airline_a = [ '#fdf6e3' , '#a82818' , 15 , 1 , '' ]
let g:airline#themes#manuscript#palette.replace.airline_z = [ '#fdf6e3' , '#a82818' , 15 , 1 , '' ]
let g:airline#themes#manuscript#palette.replace_modified = g:airline#themes#manuscript#palette.insert_modified

" visual: gold ochre
let s:V1 = [ '#18150f' , '#c18401' , 0   , 3   ]
let s:V2 = [ '#302c26' , '#d4c8b4' , 236 , 250 ]
let s:V3 = [ '#302c26' , '#e4d8c4' , 236 , 252 ]
let g:airline#themes#manuscript#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#manuscript#palette.visual_modified = {
      \ 'airline_c': [ '#a82818' , '#e4d8c4' , 1 , 252 , 'bold' ] ,
      \ }

" inactive: muted
let s:IA = [ '#6a6258' , '#e4d8c4' , 243 , 252 , '' ]
let g:airline#themes#manuscript#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
let g:airline#themes#manuscript#palette.inactive_modified = {
      \ 'airline_c': [ '#a82818' , '' , 1 , '' , '' ] ,
      \ }

" tabline
let g:airline#themes#manuscript#palette.tabline = {
      \ 'airline_tab':      ['#302c26', '#d4c8b4',  236, 250, ''],
      \ 'airline_tabsel':   ['#fdf6e3', '#007171',  15,  6,  'bold'],
      \ 'airline_tabtype':  ['#302c26', '#c9bda4',  236, 249, ''],
      \ 'airline_tabfill':  ['#302c26', '#e4d8c4',  236, 252, ''],
      \ 'airline_tabmod':   ['#a82818', '#e4d8c4',  1,   252, 'bold'],
      \ }

" warning: vermillion
let s:WI = [ '#fdf6e3', '#a82818', 15, 1 ]
let g:airline#themes#manuscript#palette.normal.airline_warning = [ s:WI[0], s:WI[1], s:WI[2], s:WI[3] ]
let g:airline#themes#manuscript#palette.normal_modified.airline_warning = g:airline#themes#manuscript#palette.normal.airline_warning
let g:airline#themes#manuscript#palette.insert.airline_warning = g:airline#themes#manuscript#palette.normal.airline_warning
let g:airline#themes#manuscript#palette.insert_modified.airline_warning = g:airline#themes#manuscript#palette.normal.airline_warning
let g:airline#themes#manuscript#palette.visual.airline_warning = g:airline#themes#manuscript#palette.normal.airline_warning
let g:airline#themes#manuscript#palette.visual_modified.airline_warning = g:airline#themes#manuscript#palette.normal.airline_warning
let g:airline#themes#manuscript#palette.replace.airline_warning = g:airline#themes#manuscript#palette.normal.airline_warning
let g:airline#themes#manuscript#palette.replace_modified.airline_warning = g:airline#themes#manuscript#palette.normal.airline_warning
