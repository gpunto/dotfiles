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

check_protected_branch_operation() {
    local protected_branch_name

    if protected_branch_name=$(is_current_branch_protected); then
        # Check if any remote URL contains "gpunto"
        if git remote -v | grep -q "gpunto"; then
            echo "⚠️  Warning: Operation on protected branch '$protected_branch_name'."
            return 0
        else
            echo "🚫 Operation on protected branch '$protected_branch_name' is not allowed."
            return 1
        fi
    fi

    return 0
}
