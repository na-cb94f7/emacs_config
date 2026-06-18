;;; arni-package-manager.el
;;; Configure pacakge.el

(require 'package)
(setq package-install-upgrade-built-in t) ; Upgrade built-in packages along with manually-installed ones
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;;; Make use-package install packages if they aren't

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package-ensure)
(setq use-package-always-ensure t) ; Install packages if not installed and configured through use-package
(setq package-check-signature nil)
