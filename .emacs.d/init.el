;; emacs config
;; abandon all hope, ye who enter here

(setq dotfiles-dir (file-name-directory
                    (or (buffer-file-name) load-file-name)))
(add-to-list 'load-path dotfiles-dir)

(require 'funs)
(require 'packages)

;; keybindings

(when (eq system-type 'darwin)
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'meta))

(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

(global-set-key (kbd "M-n") 'new-frame)
(global-set-key (kbd "M-w") 'delete-frame)
(global-set-key (kbd "M-`") 'other-frame)

(global-set-key (kbd "C-w") 'my-backward-kill-word)
(global-set-key (kbd "<M-backspace>") 'my-backward-kill-word)
(global-set-key (kbd "C-;") 'kill-whole-line)
(global-set-key (kbd "C-'") (lambda () (interactive) (next-line) (join-line)))

(global-set-key (kbd "C-v") 'View-scroll-page-forward)
(global-set-key (kbd "M-v") 'View-scroll-page-backward)

(global-set-key (kbd "C-q") 'set-mark-command)
(global-set-key (kbd "C-x C-q") 'pop-global-mark)

(global-set-key (kbd "M-[") 'backward-paragraph)
(global-set-key (kbd "M-]") 'forward-paragraph)

(global-set-key (kbd "RET") 'newline-and-indent)

(global-set-key (kbd "M-z") 'undo)
(global-set-key (kbd "C-/") 'zap-to-char)

(global-set-key (kbd "M-3") 'split-window-horizontally) ; was digit-argument
(global-set-key (kbd "M-2") 'split-window-vertically) ; was digit-argument
(global-set-key (kbd "M-1") 'delete-other-windows) ; was digit-argument
(global-set-key (kbd "M-0") 'delete-window) ; was digit-argument
(global-set-key (kbd "M-o") 'other-window) ; was facemenu-keymap
(global-set-key (kbd "M-O") 'rotate-windows)

(add-hook 'dired-mode-hook (lambda () (define-key dired-mode-map (kbd "M-o") 'other-window))) ; was dired-omit-mode
(add-hook 'ibuffer-mode-hook (lambda () (define-key ibuffer-mode-map (kbd "M-o") 'other-window))) ; was ibuffer-visit-buffer-1-window

(global-set-key (kbd "C-x C-c") 'kill-this-buffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(defalias 'yes-or-no-p 'y-or-n-p)

;; look

(when window-system
  (set-frame-size (selected-frame) 148 44)
  (add-to-list 'default-frame-alist '(height . 44))
  (add-to-list 'default-frame-alist '(width . 148))

  (menu-bar-mode -1)
  (tooltip-mode -1)
  (mouse-wheel-mode t)
  (blink-cursor-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (setq frame-title-format (list "emacs - "  '(buffer-file-name "%f" "%b")))
  (setq icon-title-format frame-title-format)
  (load-theme 'naquadah t)
  (global-hl-line-mode 1)

  (load "server")
  (unless (server-running-p) (server-start)))

;; settings

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(ansi-color-for-comint-mode-on)

(setq
 visible-bell t
 echo-keystrokes 0.1
										;font-lock-maximum-decoration t
 inhibit-startup-message t
 transient-mark-mode t
 color-theme-is-global t
 shift-select-mode nil
 mouse-yank-at-point t
 kill-whole-line t
 require-final-newline t
 truncate-partial-width-windows nil
 uniquify-buffer-name-style 'forward
 whitespace-style '(trailing lines space-before-tab indentation space-after-tab)
 whitespace-line-column 100
 ediff-window-setup-function 'ediff-setup-windows-plain
 
 xterm-mouse-mode t
 x-select-enable-clipboard t
 custom-safe-themes t
 ring-bell-function 'ignore

 delete-old-versions t

 ;; scroll two lines at a time (less "jumpy" than defaults)
;mouse-wheel-scroll-amount '(2 ((shift) . 2)) ;; one line at a time  
;mouse-wheel-progressive-speed nil ;; don't accelerate scrolling
;mouse-wheel-follow-mouse t ;; scroll window under mouse
 scroll-step 1 ;; keyboard scroll one line at a time
; redisplay-dont-pause t
 scroll-margin 5
; scroll-conservatively 10000
;next-screen-context-lines 15
 which-function-mode t
 )

(setq-default
 major-mode 'text-mode          ;; default mode
 case-fold-search t             ;; case INsensitive search
;indent-tabs-mode nil           ;; do not use tabs for indentation
 fill-column 80                 ;; number of chars in line
 c-basic-offset 8               ;; indent C code
 sgml-basic-offset 2
 tab-width 4
 left-fringe-width 0            ;; no need for left fringe
 scroll-up-aggressively 0.01    ;; smooth scrolling
 scroll-down-aggressively 0.01)

(rainbow-mode t)
(rainbow-delimiters-mode t)
(ido-mode t)
(nyan-mode t)
