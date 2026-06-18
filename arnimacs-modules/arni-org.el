;;; arni-org
;;; configuring general options of org-mode

(use-package org
  :init
  (setq org-todo-keywords
        '((sequence "TODO(t)" "IN-PROGRESS(i)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
  (setq org-startup-folded		'content
	  org-use-speed-commands	t
	  org-refile-targets		'((nil :maxlevel		.	3)
					  (org-agenda-files :maxlevel	.	3))
	  org-ellipsis			" ▼"
	  org-fontify-todo-headline     nil
	  org-fontify-done-headline     nil
	  org-insert-heading-respect-content t)
  (require 'ox-md) ; org → markdown export
  :hook
  (org-mode . org-indent-mode)
  :bind
  (("C-c c" . org-capture)
   ("C-c a" . org-agenda)
   ("C-c l" . org-store-link)
   :map org-mode-map
   ("C-," . nil)))

;;; org-babel

(use-package org
  :init
  (setq org-babel-lisp-eval-fn 'sly-eval)
  (setq org-babel-python-command "python3")
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (emacs-lisp . t)
     (shell . t)
     (lisp . t))))

;;; org-agenda configuration

(use-package org
  :init
  (defun arni/org-agenda-wm-call ()
    (interactive)
    (org-agenda :keys "a")
    (delete-other-windows))
  (setq org-agenda-files	'("~/org/refile.org")
	org-default-notes-file	"~/org/refile.org")
  (setq org-capture-templates
          '(("t" "Task" entry (file+headline "~/org/refile.org" "Tasks")
             "* TODO %? :task:\nEntered on %T\n %i\n %a")
            ("n" "Notes" entry (file+headline "~/org/refile.org" "Notes")
             "* %? :notes:\nEntered on %T\n %i %a\n** Context")
            ("r" "Reflection" entry (file+headline "~/org/refile.org" "Reflections")
             "* %? :reflection:\nEntered on %T\n %i %a\n** Context")
            ("p" "Project" entry (file+headline "~/org/refile.org" "Projects")
             "* %? :project:\nEntered on %T\n %i %a\n** Context")
            ("R" "Recipe" entry (file+headline "~/org/refile.org" "Recipes")
             "* %? :recipe:\nEntered on %T\n %i\n %a")
            ("i" "Idea" entry (file+headline "~/org/refile.org" "Ideas")
             "* %? :idea:\nEntered on %T\n %i\n %a")
	    ("m" "Mini-essay" entry (file+headline "~/org/refile.org" "Mini-Essays")
             "* %? :mini-essay:\nEntered on %T\n %i\n %a")
	    ("c" "Creative Writing" entry (file+headline "~/org/refile.org" "Creative Writing")
             "* %? :creative:\nEntered on %T\n %i %a\n** Thoughts and reflections")))
  (setq org-agenda-custom-commands
	'(
          ;; Existing custom commands
          ("n" "Notes" tags "notes"
           ((org-agenda-overriding-header "Notes")
            (org-agenda-files '("~/org/refile.org"))
            (org-agenda-skip-function
             '(org-agenda-skip-entry-if 'notregexp ":notes:$"))))
          ("t" "Tasks" tags "task"
           ((org-agenda-overriding-header "Tasks")
            (org-agenda-files '("~/org/refile.org"))
            (org-agenda-skip-function
             '(org-agenda-skip-entry-if 'notregexp ":task:$"))))
          ("r" "Reflections" tags "reflection"
           ((org-agenda-overriding-header "Reflections")
            (org-agenda-files '("~/org/refile.org"))
            (org-agenda-skip-function
             '(org-agenda-skip-entry-if 'notregexp ":reflection:$"))))
          ("p" "Projects" tags "project"
           ((org-agenda-overriding-header "Projects")
            (org-agenda-files '("~/org/refile.org"))
            (org-agenda-skip-function
             '(org-agenda-skip-entry-if 'notregexp ":project:$"))))
          ("R" "Recipes" tags "recipe"
           ((org-agenda-overriding-header "Recipes")
            (org-agenda-files '("~/org/refile.org"))
            (org-agenda-skip-function
             '(org-agenda-skip-entry-if 'notregexp ":recipe:$"))))
          ("i" "Ideas" tags "idea"
           ((org-agenda-overriding-header "Ideas")
            (org-agenda-files '("~/org/refile.org"))
            (org-agenda-skip-function
             '(org-agenda-skip-entry-if 'notregexp ":idea:$"))))

          ;; New custom commands
          ("w" "Captures from last week"
           ((agenda ""
                    ((org-agenda-start-day "-7d")
                     (org-agenda-span 7)
                     (org-agenda-start-on-weekday nil)
                     (org-agenda-start-with-log-mode t)
                     (org-agenda-skip-function
                      '(org-agenda-skip-entry-if 'nottodo 'done))))))

          ("d" "Deadlines in next two weeks"
           ((agenda ""
                    ((org-agenda-time-grid nil)
                     (org-deadline-warning-days 14)
                     (org-agenda-entry-types '(:deadline))
                     (org-agenda-span 14)
                     (org-agenda-start-on-weekday nil)))))

          ("s" "Scheduled tasks for next week"
           ((agenda ""
                    ((org-agenda-entry-types '(:scheduled))
                     (org-agenda-span 7)
                     (org-agenda-start-on-weekday nil))))))))
