#!/bin/bash
pacman -S fakeroot autoconf automake bison flex gcc make patch pkgconf
find /usr/bin/wget || pacman -S wget
pacman -U yay-11.0.2-1-x86_64.pkg.tar.zst
