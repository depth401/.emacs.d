;; <leaf-install-code>
(eval-and-compile
  (customize-set-variable
   'package-archives '(("org" . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))
;; </leaf-install-code>

(leaf diminish :ensure t)
(leaf el-get :ensure t)

(eval-when-compile (require 'cl-lib))

(leaf cus-start
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :custom ((indent-tabs-mode . nil)
           (make-backup-files . nil)
           (auto-save-default . nil)
           (suggest-key-bindings . nil)
           (delete-by-moving-to-trash . t))
  :config
  (defalias 'yes-or-no-p 'y-or-n-p))

(defvar org-inits-dir (file-name-as-directory "~/.emacs.d/inits"))

(defun org-inits-file (filename)
  (concat org-inits-dir filename))

(defun org-inits-rm-elc-files ()
  (interactive)
  (let ((init-elc-files (file-expand-wildcards (concat org-inits-dir "*.elc"))))
    (dolist (file init-elc-files)
      (if (file-exists-p file)
        (delete-file file)))))

(defun org-inits-byte-compile-init-files ()
  (interactive)
  (let ((init-file (org-inits-file "init.el")))
    (if (file-exists-p init-file)
        (byte-compile-file init-file))))

(leaf exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(leaf modus-themes
  :ensure t
  :custom ((modus-themes-italic-constructs . t)
           (modus-themes-bold-constructs . t)
           (modus-themes-region '(bg-only no-extend)))
  :config
  (modus-themes-load-themes)
  ;; (modus-themes-load-vivendi)
  (modus-themes-load-operandi)
  )

(leaf moody
  :ensure t
  :custom ((x-underline-at-descent-line . t))
  :config
  (let ((line (face-attribute 'mode-line :underline)))
    (set-face-attribute 'mode-line          nil :overline   line)
    (set-face-attribute 'mode-line-inactive nil :overline   line)
    (set-face-attribute 'mode-line-inactive nil :underline  line)
    (set-face-attribute 'mode-line          nil :box        nil)
    (set-face-attribute 'mode-line-inactive nil :box        nil)
    (set-face-attribute 'mode-line-inactive nil :background "#f9f2d9"))
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode)
  (moody-replace-eldoc-minibuffer-message-function))

(leaf mlscroll
  :ensure t
  :config
  (custom-set-variables
   '(mlscroll-in-color "#FFA07A") ;; light coral
   '(mlscroll-out-color "#FFFFE0")
   '(mlscroll-width-chars 12))
  :global-minor-mode mlscroll)

(leaf smooth-scroll
  :diminish ""
  :ensure t
  :global-minor-mode t)

(leaf all-the-icons
  :ensure t
  :if (display-graphic-p))

(leaf prettify-symbols
  :diminish ""
  :hook org-mode-hook elm-mode-hook)

(leaf autorevert
  :diminish auto-revert
  :global-minor-mode global-auto-revert-mode)

(leaf org
  :custom ((org-src-tab-acts-natively . t)
           (org-src-preserve-indentation . t)
           (org-edit-src-content-indentation . 0))

  :config
  (setq-default prettify-symbols-alist '(("#+begin_src" . "")
                                         ;; ("#+begin_src" . "▨")
                                         ("#+end_src" . "▨")
                                         ("#+RESULTS:" . "")
                                         ("[ ]" . "") ;; ☐ 
                                         ("[X]" . "" ) ;; ☑ 
                                         ("[-]" . "" ))) ;; 

  (custom-set-faces
   '(org-block-begin-line
     ((((background dark))
       (:foreground "#669966" :weight bold)) ;; :background "#444444"
      (t (:foreground "#CC3333" :weight bold)))) ;; :background "#EFEFEF"
   '(org-block-end-line
     ((((background dark)) (:foreground "#CC3333" :weight bold))
      (t (:foreground "#669966" :weight bold))))))

(leaf org-bullets
  :ensure t
  :hook (org-mode-hook . (lambda () (org-bullets-mode 1))))

(leaf skk
  :diminish ""
  :ensure ddskk
  :bind (("C-x C-j" . skk-mode))
  :custom ((default-input-method . "japanese-skk"))
  :pre-setq
  (skk-byte-compile-init-file . t)
  :config
  (leaf ddskk-posframe
    :diminish ""
    :ensure t
    :global-minor-mode t))

(leaf ivy
  :diminish ""
  :ensure t
  :bind (("C-c C-r" . ivy-resume))
  :global-minor-mode ivy-mode
  :custom ((ivy-count-format . "(%d/%d) ")
           (ivy-use-selectable-prompt . t)
           (ivy-on-del-error-function . #'ignore)
           (ivy-use-virtual-buffers . t)
           (ivy-wrap . t)
           (enable-recursive-minibuffers . t))
  :config
  (leaf ivy-posframe
    :diminish ""
    :ensure t
    :global-minor-mode ivy-posframe-mode
    :custom ((ivy-posframe-height-alist . '((counsel-M-x . 15)
                                            (t . 30)))
             (ivy-posframe-display-functions-alist . '(
                                                       ;; (counsel-M-x . ivy-posframe-display-at-point)
                                                       (t . ivy-posframe-display)))))

  (defface my-ivy-arrow-visible
    '((((class color) (background light)) :foreground "orange")
      (((class color) (background dark)) :foreground "#EE6363"))
    "Face used by Ivy for highlighting the arrow.")

  (defface my-ivy-arrow-invisible
    `((((class color) (background light)) :foreground ,(face-attribute 'ivy-posframe :background))
      (((class color) (background dark)) :foreground "#31343F"))
    "Face used by Ivy for highlighting the invisible arrow.")

  (defun my-pre-prompt-function ()
    (if window-system
        (format "%s "
                (all-the-icons-faicon "sort-amount-asc")) ;; ""
      (format "%s\n" (make-string (1- (frame-width)) ?\x2D))))
  (setq ivy-pre-prompt-function #'my-pre-prompt-function)

  (if window-system
      (when (require 'all-the-icons nil t)
        (defun my-ivy-format-function-arrow (cands)
          "Transform CANDS into a string for minibuffer."
          (ivy--format-function-generic
           (lambda (str)
             (concat (all-the-icons-faicon
                      "hand-o-right"
                      :v-adjust -0.2 :face 'my-ivy-arrow-visible)
                     " " (ivy--add-face str 'ivy-current-match)))
           (lambda (str)
             (concat (all-the-icons-faicon
                      "hand-o-right" :face 'my-ivy-arrow-invisible) " " str))
           cands
           "\n"))
        (setq ivy-format-functions-alist
              '((t . my-ivy-format-function-arrow))))
    (setq ivy-format-functions-alist '((t . ivy-format-function-arrow))))
  
  (leaf all-the-icons-ivy
    :ensure t
    :config
    (all-the-icons-ivy-setup)

    (dolist (command '(counsel-projectile-switch-project
                       counsel-ibuffer))
      (add-to-list 'all-the-icons-ivy-buffer-commands command)))

  (leaf ivy-hydra
    :ensure t
    :setq ((ivy-read-action-function . #'ivy-hydra-read-action))))

(leaf counsel
  :diminish ""
  :ensure t
  :bind (("C-M-s" . counsel-rg)
         ("C-M-z" . counsel-fzf)
         ("C-M-r" . counsel-recentf)
         ("C-M-g" . counsel-git-grep))
  :global-minor-mode counsel-mode
  :config
  (add-to-list 'ivy-more-chars-alist '(counsel-rg . 2)))

(leaf counsel-ghq
  :el-get SuzumiyaAoba/counsel-ghq
  :bind (("C-c C-g" . counsel-ghq)))

(leaf swiper
  :ensure t
  :bind (("C-s" . swiper)
         ("M-s p" . swiper-thing-at-point)))

(leaf prescient
  :ensure t
  :custom `((prescient-aggresive-file-save . t)
            (prescient-save-file . ,(expand-file-name "~/.emacs.d/prescient-save.el")))
  :global-minor-mode prescient-persist-mode
  :config

  (leaf ivy-prescient
    :ensure t
    :custom ((ivy-precient-retain-classic-highlighting . t))
    :global-minor-mode ivy-prescient-mode
    :config
    (setf (alist-get 'counsel-M-x ivy-re-builders-alist)
          #'ivy-prescient-re-builder)
    (setf (alist-get t ivy-re-builders-alist) #'ivy--regex-ignore-order)))

(leaf anzu
  :diminish ""
  :ensure t
  :bind (([remap query-replace] . 'anzu-query-replace)
         ([remap query-replace-regex] . 'anzu-query-replace-regex))
  :custom ((anzu-replace-threshold . 1000)
           (anzu-search-threshold . 1000))
  :config
  (copy-face 'mode-line 'anzu-mode-line))

(leaf volatile-highlights
  :diminish ""
  :ensure t
  :global-minor-mode volatile-highlights-mode)

(leaf highlight-indent-guides
  :diminish ""
  :ensure t
  :hook prog-mode-hook yaml-mode-hook
  :custom ((highlight-indent-guides-auto-enabled . t)
           (highlight-indent-guides-responsive . t)
           (highlight-indent-guides-method . 'character)))

(leaf hl-line-mode
  :global-minor-mode global-hl-line-mode)

(leaf undohist
  :ensure t
  :require t
  :config
  (undohist-initialize))

(leaf undo-tree
  :diminish ""
  :ensure t
  :global-minor-mode global-undo-tree-mode)

(leaf counsel-projectile
  :diminish projectile
  :ensure t
  :global-minor-mode counsel-projectile-mode
  :bind-keymap ("C-c p" . projectile-command-map))

(leaf company
  :diminish ""
  :ensure t
  :bind
  (:company-mode-map
   ("TAB" . indent-for-tab-command))
  (:company-active-map
   ("C-n" . company-select-next)
   ("C-p" . company-select-previous))
  (:company-search-map
   ("C-n" . company-select-next)
   ("C-p" . comapny-select-previous))
  :custom ((company-idle-delay . 0)
           (company-selection-wrap-around . t)
           (company-ignore-case . t)
           (company-dabbrev-downcase . nil))
  :global-minor-mode global-company-mode)

;; (leaf tree-sitter
;;   :ensure t
;;   :global-minor-mode global-tree-sitter-mode)

(leaf eldoc
  :diminish ""
  :config
  (defun ad:eldoc-message (f &optional string)
    (unless (active-minibuffer-window)
      (funcall f string)))
  (advice-add 'eldoc-message :around #'ad:eldoc-message))

(leaf display-fill-column-indicator
  :hook git-commit-mode-hook
  :custom
  (display-fill-column-indicator-column . 50))

(leaf rainbow-mode
  :diminish ""
  :ensure t
  :hook prog-mode-hook)

(leaf rainbow-delimiters
  :diminish ""
  :ensure t
  :hook prog-mode-hook)

(leaf flycheck
  :diminish ""
  :ensure t
  :global-minor-mode global-flycheck-mode)

(leaf magit
  :diminish ""
  :ensure t
  :custom ((magit-display-buffer-function . #'magit-display-buffer-fullframe-status-v1)
           (magit-completing-read-function . 'ivy-completing-read)))

(leaf git-gutter
  :diminish ""
  :ensure t
  :custom
  ((git-gutter:unchanged-sign . " ")
   (git-gutter:modified-sign  . " ")
   (git-gutter:added-sign     . " ")
   (git-gutter:deleted-sign   . " "))
  :custom-face
  `((git-gutter:unchanged . '((t (:background ,(face-attribute 'line-number :background)))))
    (git-gutter:modified  . '((t (:background "#f1fa8c"))))
    (git-gutter:added     . '((t (:background "#50fa7b"))))
    (git-gutter:deleted   . '((t (:background "#ff79c6")))))
  :global-minor-mode global-git-gutter-mode)

(leaf lsp-mode
  :ensure t
  :custom ((lsp-document-sync-method lsp--sync-incremental)))

(leaf lsp-ui
  :ensure t)

(leaf dumb-jump
  :ensure t
  :config

  (defhydra dumb-jump-hydra (:color blue :columns 3)
    "Dumb Jump"
    ("j" dumb-jump-go "Go")
    ("o" dumb-jump-go-other-window "Other window")
    ("e" dumb-jump-go-prefer-external "Go external")
    ("x" dumb-jump-go-prefer-external-other-window "Go external other window")
    ("i" dumb-jump-go-prompt "Prompt")
    ("l" dumb-jump-quick-look "Quick look")
    ("b" dumb-jump-back "Back")))

(leaf yaml-mode
  :ensure t)

(leaf web-mode
  :ensure t
  :mode "\\.html?\\'"
  :custom ((web-mode-markup-indent-offset . 2)))

(leaf js-mode
  :custom ((js-indent-level . 2)))

(leaf typescript-mode
  ;; :ensure t
  :el-get emacs-typescript/typescript.el
  :custom ((typescript-indent-level . 2)))

(leaf elm-mode
  :ensure t
  :hook ((elm-mode-hook . elm-format-on-save-mode)
         (elm-mode-hook . (lambda () (push '("|>" . ?▷) prettify-symbols-alist)
                            (push '("<|" . ?◁) prettify-symbols-alist)
                            (push '("->" . ?→) prettify-symbols-alist)))))

(defun open-init-org ()
  "Toggle current buffer between init.org."
  (interactive)
  (let ((path (buffer-file-name)))
    (if (equal path (expand-file-name "~/.emacs.d/inits/init.org"))
        (switch-to-buffer (other-buffer))
      (find-file "~/.emacs.d/inits/init.org"))))

(leaf custom-key-bindings
  :bind (("M-SPC" . open-init-org)))
