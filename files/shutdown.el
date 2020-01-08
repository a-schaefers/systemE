#!/bin/setsid /bin/dash
":"; exec /boot/emacs/bin/emacs --quick --script "$0" "$@" </dev/tty1 >/dev/tty1 2>&1 # -*- mode: emacs-lisp; lexical-binding: t; -*-

(setenv "PATH" "/bin")
(setenv "SHELL" "/bin/dash")

(setq exec-path '("/bin")
      shell-file-name "/bin/dash"
      debug-on-error nil)
