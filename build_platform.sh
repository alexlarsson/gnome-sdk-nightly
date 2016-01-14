#!/bin/sh

set -e

DEVEL_MODULES="vala wayland-protocols gnome-common yelp-tools yelp-xsl vala-bootstrap"

rm -rf platform
xdg-app build-init -w platform org.gnome.Platform org.freedesktop.Platform org.freedesktop.Platform 1.2

ostree diff --repo=.xdg-app-builder/cache org.gnome.Sdk.json/init org.gnome.Sdk.json/finish |
    grep  "^[MA]    /usr" |
    sed "s#^[MA]    /usr#usr#" |
    grep -v \
         -e "^usr/lib/debug" \
         -e "^usr/include"  \
         -e "^usr/share/aclocal" \
         -e "^usr/share/pkgconfig" \
         -e "^usr/lib/pkgconfig" \
         -e "^usr/share/vala" |
    sort  > filtered_files

for module in $DEVEL_MODULES; do
    ostree diff --repo=.xdg-app-builder/cache org.gnome.Sdk.json/build-$module^ org.gnome.Sdk.json/build-$module | grep  "^A    /usr" | sed "s#^[MA]    /usr#usr#" | sort > module_files
    comm -2 -3 filtered_files module_files > new_filtered_files
    mv new_filtered_files filtered_files
done

cat filtered_files | while read file; do
    [ -d "sdk/${file}" ] && continue
    rm -f platform/${file}
    mkdir -p `dirname platform/${file}`
    cp -al sdk/${file} platform/${file}
done

cp metadata.platform platform/metadata.platform
xdg-app build-export --metadata=metadata.platform --exclude="/lib/debug/*" -r repo platform
