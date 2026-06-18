;;; arni-dired
;;; dired-preview
;; use-package declaration

(use-package dired-preview
  :init
  (setq dired-preview-delay 0.6
	  dired-preview-max-size (expt 2 20))
  (setq dired-preview-ignored-extensions-regexp
        (concat "\\."
                "\\(gz\\|"
                "zst\\|"
                "tar\\|"
                "xz\\|"
                "rar\\|"
                "zip\\|"
                "iso\\|"
		"AppImage\\|"
                "epub"
                "\\)"))
  :bind
  ("C-x M-p" . dired-preview-global-mode))

;;; dired
;; function definitions

(defun arni/diredpretties-hook()
  (dired-hide-details-mode 1)	;; Hiding details like file permissions
  (hl-line-mode 1) ;; line highlighted
  (dired-omit-mode 1))

(defun arni/dwim-dired-find-file (arg)
  "When called alone, calls dired.
But when called with ARG, like C-u, calls rgrep."
  (interactive "P")
  (if arg
      (call-interactively 'rgrep)
    (call-interactively 'dired)))

;; use-package declarations

(use-package dired
  :ensure nil
  :demand t
  :init
  (require 'dired-x)
  (add-hook 'dired-mode-hook 'arni/diredpretties-hook)
  (setq dired-omit-files		"^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\..*$"      ;; Bound to C-x M-o (dired-omit-mode) in dired-mode-map, by default
      dired-dwim-target			t
      dired-auto-revert-buffer		t
      delete-by-moving-to-trash		t
      trash-directory			"~/.local.share/Trash/files/"
      dired-listing-switches		"-alh --group-directories-first"
      dired-create-destination-dirs	'ask
      dired-guess-shell-alist-user	'(("\\.mkv\\'" "vlc"))
      dired-clean-up-buffers-too        nil)
  :bind
  (("C-x M-h" . dired-hide-details-mode)
   :map dired-mode-map
   ("b" . dired-up-directory)
   ("s" . arni/dwim-dired-find-file)
   ("<TAB>" . dired-subtree-toggle)
   ("<mouse-2>" . dired-mouse-find-file))) ;; opens in new window by default, dont like it

;;; dired trash utility

(with-eval-after-load 'dired
  (add-hook 'dired-after-readin-hook
  	    (lambda ()
  	      (if (equal (dired-current-directory) "/home/arni/.local.share/Trash/files/") ;; dont use eq !
  		  (progn
    		    (setq-local delete-by-moving-to-trash nil)
  		    (highlight-regexp "/home/arni/.local.share/Trash/files" 'hi-pink)
  		    (message "Files will be fully deleted here!"))
  		(ignore)))))
