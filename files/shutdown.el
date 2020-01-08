#!/bin/setsid /bin/dash
":"; exec /boot/emacs/bin/emacs --quick --script "$0" "$@" </dev/tty1 >/dev/tty1 2>&1 # -*- mode: emacs-lisp; lexical-binding: t; -*-

;; A minimal minimal elisp rewrite of https://github.com/kisslinux/init/blob/master/lib/init/rc.shutdown

;; The following were also helpful:
;; https://gist.github.com/lunaryorn/91a7734a8c1d93a8d1b0d3f85fe18b1e
;; https://busybox.net/FAQ.html#job_control
;; https://stackoverflow.com/questions/23299314/finding-the-exit-code-of-a-shell-command-in-elisp
;; https://github.com/Sweets/hummingbird
;; https://felipec.wordpress.com/2013/11/04/init
;; https://www.emacswiki.org/emacs/PersistentProcesses
