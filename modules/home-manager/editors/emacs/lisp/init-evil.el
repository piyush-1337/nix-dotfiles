;;; init-evil.el -*- lexical-binding: t; -*-

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-undo-system 'undo-redo)

  :config
  (evil-mode 1)

  (define-key evil-motion-state-map (kbd "H") #'evil-first-non-blank)
  (define-key evil-motion-state-map (kbd "L") #'evil-end-of-line)

  (evil-define-key 'normal 'global "gcc" #'comment-line)
  (evil-define-key 'visual 'global "gc"
    (lambda ()
      (interactive)
      (call-interactively #'comment-line)
      (evil-normal-state)))

  (define-key evil-normal-state-map (kbd "C-s") #'save-buffer)
  (define-key evil-insert-state-map (kbd "C-s") #'save-buffer)
  (define-key evil-visual-state-map (kbd "C-s") #'save-buffer)
  (global-set-key (kbd "C-s") #'save-buffer)

  (evil-set-leader '(normal visual motion) (kbd "SPC"))
  (evil-define-key '(normal visual motion) 'global
    (kbd "<leader> SPC") #'project-find-file
    (kbd "<leader> ,")   #'consult-buffer
    (kbd "<leader> s b") #'consult-line
    (kbd "<leader> s g") #'consult-ripgrep

    (kbd "<leader> p p") #'project-switch-project
    (kbd "<leader> p f") #'project-find-file
    (kbd "<leader> p d") #'project-dired))


(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))


(use-package evil-escape
  :init
  (setq-default evil-escape-key-sequence "jk")
  (setq-default evil-escape-delay 0.15)
  (setq-default evil-escape-excluded-states '(visual))
  (setq evil-escape-excluded-major-modes '(eat-mode
                                           term-mode
                                           vterm-mode
                                           eshell-mode))
  :config
  (add-hook 'evil-escape-inhibit-functions #'evil-escape--is-magit-buffer)
  (evil-escape-mode 1))


(provide 'init-evil)
