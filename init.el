;; -*- coding:utf-8 lexical-binding: t -*-

(require 'org)
(defvar init-dir "~/.emacs.d/inits")
(org-babel-load-file (expand-file-name "init.org" init-dir))

