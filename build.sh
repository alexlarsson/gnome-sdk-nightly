#!/bin/sh

set -e

rm -rf sdk
xdg-app-builder --ccache --require-changes --repo=repo --subject="Nightly build of org.gnome.Sdk, `date`" ${EXPORT_ARGS-} sdk org.gnome.Sdk.json
