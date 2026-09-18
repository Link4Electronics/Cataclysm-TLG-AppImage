#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/com.cataclysm-tlg.cataclysm-tlg.svg
export DESKTOP=/usr/share/applications/com.cataclysm-tlg.cataclysm-tlg.desktop
export APPNAME=Cataclysm-TLG
export STARTUPWMCLASS=cataclysm-tlg-tiles
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun /usr/bin/cataclysm-tlg-tiles /usr/share/cataclysm-tlg

# fontdata.json ships legacy "data/font/..." paths for repo-root layouts; the
# game resolves fonts relative to datadir/font/, so strip the prefix
sed -i 's#data/font/##g' AppDir/share/cataclysm-tlg/fontdata.json

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage
