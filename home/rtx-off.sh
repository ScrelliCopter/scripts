#!/bin/bash
sudo rmmod nvidia_drm && sudo rmmod nvidia_modeset && sudo rmmod nvidia && sudo tee /proc/acpi/bbswitch <<<OFF && echo okay
[ -f "/usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf" ] && sudo rm -f /usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf
