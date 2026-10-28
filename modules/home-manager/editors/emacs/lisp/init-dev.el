;;; init-dev.el -*- lexical-binding: t; -*-

(use-package envrc
  :hook (after-init . envrc-global-mode))

(use-package project
  :ensure nil
  :custom
  (project-switch-commands #'project-find-file)

  :config
  (when (file-directory-p "~/dev/projects/")
    (project-remember-projects-under "~/dev/projects/")))

(add-to-list 'trusted-content "~/dev/")
(add-to-list 'trusted-content "/etc/nixos-dotfiles/")

(use-package flymake
  :ensure nil
  :custom
  (flymake-show-diagnostics-at-end-of-line 'short)
  (flymake-suppress-zero-counters t))

(use-package eglot
  :ensure nil
  :custom
  (eglot-autoshutdown t)
  (eglot-cache-session-completions nil)
  (eglot-send-changes-idle-time 0.1)
  :config
  (setq eglot-events-buffer-config '(:size 0)
        jit-lock-context-time 0.1)
  (add-to-list 'eglot-server-programs '(nix-mode . ("nixd")))
  (add-to-list 'eglot-server-programs '((c-mode c-ts-mode c++-mode c++-ts-mode) . ("clangd" "--experimental-modules-support"))))

(with-eval-after-load 'cape
  (advice-add #'eglot-completion-at-point :around #'cape-wrap-buster)
  (advice-add #'eglot-completion-at-point :around #'cape-wrap-noninterruptible))

(add-hook 'eglot-managed-mode-hook
          (lambda ()
            (setq-local completion-at-point-functions
                        (list #'eglot-completion-at-point
                              #'cape-file))
            (setq-local eldoc-documentation-functions
                        (cons #'eglot-signature-eldoc-function
                              (remove #'eglot-signature-eldoc-function eldoc-documentation-functions)))))

(defun my/eldoc-message-command-p-a (orig-fn command)
  "Allow ElDoc messages during insert mode and for Evil/electric commands."
  (or (and (bound-and-true-p evil-mode)
           (evil-insert-state-p))
      (and (symbolp command)
           (let ((name (symbol-name command)))
             (or (string-prefix-p "evil-" name)
                 (string-prefix-p "c-electric-" name))))
      (funcall orig-fn command)))

(with-eval-after-load 'eldoc
  (advice-add #'eldoc--message-command-p :around #'my/eldoc-message-command-p-a)
  (eldoc-add-command-completions "evil-"))

(with-eval-after-load 'corfu
  (advice-remove #'eldoc-display-message-no-interference-p #'corfu--eldoc-advice))

(defun my/eldoc-doc-buffer-focus-a (&optional interactive)
  "Focus the ElDoc documentation window when opened interactively."
  (when interactive
    (when-let* ((win (and (bound-and-true-p eldoc--doc-buffer)
                          (buffer-live-p eldoc--doc-buffer)
                          (get-buffer-window eldoc--doc-buffer))))
      (select-window win))))

(advice-add #'eldoc-doc-buffer :after #'my/eldoc-doc-buffer-focus-a)

(defun my/eldoc-doc-and-focus ()
  "Open ElDoc documentation and jump focus directly into that window."
  (interactive)
  (eldoc-print-current-symbol-info)
  (eldoc-doc-buffer t)
  (when-let* ((win (and (bound-and-true-p eldoc--doc-buffer)
                        (buffer-live-p eldoc--doc-buffer)
                        (get-buffer-window eldoc--doc-buffer))))
    (select-window win)))

(evil-define-key 'normal 'global (kbd "K") #'my/eldoc-doc-and-focus)
(with-eval-after-load 'eglot
  (evil-define-key 'normal eglot-mode-map (kbd "K") #'my/eldoc-doc-and-focus))
(with-eval-after-load 'evil-collection-eglot
  (evil-collection-define-key 'normal 'eglot-mode-map (kbd "K") #'my/eldoc-doc-and-focus))

(use-package nix-mode
  :mode "\\.nix\\'"
  :hook (nix-mode . eglot-ensure))

(use-package rust-mode
  :mode "\\.rs\\'"
  :hook (rust-mode . eglot-ensure))

(use-package markdown-mode
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :custom
  (markdown-hide-markup t)
  (markdown-fontify-code-blocks-natively t)
  (markdown-header-scaling t)
  (markdown-header-scaling-values '(1.4 1.25 1.15 1.05 1.0 1.0))
  (markdown-enable-math t)
  (markdown-list-indent-width 2)
  :config
  (set-face-attribute 'markdown-code-face nil :background "#1a1a20" :extend t)
  (evil-define-key 'normal markdown-mode-map
    (kbd "<leader> m h") #'markdown-toggle-markup-hiding
    (kbd "<leader> m i") #'markdown-toggle-inline-images)
  (evil-define-key 'normal gfm-mode-map
    (kbd "<leader> m h") #'markdown-toggle-markup-hiding
    (kbd "<leader> m i") #'markdown-toggle-inline-images))

(add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
(add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
(add-to-list 'major-mode-remap-alist '(c-or-c++-mode . c-or-c++-ts-mode))

(dolist (hook '(c-mode-hook c++-mode-hook c-ts-mode-hook c++-ts-mode-hook))
  (add-hook hook #'eglot-ensure))

(add-to-list 'auto-mode-alist '("\\.\\(cppm\\|cxxm\\|ixx\\)\\'" . c++-ts-mode))

(defun my/eglot-code-actions-always-prompt ()
  "Show the code actions menu even if there is only one candidate."
  (interactive)
  (let ((eglot--suggestion-overlay nil))
    (call-interactively #'eglot-code-actions)))

(setq compilation-scroll-output t
      compilation-always-kill t)

(evil-define-key '(normal visual motion) 'global
  (kbd "<leader> c f") #'eglot-format-buffer
  (kbd "<leader> c a") #'my/eglot-code-actions-always-prompt
  (kbd "<leader> r n") #'eglot-rename
  (kbd "<leader> c d") #'consult-flymake
  (kbd "<leader> c c") #'project-compile
  (kbd "<leader> c r") #'recompile
  "[d"                 #'flymake-goto-prev-error
  "]d"                 #'flymake-goto-next-error)

(setq eglot-ignored-server-capabilities '(:documentOnTypeFormattingProvider))


(provide 'init-dev)
