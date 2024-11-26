#!/usr/bin/env bash

# Array of package managers and their lock files
PACKAGE_MANAGERS=("npm:package-lock.json" "pnpm:pnpm-lock.yaml" "yarn:yarn.lock" "bun:bun.lockb")

# A function to detect the package manager based on lock files
detect_package_manager() {
    for entry in "${PACKAGE_MANAGERS[@]}"; do
        IFS=":" read -r manager lockfile <<<"$entry"
        if [ -f "$lockfile" ]; then
            echo "$manager"
            return
        fi
    done
    echo "" # Return empty string if no lock file is found
}

# Function to display usage
show_help() {
    echo "Usage: npm-proxy.sh [command] [arguments...]"
    echo "Proxies npm commands to the appropriate package manager."
}

# If no arguments are provided, show help and exit
if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

# Detect the package manager
PACKAGE_MANAGER=$(detect_package_manager)

if [ -z "$PACKAGE_MANAGER" ]; then
    echo "No package manager lock file detected."
    echo "Please choose a package manager:"
    select choice in "${PACKAGE_MANAGERS[@]%%:*}"; do
        if [[ -n "$choice" ]]; then
            PACKAGE_MANAGER="$choice"
            break
        else
            echo "Invalid choice. Aborting."
            exit 1
        fi
    done
fi

echo "Using package manager: $PACKAGE_MANAGER"

# Proxy the command to the detected package manager
"$PACKAGE_MANAGER" "$@"
