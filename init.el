
;; This buffer is for text that is not saved, and for Lisp evaluation.
;; To create a file, visit it with C-x C-f and enter text in its buffer.

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;; latex-preview-pane
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  ;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
  ;; and `package-pinned-packages`. Most users will not need or want to do this.
  ;; (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  )
(package-initialize)

;; Hide tool bar
(tool-bar-mode -1)

;; Hide scroll bar
(scroll-bar-mode -1)

;; Show line numbers 
(global-linum-mode 1)

;; Add Packages
(require 'cl)
(defvar my/packages '(
		      company
		      material-theme
		      hungry-delete
		      smex
		      swiper
		      counsel
		      smartparens
		      ) "Default packages")

(setq package-selected-packages 'my/packages)

(defun my/packages-installed-p ()
  (loop for pkg in my/packages
	when (not (package-installed-p pkg)) do (return nil)
	finally (return t)))

(unless (my/packages-installed-p)
    (message "%s" "Refreshing package database...")
    (package-refresh-contents)
    (dolist (pkg my/packages)
      (when (not (package-installed-p pkg))
	(package-install pkg))))

;; Change font
(set-face-attribute 'default nil :font "SF Mono Medium")

;; Change font size to 16pt
(set-face-attribute 'default nil :height 160)

;; Quickly open this init file
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))
;; Bind with <f2> key
(global-set-key (kbd "<f2>") 'open-init-file)

;; Auto-completion(company)
(global-company-mode 1)

;; Set cursor type to vertical bar
(setq-default cursor-type 'bar)

;; Show recent files
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-item 10)
;; bind "C-x C-r" to recent files
(global-set-key (kbd "C-x C-r") 'recentf-open-files)

;; Delete selection mode (replace rather than append)
(delete-selection-mode t)

;; smartparens configurations
(require 'smartparens-config)
;; Always start smartparens mode in emacs-lisp-mode.
;; (add-hook 'emacs-lisp-mode-hook #'smartparens-mode)
(smartparens-global-mode t)


;; swiper ivy configurations
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
;; enable this if you want `swiper' to use it
;; (setq search-default-mode #'char-fold-to-regexp)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-h f") 'counsel-describe-function)
(global-set-key (kbd "C-h v") 'counsel-describe-variable)

;; Open emacs in full screen
;; (add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Parentheses matching
(add-hook 'emacs-lisp-mode-hook 'show-paren-mode)

;; Highlight current line
(global-hl-line-mode 1)

;; hungry-delete
(require 'hungry-delete)
(global-hungry-delete-mode)

;; ac-ispell
(add-hook 'some-mode-hook 'ac-ispell-ac-setup)
;; Completion words longer than 4 characters
(custom-set-variables
  '(ac-ispell-requires 4)
  '(ac-ispell-fuzzy-limit 2))

(eval-after-load "auto-complete"
  '(progn
      (ac-ispell-setup)))

(add-hook 'git-commit-mode-hook 'ac-ispell-ac-setup)
(add-hook 'mail-mode-hook 'ac-ispell-ac-setup)

;; sublimity scroll
;;(require 'sublimity)
;;(require 'sublimity-scroll)
;;(require 'sublimity-map) ;; experimental
;;(require 'sublimity-attractive)
;;(sublimity-mode 1)
;;(setq sublimity-scroll-weight 10
;;      sublimity-scroll-drift-length 5)

;; flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Auctex basic configurations
;; (setenv "PATH" "/usr/local/bin:/Library/TeX/texbin/:$PATH" t)
;; (setq exec-path (append exec-path '("/Library/TeX/texbin")))
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin:/Library/TeX/texbin"))
(setq exec-path (append exec-path '("/usr/local/bin" "/Library/TeX/texbin/")))

;; auctex auto save
(setq TeX-save-query nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;latex-preview-panel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "/home/tan/config/emacs/extend/latex-preview-pane")
(require 'latex-preview-pane)
(latex-preview-pane-enable)

;; matlab-emacs
;; Replace path below to be where your matlab.el file is.
(add-to-list 'load-path "~/matlab-emacs")
(load-library "matlab-load")

;; Enable CEDET feature support for MATLAB code. (Optional)
;; (matlab-cedet-setup)

;; Load themes
;; (add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;; material theme
(load-theme 'material t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-idle-delay 0.08)
 '(company-minimum-prefix-length 2)
 '(custom-enabled-themes (quote (sanityinc-tomorrow-eighties)))
 '(custom-safe-themes
   (quote
    ("a24c5b3c12d147da6cef80938dca1223b7c7f70f2f382b26308eba014dc4833a" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "732b807b0543855541743429c9979ebfb363e27ec91e82f463c91e68c772f6e3" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" default)))
 '(doc-view-continuous t)
 '(global-flycheck-mode t)
 '(hl-sexp-background-color "#1c1f26")
 '(package-selected-packages
   (quote
    (ac-ispell pdf-tools matlab-mode company-irony flycheck-irony irony use-package sublimity smex smartparens rainbow-delimiters material-theme latex-preview-pane hungry-delete flycheck counsel company color-theme-sanityinc-tomorrow auto-complete-auctex auctex)))
 '(preview-auto-cache-preamble t)
 '(preview-pdf-color-adjust-method (quote compatible))
 '(preview-transparent-color (quote (highlight :background))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bad-face ((t (:background "firebrick" :foreground "White"))))
 '(preview-face ((t (:distant-foreground "white" :foreground "white"))))
 '(preview-reference-face ((t nil))))


