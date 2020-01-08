#!/bin/setsid /boot/bin/dash
":"; LD_LIBRARY_PATH=/boot/emacs exec /boot/bin/emacs --quick --script "$0" "$@" </dev/tty1 >/dev/tty1 2>&1 # -*- mode: emacs-lisp; lexical-binding: t; -*-

(setq debug-on-error nil)

(setenv "PATH" "/boot/bin:/bin")
(setq exec-path '("/boot/bin" "/bin"))

(setenv "SHELL" "/boot/bin/dash")
(setq shell-file-name "/boot/bin/dash")

(require 'subr-x)

(defun process-exit-code-and-output (program &rest args)
  "Run PROGRAM with ARGS and return the exit code and output in a list."
  (with-temp-buffer
    (list (apply 'call-process program nil (current-buffer) nil args)
          (buffer-string))))
