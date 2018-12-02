" *** PART 1 ******************************************************************

autocmd FileType c set cindent

inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>

set ruler

syntax on
filetype on
colorscheme desert


set hls
match DiffText \  \
2match DiffText /\s\n/

set backup
:call system("mkdir -p ~/.vim/backup")
set backupdir=~/.vim/backup/
set writebackup
set backupcopy=yes
au BufWritePre * let &bex = '~'


" *** BONUS PART 1 ************************************************************

set number
set colorcolumn=80
set number
set showcmd


" *** PART 3 ******************************************************************

" s:Name -> only local scripting functions
" to test a fonction (si not local) -> :put =GetFileName()

function s:GetMail()
	if ($MAIL == '')
		return 'marvin@42.fr'
	else
		return $MAIL
	endif
endfunction

function s:GetUser()
	if ($USER == '')
		return 'marvin'
	else
		return $USER
	endif
endfunction

function s:GetFileName()
	return expand('%:t')
endfunction

function s:GetCreationDate()
	""let time = system('stat -f "%B" ' . s:GetFileName())
	return strftime("%Y/%m/%d %H:%M:%S")
endfunction

function s:GetLastModifDate()
	""return strftime("%Y/%m/%d %H:%M:%S", getftime(s:GetFileName()))
	return strftime("%Y/%m/%d %H:%M:%S")
endfunction

function s:HeaderFileLine(filename)
	let line = "/*   "
	let line .= printf("%-41.41s", a:filename)
	let line .= "          :+:      :+:    :+:   */"
	return line
endfunction

function s:HeaderUserMailLine(user, mail)
	let mail = printf("<%.25s>", a:mail)
	let user_mail = printf("%.9s %-27.27s", a:user, mail)
	return printf("/*   By: %-37s      +#+  +:+       +#+        */", user_mail)
endfunction

function s:HeaderCreationDate(creation_date, user)
	return printf("/*   Created: %s by %-9.9s         #+#    #+#             */", a:creation_date, a:user)
endfunction

function s:HeaderUpdatedDate(last_modif_date, user)
	return printf("/*   Updated: %s by %-9.9s        ###   ########.fr       */", a:last_modif_date, a:user)
endfunction

function CheckLine(line1, line2)
	if a:line1 == a:line2
		return 0
	else
		return 1
	endif
endfunction

function CheckLength(line, l)
	if strlen(a:line) == a:l
		return 0
	else
		return 1
	endif
endfunction

function s:CheckHeader()
	let rslt = 0
	let rslt += CheckLine(getline(1), "/* ************************************************************************** */")
	let rslt += CheckLine(getline(2), "/*                                                                            */")
	let rslt += CheckLine(getline(3), "/*                                                        :::      ::::::::   */")
	let rslt += CheckLength(getline(4), 80)
	let rslt += CheckLine(getline(5), "/*                                                    +:+ +:+         +:+     */")
	let rslt += CheckLength(getline(6), 80)
	let rslt += CheckLine(getline(7), "/*                                                +#+#+#+#+#+   +#+           */")
	let rslt += CheckLength(getline(8), 80)
	let rslt += CheckLength(getline(9), 80)
	let rslt += CheckLine(getline(10), "/*                                                                            */")
	let rslt += CheckLine(getline(11), "/* ************************************************************************** */")
	return rslt
endfunction

function Insert42Header()
	let user             = s:GetUser()
	let mail             = s:GetMail()
	let filename        = s:GetFileName()
	let creation_date     = s:GetCreationDate()
	let last_modif_date = s:GetLastModifDate()

	if (s:CheckHeader() != 0)
		call append(0, "/* ************************************************************************** */")
		call append(1, "/*                                                                            */")
		call append(2, "/*                                                        :::      ::::::::   */")
		call append(3, s:HeaderFileLine(filename))
		call append(4, "/*                                                    +:+ +:+         +:+     */")
		call append(5, s:HeaderUserMailLine(user, mail))
		call append(6, "/*                                                +#+#+#+#+#+   +#+           */")
		call append(7, s:HeaderCreationDate(creation_date, user))
		call append(8, s:HeaderUpdatedDate(last_modif_date, user))
		call append(9, "/*                                                                            */")
		call append(10, "/* ************************************************************************** */")
		call append(11, "")
	endif
endfunction

function UpdateLastModifDate()

	if &mod != 0 " If the file was modified

		let user            = s:GetUser()
		let last_modif_date = strftime("%Y/%m/%d %H:%M:%S")

		let line_from_file = getline(9)
		let updated_line   = s:HeaderUpdatedDate(last_modif_date, user)
		let part_line_from_file = strpart(line_from_file, 0, 13)

		" If the header updated line is present AND  both lines aren't identical
		if (s:CheckHeader() == 0)
			call setline (9, updated_line)
		endif

	endif
endfunction


" Shortcut to add header
nnoremap <silent><C-c><C-h> :call Insert42Header()<CR>
" Update line of header (if necessary) when registering
autocmd BufWritePre * call UpdateLastModifDate ()
