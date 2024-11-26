#!/usr/bin/env bash
echo -e "\033[34mnpm-proxy.sh\033[0m"

# Array if package managers and their lock files
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
    echo "npm" # Default to npm if no lock file is found
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

echo -e "\033[90mUsing package manager: $PACKAGE_MANAGER\033[0m"

echo ""

# Proxy the command to the detected package manager
"$PACKAGE_MANAGER" "$@"
