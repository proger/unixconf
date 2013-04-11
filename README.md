unixconf
========

This repo contains my configuration files. Lately this has become mostly OSX-centric so the `master` branch
contains only configuration files used by my OSX setup.

For the rest of the cool stuff look into `linux` and `openbsd` branches.

Deployment
----------

* I like `zfs` so like a true `zfs`-hipster I rename /Users to /tank. To do that boot your Mac into
single mode and run:

    make osx-fixtank USER=yourlogin

* When in default boot mode do:

    make all vimrc_repo=https://github.com/proger/vimrc.git
