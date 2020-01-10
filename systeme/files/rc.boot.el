#!/bin/dash
":"; exec /bin/emacs --quick --script "$0" "$@" # -*- mode: emacs-lisp; lexical-binding: t; -*-

(require 'subr-x)

(setq debug-on-error nil)

(setenv "PATH" "/bin")
(setq exec-path '("/bin"))

(setenv "SHELL" "/bin/dash")
(setq shell-file-name "/bin/dash")

(defun process-exit-code-and-output (program &rest args)
  "Run PROGRAM with ARGS and return the exit code and output in a list."
  (with-temp-buffer
    (list (apply 'call-process program nil (current-buffer) nil args)
          (buffer-string))))

(message
 (concat "Begin systemE initialization..." (shell-command-to-string "uname -sr")))

(progn
  (message "Mounting proc...")
  (message "%s"
           (process-exit-code-and-output
            "ubase-box" "mount" "-o" "nosuid,noexec,nodev" "-t" "proc" "proc" "/proc")))

(progn
  (message "Mounting sys...")
  (message "%s"
           (process-exit-code-and-output
            "ubase-box" "mount" "-o" "nosuid,noexec,nodev" "-t" "sysfs" "sys" "/sys")))

(progn
  (message "Mounting run...")
  (message "%s"
           (process-exit-code-and-output
            "ubase-box" "mount" "-o" "mode=0755,nosuid,nodev" "-t" "tmpfs" "run" "/run")))

(progn
  (message "Mounting dev...")
  (message "%s"
           (process-exit-code-and-output
            "ubase-box" "mount" "-o" "mode=0755,nosuid" "-t" "devtmpfs" "dev" "/dev")))

(progn
  (message "Creating /run directories...")

  (make-directory "/run" t)
  (set-file-modes "/run" #o755)

  (make-directory "/run/runit" t)
  (set-file-modes "/run/runit" #o755)

  (make-directory "/run/lvm" t)
  (set-file-modes "/run/lvm" #o755)

  (make-directory "/run/user" t)
  (set-file-modes "/run/user" #o755)

  (make-directory "/run/lock" t)
  (set-file-modes "/run/lock" #o755)

  (make-directory "/run/log" t)
  (set-file-modes "/run/log" #o755)

  (make-directory "/dev/pts" t)
  (set-file-modes "/dev/pts" #o755)

  (make-directory "/dev/shm" t)
  (set-file-modes "/dev/shm" #o755))

(and
 (message "Mounting devpts...")
 (message "%s"
          (process-exit-code-and-output
           "ubase-box" "mount" "-o" "mode=0620,gid=5,nosuid" "-nt" "devpts" "devpts" "/dev/pts")))

(and
 (message "Mounting shm...")
 (message "%s"
          (process-exit-code-and-output
           "ubase-box" "mount" "-o" "mode=0777,nosuid,nodev" "-nt" "tmpfs" "shm" "/dev/shm")))

(when (executable-find "udevd")
  (message "Starting eudev...")
  (message "%s"
           (process-exit-code-and-output
            "udevd" "--daemon"))
  (message "%s"
           (process-exit-code-and-output
            "udevadm" "trigger" "--action=add" "--type=subsystems"))
  (message "%s"
           (process-exit-code-and-output
            "udevadm" "trigger" "--action=add" "--type=devices"))
  (message "%s"
           (process-exit-code-and-output
            "udevadm" "settle")))

(defun emergency ()
  "not sure how to do this part"
  (message "CTRL + ALT + DEL")
  (kill-emacs 1))

(progn
  (message "Remounting rootfs as ro...")
  (or (message "%s"
               (process-exit-code-and-output
                "ubase-box" "mount" "-o" "remount,ro" "/"))
      (emergency)))

(progn
  (message "Checking filesystems...")
  (or (eq 0 (call-process "fsck" nil nil nil "-ATat" "noopts=_netdev"))
      (emergency)))

(progn
  (message "Remounting rootfs as rw...")
  (or (message "%s"
               (process-exit-code-and-output
                "ubase-box" "mount" "-o" "remount,rw" "/"))
      (emergency)))

(progn
  (message "Mounting all local filesystems...")
  (or (message "%s"
               (process-exit-code-and-output
                "ubase-box" "mount" "-a"))
      (emergency)))

(progn
  (message "Seeding random...")
  (if (file-exists-p "/var/random.seed")
      (start-process-shell-command "cat" nil "cat /var/random.seed > /dev/urandom")
    (progn
      (message "This may hang. Mash the keyboard to generate entropy...")
      (message "%s"
               (process-exit-code-and-output "dd" "count=1" "bs=512" "if=/dev/random" "of=/var/random.seed")))))

(progn
  (message "Setting up loopback...")
  (message "%s"
           (process-exit-code-and-output "ip" "link" "set" "up" "dev" "lo")))

(progn
  (message "Setting hostname...")
  (or
   (and
    (setq hostname
          (and (file-exists-p "/etc/hostname")
               (with-temp-buffer
                 (insert-file-contents "/etc/hostname")
                 (string-trim (buffer-string)))))
    (message "%s"
             (shell-command (concat "echo " hostname " > /proc/sys/kernel/hostname"))))
   (message "%s"
            (shell-command "echo KISS > /proc/sys/kernel/hostname"))))

(when (file-exists-p "/etc/sysctl.conf")
  (message "Loading sysctl settings...")
  (message "%s"
           (process-exit-code-and-output "sysctl" "-p" "/etc/sysctl.conf")))

(when (executable-find "udevd")
  (message "Exiting eudev...")
  (message "%s"
           (process-exit-code-and-output "udevadm" "control" "--exit")))

(progn
  (message "Storing dmesg output to /var/log...")
  (start-process-shell-command "dmesg" nil "dmesg > /var/log/dmesg.log"))

(progn
  (message "Starting process supervsor...")
  (call-process-shell-command "nohup ubase-box respawn runsvdir -P /var/service &" nil nil 0))

(message "Boot stage complete...")

(progn
  (call-process-shell-command "nohup ubase-box respawn ubase-box getty /dev/tty1 linux &" nil nil 0)
  (call-process-shell-command "nohup ubase-box respawn ubase-box getty /dev/tty2 linux &" nil nil 0)
  (call-process-shell-command "nohup ubase-box respawn ubase-box getty /dev/tty3 linux &" nil nil 0)
  (call-process-shell-command "nohup ubase-box respawn ubase-box getty /dev/tty4 linux &" nil nil 0))

(kill-emacs 0)
