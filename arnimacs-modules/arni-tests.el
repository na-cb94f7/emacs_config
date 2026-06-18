;; lightweight avy replacement
(global-set-key (kbd "C-j")
	(lambda ()
	  (interactive)
	  (push-mark)
	  (isearch-resume "\\<" t nil t "\\<" t)))

(define-key isearch-mode-map (kbd "C-j") 'avy-isearch)
(use-package org
  :config
  (define-key org-mode-map (kbd "C-j")
	      (lambda ()
		(interactive)
		(push-mark)
		(isearch-resume "\\<" t nil t "\\<" t)))
  ;; reverse
  (define-key org-mode-map (kbd "C-S-j")
	      (lambda ()
  		(interactive)
		(push-mark)
  		(isearch-resume "\\<" t nil nil "\\<" t))))

;; reverse
(global-set-key (kbd "C-S-j")
	(lambda ()
	  (interactive)
	  (push-mark)
	  (isearch-resume "\\<" t nil nil "\\<" t)))
