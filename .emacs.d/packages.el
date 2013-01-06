;; packages

(defvar
  my-packages
  '(evil
    anything
    nyan-mode rainbow-mode rainbow-delimiters
    erlang haskell-mode clojure-mode nrepl
	auto-complete
	magit ack
	minimap))

(require 'package)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

(when (not package-archive-contents) (package-refresh-contents))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(require 'erlang-start)
(add-hook 'erlang-mode-hook (lambda ()
							  (local-set-key [return] 'newline-and-indent)))

(require 'auto-complete-config)
(ac-config-default)
(ac-set-trigger-key "TAB")
(setq ac-auto-start nil)

(require 'minimap)

(provide 'packages)
