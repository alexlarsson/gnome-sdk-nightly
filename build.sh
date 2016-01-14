#!/bin/sh

set -e

xdg-app-builder --ccache sdk org.gnome.Sdk.json
cp metadata.sdk sdk/metadata.sdk
mv sdk/files/manifest.json sdk/usr/
xdg-app build-export --metadata=metadata.sdk --exclude="/lib/debug/*" -r repo sdk
