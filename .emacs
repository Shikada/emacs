(add-to-list 'default-frame-alist '(fullscreen . maximized))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(global-set-key [(C tab)] 'buffer-menu)
(setq ring-bell-function 'ignore)

(setq package-enable-at-startup nil)
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("12b4427ae6e0eef8b870b450e59e75122d5080016a9061c9696959e50d578057" "ac2b1fed9c0f0190045359327e963ddad250e131fbf332e80d371b2e1dbc1dc4" "ad950f1b1bf65682e390f3547d479fd35d8c66cafa2b8aa28179d78122faa947" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "cdbd0a803de328a4986659d799659939d13ec01da1f482d838b68038c1bb35e8" "4f5bb895d88b6fe6a983e63429f154b8d939b4a8c581956493783b2515e22d6d" "a0feb1322de9e26a4d209d1cfa236deaf64662bb604fa513cca6a057ddf0ef64" "04dd0236a367865e591927a3810f178e8d33c372ad5bfef48b5ce90d4b476481" "7153b82e50b6f7452b4519097f880d968a6eaf6f6ef38cc45a144958e553fbc6" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Don't show splash screen, emacs starts directly in scratch buffer
(setq inhibit-splash-screen t)

(load-theme 'sanityinc-tomorrow-night t)
(set-default-font "Consolas 12")

;; Activate Wind Move if available.
;; Allows moving between windows with shitft + arrow key
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; Activate Winner Mode
;; Allows to switch through window configurations with C-c left or right arrow
(when (fboundp 'winner-mode)
  (winner-mode 1))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))


(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
    (global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
    (global-set-key (kbd "S-C-<down>") 'shrink-window)
    (global-set-key (kbd "S-C-<up>") 'enlarge-window)

;; Always use truncated lines instead of line wraping
;; and set smoother horizontal scrolling
(set-default 'truncate-lines t)
(setq hscroll-margin 2)
(setq hscroll-step 20)

;; Smooth scrolling
(setq redisplay-dont-pause t
  scroll-margin 1
  scroll-step 1
  scroll-conservatively 10000
  scroll-preserve-screen-position 1
  mouse-wheel-progressive-speed nil)

;; Saves the clipboard before doing kill, so if you copy something
;; from another program and then kill something you can get it by
;; doing C-y and then M-y to cycle the kill ring to that entry
(setq save-interprogram-paste-before-kill t)

;; Opens emacs config file
(global-set-key (kbd "C-c c") (lambda() (interactive)(find-file user-init-file)))

(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))

(defun backward-delete-subword (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (subword-backward arg) (point))))

;; Make subword-mode work as expected when doing backward-delete-word (it doesn't implement it by default)
(require `subword)
(define-key subword-mode-map (kbd "C-<backspace>") `backward-delete-subword)

(global-set-key (kbd "C-<backspace>") ` backward-delete-word)
(global-set-key (kbd "M-<backspace>") `backward-kill-word)

(add-hook 'ruby-mode-hook (lambda () (local-set-key "\r" 'newline-an(setq inhibit-splash-screen t)d-indent)))

;; When at end of buffer going to next line (C-n) will add new lines
(setq next-line-add-newlines t)

;; Show file path in frame title
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
	    '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;; Normal (non-dired) search commands also limit themselves to file names only
(setq dired-isearch-filenames t)

;; Handle identation like Visual Studio does
;; Turn on subword-mode
(defun my-csharp-mode-hook ()
  (progn
    (setq tab-width 4
	  indent-tabs-mode nil)
    (subword-mode t)))

(add-hook 'csharp-mode-hook 'my-csharp-mode-hook)

;; Prevent emacs making backups and auto-save files everywhere by always
;; putting them all in a temp folder
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(defun split-window-right-with-select ()
  "Creates a new window to the right of the current one and switches focus to it."
  (interactive)
  (progn
    (split-window-right)
    (other-window 1)))

(global-set-key (kbd "C-x 3") `split-window-right-with-select)

(defun split-window-below-with-select ()
  "Creates a new window below the current one and switches focus to it."
  (interactive)
  (progn
    (split-window-below)
    (other-window 1)))

(global-set-key (kbd "C-x 2") `split-window-below-with-select)

;; Splits the root window, so it adds new windows in relation to all
;; already existing windows, in the desired direction, as well as
;; switching focus to the new window
(defun my-split-root-window (size direction)
  (progn
    (split-window (frame-root-window)
		  (and size (prefix-numeric-value size))
		  direction)
    (other-window 1)))

;; Useful when there are, for example, two vertical windows and we need a new
;; horizontal window that is above both of them
(defun my-split-root-window-below (&optional size)
  (interactive "P")
  (my-split-root-window size 'below))

(global-set-key (kbd "C-x M-2") `my-split-root-window-below)

;; Useful when there are, for example, two horizontal windows and we need a new
;; vertical window that is to the right of both of them
(defun my-split-root-window-right (&optional size)
  (interactive "P")
  (my-split-root-window size 'right))

(global-set-key (kbd "C-x M-3") `my-split-root-window-right)
