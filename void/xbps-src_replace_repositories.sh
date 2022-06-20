#/bin/sh
find ./etc/xbps.d -maxdepth 1 -type f | xargs sed -i 's#^repository=https://alpha.de.repo.voidlinux.org#repository=https://ftp.swin.edu.au/voidlinux#'
