#!/bin/sh

set -e
set -x

xdg-app-builder --ccache app org.gnome.Sdk.json
cp metadata.sdk app/metadata.sdk
mv app/files/manifest.json app/usr/
xdg-app build-export --metadata=metadata.sdk --exclude="/lib/debug/*" -r repo app
