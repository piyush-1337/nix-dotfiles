;;; early-init.el -*- lexical-binding: t; -*-

(setq package-user-dir (expand-file-name "emacs/elpa" (or (getenv "XDG_DATA_HOME") "~/.local/share")))

(when (and (fboundp 'startup-redirect-eln-cache)
           (fboundp 'native-comp-available-p)
           (native-comp-available-p))
  (startup-redirect-eln-cache (expand-file-name "emacs/eln-cache" (or (getenv "XDG_CACHE_HOME") "~/.cache"))))

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(defvar default-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
	  (lambda ()
	    (setq gc-cons-threshold (* 16 1024 1024)
		  gc-cons-percentage 0.1
		  file-name-handler-alist default-file-name-handler-alist)))

(setq native-comp-async-report-warnings-errors 'silent)

(when (boundp 'pgtk-wait-for-event-timeout)
  (setq pgtk-wait-for-event-timeout 0.001))

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)

(setq inhibit-startup-message t
      inhibit-startup-echo-area-message user-login-name
      inhibit-splash-screen t)
