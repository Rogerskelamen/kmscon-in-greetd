# kmscon in greetd

This repository contains shells scripts and a sudoers file intended to be used
when running [greetd](https://sr.ht/~kennylevinsen/greetd) greeters under
[kmscon](https://github.com/Aetf/kmscon), as part of one possible workaround
that addresses kmscon not starting as the default session command in greetd.

Questions on how to use kmscon with greetd were asked in this
[kmscon discussion](https://github.com/Aetf/kmscon/discussions/76) and
[greetd ticket](https://todo.sr.ht/~kennylevinsen/greetd/36).
I have written the reasons why kmscon cannot be used as expected on this
[comment](https://github.com/Aetf/kmscon/discussions/76#discussioncomment-12734606)
in the mentioned kmscon discussion.

## Files

- `accessvt` (`/usr/local/bin/accessvt`): Runs `grantvt` using sudo before and
   after running the command passed in arguments, to temporarily set the owner
   of `/dev/ttyN`.

- `grantvt` (`/usr/local/sbin/grantvt`): Sets the owner of the file used to open
   an inherited file descriptor which references the VT, to root or the user that
   ran the script using sudo. This avoids setting the owner of a TTY where the
   greeter isn't running.

- `grantvt.sudoers.in` (`/etc/greeters.d/grantvt`): Allows greeter user to run
   `grantvt` using sudo without authentication.

- `kmscon-fg` (`/usr/local/bin/grantvt`): Runs command passed in arguments under
   kmscon only once without resetting environment variables.

I would be glad to receive suggestions on better file names. I've also spent
a lot of time on this, so I have no plans to add much changes.

File descriptors cannot be passed using doas, so `grantvt` needs to use a
different (less restrictive?) check to support it.

## Setup

1. Run `make` and set macros defined at the top of the Makefile in arguments
   if needed, e.g. `make GREETD_USER=_greetd`.
2. Run `sudo make install` with same macros specified before `install`.
3. Disable kmscon service if installed.
4. Add greeter to groups with access to files below:
   - `/dev/input/*`
   - `/dev/dri/card*` - if systemd isn't used
     - `/dev/fb*` - if not available, but group is required even with systemd
5. Combine greeter command in greetd configuration with `accessvt kmscon-fg`,
   e.g. `accessvt kmscon-fg tuigreet -t`.
6. Enable greetd service.

## Issues

Please report issues or ask questions in this repository only, unless it can be
confirmed that it likely should be addressed with the involved programs.
