;; DESCRIPTION: topfunky settings

(add-to-list 'load-path (concat dotfiles-dir "/vendor"))

;; Save backups in one place
;; Put autosave files (ie #foo#) in one place, *not*
;; scattered all over the file system!
(defvar autosave-dir
  (concat "/tmp/emacs_autosaves/" (user-login-name) "/"))

(make-directory autosave-dir t)

(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))

(defun make-auto-save-file-name ()
  (concat autosave-dir
          (if buffer-file-name
              (concat "#" (file-name-nondirectory buffer-file-name) "#")
            (expand-file-name
             (concat "#%" (buffer-name) "#")))))

;; Put backup files (ie foo~) in one place too. (The backup-directory-alist
;; list contains regexp=>directory mappings; filenames matching a regexp are
;; backed up in the corresponding directory. Emacs will mkdir it if necessary.)
(defvar backup-dir (concat "/tmp/emacs_backups/" (user-login-name) "/"))
(setq backup-directory-alist (list (cons "." backup-dir)))

(setq default-tab-width 2)
(setq tab-width 2)

;; Clojure
;;(eval-after-load 'clojure-mode '(clojure-slime-config))

;; Plain Text
;;; Stefan Monnier <foo at acm.org>. It is the opposite of
;;; fill-paragraph. Takes a multi-line paragraph and makes
;;; it into a single line of text.
(defun unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(defun refresh-file ()
  (interactive)
  (revert-buffer t t t))
(global-set-key [f5] 'refresh-file)

;; Snippets
(add-to-list 'load-path (concat dotfiles-dir "/vendor/yasnippet.el"))
(require 'yasnippet)
(yas/initialize)
(yas/load-directory (concat dotfiles-dir "/vendor/yasnippet.el/snippets"))

;; Commands
(require 'unbound)

;; Minor Modes
(add-to-list 'load-path (concat dotfiles-dir "/vendor/textmate.el"))
(require 'textmate)
(textmate-mode)
(require 'whitespace)

;; Major Modes

;; Javascript
;; TODO javascript-indent-level 2

;; Remove scrollbars and make hippie expand
;; work nicely with yasnippet
(scroll-bar-mode -1)
(require 'hippie-exp)
(setq hippie-expand-try-functions-list
      '(yas/hippie-try-expand
        try-expand-dabbrev
        try-expand-dabbrev-visible
        try-expand-dabbrev-all-buffers
        ;;        try-expand-dabbrev-from-kill
        ;;         try-complete-file-name
        ;;         try-complete-file-name-partially
        ;;         try-complete-lisp-symbol
        ;;         try-complete-lisp-symbol-partially
        ;;         try-expand-line
        ;;         try-expand-line-all-buffers
        ;;         try-expand-list
        ;;         try-expand-list-all-buffers
        ;;        try-expand-whole-kill
        ))

(defun indent-or-complete ()
  (interactive)
  (if (and (looking-at "$") (not (looking-back "^\\s-*")))
      (hippie-expand nil)
    (indent-for-tab-command)))
(add-hook 'find-file-hooks (function (lambda ()
                                       (local-set-key (kbd "TAB") 'indent-or-complete))))

;; dabbrev-case-fold-search for case-sensitive search

;; Rinari
(add-to-list 'load-path (concat dotfiles-dir "/vendor/jump.el"))
(add-to-list 'load-path (concat dotfiles-dir "/vendor/rinari"))
(require 'rinari)
(define-key rinari-minor-mode-map [(control meta shift down)] 'rinari-find-rspec)
(define-key rinari-minor-mode-map [(control meta shift left)] 'rinari-find-controller)
(define-key rinari-minor-mode-map [(control meta shift up)] 'rinari-find-model)
(define-key rinari-minor-mode-map [(control meta shift right)] 'rinari-find-view)

(defun rake-generate-html ()
  (interactive)
  (rake "generate_html"))
(global-set-key [(meta shift r)] 'rake-generate-html)


(autoload 'applescript-mode "applescript-mode" "major mode for editing AppleScript source." t)
(setq auto-mode-alist
      (cons '("\\.applescript$" . applescript-mode) auto-mode-alist))

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

(require 'textile-mode)
(add-to-list 'auto-mode-alist '("\\.textile\\'" . textile-mode))

(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.mdown\\'" . markdown-mode))

(require 'haml-mode)
(add-to-list 'auto-mode-alist '("\\.haml$" . haml-mode))
(define-key haml-mode-map [(control meta down)] 'haml-forward-sexp)
(define-key haml-mode-map [(control meta up)] 'haml-backward-sexp)
(define-key haml-mode-map [(control meta left)] 'haml-up-list)
(define-key haml-mode-map [(control meta right)] 'haml-down-list)

(require 'sass-mode)
(add-to-list 'auto-mode-alist '("\\.sass$" . sass-mode))

(add-to-list 'auto-mode-alist '("\\.sake\\'" . ruby-mode))

;; XCODE
(require 'objc-c-mode)

;; (setq c-default-style "bsd"
;;       c-basic-offset 2)

(require 'cc-menus)

(require 'xcode)
(define-key objc-mode-map [(meta r)] 'xcode-compile)
(define-key objc-mode-map [(meta K)] 'xcode-clean)
(add-hook 'c-mode-common-hook
          (lambda()
            (local-set-key  [(meta O)] 'ff-find-other-file)))
(add-hook 'c-mode-common-hook
          (lambda()
            (local-set-key (kbd "C-c <right>") 'hs-show-block)
            (local-set-key (kbd "C-c <left>")  'hs-hide-block)
            (local-set-key (kbd "C-c <up>")    'hs-hide-all)
            (local-set-key (kbd "C-c <down>")  'hs-show-all)
            (hs-minor-mode t)))         ; Hide and show blocks
(add-to-list 'auto-mode-alist '("\\.h\\'" . objc-mode))
(require 'objj-mode)

;; Mercurial
;;(require 'mercurial)

;; Font
(set-face-font 'default "-apple-inconsolata-medium-r-normal--20-0-72-72-m-0-iso10646-1")

;; Color Themes
(add-to-list 'load-path (concat dotfiles-dir "/vendor/color-theme"))
(require 'color-theme)
(color-theme-initialize)

;; Functions

(require 'line-num)

;; Full screen toggle
(defun toggle-fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen (if (frame-parameter nil 'fullscreen)
                                           nil
                                         'fullboth)))
(global-set-key (kbd "M-n") 'toggle-fullscreen)


;; Keyboard

;; Split Windows
(global-set-key [f6] 'split-window-horizontally)
(global-set-key [f7] 'split-window-vertically)
(global-set-key [f8] 'delete-window)

;; Some Mac-friendly key counterparts
(global-set-key (kbd "M-s") 'save-buffer)
(global-set-key (kbd "M-z") 'undo)

;; Keyboard Overrides
(define-key textile-mode-map (kbd "M-s") 'save-buffer)
(define-key text-mode-map (kbd "M-s") 'save-buffer)

(global-set-key [(meta up)] 'beginning-of-buffer)
(global-set-key [(meta down)] 'end-of-buffer)

(global-set-key [(meta shift right)] 'ido-switch-buffer)
(global-set-key [(meta shift up)] 'recentf-ido-find-file)
(global-set-key [(meta shift down)] 'ido-find-file)
(global-set-key [(meta shift left)] 'magit-status)

(global-set-key [(meta H)] 'delete-other-windows)

(global-set-key [(meta D)] 'backward-kill-word) ;; (meta d) is opposite

(global-set-key [(meta N)] 'cleanup-buffer)

(global-set-key [(control \])] 'indent-rigidly)

;; Other

(prefer-coding-system 'utf-8)

(server-start)

;; Experimentation
;; TODO Move to separate theme file.

;;; theme-start
(defun topfunky-reload-theme ()
  "Reload init.el and the color-theme-helvetica"
  (interactive)
  (save-buffer)
  (eval-buffer)
  (color-theme-helvetica))

(global-set-key [f8] 'topfunky-reload-theme)

;; theme-colors
;; yellow: #ffffcc
;; blue:   #6688ee
;; green:  #52c62b
;; lightest grey: #f1f1f1
;; greys: #aa, #bb, #cc
;; light blue:    #c2cff1

(defun color-theme-helvetica ()
  "Attempt at a modern theme."
  (interactive)
  (color-theme-install
   '(color-theme-helvetica
     ((background-color . "#444444")
      (background-mode . dark)
      (border-color . "black")
      (cursor-color . "#cccccc")
      (foreground-color . "#d3d3d3")
      (mouse-color . "Grey"))
     ((apropos-keybinding-face . underline)
      (apropos-label-face face italic mouse-face highlight)
      (apropos-match-face . secondary-selection)
      (apropos-property-face . bold-italic)
      (apropos-symbol-face . info-xref)
      (display-time-mail-face . mode-line)
      (gnus-article-button-face . bold)
      (gnus-article-mouse-face . highlight)
      (gnus-carpal-button-face . bold)
      (gnus-carpal-header-face . bold-italic)
      (gnus-cite-attribution-face . gnus-cite-attribution-face)
      (gnus-mouse-face . highlight)
      (gnus-selected-tree-face . modeline)
      (gnus-signature-face . gnus-signature-face)
      (gnus-summary-selected-face . gnus-summary-selected-face)
      (gnus-treat-display-xface . head)
      (help-highlight-face . underline)
      (list-matching-lines-face . bold)
      (view-highlight-face . highlight)
      (widget-mouse-face . highlight))
     (default ((t (:stipple nil :foreground "#aaaaaa" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :width normal :family "Inconsolata"))))
     (bbdb-field-name ((t (:foreground "green"))))
     (bg:erc-color-face0 ((t (:background "White"))))
     (bg:erc-color-face1 ((t (:background "black"))))
     (bg:erc-color-face10 ((t (:background "lightblue1"))))
     (bg:erc-color-face11 ((t (:background "cyan"))))
     (bg:erc-color-face12 ((t (:background "blue"))))
     (bg:erc-color-face13 ((t (:background "deeppink"))))
     (bg:erc-color-face14 ((t (:background "gray50"))))
     (bg:erc-color-face15 ((t (:background "gray90"))))
     (bg:erc-color-face2 ((t (:background "blue4"))))
     (bg:erc-color-face3 ((t (:background "green4"))))
     (bg:erc-color-face4 ((t (:background "red"))))
     (bg:erc-color-face5 ((t (:background "brown"))))
     (bg:erc-color-face6 ((t (:background "purple"))))
     (bg:erc-color-face7 ((t (:background "orange"))))
     (bg:erc-color-face8 ((t (:background "yellow"))))
     (bg:erc-color-face9 ((t (:background "green"))))
     (blue ((t (:foreground "#6688ee"))))
     (bold ((t (:bold t :foreground "#bbbbbb" :weight bold :family "Helvetica Neue"))))
     (bold-italic ((t (:italic t :bold t :slant italic :weight bold :family "Helvetica Neue"))))
     (border ((t (:background "black"))))
     (calendar-today-face ((t (:underline t))))
     (comint-highlight-input ((t (:bold t :weight bold))))
     (comint-highlight-prompt ((t (:foreground "#c2cff1"))))
     (cperl-array-face ((t (:foreground "Yellow"))))
     (cperl-hash-face ((t (:foreground "White"))))
     (cperl-nonoverridable-face ((t (:foreground "SkyBlue"))))
     (cursor ((t (:background "purple"))))
     (custom-button-face ((t (:foreground "MediumSlateBlue" :underline t))))
     (custom-button-pressed-face ((t (:background "lightgrey" :foreground "black" :box (:line-width 2 :style pressed-button)))))
     (custom-changed-face ((t (:background "blue" :foreground "white"))))
     (custom-comment-face ((t (:background "dim gray"))))
     (custom-comment-tag-face ((t (:foreground "gray80"))))
     (custom-documentation-face ((t (:foreground "Grey"))))
     (custom-face-tag-face ((t (:bold t :family "Helvetica Neue" :weight bold :height 1.2))))
     (custom-group-tag-face ((t (:foreground "MediumAquamarine"))))
     (custom-group-tag-face-1 ((t (:bold t :family "Helvetica Neue" :foreground "pink" :weight bold :height 1.2))))
     (custom-invalid-face ((t (:background "red" :foreground "yellow"))))
     (custom-modified-face ((t (:background "blue" :foreground "white"))))
     (custom-rogue-face ((t (:background "black" :foreground "pink"))))
     (custom-saved-face ((t (:underline t))))
     (custom-set-face ((t (:background "white" :foreground "blue"))))
     (custom-state-face ((t (:foreground "Coral"))))
     (custom-variable-button-face ((t (:underline t))))
     (custom-variable-tag-face ((t (:foreground "Aquamarine"))))
     (date ((t (:foreground "green"))))
     (diary-face ((t (:bold t :foreground "IndianRed" :weight bold))))
     (dired-face-directory ((t (:bold t :foreground "sky blue" :weight bold))))
     (dired-face-executable ((t (:foreground "#d90000"))))
     (dired-face-flagged ((t (:foreground "tomato"))))
     (dired-face-marked ((t (:foreground "light salmon"))))
     (dired-face-permissions ((t (:foreground "aquamarine"))))
     (erc-action-face ((t (:bold t :weight bold))))
     (erc-bold-face ((t (:bold t :weight bold))))
     (erc-default-face ((t (nil))))
     (erc-direct-msg-face ((t (:foreground "pale green"))))
     (erc-error-face ((t (:bold t :foreground "IndianRed" :weight bold))))
     (erc-highlight-face ((t (:bold t :foreground "pale green" :weight bold))))
     (erc-host-danger-face ((t (:foreground "red"))))
     (erc-input-face ((t (:foreground "light blue"))))
     (erc-inverse-face ((t (:background "steel blue"))))
     (erc-notice-face ((t (:foreground "light salmon"))))
     (erc-pal-face ((t (:foreground "pale green"))))
     (erc-prompt-face ((t (:bold t :foreground "light blue" :weight bold))))
     (erc-underline-face ((t (:underline t))))
     (eshell-ls-archive-face ((t (:bold t :foreground "IndianRed" :weight bold))))
     (eshell-ls-backup-face ((t (:foreground "Grey"))))
     (eshell-ls-clutter-face ((t (:bold t :foreground "DimGray" :weight bold))))
     (eshell-ls-directory-face ((t (:bold t :foreground "MediumSlateBlue" :weight bold))))
     (eshell-ls-executable-face ((t (:bold t :foreground "Coral" :weight bold))))
     (eshell-ls-missing-face ((t (:bold t :foreground "black" :weight bold))))
     (eshell-ls-picture-face ((t (:foreground "Violet"))))
     (eshell-ls-product-face ((t (:foreground "LightSalmon"))))
     (eshell-ls-readonly-face ((t (:foreground "Aquamarine"))))
     (eshell-ls-special-face ((t (:bold t :foreground "Gold" :weight bold))))
     (eshell-ls-symlink-face ((t (:bold t :foreground "White" :weight bold))))
     (eshell-ls-text-face ((t (:foreground "medium aquamarine"))))
     (eshell-ls-todo-face ((t (:bold t :foreground "aquamarine" :weight bold))))
     (eshell-ls-unreadable-face ((t (:foreground "DimGray"))))
     (eshell-prompt-face ((t (:foreground "powder blue"))))
     (face-1 ((t (:stipple nil :foreground "royal blue" :family "andale mono"))))
     (face-2 ((t (:stipple nil :foreground "DeepSkyBlue1" :overline nil :underline nil :slant normal :family "Inconsolata"))))
     (face-3 ((t (:stipple nil :foreground "NavajoWhite3"))))
     (fg:erc-color-face0 ((t (:foreground "white"))))
     (fg:erc-color-face1 ((t (:foreground "beige"))))
     (fg:erc-color-face10 ((t (:foreground "pale goldenrod"))))
     (fg:erc-color-face11 ((t (:foreground "light goldenrod yellow"))))
     (fg:erc-color-face12 ((t (:foreground "light yellow"))))
     (fg:erc-color-face13 ((t (:foreground "yellow"))))
     (fg:erc-color-face14 ((t (:foreground "light goldenrod"))))
     (fg:erc-color-face15 ((t (:foreground "lime green"))))
     (fg:erc-color-face2 ((t (:foreground "lemon chiffon"))))
     (fg:erc-color-face3 ((t (:foreground "light cyan"))))
     (fg:erc-color-face4 ((t (:foreground "powder blue"))))
     (fg:erc-color-face5 ((t (:foreground "sky blue"))))
     (fg:erc-color-face6 ((t (:foreground "dark sea green"))))
     (fg:erc-color-face7 ((t (:foreground "pale green"))))
     (fg:erc-color-face8 ((t (:foreground "medium spring green"))))
     (fg:erc-color-face9 ((t (:foreground "khaki"))))
     (fixed-pitch ((t (:family "Inconsolata"))))
     (font-lock-builtin-face ((t (:bold t :foreground "#c2cff1" :weight bold))))
     (font-lock-comment-face ((t (:foreground "#777"))))
     (font-lock-constant-face ((t (:bold t :foreground "#52c62b" :weight bold))))
     (font-lock-doc-face ((t (:italic t :slant italic :foreground "#6688ee"))))
     (font-lock-doc-string-face ((t (:foreground "#6688ee"))))
     (font-lock-function-name-face ((t (:bold t :foreground "#ffffbb" :weight bold))))
     (font-lock-keyword-face ((t (:foreground "#888"))))
     (font-lock-preprocessor-face ((t (:foreground "#6688ee"))))
     (font-lock-reference-face ((t (:foreground "#c2cff1"))))
     (font-lock-string-face ((t (:foreground "#ffffcc"))))
     (font-lock-type-face ((t (:bold t :foreground "#c2cff1" :weight bold))))
     (font-lock-variable-name-face ((t (:italic t :bold t :foreground "#f3f3f3" :slant italic :weight bold))))
     (font-lock-warning-face ((t (:bold t :foreground "IndianRed" :weight bold))))
     (fringe ((t (:background "#444444"))))
     (gnus-cite-attribution-face ((t (:family "Helvetica Neue"))))
     (gnus-cite-face-1 ((t (:foreground "DarkGoldenrod3"))))
     (gnus-cite-face-10 ((t (nil))))
     (gnus-cite-face-11 ((t (nil))))
     (gnus-cite-face-2 ((t (:foreground "IndianRed3"))))
     (gnus-cite-face-3 ((t (:foreground "tomato"))))
     (gnus-cite-face-4 ((t (:foreground "yellow green"))))
     (gnus-cite-face-5 ((t (:foreground "SteelBlue3"))))
     (gnus-cite-face-6 ((t (:foreground "Azure3"))))
     (gnus-cite-face-7 ((t (:foreground "Azure4"))))
     (gnus-cite-face-8 ((t (:foreground "SpringGreen4"))))
     (gnus-cite-face-9 ((t (:foreground "SlateGray4"))))
     (gnus-emphasis-bold ((t (:bold t :foreground "greenyellow" :weight bold :family "Helvetica Neue"))))
     (gnus-emphasis-bold-italic ((t (:italic t :bold t :foreground "OrangeRed1" :slant italic :weight bold :family "Helvetica Neue"))))
     (gnus-emphasis-highlight-words ((t (:background "black" :foreground "khaki"))))
     (gnus-emphasis-italic ((t (:italic t :bold t :foreground "orange" :slant italic :weight bold :family "Helvetica Neue"))))
     (gnus-emphasis-underline ((t (:foreground "greenyellow" :underline t))))
     (gnus-emphasis-underline-bold ((t (:bold t :foreground "khaki" :underline t :weight bold :family "Helvetica Neue"))))
     (gnus-emphasis-underline-bold-italic ((t (:italic t :bold t :underline t :slant italic :weight bold :family "Helvetica Neue"))))
     (gnus-emphasis-underline-italic ((t (:italic t :foreground "orange" :underline t :slant italic :family "Helvetica Neue"))))
     (gnus-group-mail-1-empty-face ((t (:foreground "Salmon4"))))
     (gnus-group-mail-1-face ((t (:bold t :foreground "firebrick1" :weight bold))))
     (gnus-group-mail-2-empty-face ((t (:foreground "turquoise4"))))
     (gnus-group-mail-2-face ((t (:bold t :foreground "turquoise" :weight bold))))
     (gnus-group-mail-3-empty-face ((t (:foreground "LightCyan4"))))
     (gnus-group-mail-3-face ((t (:bold t :foreground "LightCyan1" :weight bold))))
     (gnus-group-mail-low-empty-face ((t (:foreground "SteelBlue4"))))
     (gnus-group-mail-low-face ((t (:bold t :foreground "SteelBlue2" :weight bold))))
     (gnus-group-news-1-empty-face ((t (:foreground "Salmon4"))))
     (gnus-group-news-1-face ((t (:bold t :foreground "FireBrick1" :weight bold))))
     (gnus-group-news-2-empty-face ((t (:foreground "darkorange3"))))
     (gnus-group-news-2-face ((t (:bold t :foreground "dark orange" :weight bold))))
     (gnus-group-news-3-empty-face ((t (:foreground "turquoise4"))))
     (gnus-group-news-3-face ((t (:bold t :foreground "Aquamarine" :weight bold))))
     (gnus-group-news-4-empty-face ((t (:foreground "SpringGreen4"))))
     (gnus-group-news-4-face ((t (:bold t :foreground "SpringGreen2" :weight bold))))
     (gnus-group-news-5-empty-face ((t (:foreground "OliveDrab4"))))
     (gnus-group-news-5-face ((t (:bold t :foreground "OliveDrab2" :weight bold))))
     (gnus-group-news-6-empty-face ((t (:foreground "DarkGoldenrod4"))))
     (gnus-group-news-6-face ((t (:bold t :foreground "DarkGoldenrod3" :weight bold))))
     (gnus-group-news-low-empty-face ((t (:foreground "wheat4"))))
     (gnus-group-news-low-face ((t (:bold t :foreground "tan4" :weight bold))))
     (gnus-header-content-face ((t (:foreground "LightSkyBlue3"))))
     (gnus-header-from-face ((t (:bold t :foreground "light cyan" :weight bold))))
     (gnus-header-name-face ((t (:bold t :foreground "DodgerBlue1" :weight bold))))
     (gnus-header-newsgroups-face ((t (:italic t :bold t :foreground "LightSkyBlue3" :slant italic :weight bold))))
     (gnus-header-subject-face ((t (:bold t :foreground "light cyan" :weight bold))))
     (gnus-signature-face ((t (:italic t :foreground "salmon" :slant italic))))
     (gnus-splash-face ((t (:foreground "Firebrick1"))))
     (gnus-summary-cancelled-face ((t (:background "black" :foreground "yellow"))))
     (gnus-summary-high-ancient-face ((t (:bold t :foreground "MistyRose4" :weight bold))))
     (gnus-summary-high-read-face ((t (:bold t :foreground "tomato3" :weight bold))))
     (gnus-summary-high-ticked-face ((t (:bold t :foreground "coral" :weight bold))))
     (gnus-summary-high-unread-face ((t (:italic t :bold t :foreground "red1" :slant italic :weight bold))))
     (gnus-summary-low-ancient-face ((t (:italic t :foreground "DarkSeaGreen4" :slant italic))))
     (gnus-summary-low-read-face ((t (:foreground "SeaGreen4"))))
     (gnus-summary-low-ticked-face ((t (:italic t :foreground "Green4" :slant italic))))
     (gnus-summary-low-unread-face ((t (:italic t :foreground "green3" :slant italic))))
     (gnus-summary-normal-ancient-face ((t (:foreground "RoyalBlue"))))
     (gnus-summary-normal-read-face ((t (:foreground "khaki4"))))
     (gnus-summary-normal-ticked-face ((t (:foreground "khaki3"))))
     (gnus-summary-normal-unread-face ((t (:foreground "khaki"))))
     (gnus-summary-selected-face ((t (:foreground "gold" :underline t))))
     (green ((t (:foreground "#52c62b"))))
     (gui-button-face ((t (:foreground "red" :background "black"))))
     (gui-element ((t (:bold t :background "#ffffff" :foreground "#000000" :weight bold))))
     (header-line ((t (:box (:line-width -1 :style released-button) :background "grey20" :foreground "grey90" :box nil))))
     (highlight ((t (:background "#3c3c3c"))))
     (highline-face ((t (:background "SeaGreen"))))
     (holiday-face ((t (:background "DimGray"))))
     (info-menu-5 ((t (:underline t))))
     (info-node ((t (:bold t :foreground "DodgerBlue1" :underline t :weight bold))))
     (info-xref ((t (:bold t :foreground "DodgerBlue3" :weight bold))))
     (isearch ((t (:background "#d2d2d2" :foreground "black"))))
     (isearch-lazy-highlight-face ((t (:background "#333"))))
     (italic ((t (:italic t :foreground "chocolate3" :slant italic))))
     (menu ((t (nil))))
     (message-cited-text-face ((t (:foreground "White"))))
     (message-header-cc-face ((t (:foreground "light cyan"))))
     (message-header-name-face ((t (:foreground "DodgerBlue1"))))
     (message-header-newsgroups-face ((t (:italic t :bold t :foreground "LightSkyBlue3" :slant italic :weight bold))))
     (message-header-other-face ((t (:foreground "LightSkyBlue3"))))
     (message-header-subject-face ((t (:bold t :foreground "light cyan" :weight bold))))
     (message-header-to-face ((t (:bold t :foreground "light cyan" :weight bold))))
     (message-header-xheader-face ((t (:foreground "DodgerBlue3"))))
     (message-mml-face ((t (:foreground "ForestGreen"))))
     (message-separator-face ((t (:background "cornflower blue" :foreground "chocolate"))))

     (modeline ((t (:background "#3c3c3c" :foreground "#777777" ))))
     (modeline-buffer-id ((t (:bold t :foreground "White" :weight bold :family "Helvetica Neue"))))
     (modeline-inactive ((t (:background "#444444" :foreground "#505050"))))
     (modeline-mousable ((t (:bold t :background "dark olive green" :foreground "yellow green" :weight bold :family "Helvetica Neue"))))
     (modeline-mousable-minor-mode ((t (:bold t :background "dark olive green" :foreground "wheat" :weight bold :family "Helvetica Neue"))))

     (mouse ((t (:background "Grey"))))
     (paren-blink-off ((t (:foreground "brown"))))
     (region ((t (:background "#222222"))))
     (ruler-mode-column-number-face ((t (:box (:color "grey76" :line-width 1 :style released-button) :background "grey76" :stipple nil :inverse-video nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :width normal :family "Inconsolata" :foreground "black"))))
     (ruler-mode-current-column-face ((t (:bold t :box (:color "grey76" :line-width 1 :style released-button) :background "grey76" :stipple nil :inverse-video nil :strike-through nil :overline nil :underline nil :slant normal :width normal :family "Inconsolata" :foreground "yellow" :weight bold))))
     (ruler-mode-default-face ((t (:family "Inconsolata" :width normal :weight normal :slant normal :underline nil :overline nil :strike-through nil :inverse-video nil :stipple nil :background "grey76" :foreground "grey64" :box (:color "grey76" :line-width 1 :style released-button)))))
     (ruler-mode-fill-column-face ((t (:box (:color "grey76" :line-width 1 :style released-button) :background "grey76" :stipple nil :inverse-video nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :width normal :family "Inconsolata" :foreground "red"))))
     (ruler-mode-margins-face ((t (:box (:color "grey76" :line-width 1 :style released-button) :foreground "grey64" :stipple nil :inverse-video nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :width normal :family "Inconsolata" :background "grey64"))))
     (ruler-mode-tab-stop-face ((t (:box (:color "grey76" :line-width 1 :style released-button) :background "grey76" :stipple nil :inverse-video nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :width normal :family "Inconsolata" :foreground "steelblue"))))
     (scroll-bar ((t (nil))))
     (secondary-selection ((t (:background "Aquamarine" :foreground "SlateBlue"))))
     (show-paren-match-face ((t (:bold t :foreground "#ffffbb" :background "black" :weight bold))))
     (show-paren-mismatch-face ((t (:foreground "Red" :background "black"))))
     (swbuff-current-buffer-face ((t (:bold t :foreground "red" :weight bold))))
     (text-cursor ((t (:background "Red" :foreground "white"))))
     (tool-bar ((t (:background "grey75" :foreground "black" :box (:line-width 1 :style released-button)))))
     (trailing-whitespace ((t (:background "red"))))
     (underline ((t (:underline t))))
     (variable-pitch ((t (:family "Helvetica Neue"))))
     (textile-link-face (()t (:foreground "#222222")))
     (w3m-anchor-face ((t (:bold t :foreground "DodgerBlue1" :weight bold))))
     (w3m-arrived-anchor-face ((t (:bold t :foreground "DodgerBlue3" :weight bold))))
     (w3m-header-line-location-content-face ((t (:background "dark olive green" :foreground "wheat"))))
     (w3m-header-line-location-title-face ((t (:background "dark olive green" :foreground "beige"))))
     (widget-button-face ((t (:bold t :foreground "green" :weight bold :family "Inconsolata"))))
     (widget-button-pressed-face ((t (:foreground "red"))))
     (widget-documentation-face ((t (:foreground "lime green"))))
     (widget-field-face ((t (:foreground "LightBlue"))))
     (widget-inactive-face ((t (:foreground "DimGray"))))
     (widget-single-line-field-face ((t (:foreground "LightBlue"))))
     (woman-bold-face ((t (:bold t :weight bold :family "Helvetica Neue"))))
     (woman-italic-face ((t (:italic t :foreground "beige" :slant italic :family "Helvetica Neue"))))
     (woman-unknown-face ((t (:foreground "LightSalmon"))))
     (zmacs-region ((t (:background "dark cyan" :foreground "cyan")))))))

;;; theme-end

;; Activate theme
(color-theme-helvetica)
;; (color-theme-emacs-21)
