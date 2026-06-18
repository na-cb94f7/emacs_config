;;; repeat-mode
;; use-package declaration

(use-package repeat
  :ensure nil
  :config
  (setq repeat-on-final-keystroke t
	repeat-exit-timeout 5
	repeat-exit-key "<escape>"
	repeat-keep-prefix nil
	repeat-check-key t
	set-mark-command-repeat-pop t))

;;; which-key
;; use-package declaration

(use-package which-key
  :config
  (setq which-key-idle-delay 0.4)
  (which-key-mode 1))
