#!/bin/sh

set -e
set -x

xdg-app-builder app org.gnome.Sdk.json
cp metadata.sdk app/metadata
mv app/files/manifest.json app/usr/
xdg-app build-export -r repo app
