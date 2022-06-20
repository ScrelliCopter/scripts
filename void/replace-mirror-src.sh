find etc/xbps.d/ -type f -name "repos-remote*.conf" -execdir sed -i 's|alpha.de.repo.voidlinux.org|mirror.clarkson.edu/voidlinux|' "{}" \;
