;; ___________________________________________________________________
;;
;;                   ___ _ __ ___   __ _  ___ ___
;;                  / _ \ '_ ` _ \ / _` |/ __/ __|
;;                 |  __/ | | | | | (_| | (__\__ \
;;                (_)___|_| |_| |_|\__,_|\___|___/
;;
;; ___________________________________________________________________


;; ___________________________________________________________________
;;
;; USER DETAILS
;; ___________________________________________________________________

  (setq user-full-name "Roland Schultheiss")
  (setq user-mail-address "rolschultheiss@gmail.com")


;; ___________________________________________________________________
;;
;; PACKAGE SYSTEM
;; ___________________________________________________________________

; loads common lisp to execute some commands ('loop')
  (require 'cl)

; set package repos
  (load "package")
  (package-initialize)
  (add-to-list 'package-archives
               '("melpa" . "http://melpa.org/packages/") t)

; Default packages
  (defvar roschu-packages '(magit
                            markdown-mode
                            org
			    auctex
			    ebib
			    ess
			    auto-complete
			    smart-mode-line
			    goto-chg
			    dired+
			    emms
                            color-theme)
    "Default packages")

; Check if all default packages are there...
  (defun roschu-packages-installed-p ()
    (loop for pkg in roschu-packages
          when (not (package-installed-p pkg)) do (return nil)
          finally (return t)))
; ... if not install them
  (unless (roschu-packages-installed-p)
    (message "%s" "Refreshing package database...")
    (package-refresh-contents)
    (dolist (pkg roschu-packages)
      (when (not (package-installed-p pkg))
        (package-install pkg))))


;; ___________________________________________________________________
;;
;; DEFAULT PATH SETTINGS
;; ___________________________________________________________________
;;

; WINDOWS
  (setq default-directory "C:/Users/rolsch/Documents" )
  (setq inferior-R-program-name "C:/Program Files/R/R-3.1.1/bin/x64/Rterm.exe")

;; UNIX-like
;  R stuff (ESS)
;  (load "/home/u22/rolsch/.emacs.d/ess-13.05/lisp/ess-site.el")

;; Overall Unix behavior regardless of platform
  (set-default buffer-file-coding-system 'utf-8-unix)
  (set-default-coding-systems 'utf-8-unix)
  (prefer-coding-system 'utf-8-unix)
  (set-default default-buffer-file-coding-system 'utf-8-unix)


;; ___________________________________________________________________
;;
;; START-UP OPTIONS
;; ___________________________________________________________________
;;
; don't show the startup screen
  (setq inhibit-startup-screen t
	initial-scratch-message nil)
; don't show the menu bar, tool bar, scroll bar
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
; other stuff
  (fset 'yes-or-no-p 'y-or-n-p)
  (set-terminal-coding-system 'iso-latin-1)
  (setq scroll-conservatively 1)
  (require 'auto-complete)
  (global-auto-complete-mode t)

;; ___________________________________________________________________
;;
;; DISPLAY SETTINGS
;; ___________________________________________________________________
;;

; Ido is handy because it makes switching between buffers,
  (require 'ido)
  (ido-mode t)
; set font for all windows
  (add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-10"))
; color theme
  (require 'color-theme)
  (color-theme-initialize)
  (color-theme-charcoal-black)
; highlight the current line
  (global-hl-line-mode t)
  (set-face-background hl-line-face "#696969")
; display line numbers to the right of the window
  (global-linum-mode t)
; show the current line and column numbers in the stats bar as well
  (line-number-mode t)
  (column-number-mode t)
; show time
  (display-time-mode 1)
; if there is size information associated with text, change the text
; size to reflect it
  (size-indication-mode t)
; shows file in frame title
  (when window-system
    (setq frame-title-format '(buffer-file-name "%f" ("%b"))))
; smart-line mode
  (sml/setup)
  (sml/apply-theme 'automatic)

; Darkroom mode for Windows
(add-to-list 'load-path "C:/Users/rolsch/.emacs.d/dr/")
(require 'darkroom-mode)



;; ___________________________________________________________________
;;
;; EDITING
;; ___________________________________________________________________
;;

; always use spaces, not tabs, when indenting
  (setq indent-tabs-mode nil)
; require final newlines in files when they are saved
  (setq require-final-newline t)
; show end of file
  (setq-default indicate-empty-lines t)
  (when (not indicate-empty-lines)
    (toggle-indicate-empty-lines))
; wrap text
  (global-visual-line-mode t)
; language
  (setq current-language-environment "English")
; highlight parentheses when the cursor is next to them
  (require 'paren)
  (show-paren-mode t)
; Will overwrite in marked region
  (delete-selection-mode t)
  (transient-mark-mode t)
; use system clipboard
  (setq x-select-enable-clipboard t)
; do not create backup files
  (setq make-backup-files nil)
; "Replace" the backspace key
  (global-set-key "\C-q" 'backward-kill-word)
; go to last change
  (require 'goto-chg)
  (global-set-key (kbd "C-.") 'goto-last-change)
; use dired extensions
(require 'dired+)
(setq-default ispell-program-name "aspell")
;; Make sizes human-readable by default, sort version numbers
;; correctly, and put dotfiles and capital-letters first.
(setq-default dired-listing-switches "-alhv")


;; ___________________________________________________________________
;;
;; ORG-MODE
;; ___________________________________________________________________

  (require 'python)
  (setq python-shell-interpreter "ipython")
; (setq python-shell-interpreter-args "--pylab")


;; ___________________________________________________________________
;;
;; ORG-MODE
;; ___________________________________________________________________

; Connect org-mode to reftex (see resources)
  (defun org-mode-reftex-setup ()
    (load-library "reftex")
    (and (buffer-file-name) (file-exists-p (buffer-file-name))
         (progn
           ; enable auto-revert-mode
	   ; update reftex when bibtex file changes on disk
           (global-auto-revert-mode t)
           (reftex-parse-all)
	   ; add a custom reftex cite format to insert links
           (reftex-set-cite-format
            '((?b . "[[bib:%l][%l-bib]]")
              (?n . "[[notes:%l][%l-notes]]")
              (?p . "[[papers:%l][%l-paper]]")
	      (?c . "\\cite[]{%l}")
              (?h . "* %2a (%y) %t\n[[bib:%l][%l-bib]]\n[[papers:%l][%l-paper]]\n:PROPERTIES:\n:Custom_ID:%l\n:READ:nil\n:END:\n** Notes\n- Dummy text\n\n")))))
    (define-key org-mode-map (kbd "C-c )") 'reftex-citation)
    (define-key org-mode-map (kbd "C-c (") 'org-mode-reftex-search))

  (setq org-link-abbrev-alist
        '(("bib" . "~/Documents/research/bibliography/roschu.bib::%s")
          ("notes" . "~/Documents/research/bibliography/notes.org::#%s")
          ("papers" . "~/Documents/research/bibliography/pdf/%s.pdf")))

  (add-hook 'org-mode-hook 'org-mode-reftex-setup)

  (defun org-mode-reftex-search ()
    ;;jump to the notes for the paper pointed to at from reftex search
    (interactive)
    (org-open-link-from-string (format "[[notes:%s]]" (first (reftex-citation t)))))

; see ebib manual
  (org-add-link-type "ebib" 'ebib)


;; -------------

;;; Org Mode

  (add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
  (require 'org)
  (setq org-hide-leading-stars nil)
  (setq org-startup-indented t)
  (setq org-cycle-separator-lines 0)
  (setq org-blank-before-new-entry (quote ((heading)
					   (plain-list-item . auto))))
  (setq org-deadline-warning-days 30)

;; Standard key bindings
  (global-set-key "\C-cl" 'org-store-link)
  (global-set-key "\C-ca" 'org-agenda)
  (global-set-key "\C-cb" 'org-iswitchb)

  (setq org-agenda-files (quote ("~/Documents/research/orgfiles/refile.org"
				 "~/Documents/research/orgfiles/todo.org")))

  (defun refileFile ()
    (interactive)
    (find-file "~/Documents/research/orgfiles/refile.org")
  )
  (global-set-key (kbd "C-c g") 'refileFile)

  (setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))

  (setq org-todo-keyword-faces
      (quote (("TODO" :foreground "firebrick" :weight bold)
              ("NEXT" :foreground "DeepSkyBlue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "MediumSlateBlue" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))

  (setq org-use-fast-todo-selection t)
  (setq org-complete-tags-always-offer-all-agenda-tags t)

  (setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t))
              ("HOLD" ("WAITING") ("HOLD" . t))
              (done ("WAITING") ("HOLD"))
              ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
              ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
              ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

  (setq org-directory "~/Documents/research/orgfiles")
  (setq org-default-notes-file "~/Documents/research/orgfiles/refile.org")

;; I use C-c c to start capture mode
  (global-set-key (kbd "C-c c") 'org-capture)

;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
; check: http://orgmode.org/manual/Template-expansion.html
  (setq org-capture-templates
      (quote (("t" "todo" entry (file "~/Documents/research/orgfiles/refile.org")
               "* TODO %?\n%U")
              ("r" "respond" entry (file "~/Documents/research/orgfiles/refile.org")
               "* NEXT Respond to %?\n%U")
              ("n" "note" entry (file "~/Documents/research/orgfiles/refile.org")
               "* %? :NOTE:\n%U")
              ("w" "review" entry (file "~/Documents/research/orgfiles/refile.org")
               "* TODO Review %? :REVIEW:\n%U\n%a")
              ("m" "Meeting" entry (file "~/Documents/research/orgfiles/refile.org")
               "* MEETING with %? :MEETING:\n%U")
              ("p" "Phone call" entry (file "~/Documents/research/orgfiles/refile.org")
               "* PHONE %? :PHONE:\n%U"))))

; Targets include this file and any file contributing to the agenda - up to 9 levels deep
  (setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

; Use full outline paths for refile targets - we file directly with IDO
  (setq org-refile-use-outline-path t)

; Targets complete directly with IDO
  (setq org-outline-path-complete-in-steps nil)

; Allow refile to create parent tasks with confirmation
  (setq org-refile-allow-creating-parent-nodes (quote confirm))

; Use IDO for both buffer and file completion and ido-everywhere to t
  (setq org-completion-use-ido t)
  (setq ido-everywhere t)
  (setq ido-max-directory-size 100000)
  (ido-mode (quote both))

; Use the current window when visiting files and buffers with ido
  (setq ido-default-file-method 'selected-window)
  (setq ido-default-buffer-method 'selected-window)

; Use the current window for indirect buffer display
  (setq org-indirect-buffer-display 'current-window)

;; Do not dim blocked tasks
  (setq org-agenda-dim-blocked-tasks nil)

;; Compact the block agenda view
  (setq org-agenda-compact-blocks t)

;; Custom agenda command definitions
  (setq org-agenda-custom-commands
      (quote (("N" "Notes" tags "NOTE"
               ((org-agenda-overriding-header "Notes")
                (org-tags-match-list-sublevels t)))
              ("h" "Habits" tags-todo "STYLE=\"habit\""
               ((org-agenda-overriding-header "Habits")
                (org-agenda-sorting-strategy
                 '(todo-state-down effort-up category-keep))))
              ("z" "Agenda"
               ((agenda "" nil)
                (tags "REFILE"
                      ((org-agenda-overriding-header "Tasks to Refile")
                       (org-tags-match-list-sublevels nil)))
                (tags-todo "-CANCELLED/!"
                           ((org-agenda-overriding-header "Stuck Projects")
                            (org-agenda-skip-function 'bh/skip-non-stuck-projects)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-HOLD-CANCELLED/!"
                           ((org-agenda-overriding-header "Projects")
                            (org-agenda-skip-function 'bh/skip-non-projects)
                            (org-tags-match-list-sublevels 'indented)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-CANCELLED/!NEXT"
                           ((org-agenda-overriding-header (concat "Project Next Tasks"
                                                                  (if bh/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
                            (org-tags-match-list-sublevels t)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                             '(todo-state-down effort-up category-keep))))
                (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                           ((org-agenda-overriding-header (concat "Project Subtasks"
                                                                  (if bh/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'bh/skip-non-project-tasks)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                           ((org-agenda-overriding-header (concat "Standalone Tasks"
                                                                  (if bh/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'bh/skip-project-tasks)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-CANCELLED+WAITING|HOLD/!"
                           ((org-agenda-overriding-header (concat "Waiting and Postponed Tasks"
                                                                  (if bh/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'bh/skip-non-tasks)
                            (org-tags-match-list-sublevels nil)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)))
                (tags "-REFILE/"
                      ((org-agenda-overriding-header "Tasks to Archive")
                       (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
                       (org-tags-match-list-sublevels nil))))
               nil))))

;; ___________________________________________________________________
;;
;; MARKDOWN-MODE
;; ___________________________________________________________________

; Associate file endings with md mode
  (load-library "reftex")
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
; Make md and reftex work together
  (add-hook 'markdown-mode-hook 'turn-on-reftex)
; generate the markdown ref style
  (eval-after-load 'reftex-vars
    '(progn
       (setq reftex-cite-format '((?\C-m . "[@%l]")))))

  (setq reftex-default-bibliography '("~/Documents/research/bibliography/roschu.bib"))

;; ___________________________________________________________________
;;
;; Bibtex
;; ___________________________________________________________________

; Customize bibtex entry format and key generation
  (setq bibtex-align-at-equal-sign t
	bibtex-autokey-name-year-separator ""
	bibtex-autokey-year-title-separator ""
	bibtex-autokey-titleword-first-ignore '("the" "a" "if" "and" "an")
	bibtex-autokey-titleword-length 30
	bibtex-autokey-titlewords 1)

;; ___________________________________________________________________
;;
;; Latex
;; ___________________________________________________________________

  (require 'preview)
; from http://tex.stackexchange.com/questions/52179/what-is-your-favorite-emacs-and-or-auctex-command-trick
  (add-hook 'TeX-mode-hook
	    (lambda () (TeX-fold-mode 1))); Automatically activate TeX-fold-mode.
; insert key in latex document from ebib (code from ebib manual)
  (add-hook 'LaTeX-mode-hook #'(lambda ()
				 (local-set-key "\C-cb" 'ebib-insert-bibtex-key)))




;; ___________________________________________________________________
;;
;; RESOURCES
;; ___________________________________________________________________

;; org mode reftex etc
; http://tincman.wordpress.com/2011/01/04/research-paper-management-with-emacs-org-mode-and-reftex/

;; org mode workflow
; http://doc.norang.ca/org-mode.html

;; general .emacs
; http://www.aaronbedra.com/emacs.d/

;; Bibtex
; http://jblevins.org/log/bibtex

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;                      T   H   E          E   N   D
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("3a727bdc09a7a141e58925258b6e873c65ccf393b2240c51553098ca93957723" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" default)))
 '(org-agenda-files
   (quote
    ("~/Documents/research/publications/unsorted/emacs_stuff/emacs_cs.org" "~/Documents/research/orgfiles/refile.org" "~/Documents/research/orgfiles/todo.org"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
