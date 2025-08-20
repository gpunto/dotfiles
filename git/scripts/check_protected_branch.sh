#!/bin/sh

PROTECTED_BRANCHES=("main" "master" "develop")

is_current_branch_protected() {
    local current_branch
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    for protected_branch in "${PROTECTED_BRANCHES[@]}"; do
        if [ "$current_branch" = "$protected_branch" ]; then
            echo "$current_branch"
            return 0 # Success: The branch is protected.
        fi
    done

    return 1 # Failure: The branch is not protected.
}
