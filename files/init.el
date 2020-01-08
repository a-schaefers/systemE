#!/bin/setsid /boot/bin/dash
":"; LD_LIBRARY_PATH=/boot/emacs exec /boot/bin/emacs </dev/tty1 >/dev/tty1 2>&1 # -*- mode: emacs-lisp; lexical-binding: t; -*-

(setq debug-on-error nil)

(setenv "PATH" "/boot/bin:/bin")
(setq exec-path '("/boot/bin" "/bin"))

(setenv "SHELL" "/boot/bin/dash")
(setq shell-file-name "/boot/bin/dash")

;; TODO

(kill-emacs 0)
