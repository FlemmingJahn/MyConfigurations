(setq default-major-mode 'text-mode)
(setq text-mode-hook
      '(lambda nil
	 (setq fill-column 72)
	 (auto-fill-mode 0)))






(setq load-path (cons (expand-file-name "~/lisp/vhdlmode") load-path))
(setq load-path (cons (expand-file-name "~/lisp") load-path))

(setq load-path (cons "~/emacs" load-path))

;(require 'idutils)

;; Default follow symbolic links without asking
(setq vc-follow-symlinks t)

(setq-default frame-title-format (list "Emacs: " emacs-version "  %f" ))
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Color for different modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'tcl-mode-hook            'turn-on-font-lock)
(add-hook 'java-mode-hook            'turn-on-font-lock)
(add-hook 'emacs-lisp-mode-hook  'turn-on-font-lock)
(add-hook 'makefile-mode-hook    'turn-on-font-lock)
(add-hook 'perl-mode-hook        'turn-on-font-lock)

(autoload 'xml-mode "psgml" "Major mode to edit XML files." t)
(add-hook 'xml-mode-hook 'turn-on-font-lock)

(setq auto-mode-alist (cons '("\\.js?\\'" . java-mode) auto-mode-alist))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ETAGS stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Skip the asking of "really open" for large files
;(setq large-file-warning-threshold nil)


(defvar tcl-indent-level 2
  "*Indentation of Tcl statements with respect to containing block.")

(defvar tcl-continued-indent-level 2
  "*Indentation of continuation line relative to first line of command.")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Backup stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;  (setq backup-by-copying t)
;  (setq backup-directory-alist '(("." . "~/.backups/")))
;  (setq delete-old-versions t)
;  (setq kept-new-versions 6)
;  (setq kept-old-versions 2)

  ;;  If you want to prevent emacs from creating the backup file add following line in the file:
  (setq make-backup-files nil)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Special key-mappings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Make the "iconize" key the "undo" key
(global-unset-key [?\C-z])
(global-set-key [?\C-z] 'undo)
(global-unset-key [?\C-l])
(define-key global-map [?\C-l]  'goto-line)
(global-unset-key [?\C-b])
(define-key global-map [?\C-b]  'forward-sexp)
(global-set-key [delete] 'delete-char)
(define-key global-map "\C-s"  'isearch-forward-regexp)

(define-key global-map [?\C-f]    'find-tag-other-window)
(define-key global-map [?\M-.]    'find-tag-other-window)
(define-key global-map [f7] 'gid)

; This binds word completions to Shift-Tab
;(define-key global-map "\C-s"  'hippie-expand)
(global-set-key "\C-c" 'hippie-expand) ; CTRL + c for autocomplete
;(global-set-key "\M- " 'hippie-expand)
;(global-set-key "[S-tab]" 'hippie-expand)
;(global-set-key [S-tab] 'dabbrev-expand)


;;(global-set-key [delete ?\C-d])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Font-lock stuff (used by VHDL mode etc.)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 (global-font-lock-mode t)




; Setting font size
(set-face-attribute 'default nil :height 112)




;=============================================================================
; C configurations
;=============================================================================
(setq compile-command "mk")

; Find build directory
(defun get-above-makefile () (expand-file-name
	   "build/" (loop as d = default-directory then (expand-file-name
	   ".." d) if (file-exists-p (expand-file-name "Makefile" d)) return
	   d)))


(setq-default c-basic-offset 4)

(setq compile-command "gmake ")

(require 'cl); If you don't have it already


;; Helper function to find files. Source: emacswiki
(defun* get-closest-pathname (&optional (file "Makefile"))
  "Determine the pathname of the first instance of FILE starting from the current directory towards root.
This may not do the correct thing in presence of links. If it does not find FILE, then it shall return
the current directory"
  (let ((root (expand-file-name "/")))
    (loop for d = default-directory
          then (expand-file-name ".." d)
          if (file-exists-p (expand-file-name file d))  return d
          if (equal d root) return nil)))


(setq flyspell-issue-welcome-flag nil) ;; fix flyspell problem

;; Compiling / Tags
;; Automatically find the Makefile and TAGS file
;(defun my-c-mode-common-hook()
;  (set (make-local-variable 'compile-command) (format "cd %s;make -j2 -k" (get-closest-pathname)))
;  (set (make-local-variable 'tags-file-name) (get-closest-pathname "TAGS"))
;  (flyspell-prog-mode) )


(defun my-c-mode-common-hook()
  (set (make-local-variable 'compile-command) (format "cd %s;make -j4 -l5" (get-closest-pathname)))
   (flyspell-prog-mode) )

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
(global-set-key (kbd "M->") 'pop-tag-mark) ; M-. goes to definition, M-> undos that
;(global-set-key (kbd "C-`") 'compile)

(setq compilation-read-command nil)        ; Don't prompt for compile command. C-u C-` does prompt
(setq compilation-ask-about-save nil)      ; Don't ask to save files before compiling, just save
;(global-set-key (kbd "C-c g") 'rgrep)

;; bind compiling with get-above-makefile to f8
(global-set-key [f8] (lambda () (interactive) (compile (format
	   "make -j8 -l5 -C %s" (get-above-makefile)))))

(global-set-key [f9] 'next-error)

(setq compilation-window-width 1000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Himark stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load-file "~/lisp/exbit_himark.el")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;=============================================================================
;; Load history from last time Emacs was invoked
;;=============================================================================
(desktop-load-default)
(setq desktop-globals-to-save (list
                               'command-history
                               'compile-history
                               'default-directory
                               'extended-command-history
                               'file-name-history
                               'grep-find-history
                               'grep-history
                               'minibuffer-history
                               'query-replace-history
                               'regexp-history
                               'regexp-search-ring
                               'search-ring
                               'shell-command-history
                               'find-tag-history
                               'tags-file-name
                               'tags-table-list
                               'tags-table-set-list
                               'register-alist
                               ))
(desktop-read)





;=============================================================================
; HG stuff
;=============================================================================
(require 'vc-hg)
(defun vc-hg-annotate-command (file buffer &optional revision)
"Execute \"hg annotate\" on FILE, inserting the contents in BUFFER.
Optional arg REVISION is a revision to annotate from."
(vc-hg-command buffer 0 file "annotate" "-d" "-n" "--follow" "-u"
(when revision (concat "-r" revision))))

;=============================================================================
; Various useful functions
;=============================================================================

(defun dos2unix ()
  "Replace \\r\\n with \\n"
  (interactive)
  (save-excursion)
  (goto-char (point-min))
  (while (search-forward "\r\n" nil t)
    (replace-match "\n" nil t)))

(defun unix2dos ()
  "Replace \\n with \\r\\n"
  (interactive)
  (save-excursion)
  ; Make sure that the file is in unix mode
  (dos2unix)
  (goto-char (point-min))
  (while (search-forward "\n" nil t)
    (replace-match "\r\n" nil t)))

(put 'upcase-region 'disabled nil)



;;
;;

;(load (concat (getenv "EXBIT_CONFIGURATION_DIRECTORY") "/emacs/lisp/exbit/Setup"))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; VHDL mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(autoload 'vhdl-mode "vhdl-mode" "VHDL Mode" t)
(setq auto-mode-alist (cons '("\\.vhd?\\'" . vhdl-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.ent?\\'" . vhdl-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.arc?\\'" . vhdl-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.pck?\\'" . vhdl-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.bod?\\'" . vhdl-mode) auto-mode-alist))



(setq auto-mode-alist (cons '("\\.csl?\\'" . sgml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.rml?\\'" . sgml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.tsl?\\'" . sgml-mode) auto-mode-alist))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(perl-continued-brace-offset -2)
 '(perl-continued-statement-offset 2)
 '(perl-indent-level 2)
 '(safe-local-variable-values (quote ((c-comment-only-line-offset . 0))))
 '(show-paren-mode t nil (paren))
 '(user-mail-address "fj@vitesse.com")
 '(vhdl-actual-port-name (quote ("\\(.*\\)_[ioag]+$" . "\\1")))
 '(vhdl-align-groups nil)
 '(vhdl-basic-offset 2)
 '(vhdl-clock-edge-condition (quote function))
 '(vhdl-company-name "Vitesse Semiconductor Inc")
 '(vhdl-conditions-in-parenthesis t)
 '(vhdl-end-comment-column 150)
 '(vhdl-file-footer "--------------------------------------------------------------------------------
--                                                                            --
-- End of file.                                                               --
--                                                                            --
--------------------------------------------------------------------------------
 ")
 '(vhdl-file-header "-----------------------------------------------------------------------*-VHDL-*-
--                                                                            --
--                     Copyright (C) 2000, Vitesse Semiconductor Inc          --
--                             All Rights Reserved.                           --
--                                                                            --
--------------------------------------------------------------------------------
--                                                                            --
--                              Copyright Notice:                             --
--                                                                            --
--  This document contains confidential and proprietary information.          --
--  Reproduction or usage of this document, in part or whole, by any means,   --
--  electrical, mechanical, optical, chemical or otherwise is prohibited,     --
--  without written permission from Vitesse Semiconductor Inc.                --
--                                                                            --
--  The information contained herein is protected by Danish and international --
--  copyright laws.                                                           --
--                                                                            --
--------------------------------------------------------------------------------
--  Author:        <author>
--  File name:     <filename>
--  Description:
--
--    <cursor>
--------------------------------------------------------------------------------
 ")
 '(vhdl-include-direction-comments nil)
 '(vhdl-include-type-comments t)
 '(vhdl-index-menu t)
 '(vhdl-instance-name (quote (".*" . "inst_\\& ")))
 '(vhdl-speedbar-show-hierarchy t)
 '(vhdl-standard (quote (87 nil)))
 '(vhdl-underscore-is-part-of-word t)
 '(vhdl-upper-case-attributes t)
 '(vhdl-upper-case-enum-values t)
 '(vhdl-upper-case-types nil)
 '(vhdl-word-completion-case-sensitive t))


(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(column-number-mode t)
(auto-compression-mode)

;Convert TAB to spaces
(setq-default indent-tabs-mode nil)

; package for showing spaces/tab etc.
;(require 'whitespace)

; enable showing of whitespace/tabs
;(global-whitespace-mode t)

; Avoid strange colors
;(setq whitespace-space 'underline)

; Find TAG fil hvis den findes
;(setq project_tags (format "%s" (get-above-makefile)))
;(when (file-exists-p project_tags)  (visit-tags-table project_tags));


(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

(global-set-key "\C-V" 'yank)
;(global-set-key "\C-cc" 'kill-ring-save)
