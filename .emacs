;; Enable Package use prior to .emacs load
;;(setq package-enable-at-startup nil)
(package-initialize)
;;;; paths added to load-path

(add-to-list 'load-path "~/.emacs.d/lisp/google-maps")
(add-to-list 'load-path "~/.emacs.d/lisp")
(add-to-list 'load-path "~/.emacs.d/elpa")
(add-to-list 'load-path "~/.emacs.d/themes")
(load-theme 'tango-dark t)

(require 'package)
(require 'google-maps)
;;Package managers
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")
			 ("org" . "http://orgmode.org/elpa/")))

;;;;Inhibit startup screen
(setq inhibit-startup-message t)

;;Default face size for Retina displays
(set-face-attribute 'default nil :height 200)

;;;;Wrap lines
(global-visual-line-mode t)

;;;; Python settings to use Python 3
(setq python-shell-interpreter "/usr/bin/python3")

;;;;Add settings for web-mode to make it the default for HTML editing etc
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;;org-mode;;
(require 'org)
(require 'org-contacts)
(setq org-directory "~/Dropbox/Agenda")
(setq org-agenda-files '("~/Dropbox/Agenda"))
(setq org-default-notes-file (concat org-directory "/notes.org"))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
;;remove validation link on HTML export
(setq org-html-validation-link nil)
;;syntax highlighting for org
(setq org-src-fontify-natively t)
(define-key global-map "\C-cc" 'org-capture)
(setq org-use-sub-superscripts t)
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/todo.org" "Tasks")
	 "* TODO %?\n  %i\n  %a")
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
	 "* %?\nEntered on %U\n  %i\n  %a")))


;;Set backupfolder for emacs
(setq backup-directory-alist `(("." . "~/.emacsbackup")))

;;org-babel

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "5862cafd08950bab02f890f8b4032a94ab23f591bc9b7bc831087fad648944dd" "a95fb11813c1f38ca550ca97e41c9805df08bbfab845be21b3b915efca12cb2a" "6405ad2db40ef5df9a5d2b9366c30cbdd9101a77127ebf6e90656057cfe290f5" default)))
 '(doc-view-continuous t)
 '(send-mail-function (quote smtpmail-send-it))
 '(smtpmail-smtp-server "mail.messagingengine.com")
 '(smtpmail-smtp-service 25))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;(load-theme 'sanityinc-solarized-light t)

(defvar org-babel-eval-verbose nil
  "A non-nil value makes `org-babel-eval' display")

(defun org-babel-eval (cmd body)
  "Run CMD on BODY.
If CMD succeeds then return its results, otherwise display
STDERR with `org-babel-eval-error-notify'."
  (let ((err-buff (get-buffer-create " *Org-Babel Error*")) exit-code)
    (with-current-buffer err-buff (erase-buffer))
    (with-temp-buffer
      (insert body)
      (setq exit-code
            (org-babel--shell-command-on-region
             (point-min) (point-max) cmd err-buff))
      (if (or (not (numberp exit-code)) (> exit-code 0)
              (and org-babel-eval-verbose (> (buffer-size err-buff) 0))) ; new condition
          (progn
            (with-current-buffer err-buff
              (org-babel-eval-error-notify exit-code (buffer-string)))
            nil)
        (buffer-string)))))

(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-hook 'markdown-mode-hook (lambda () (define-key markdown-mode-map (kbd "TAB") 'self-insert-command)))
(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)

;;mutt - post-mode
(autoload 'post-mode "post" "mode for e-mail" t)
(add-to-list 'auto-mode-alist
	     '("\\.*mutt-*\\|.article\\|\\.followup"
	     . post-mode))

;; standard org <-> remember stuff, RTFM
(require 'org-capture)
(require 'org-protocol)

(setq org-default-notes-file "~/org/gtd.org")

(setq org-capture-templates
      (quote
       (("m"
         "Mail"
         entry
         (file+headline "~/org/todo.org" "Incoming")
         "* TODO %^{Title}\n\n  Source: %u, %c\n\n  %i"
         :empty-lines 1)
        ;; ... more templates here ...
        )))
;; ensure that emacsclient will show just the note to be edited when invoked
;; from Mutt, and that it will shut down emacsclient once finished;
;; fallback to legacy behavior when not invoked via org-protocol.
(add-hook 'org-capture-mode-hook 'delete-other-windows)
(setq my-org-protocol-flag nil)
(defadvice org-capture-finalize (after delete-frame-at-end activate)
  "Delete frame at remember finalization"
  (progn (if my-org-protocol-flag (delete-frame))
         (setq my-org-protocol-flag nil)))
(defadvice org-capture-kill (after delete-frame-at-end activate)
  "Delete frame at remember abort"
  (progn (if my-org-protocol-flag (delete-frame))
         (setq my-org-protocol-flag nil)))
(defadvice org-protocol-capture (before set-org-protocol-flag activate)
  (setq my-org-protocol-flag t))

;;TRAMP
(setq tramp-default-method "ssh")

(font-lock-add-keywords 'python-mode
			'(("print" . font-lock-builtin-face)))
;;Twitter Mode
(add-to-list 'load-path "~/.emacs.d/lisp/twittering-mode")
(require 'twittering-mode)
(setq twittering-use-master-password t)

;;Tramp
(setq tramp-default-method "ssh")

;;MobileOrg
(setq org-mobile-directory "~/Dropbox/org/MobileOrg")

;;Tabs
(setq tab-width 4)
(setq tab-stop-list (number-sequence 4 200 4))
(setq indent-tabs-mode nil)
;(setq-default indent-tabs-mode nil)
;(setq-default tab-width 4)
;(setq indent-line-function 'insert-tab)


