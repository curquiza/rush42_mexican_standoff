; Un code en C est automatiquement indenté avec des tabulations

(setq-default c-basic-offset 4 tab-width 4 indent-tabs-mode t c-default-style "linux" )

; Une paire (parenthèse ou accolade) est automatiquement fermée lorsque vous
; saisissez l’élément ouvrant

(electric-pair-mode 1)

; La colonne de position du curseur est affichée

(column-number-mode 1)

; Deux espaces côte-à-côte sont highlightés
(global-hi-lock-mode 1)
(add-hook 'change-major-mode-hook '(lambda() (highlight-regexp "  " 'hi-yellow)))

; Un whitespace avant un retour à la ligne est highlighté

(setq-default show-trailing-whitespace t)

; Les fichiers de sauvegarde (se terminant par ~) sont archivés dans un dossier
; spécifique à l’intérieur du dossier ~/.emacs.d

(setq backup-directory-alist '(("." . "~/.emacs.d/backup")))

; BONUS

(display-time)

; PART 3

; To debug
(setq debug-on-error t)

(defun getMail () (let ((mail (getenv "MAIL"))) (if (string= mail nil) "marvin@42.fr" mail)))
(defun getUser () (let ((login (getenv "USER"))) (if (string= login nil) "marvin" login)))
(defun getFilename () (file-name-nondirectory buffer-file-name))
(defun getFormatMail () (format "%-.25s" (getMail)))
(defun getFormatUser () (format "%-.9s" (getUser)))

(defun getUserMailLine () (format "/*   By: %-37s      +#+  +:+       +#+        */\n" (concat (getFormatUser) " <" (getFormatMail) ">")))
(defun getFilenameLine () (format "/*   %-41.41s          :+:      :+:    :+:   */\n" (getFilename)))
(defun getCreationDateLine () (format "/*   Created: %s by %-9.9s         #+#    #+#             */\n" (format-time-string "%Y/%m/%d %H:%M:%S") (getUser)))
(defun getUpdatedDateLine () (format "/*   Updated: %s by %-9.9s        ###   ########.fr       */\n" (format-time-string "%Y/%m/%d %H:%M:%S") (getUser)))

(defun getLines () (split-string (buffer-string) "\n"))

(defun checkHeader ()
	(interactive)
	(goto-char (point-min))
	(setq lines (getLines))
	(and
		(string= (nth 0 lines) "/* ************************************************************************** */")
		(string= (nth 1 lines) "/*                                                                            */")
		(string= (nth 2 lines) "/*                                                        :::      ::::::::   */")
		(eq 80 (length (nth 4 lines)))
		(string= (nth 4 lines) "/*                                                    +:+ +:+         +:+     */")
		(eq 80 (length (nth 5 lines)))
		(string= (nth 6 lines) "/*                                                +#+#+#+#+#+   +#+           */")
		(eq 80 (length (nth 7 lines)))
		(eq 80 (length (nth 8 lines)))
		(string= (nth 9 lines) "/*                                                                            */")
		(string= (nth 10 lines) "/* ************************************************************************** */")
	)
)

(defun insert42Header ()
	"42 Header generation"
	(interactive)
	(if (not (eq t (checkHeader)))
		(progn
		(goto-char (point-min))
		(insert "/* ************************************************************************** */\n")
		(insert "/*                                                                            */\n")
		(insert "/*                                                        :::      ::::::::   */\n")
		(insert (getFilenameLine))
		(insert "/*                                                    +:+ +:+         +:+     */\n")
		(insert (getUserMailLine))
		(insert "/*                                                +#+#+#+#+#+   +#+           */\n")
		(insert (getCreationDateLine))
		(insert (getUpdatedDateLine))
		(insert "/*                                                                            */\n")
		(insert "/* ************************************************************************** */\n")
		(insert "\n"))
	)
)

(defun deleteLine () (let ((beg (progn (forward-line 0) (point)))) (forward-line 1) (delete-region beg (point))))

(defun update42Header ()
	(interactive)
	(setq c (point))
	(goto-char (point-min))
	(setq lines (getLines))
	(if (eq t (checkHeader))
		(progn
		(goto-line 9)
		(deleteLine)
		(insert (getUpdatedDateLine)))
	)
	(goto-char c)
)

; key binding for 42 header generation
(global-set-key (kbd "C-c h") 'insert42Header)
; update header for every save
(add-hook 'before-save-hook 'update42Header)
