;;; early-init.el --- depth401's early-init.el -*- mode: emacs-lisp; lexical-binding: t; -*-

;; Copyright (C) 2021 depth401

;;; Commentary:

;;; Code:

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)
(add-hook 'emacs-startup-hook
          (lambda ()
            "Recover GC values after startup."
            (setq gc-cons-threshold 800000
                  gc-cons-percentage 0.1)))

(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

(setq package-enable-at-startup nil)
(setq load-prefer-newer t)

(setq frame-inhibit-implied-resize t)

(push '(fullscreen . maximized) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(cursor-type . bar) default-frame-alist)
(push '(left-fringe . 0) default-frame-alist)
(push '(right-fringe . 0) default-frame-alist)
(push '(font . "Cica-16") default-frame-alist)

(setq inhibit-splash-screen t
      frame-inhibit-implied-resize t
      byte-compile-warnings '(cl-functions))

(when (featurep 'ns)
  ;; disable icon and text in frame title
  (setq ns-use-proxy-icon nil)
  (push '(ns-transparent-titlebar . t) default-frame-alist)
  (push '(ns-use-native-fullscreen . nil) default-frame-alist))

;; message box
(defalias 'message-box 'message)
(setq use-dialog-box nil)

;; bell
(setq ring-bell-function 'ignore)

;; line number
(global-display-line-numbers-mode t)
(custom-set-variables '(display-line-numbers-width-start t))

;;; early-init.el ends here
