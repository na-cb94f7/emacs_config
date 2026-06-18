;;; arni-literate-program.el
;; Setting the default safe variables

(custom-set-variables
 '(safe-local-variable-values
   '((eval add-hook 'after-save-hook #'org-odt-export-to-odt nil 'local)
     (eval add-hook 'after-save-hook (lambda nil (org-babel-tangle))
	   nil t))))
