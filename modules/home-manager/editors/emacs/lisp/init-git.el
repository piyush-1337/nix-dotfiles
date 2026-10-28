;;; init-git.el -*- lexical-binding: t; -*-

(use-package diff-hl
  :custom
  (diff-hl-flydiff-delay 0.1)
  (diff-hl-update-async t)
  :init
  (global-diff-hl-mode 1)
  (diff-hl-flydiff-mode 1)

  :hook
  ((dired-mode . diff-hl-dired-mode)
   (magit-post-refresh . diff-hl-magit-post-refresh)
   (evil-insert-state-exit . diff-hl-flydiff-update))

  :config
  (evil-define-key '(normal visual motion) 'global
    "]c"                 #'diff-hl-next-hunk
    "[c"                 #'diff-hl-previous-hunk
    (kbd "<leader> g p") #'diff-hl-show-hunk
    (kbd "<leader> g r") #'diff-hl-revert-hunk
    (kbd "<leader> g s") #'diff-hl-stage-current-hunk))

(use-package magit
  :commands (magit-status magit-diff-working-tree)
  :custom
  (magit-section-invisible-alist '((file . hide)
				   (stashes . hide)))
  :init
  (evil-define-key '(normal visual motion) 'global
    (kbd "<leader> g d") #'magit-diff-working-tree
    (kbd "<leader> g g") #'magit-status))

(provide 'init-git)
