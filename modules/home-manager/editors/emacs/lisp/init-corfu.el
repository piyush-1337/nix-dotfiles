;;; init-corfu.el -*- lexical-binding: t; -*-

(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 2)
  (corfu-quit-at-boundary 'separator)
  (corfu-quit-no-match 'separator)
  (corfu-preselect 'prompt)
  :bind (:map corfu-map
	      ("C-j" . corfu-next)
	      ("C-k" . corfu-previous)
	      ("<escape>" . corfu-quit))
  :init
  (global-corfu-mode 1)
  :config
  (corfu-popupinfo-mode 1)
  (setq corfu-popupinfo-delay '(0.25 . 0.1)))

(use-package nerd-icons-corfu
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

(use-package yasnippet
  :config
  (yas-global-mode 1))

(provide 'init-corfu)
