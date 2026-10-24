;;; init-tools.el -*- lexical-binding: t; -*-

(setq explicit-shell-file-name (executable-find "fish"))

(use-package eat
  :demand t
  :custom
  (eat-kill-buffer-on-exit t)
  (eat-enable-yank-to-terminal t)
  (eat-enable-shell-prompt-annotation nil)
  (eat-enable-shell-command-history nil)

  :hook
  (eat-mode . buffer-disable-undo)

  :config
  (keymap-set eat-semi-char-mode-map "C-h" #'evil-window-left)
  (keymap-set eat-semi-char-mode-map "C-j" #'evil-window-down)
  (keymap-set eat-semi-char-mode-map "C-k" #'evil-window-up)
  (keymap-set eat-semi-char-mode-map "C-l" #'evil-window-right)

  (evil-define-key '(normal visual motion) 'global
    (kbd "<leader> t t") #'eat
    (kbd "<leader> p t") #'eat-project))


(define-key evil-motion-state-map (kbd "C-h") #'evil-window-left)
(define-key evil-motion-state-map (kbd "C-j") #'evil-window-down)
(define-key evil-motion-state-map (kbd "C-k") #'evil-window-up)
(define-key evil-motion-state-map (kbd "C-l") #'evil-window-right)

(provide 'init-tools)
