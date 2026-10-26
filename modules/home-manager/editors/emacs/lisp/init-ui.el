;;; init-ui.el -*- lexical-binding: t; -*-

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq ring-bell-function 'ignore)

(set-face-attribute 'default nil :family "Iosevka Nerd Font Mono" :height 160)
(add-to-list 'default-frame-alist '(font . "Iosevka Nerd Font Mono-16"))

(use-package nerd-icons)

(setq modus-themes-common-palette-overrides
      '((bg-mode-line-active bg-dim)
        (border-mode-line-active bg-dim)
        (bg-mode-line-inactive bg-main)
        (border-mode-line-inactive bg-main)))

(load-theme 'modus-vivendi t)

;; (use-package doom-themes
;;   :config
;;   (setq doom-themes-enable-bold t
;; 	doom-themes-enable-italic t)
;;   (load-theme 'doom-one t))

(setq display-buffer-alist
      `(;; Bottom drawer popups: 30% height, never overwrite main code windows
        ("\\`\\*\\(compilation\\|Help\\|Messages\\|Warnings\\|xref\\|eldoc.*\\)\\*.*"
         (display-buffer-reuse-mode-window display-buffer-at-bottom)
         (window-height . 0.3)
         (dedicated . t)
         (preserve-size . (nil . t)))))

(provide 'init-ui)
