;;; org-capture from my wm
(defadvice org-switch-to-buffer-other-window
    (after supress-window-splitting activate)
  "Delete the extra window if we're in a capture frame"
  (if (equal "capture" (frame-parameter nil 'name))
      (delete-other-windows)))

(defadvice org-capture-finalize
    (after delete-capture-frame activate)
  "Advise capture-finalize to close the frame"
  (when (and (equal "capture" (frame-parameter nil 'name))
	 (not (eq this-command 'org-capture-refile)))
    (delete-frame)))

(defadvice org-capture-refile
    (after delete-capture-frame activate)
  "Advise org-refile to close the frame"
  (delete-frame))
  
(defun activate-capture-frame ()
  "run org-capture in capture frame"
  (select-frame-by-name "capture")
  (switch-to-buffer (get-buffer-create "*scratch*"))
  (org-capture)) 
;; Call org-capture system-wide with : emacsclient -c -F '(quote (name . "capture"))' -e '(activate-capture-frame)'
;; Taken from https://www.reddit.com/r/emacs/comments/74gkeq/system_wide_org_capture/

;;; arni-desktop
;;; eshell
;; use-package declaration

(use-package eshell
  :config
  (setq eshell-prompt-function
      (lambda ()
        (concat
         (propertize (system-name) 'face '(:weight bold))
         " "
         (propertize (abbreviate-file-name (eshell/pwd)) 'face '(:weight bold))
         " "
         (propertize "λ" 'face '(:weight bold))
         (propertize " " 'face 'default))))
  (setq eshell-highlight-prompt nil)
  (setq eshell-prompt-regexp "^.* λ ")
  ;; defining complex hooks
  (add-hook 'eshell-mode-hook (lambda () (setenv "TERM" "dumb")))
  (add-hook 'eshell-mode-hook 'outline-minor-mode)
  (add-hook 'eshell-mode-hook (lambda () (setq-local outline-regexp (concat eshell-prompt-regexp ".*"))))
  (add-hook 'eshell-mode-hook (lambda ()
				(setq-local imenu-generic-expression `(("Prompt" ,(concat eshell-prompt-regexp "\\(.*\\)") 1)))))
  :bind
  ("C-c t" . eshell))

;;; eat
;; use-package declaration

(use-package eat
    :defer t
    :config
    (add-hook 'eshell-load-hook #'eat-eshell-mode)
    (add-hook 'eshell-load-hook #'eat-eshell-visual-command-mode))

(use-package elfeed
  :config				
  (setq elfeed-feeds
	'(("https://meteoalerte.com/france/meteoalerte_rss.php" weather) ; Weather 
	  ("http://static.fsf.org/fsforg/rss/blogs.xml" libreware) ; FSF Blogs feed
	  ("https://tube.kher.nl/feeds/videos.xml?videoChannelId=1441" peertube) ; Yohann Hoarau
	  ("https://tube.kher.nl/feeds/videos.xml?videoChannelId=1926" peertube) ; Gwên
	  ("https://toobnix.org/feeds/videos.xml?videoChannelId=154" peertube) ; EmacsConf
	  ("https://karthinks.com/index.xml" emacs) ; karthinks
	  ("https://sachachua.com/blog/category/emacs/feed/index.xml" emacs) ; sacha chua
	  ("http://yummymelon.com/devnull/feeds/all.atom.xml" emacs) ; charles choi
	  ("https://futurism.com/feed" futurism)
	  ("https://reporterre.net/spip.php?page=backend-simple" ecology)
	  ("https://framablog.org/feed/" libreware))))
