;;; arni-search.el
;;; isearch
;; Function declarations

;; Taken from a Reddit post
;; https://www.reddit.com/r/emacs/comments/db8eu4/trying_to_collect_some_isearch_tips_and_tricks/

(defun contrib/isearch-exit-at-front ()
    "always exit isearch, at the front of search match."
    (interactive)
    (isearch-exit)
    (when isearch-forward
      (goto-char isearch-other-end)))

(defun contrib/isearch-exit-at-end ()
    "Always exit isearch, at the end of search match."
    (interactive)
    (isearch-exit)
    (when (not isearch-forward)
      (goto-char isearch-other-end)))

;; Taken from isearch+.el library
;; https://www.emacswiki.org/emacs/isearch%2b.el

(defun contrib/isearchp-remove-failed-part-or-last-char ()
    "Remove failed part of search string, or last char if successful.
    Do nothing if search string is empty to start with."
    (interactive)
    (if (equal isearch-string "")
        (isearch-update)
      (if isearch-success
          (isearch-delete-char)
        (while (isearch-fail-pos) (isearch-pop-state)))
      (isearch-update)))

;; use-package declaration
(use-package isearch
  :ensure nil
  :init
  (setq isearch-repeat-on-direction-change	t ; no pause when switching between forward and backward search
        isearch-lax-whitespace			t
	search-whitespace-regexp		".*"
	isearch-lazy-count			t
	isearch-allow-scroll			t ; can use C-v, M-v and others while in isearch to move in the buffer
	isearch-wrap-pause			'no
	lazy-highlight-initial-delay            0)
  :bind
   (:map					isearch-mode-map
   ("<return>"		.	contrib/isearch-exit-at-front)
   ("C-<return>"	.	contrib/isearch-exit-at-end)
   ("<backspace>"	.	contrib/isearchp-remove-failed-part-or-last-char)
   ("DEL"	        .	contrib/isearchp-remove-failed-part-or-last-char)))

;;; occur
;; defining functions

(defvar arni-occur-region-context-lines 0
  "The amount of context lines given to each match in 'arni/occur-region'.")

(defun arni/occur-region (start end)
  "Start an Occur search on the current buffer, with current region as search query.
This function does not support Occur's region narrowing."
  (interactive "r")
  (let ((regiontext (buffer-substring start end))
	(contextlines arni-occur-region-context-lines))
    (occur regiontext contextlines nil)
    (deactivate-mark)))

;; use-package declaration

(use-package isearch
  :ensure nil
  :demand t
  :init
  (setq list-matching-lines-default-context-lines 2) ; amount of lines shown around occur search candidates
  :bind
  ("<mouse-3>" . arni/occur-region)
  ("<down-mouse-3>" . arni/occur-region))

(use-package consult
  :bind
  (("C-x b" . consult-buffer)))

;;; eww
;; use-package declaration
(use-package eww
  :init
  (add-hook 'eww-after-render-hook 'visual-line-mode)
  (add-hook 'eww-mode-hook
	    (lambda ()
	      (setq-local tab-line-tabs-function 'tab-line-tabs-mode-buffers)
	      (tab-line-mode 1)))
  :config
  (setq eww-auto-rename-buffer t
	eww-buffer-name-length 20)
  :bind
  (("C-c e" . eww)
   :map eww-mode-map
   ("o" . org-eww-copy-for-org-mode)))

;;; view-mode
;; rebinding keys

(defvar-keymap arni-view-mode-mark-map
  :doc "Keymap for nesting mark-related commands in 'arni-view-mode-map'."
  :repeat t
  "s"		#'point-to-register ;; mark save
  "j"		#'register-to-point ;; mark jump
  "p"		#'View-back-to-mark ;; mark pop
  "m"		#'set-mark-command)

(defvar-keymap arni-view-mode-map
  :doc "Personal keymap for my preferred 'view-mode' keybindings."
  :repeat nil
  "/"		#'View-search-regexp-forward
  "f"		#'View-search-last-regexp-forward ;; forward and backward matches
  "b"		#'View-search-last-regexp-backward
  "e"		#'View-exit ;; quit mode. could be bound to g, e or q
  "n"		#'View-scroll-half-page-forward ;; next and previous pages (think the line commands)
  "p"		#'View-scroll-half-page-backward
  "SPC"	        #'View-scroll-page-forward ;; spc and s-spc rebound depending on majmode
  "S-SPC"	#'View-scroll-page-backward
  "j"		#'avy-goto-char-timer ;; jump
  "m"		arni-view-mode-mark-map
  "x"		#'exchange-point-and-mark
  "%"		#'View-goto-percent ;; go to end or specific percentage of buffer
  "("		#'beginning-of-buffer
  ")"		#'end-of-buffer
  "="		#'what-line
  "g"		#'View-goto-line
  "-"		#'negative-argument
  "9"		#'digit-argument
  "8"		#'digit-argument
  "7"		#'digit-argument
  "6"		#'digit-argument
  "5"		#'digit-argument
  "4"		#'digit-argument
  "3"		#'digit-argument
  "2"		#'digit-argument
  "1"		#'digit-argument
  "0"		#'digit-argument)

(setq view-mode-map arni-view-mode-map)

;;; imenu
;; use-package

(use-package emacs
  :config
  (setq imenu-flatten t
	imenu-level-separator ": "
	imenu-space-replacement " "
	imenu-auto-rescan t
	imenu-max-item-length 160))

;;; Defining and supplementing search-map
(defvar-keymap arni-apropos-map
  :doc "Personal keymap to nest 'apropos' commands."
  "a" #'apropos
  "d" #'apropos-documentation
  "u" #'apropos-user-option
  "c" #'apropos-command
  "f" #'apropos-function
  "v" #'apropos-variable
  "l" #'apropos-local-variable
  "C-v" #'apropos-value
  "C-l" #'apropos-local-value
  "M-l" #'apropos-library)

(define-key search-map (kbd "a") arni-apropos-map)
(define-key search-map (kbd "g") 'consult-ripgrep)
(define-key search-map (kbd "i") 'consult-info)
(define-key search-map (kbd "m") 'consult-imenu)
(define-key search-map (kbd "e") 'eww)
(define-key search-map (kbd "C-o") 'consult-outline)
(define-key search-map (kbd "s") 'shortdoc-display-group)
