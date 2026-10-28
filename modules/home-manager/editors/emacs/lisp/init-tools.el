;;; init-tools.el -*- lexical-binding: t; -*-

(defun my/project-vterm ()
  "Open or switch to a vterm buffer in the current project root."
  (interactive)
  (let* ((proj (project-current))
	 (default-directory (if proj (project-root proj) default-directory))
	 (buf-name (if proj (format "*vterm: %s*" (file-name-nondirectory  (directory-file-name default-directory))) "*vterm*")))
    (vterm buf-name)))

(use-package vterm
  :demand t
  :config
  (setq vterm-shell (executable-find "fish"))
  (evil-define-key '(normal visual motion) 'global
    (kbd "<leader> t t") #'vterm
    (kbd "<leader> p t") #'my/project-vterm))


(define-key evil-motion-state-map (kbd "C-h") #'evil-window-left)
(define-key evil-motion-state-map (kbd "C-j") #'evil-window-down)
(define-key evil-motion-state-map (kbd "C-k") #'evil-window-up)
(define-key evil-motion-state-map (kbd "C-l") #'evil-window-right)

(provide 'init-tools)
