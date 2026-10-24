;;; init-dired.el -*- lexical-binding: t; -*-

(use-package dired
  :ensure nil
  :custom
  (dired-listing-switches "-lha --group-directories-first -v --time-style=long-iso")
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-dwim-target t)
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'always)
  (delete-by-moving-to-trash t)

  :hook
  (dired-mode . dired-hide-details-mode)
  (dired-mode . hl-line-mode))

(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package wdired
  :ensure nil
  :custom
  (wdired-allow-to-change-permissions t)
  (wdired-create-parent-directories t))

(evil-define-key '(normal visual motion) 'global
  (kbd "<leader> e")   #'dired-jump
  (kbd "<leader> E")   #'project-dired)

(provide 'init-dired)
