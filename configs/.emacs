;; Visual appearance
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

(setq inhibit-startup-message 1)  ;; don't show ugly splash-screen

(toggle-frame-maximized)  ;; always open in fullscreen

(load-theme 'white-sand t)

(global-display-line-numbers-mode 1)  ;; show line numbers
(setq display-line-numbers-type 'relative)  ;; use relative line numbers

;; https://github.com/tonsky/FiraCode/blob/master/LICENSE
(set-frame-font "Fira Code 12" nil t)

;; Autocomplete
(global-company-mode 1)

;; Vim mode
(evil-mode 1)

;; Lisp
(setq inferior-lisp-program (getenv "LISP_PATH"))

