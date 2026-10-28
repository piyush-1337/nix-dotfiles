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
   (majutsu-refresh-buffer-hook . diff-hl-update)
   (evil-insert-state-exit . diff-hl-flydiff-update))

  :config
  (evil-define-key '(normal visual motion) 'global
    "]c"                 #'diff-hl-next-hunk
    "[c"                 #'diff-hl-previous-hunk
    (kbd "<leader> g p") #'diff-hl-show-hunk
    (kbd "<leader> g R") #'diff-hl-revert-hunk))

(use-package majutsu
  :vc (:url "https://github.com/0WD0/majutsu")
  :commands (majutsu
             majutsu-diff-dwim
             majutsu-log
             majutsu-describe
             majutsu-new
             majutsu-bookmark
             majutsu-squash
             majutsu-rebase
             majutsu-undo
             majutsu-evolog
             majutsu-git-push
             majutsu-git-fetch)
  :custom
  (magit-section-initial-visibility-alist '((jj-file . hide)
                                           (file . hide)
                                           (stashes . hide)))
  :init
  (evil-define-key '(normal visual motion) 'global
    (kbd "<leader> g g") #'majutsu
    (kbd "<leader> g d") #'majutsu-diff-dwim
    (kbd "<leader> g c") #'majutsu-describe
    (kbd "<leader> g n") #'majutsu-new
    (kbd "<leader> g l") #'majutsu-log
    (kbd "<leader> g b") #'majutsu-bookmark
    (kbd "<leader> g s") #'majutsu-squash
    (kbd "<leader> g r") #'majutsu-rebase
    (kbd "<leader> g u") #'majutsu-undo
    (kbd "<leader> g e") #'majutsu-evolog
    (kbd "<leader> g P") #'majutsu-git-push
    (kbd "<leader> g F") #'majutsu-git-fetch)
  :config
  (majutsu-evil-setup))

(provide 'init-git)
