;;; init-completion.el -*- lexical-binding: t; -*-

(use-package which-key
  :ensure nil
  :init
  (which-key-mode 1)
  :custom
  (which-key-idle-delay 0.4))

(use-package vertico
  :init
  (vertico-mode 1)
  :custom
  (vertico-cycle t)
  (vertico-count 12)
  :bind (:map vertico-map
	      ("C-j" . vertico-next)
	      ("C-k" . vertico-previous)))

(use-package vertico-directory
  :after vertico
  :ensure nil
  :bind (:map vertico-map
	      ("RET" . vertico-directory-enter)
	      ("DEL" . vertico-directory-delete-char))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package hotfuzz)

(use-package orderless
  :custom
  (completion-styles '(orderless hotfuzz basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles orderless hotfuzz partial-completion))
                                   (eglot-capf (styles orderless basic))))
  (orderless-matching-styles '(orderless-literal
			       orderless-regexp)))

(use-package marginalia
  :init
  (marginalia-mode 1))

(use-package consult
  :custom
  (consult-async-min-input 2)
  (xref-show-xrefs-function #'consult-xref)
  (xref-show-definitions-function #'consult-xref)
  :bind (("C-x b" . consult-buffer)
	 ("M-y" . consult-yank-pop)))

(provide 'init-completion)
