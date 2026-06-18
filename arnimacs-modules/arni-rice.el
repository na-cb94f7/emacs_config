;;; arni-rice
;;; modus-themes
;; use-package declaration
(use-package modus-themes
  :config
  (setq modus-operandi-palette-overrides ;; https://protesilaos.com/emacs/modus-themes#h:34c7a691-19bb-4037-8d2f-67a07edab150
	'((comment red-faint))))

;; Conditional to apply the theme
(if (daemonp) 
    (add-hook 'after-make-frame-functions 
   	      (lambda (frame) 
   		(with-selected-frame frame (load-theme 'modus-operandi t))))
  (load-theme 'modus-operandi t))

;;; default-frame-alist
(setq default-frame-alist
      '((font . "Atkinson Hyperlegible Mono")
	(vertical-scroll-bars . nil)))

(use-package doom-modeline
  :init
  (setq doom-modeline-buffer-encoding nil
	doom-modeline-support-imenu t)
  (column-number-mode 1)
  :config
  (doom-modeline-mode 1))

(add-hook 'server-after-make-frame-hook
	  (lambda ()
		(set-face-attribute 'tab-bar nil :inherit 'fixed-pitch :background "Gray96" :underline '(:color "black" :style line :position t) :font "Atkinson Hyperlegible Next")
		(set-face-attribute 'tab-bar-tab nil :inherit 'tab-bar :box '(:line-width (6 . 4) :color "white") :overline "black" :background "white" :underline 'nil)
		(set-face-attribute 'tab-bar-tab-inactive nil :inherit '(shadow tab-bar-tab) :background "Gray96" :overline t :underline '(:color "black" :style line :position t))))

(setq tab-bar-separator 'nil)
(setq tab-bar-new-button-show nil)
(setq tab-bar-new-tab-choice "*scratch*")
(setq tab-bar-show t)
(setq tab-bar-format '(tab-bar-format-tabs tab-bar-separator tab-bar-format-align-right))
(defun tab-bar-tab-name-format-default (tab i)
  (let ((current-p (eq (car tab) 'current-tab)))
    (concat (propertize " " 'face `(:background "Black" )
			'display '(space :width (1)))
	    (propertize
	     (concat (if tab-bar-tab-hints (format "%d " i) "")
		     (alist-get 'name tab)
		     (or (and tab-bar-close-button-show
			      (not (eq tab-bar-close-button-show
				       (if current-p 'non-selected 'selected)))
			      tab-bar-close-button)
			 ""))
	     'face (funcall tab-bar-tab-face-function tab))
	    (propertize " " 'face `(:background "Black" )
			'display '(space :width (1))))))
(tab-bar-history-mode t)
(tab-bar-mode t)
