#!/bin/bash

# Run this after every `brew upgrade backrest` (or `brew upgrade` in general).
#
# macOS ties Full Disk Access grants to a binary's code signature. Backrest's
# Homebrew build and its bundled restic binary are both ad-hoc signed, so every
# upgrade gets a new signature hash and silently loses FDA. There is no CLI way
# to grant TCC permissions (Apple does this on purpose), so this script does
# everything scriptable and leaves only the unavoidable drag-and-drop step.
#
# It also restarts the backrest service at the end: a running launchd process
# caches its TCC state at launch, so re-granting FDA without restarting the
# daemon has no effect.

set -e

BACKREST_BIN="$(brew --prefix backrest 2>/dev/null)/bin/backrest"
RESTIC_BIN="$HOME/.local/share/backrest/restic"

echo "Opening Full Disk Access settings..."
open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"

echo "Revealing backrest binary in Finder: $BACKREST_BIN"
open -R "$BACKREST_BIN"

if [[ -f "$RESTIC_BIN" ]]; then
    echo "Revealing restic binary in Finder: $RESTIC_BIN"
    open -R "$RESTIC_BIN"
else
    echo "restic binary not found at $RESTIC_BIN (skip if backrest hasn't run yet)"
fi

echo ""
echo "Drag both revealed binaries into the Full Disk Access list, then press Enter to restart the backrest service."
read -r

brew services restart garethgeorge/backrest-tap/backrest
echo "Done. Trigger a backup to confirm Desktop/Documents/Downloads/etc. no longer error."
