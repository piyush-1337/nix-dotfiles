;;; init-core.el -*- lexical-binding: t; -*-

(use-package no-littering
  :demand t
  :init
  (setq no-littering-var-directory (expand-file-name "emacs/var/" (or (getenv "XDG_STATE_HOME") "~/.local/state/"))
        no-littering-etc-directory (expand-file-name "emacs/etc/" (or (getenv "XDG_DATA_HOME") "~/.local/share/")))
  :config
  (no-littering-theme-backups)

  (let ((dir (no-littering-expand-var-file-name "lock-files/")))
    (make-directory dir t)
    (setq lock-file-name-transforms `((".*" ,dir t))))

  (setq backup-by-copying t
        delete-old-versions t
        kept-new-versions 5
        kept-old-versions 2
        version-control t)

  (with-eval-after-load 'recentf
    (add-to-list 'recentf-exclude (recentf-expand-file-name no-littering-var-directory))
    (add-to-list 'recentf-exclude (recentf-expand-file-name no-littering-etc-directory))))

(electric-pair-mode 1)
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

(savehist-mode 1)
(recentf-mode 1)
(save-place-mode 1)            

(setq use-short-answers t)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(setq eldoc-idle-delay 0.05
      eldoc-echo-area-use-multiline-p nil
      eldoc-echo-area-display-truncation-message nil)
(setq read-process-output-max (* 1024 1024))

(setq scroll-step 1
      scroll-conservatively 101
      scroll-margin 4
      hscroll-margin 8
      hscroll-step 1
      scroll-preserve-screen-position t
      auto-window-vscroll nil)

(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode 1))

(provide 'init-core)
