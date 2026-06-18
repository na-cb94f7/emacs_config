;;; arni-programming
;;; sly
(use-package sly)

;;; python-mode
;;; hooks
(add-hook 'inferior-python-mode-hook
	  '(lambda () (define-key inferior-python-mode-map (kbd "C-c C-h") 'python-eldoc-at-point)))

(add-hook 'python-mode-hook
	  '(lambda () (define-key python-mode-map (kbd "C-c C-h") 'python-eldoc-at-point)))

(add-hook 'python-mode-hook 'whitespace-mode)

(eval-after-load 'autoinsert
'(define-auto-insert '("\\.c\\'" . "C skeleton")
   '(
     "Short description: "
     "/*\n "
     (file-name-nondirectory (buffer-file-name))
     " -- " str \n
     "Written on " (format-time-string "%A, %e %B %Y.") \n
     " */" > \n \n
     "#include <stdio.h>" \n
     "#include \""
     (file-name-sans-extension
      (file-name-nondirectory (buffer-file-name)))
     ".h\"" \n \n
     "int main(void)" \n
     "{" > \n
     > _ \n
     "return 0;" > \n
     "}" > \n)))

;;; outline-mode
(use-package outline
  :config
  (setq outline-minor-mode-cycle t
	outline-minor-mode-cycle-filter t
	outline-blank-line t
	outline-default-state t
	outline-minor-mode-use-buttons nil)
  ;; look into outline-minor-mode-highlight to underline headings ?
  :bind (:map outline-minor-mode-map
	      ("M-h" . outline-mark-subtree)
	      ("C-c C-u" . outline-up-heading)
	      ("C-c C-b" . outline-backward-same-level)
	      ("C-c C-f" . outline-forward-same-level)
	      ("C-c C-p" . outline-previous-visible-heading)
	      ("C-c C-n" . outline-next-visible-heading)
	      ("C-c C-j" . consult-imenu))
  :hook
  (prog-mode . outline-minor-mode))
