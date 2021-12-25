;; -*- coding:utf-8 lexical-binding: t -*-

(require 'org)
(defvar init-dir "~/.emacs.d/inits")
(org-babel-load-file (expand-file-name "init.org" init-dir))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(tree-sitter swiper counsel ivy-posframe all-the-icons-ivy ivy ddskk-posframe ddskk all-the-icons modus-themes diminish blackout el-get hydra leaf-keywords leaf)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
