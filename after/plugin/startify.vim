if !get(g:, "loaded_startify", v:false)
  finish
endif

let g:startify_session_persistence = 1
" let g:startify_lists = [
"   \ { 'type': 'files', 'header': startify#pad(['MRU']) },
"   \ { 'type': 'dir', 'header': startify#pad(['MRU ' . getcwd()]) },
"   \ { 'type': 'sessions', 'header': startify#pad(['Sessions']) },
"   \ ]
let g:startify_custom_header =
  \ startify#pad([
  \ '',
  \ '██╗  ██╗██╗██████╗  █████╗ ██████╗ ██████╗  █████╗',
  \ '██║ ██╔╝██║██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗',
  \ '█████╔╝ ██║██████╔╝███████║██║  ██║██║  ██║███████║',
  \ '██╔═██╗ ██║██╔══██╗██╔══██║██║  ██║██║  ██║██╔══██║',
  \ '██║  ██╗██║██████╔╝██║  ██║██████╔╝██████╔╝██║  ██║',
  \ '╚═╝  ╚═╝╚═╝╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚═════╝ ╚═╝  ╚═╝',
  \ '',
  \ ])
