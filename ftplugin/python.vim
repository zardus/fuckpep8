" Name:          fuckpep8 (global plugin)
" Version:       1.2
" Author:        Yan Shoshitaishvili <yans@yancomm.net>
" Updates:       http://github.com/zardus/fuckpep8
" Purpose:       Make life feasible in the presense of crazy space-hippies.
"                Necessary because there are people in the world that are not
"                reasonable enough to use tabs :-(
"
" License:       You may redistribute this plugin under the same terms as Vim
"                itself.
"
" Usage:         None! It works as a filetype plugin.
"
" Requirements:  Needs the awesome detectindex plugin
"                   (http://www.vim.org/scripts/script.php?script_id=1171)

function! UndoSmartRetab()
	let cr = changenr()
	let b:tabundos[cr] = 1
	if !has_key(b:tabundos, "max") || cr > b:tabundos["max"]
		let b:tabundos["max"] = cr
	endif
	let b:tabundos["win_" . cr] = winsaveview()
	retab!
endfunction

function! TabUndoEntryCount(from_cr)
	if !has_key(b:tabundos, a:from_cr - 1)
		return 0
	endif
	return 1 + TabUndoEntryCount(a:from_cr - 1)
endfunction

function! TabRedoEntryCount(from_cr)
	if !has_key(b:tabundos, a:from_cr)
		return 0
	endif
	return 1 + TabRedoEntryCount(a:from_cr + 1)
endfunction

function! RetabSmartUndo()
	let num_undo = TabUndoEntryCount(changenr())

	let win = winsaveview()
	while num_undo > 0
		silent! :undo
		let num_undo -= 1
	endwhile
	call winrestview(win)

	:undo
endfunction

function! RetabSmartRedo()
	let num_undo = TabRedoEntryCount(changenr())

	let win = winsaveview()
	while num_undo > 0
		silent! :redo
		let num_undo -= 1
	endwhile
	call winrestview(win)

	:redo
endfunction

function! FixIndent()
	let &l:tabstop = &l:shiftwidth

	if &l:expandtab
		"echom "Fixing indent"

		let b:tabified = 1
		let b:oldtabstop = &l:tabstop
		setlocal noexpandtab

		call UndoSmartRetab()

		setlocal tabstop=4
		setlocal softtabstop=4
		setlocal shiftwidth=4
	else
		let b:tabified = 0
	endif
endfunction

function! UnfixIndent()
	if exists('b:tabified') && b:tabified
		set expandtab
		let &l:tabstop=b:oldtabstop
		let &l:softtabstop=b:oldtabstop

		call UndoSmartRetab()
	endif
endfunction

function! DictToStr(d)
	redir => dstr
	silent! echo a:d
	redir end

	return strpart(dstr, 1)
endfunction

function! StrToDict(dstr)
	sandbox let d = eval(a:dstr)
	return d
endfunction

function! SaveTabUndos(filename)
	call writefile([ DictToStr(b:tabundos) ], a:filename)
endfunction

function! LoadTabUndos(filename)
	if filereadable(a:filename)
		let b:tabundos = StrToDict(readfile(a:filename)[0])

		if b:tabundos["max"] > undotree()["seq_last"]
			" our undo file probably got invalidated from under us
			"echom "Clearing tabundos"
			let b:tabundos = { }
		endif
	else
		let b:tabundos = { }
	endif
endfunction

let b:tabundofile = undofile(bufname("%")) . "-fuckpep8"
call LoadTabUndos(b:tabundofile)

:DetectIndent
call FixIndent()
autocmd BufWritePre *.py call UnfixIndent()
autocmd BufWritePost *.py call FixIndent()
autocmd BufWritePost *.py call SaveTabUndos(b:tabundofile)

map u :call RetabSmartUndo()<CR>
map <c-r> :call RetabSmartRedo()<CR>
