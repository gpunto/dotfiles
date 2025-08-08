#!/bin/sh

echo "Setting up Git configuration..."

if git config --global include.path '~/Sviluppo/dotfiles/git/gitconfig_global'; then
  echo "✅ Git setup complete"
else
  echo "❌ ERROR: Failed to set the Git configuration." >&2
  exit 1
fi
