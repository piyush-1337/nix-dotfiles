;;; init.el -*- lexical-binding: t; -*-

(setq inhibit-startup-message t)

(setq custom-file (expand-file-name "emacs/custom.el" (or (getenv "XDG_STATE_HOME") "~/.local/state")))
(when (file-exists-p custom-file)
  (load custom-file :nomessage))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

(require 'init-core)
(require 'init-evil)
(require 'init-ui)
(require 'init-completion)
(require 'init-corfu)
(require 'init-dev)
(require 'init-tools)
(require 'init-dired)
(require 'init-git)
