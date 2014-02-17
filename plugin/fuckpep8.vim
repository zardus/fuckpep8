" Name:          fuckpep8 (global plugin)
" Version:       1.0
" Author:        Yan Shoshitaishvili <yans@yancomm.net>
" Updates:       http://github.com/zardus/fuckpep8
" Purpose:       Make life feasible in the presense of crazy space-hippies.
"                Necessary because there are people in the world that are not
"                reasonable enough to use tabs :-(
"
" License:       You may redistribute this plugin under the same terms as Vim
"                itself.
"
" Usage:         Put the following in your .vimrc:
"
"                    autocmd BufReadPost *.py call FixIndent()
"                    autocmd BufWritePre *.py call UnfixIndent()
"
" Requirements:  Needs the awesome detectindex plugin
"                   (http://www.vim.org/scripts/script.php?script_id=1171)


function! FixIndent()
	let &l:tabstop = &l:shiftwidth

	if &l:expandtab
		"echom "Fixing indent"

		let b:tabified = 1
		let b:oldtabstop = &l:tabstop
		setlocal noexpandtab
		retab!
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
		retab!
	endif
endfunction
