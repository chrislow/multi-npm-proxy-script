#!/usr/bin/env bash
echo -e "\033[34mnpm-proxy.sh\033[0m"

# Array if package managers and their lock files
PACKAGE_MANAGERS=("npm:package-lock.json" "pnpm:pnpm-lock.yaml" "yarn:yarn.lock" "bun:bun.lockb")

# A function to validate package manager name
is_valid_package_manager() {
    local pm=$1
    for entry in "${PACKAGE_MANAGERS[@]}"; do
        IFS=":" read -r manager _ <<<"$entry"
        if [ "$manager" = "$pm" ]; then
            return 0
        fi
    done
    return 1
}

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
    echo "Usage: npm-proxy.sh [options] [command] [arguments...]"
    echo "Proxies npm commands to the appropriate package manager."
    echo ""
    echo "Options:"
    echo "  --use <manager>    Force using specific package manager (npm|pnpm|yarn|bun)"
    echo ""
    echo "Examples:"
    echo "  npm-proxy.sh --use pnpm install"
    echo "  npm-proxy.sh --use yarn add express"
    echo "  npm-proxy.sh --use bun run start"
}

# If no arguments are provided, show help and exit
if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

# Check for forced package manager
PACKAGE_MANAGER=""
if [ "$1" = "--use" ]; then
    if [ -z "$2" ]; then
        echo "Error: Package manager name required"
        exit 1
    fi
    if ! is_valid_package_manager "$2"; then
        echo "Error: Invalid package manager '$2'"
        exit 1
    fi
    PACKAGE_MANAGER="$2"
    shift 2
else
    # Detect the package manager
    PACKAGE_MANAGER=$(detect_package_manager)
fi

echo -e "\033[90mUsing package manager: $PACKAGE_MANAGER\033[0m"

echo ""

# Check if there are any remaining arguments
if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

# Proxy the command to the detected package manager
"$PACKAGE_MANAGER" "$@"
