#!/bin/setsid /boot/bin/dash
":"; LD_LIBRARY_PATH=/boot/emacs exec /boot/bin/emacs --quick --script "$0" "$@" </dev/tty1 >/dev/tty1 2>&1 # -*- mode: emacs-lisp; lexical-binding: t; -*-

;; TODO use ARGV $1

(setq debug-on-error nil)

(setenv "PATH" "/boot/bin:/bin")
(setq exec-path '("/boot/bin" "/bin"))

(setenv "SHELL" "/boot/bin/dash")
(setq shell-file-name "/boot/bin/dash")

(defun process-exit-code-and-output (program &rest args)
  "Run PROGRAM with ARGS and return the exit code and output in a list."
  (with-temp-buffer
    (list (apply 'call-process program nil (current-buffer) nil args)
          (buffer-string))))

(progn ;; TODO this is junk
  (message "Waiting for services to stop...")
  (shell-command "sv" nil "sv -w196 force-stop /var/service/*")
  (shell-command "sv" nil "sv exit /var/service/*"))

(progn
  (message "Saving random seed...")
  (message "%s"
           (process-exit-code-and-output "dd" "count=1" "bs=512" "if=/dev/random" "of=/var/random.seed")))

(progn  (message "Sending TERM signal to all processes...")
        (message "%s"
                 (process-exit-code-and-output "ubase-box" "killall5" "TERM")))

(sleep-for 1)

(progn  (message "Sending KILL signal to all processes...")
        (message "%s"
                 (process-exit-code-and-output "ubase-box" "killall5" "KILL")))

(progn  (message "Unmounting filesystems and disabling swap...")
        (message "%s"
                 (process-exit-code-and-output "ubase-box" "swapoff" "-a"))
        (message "%s"
                 (process-exit-code-and-output "ubase-box" "umount" "-a"))
        (message "%s"
                 (process-exit-code-and-output "ubase-box" "mount" "-o" "remount,ro" "/"))
        (message "%s"
                 (process-exit-code-and-output "sbase-box" "sync")))

(progn
  (message "Goodbye.")
  (message "%s"
           (process-exit-code-and-output "ubase-box" "halt" "-p")))
