" Author: Joe <r29jk10@gmail.com>
" Description: norminette linter for C files.

call ale#Set('cpp_norminette_executable', 'norminette')
call ale#Set('cpp_norminette_options', '')

function! ale_linters#cpp#norminette#GetExecutable(buffer) abort
    return ale#Var(a:buffer, 'cpp_norminette_executable')
endfunction

function! ale_linters#cpp#norminette#GetCommand(buffer) abort
    return ale#Escape(ale_linters#cpp#norminette#GetExecutable(a:buffer))
    \   . ale#Var(a:buffer, 'cpp_norminette_options')
    \   . ' %t'
endfunction


function! ale_linters#cpp#norminette#Opscript(buffer, lines) abort
    " Look for lines like the following.
    "
    " Error (line 27): multiple empty lines
    let l:pattern = '\v^(Norme|Error|Warning)( \(line (\d+)(, col (\d+))?\))?\:(.+)$'
    let l:output = []
	let l:curr_file = ''
	let l:lel = ale#util#GetMatches(a:lines, l:pattern)

    for l:match in ale#util#GetMatches(a:lines, l:pattern)
		if l:match[1] == "Norme"
			let l:curr_file = l:match[6]
		endif
		" if ale#path#IsBufferPath(a:buffer, l:curr_file) && l:match[1] == "Error"
		if l:match[1] == "Error" || l:match[1] == "Warning"
			call add(l:output, {
            \   'lnum': str2nr(l:match[3]),
			\   'col': l:match[5] is# '' ? 0 : str2nr(l:match[5]),
            \   'type': l:match[1] is# 'Error' ? 'E' : 'W',
            \   'text': l:match[0],
            \})
        endif
    endfor

    return l:output
endfunction

call ale#linter#Define('cpp', {
\   'name': 'norminette',
\   'output_stream': 'both',
\   'executable': function('ale_linters#cpp#norminette#GetExecutable'),
\   'command': function('ale_linters#cpp#norminette#GetCommand'),
\   'callback': 'ale_linters#cpp#norminette#Opscript',
\})
