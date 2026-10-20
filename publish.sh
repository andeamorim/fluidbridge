#!/bin/sh
# Publishes site/ (landing, manual, privacy policy) to the public repo andeamorim/fluidbridge (GitHub Pages).
# The app code stays in this private repo; only this folder is pushed.
set -e
cd "$(dirname "$0")/.."
git subtree split --prefix site -b site-publish
git push https://github.com/andeamorim/fluidbridge.git site-publish:main --force
git branch -D site-publish
