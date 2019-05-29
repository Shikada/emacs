;; Opens emacs config file
(global-set-key (kbd "C-c c") (lambda() (interactive)(find-file user-init-file)))

;; This will be changed frequently and depending on machine
(setq default-directory "D:/repos/")

;; Adding some thing to PATH is necessary in Windows for some functionality to work
(setenv "PATH"
	(concat
	 ;; Change this with your path to MSYS bin directory
	 "C:\\Users\\o.munjin\\.babun\\cygwin\\bin;" ;; this fixed find command not working (for example when using find-name-dired)
	 (getenv "PATH")))

;; Add melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(package-initialize)
;; If a specific version of a package fails to load then probably newer descriptions need to be downloaded on this machine.
;; This usually happens when transfering configuration between machines. When emacs start it might fail to download missing packages.
;; This is a known issue with package.el and there are work arounds, but it would be better to switch to an alternative package manager.
;; In the meantime, try running package-refresh-contents and restaring Emacs.

;; Bootstrap `use-package'
;; This is the only package we install manually like this, all other will be installed using use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Always ensure packages listed with use-package are installed
;; Each package can use ":ensure nil" option do override this
;; Such packages then need to be installed manually
(setq use-package-always-ensure t)

;; Some basic configuration
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(global-set-key [(C-S-tab)] 'buffer-menu)
(global-set-key [(C-tab)] 'other-window)
(setq ring-bell-function 'ignore)
(global-set-key [(?\M-p)] 'scroll-down-line)
(global-set-key [(?\M-n)] 'scroll-up-line)
(set-default-font "Consolas 12")
(electric-pair-mode t)
(show-paren-mode t)
(global-set-key (kbd "C-c .") `xref-find-definitions-other-window)
(delete-selection-mode t)

;; Need to override keybinding in cc-mode, since it sets it to c-set-style
(require `cc-mode)
(define-key c-mode-map (kbd "C-c .") `xref-find-definitions-other-window)
(global-display-line-numbers-mode t)
(global-set-key (kbd "C-S-s") `isearch-forward-symbol-at-point)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("12b4427ae6e0eef8b870b450e59e75122d5080016a9061c9696959e50d578057" "ac2b1fed9c0f0190045359327e963ddad250e131fbf332e80d371b2e1dbc1dc4" "ad950f1b1bf65682e390f3547d479fd35d8c66cafa2b8aa28179d78122faa947" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "cdbd0a803de328a4986659d799659939d13ec01da1f482d838b68038c1bb35e8" "4f5bb895d88b6fe6a983e63429f154b8d939b4a8c581956493783b2515e22d6d" "a0feb1322de9e26a4d209d1cfa236deaf64662bb604fa513cca6a057ddf0ef64" "04dd0236a367865e591927a3810f178e8d33c372ad5bfef48b5ce90d4b476481" "7153b82e50b6f7452b4519097f880d968a6eaf6f6ef38cc45a144958e553fbc6" default)))
 '(package-selected-packages
   (quote
    (company-lsp company company-mode yasnippet lsp-mode lsp-mode-ui elixir-mode csharp-mod inf-ruby json-mode counsel csharp-mode doom-themes haskell-mode magit swiper ivy paren-face aggressive-indent aggressive-indent-mode paredit use-package color-theme-sanityinc-tomorrow))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Don't show splash screen, emacs starts directly in scratch buffer
(setq inhibit-splash-screen t)

;; revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; highlight the current line
(global-hl-line-mode +1)

(use-package color-theme-sanityinc-tomorrow)

(use-package doom-themes
  :preface
  (defvar region-fg nil) ; see https://github.com/hlissner/emacs-doom-themes/issues/166
  :init
  (load-theme 'doom-vibrant t))

;; Handle identation like Visual Studio does
;; Turn on subword-mode
(defun my-csharp-mode-hook ()
  (progn
    (setq tab-width 4
	  indent-tabs-mode nil)
    (subword-mode t)
    (define-key csharp-mode-map (kbd "C-d") `duplicate-line)))

(use-package csharp-mode
  :config
  (add-hook 'csharp-mode-hook 'my-csharp-mode-hook))

(use-package ruby-mode
  :config
  (add-hook 'ruby-mode-hook (lambda () (local-set-key "\r" 'newline-and-indent))))

(use-package inf-ruby)

(use-package magit
  :bind ("C-x g" . magit-status)) ;; have to use bind here because autoloading magit take 3-4 seconds, so it slows down emacs init a lot without bind

(use-package paredit 
  :config
  (add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
  (add-hook 'ielm-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
  (add-hook 'scheme-mode-hook           #'enable-paredit-mode)
  (define-key paredit-mode-map (kbd "M-SPC") 'paredit-open-round))

(use-package aggressive-indent
  :config
  (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
  (add-hook 'ielm-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
  (add-hook 'scheme-mode-hook           #'enable-paredit-mode)
  (put 'paredit-backward-delete 'delete-selection 'supersede)
  (put 'paredit-forward-delete 'delete-selection 'supersede))

(use-package paren-face
  :config
  (global-paren-face-mode t))

(use-package ivy
  :config
  (ivy-mode t)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t))

(use-package counsel
  :config (counsel-mode t))

(use-package swiper
  :bind ("C-s" . swiper))

(use-package haskell-mode)

(use-package json-mode)

(use-package elixir-mode)

(use-package yasnippet)

(use-package lsp-mode
  :bind ("C-c h" . lsp-describe-thing-at-point)
  :commands lsp
  :ensure t
  :diminish lsp-mode
  :hook
  (elixir-mode . lsp)
  :init
  (add-to-list 'exec-path "D:/repos/elixir-ls/release")
  (setq lsp-ui-doc-enable nil))

(use-package company)

(use-package company-lsp
  :bind
  ("M-SPC" . company-complete)
  :config
  (push 'company-lsp company-backends)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1))

;; Activate Wind Move if available.
;; Allows moving between windows with shitft + arrow key
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; Activate Winner Mode
;; Allows to switch through window configurations with C-c left or right arrow
(when (fboundp 'winner-mode)
  (winner-mode 1))

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

;; Define this command to use instead of backwawrd-kill-word.
;; Difference is it doesn't copy anything to the kill-ring.
(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (forward-same-syntax (- arg)) (point))))

;; Same as backward-delete-word but for use in subword-mode and without
;; -same-syntax as subword doesn't have an equivalent.
(defun backward-delete-subword (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (subword-backward arg) (point))))

;; Make subword-mode work like backward-delete-word (it doesn't implement it by default)
(require `subword)
(define-key subword-mode-map (kbd "C-S-<backspace>") `backward-delete-subword)

(global-set-key (kbd "C-<backspace>") `backward-delete-word)
(global-set-key (kbd "M-<backspace>") `backward-kill-word)

;; When at end of buffer going to next line (C-n) will add new lines
(setq next-line-add-newlines t)

;; Show file path in frame title
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
	    '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;; Normal (non-dired) search commands also limit themselves to file names only
(setq dired-isearch-filenames t)

(setq omnisharp-server-executable-path "D://GitRepo//omnisharp-roslyn//artifacts//publish//OmniSharp//default//net451//")

;; Prevent emacs from making backups and auto-save files everywhere by always
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
;; making all windows balanced and switching focus to the new window
(defun my-split-root-window (size direction)
  (let ((new-window (split-window (frame-root-window)
				  (and size (prefix-numeric-value size))
				  direction)))
    (balance-windows-area)
    (select-window new-window)))

;; Useful when there are, for example, two vertical windows and we need a new
;; horizontal window that is below both of them
(defun my-split-root-window-below (&optional size)
  "Create a new window below all current windows."
  (interactive "P")
  (my-split-root-window size 'below))

(global-set-key (kbd "C-x M-2") `my-split-root-window-below)

;; Useful when there are, for example, two horizontal windows and we need a new
;; vertical window that is to the right of both of them
(defun my-split-root-window-right (&optional size)
  "Create a new window to the left of all current windows."
  (interactive "P")
  (my-split-root-window size 'right))

(global-set-key (kbd "C-x M-3") `my-split-root-window-right)

;; Very useful for actions that create buffers in another window. Usually you would
;; have to switch to it in order to quit it (usually by pressing 'q'). This is just
;; a shortcut for those two actions
(defun quit-other-window ()
  "Switch to other window and quit that window."
  (interactive)
  (other-window 1)
  (quit-window))

(global-set-key (kbd "C-x K") `quit-other-window)

(require `xref)

(defun xref-goto-xref-same-window ()
  "Jump to the xref on the current line while staying on the same window."
  (interactive)
  (let ((xref (xref--item-at-point)))
    (xref--pop-to-location xref)))

(define-key xref--button-map (kbd "C-m") `xref-goto-xref-same-window)
(define-key xref--xref-buffer-mode-map (kbd "<C-return>") `xref-goto-xref)

(defun recompile-packages ()
  "Recompiles everything in emacs.d/elpa folder."
  (interactive)
  (byte-recompile-directory package-user-dir nil 'force))

(defun duplicate-line ()
  "Insert a copy of the current line directly below it."
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (newline)
  (yank))

(global-set-key (kbd "C-c C-d") `duplicate-line)
