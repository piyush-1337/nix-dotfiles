;;; init-ui.el -*- lexical-binding: t; -*-

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq ring-bell-function 'ignore)

(set-face-attribute 'default nil :family "Iosevka Nerd Font Mono" :height 160)
(add-to-list 'default-frame-alist '(font . "Iosevka Nerd Font Mono-16"))

(use-package nerd-icons)
(load-theme 'modus-vivendi t)

;; (use-package doom-themes
;;   :config
;;   (setq doom-themes-enable-bold t
;; 	doom-themes-enable-italic t)
;;   (load-theme 'doom-one t))

(provide 'init-ui)
