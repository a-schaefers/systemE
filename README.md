# systemE
A lightweight systemd replacement written in Emacs lisp

## About

Using the tooling in this repo, I am able to boot from linux to sinit as pid1, and from there straight into Emacs as pid3? using --script mode, performing all typical rc.boot system initialization using Emacs lisp all the way to the getty.

Additionally from the getty, I use Emacs as a login shell, dotfiles manager, startx / xinitrc replacement, and Window Manager. I have nearly purged shell scrips from my life entirely. For more information about these things, see my [.emacs and dotfiles](https://github.com/a-schaefers/dotfiles) repo.

The plan is to update this repo as I progress in making my machine more "lispy."

## This repo is technically an Emacs [kiss linux](getkiss.org) package

I took some shortcuts in packaging it and it is not an exemplary example of a kiss package __at all__. It's very hacky. However it does display the flexibility and simplicity which makes the kiss package manager fun to work with.

So this repo compiles and installs all of my project dependencies "batteries included" to /boot ...

This includes:
- sinit
- dash
- emacs-nox
- ubase
- sbase

## Status

- The elisp rc.boot and rc.shutdown scripts are [nearly] finished and I use them on my local machine. No support for fancy stuff like luks is planned.

- Currently we depend on suckless.org's sinit for pid1 and this needs to be rewritten in in elisp.

Currently we depend on busybox runit for a process supervisor and this needs to be reimplemented in elisp, or atleast converted to gnu shepherd or something lispy.

One pain point is getting a statically compiled Emacs. We don't require this, but it sure would be nice. Unfortunately, when I statically compile Emacs using musl, it results in a broken Emacs.

### The ever-growing list of Helpful / Credits / Thank You's

```elisp
;; https://github.com/kisslinux/init/blob/master/lib/init/rc.boot
;; https://github.com/kisslinux/init/blob/master/lib/init/rc.shutdown
;; https://gist.github.com/lunaryorn/91a7734a8c1d93a8d1b0d3f85fe18b1e
;; https://busybox.net/FAQ.html#job_control
;; https://stackoverflow.com/questions/23299314/finding-the-exit-code-of-a-shell-command-in-elisp
;; https://github.com/Sweets/hummingbird
;; https://felipec.wordpress.com/2013/11/04/init
;; https://www.emacswiki.org/emacs/PersistentProcesses
```
