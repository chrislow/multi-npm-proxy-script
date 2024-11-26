#!/usr/bin/env bats

setup() {
    # Create a temporary directory for testing
    TMPDIR=$(mktemp -d)
    cd "$TMPDIR"

    # Create dummy package manager scripts that simulate actual package managers
    mkdir bin
    echo -e '#!/usr/bin/env bash\necho "npm $*"' >bin/npm
    echo -e '#!/usr/bin/env bash\necho "pnpm $*"' >bin/pnpm
    echo -e '#!/usr/bin/env bash\necho "yarn $*"' >bin/yarn
    echo -e '#!/usr/bin/env bash\necho "bun $*"' >bin/bun
    chmod +x bin/*

    # Prepend the dummy bin directory to PATH
    export PATH="$TMPDIR/bin:$PATH"

    # Path to the npm-proxy.sh script
    SCRIPT_PATH="./npm-proxy.sh"
    chmod +x "$SCRIPT_PATH"
}

teardown() {
    # Clean up after tests
    rm -rf "$TMPDIR"
}

@test "Displays help and exits with status 1 when no arguments are provided" {
    run bash "$SCRIPT_PATH"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Usage: npm-proxy.sh"* ]]
}

@test "Exits with error when '--use' is provided without a package manager" {
    run bash "$SCRIPT_PATH" --use
    [ "$status" -eq 1 ]
    [[ "$output" == *"Error: Package manager name required"* ]]
}

@test "Exits with error when an invalid package manager is specified with '--use'" {
    run bash "$SCRIPT_PATH" --use invalidpm
    [ "$status" -eq 1 ]
    [[ "$output" == *"Error: Invalid package manager 'invalidpm'"* ]]
}

@test "Uses the specified valid package manager with '--use'" {
    run bash "$SCRIPT_PATH" --use pnpm install
    [ "$status" -eq 0 ]
    [[ "$output" == *"Using package manager: pnpm"* ]]
    [[ "$output" == *"pnpm install"* ]]
}

@test "Detects npm based on package-lock.json" {
    touch package-lock.json
    run bash "$SCRIPT_PATH" install
    [ "$status" -eq 0 ]
    [[ "$output" == *"Using package manager: npm"* ]]
    [[ "$output" == *"npm install"* ]]
}

@test "Detects pnpm based on pnpm-lock.yaml" {
    touch pnpm-lock.yaml
    run bash "$SCRIPT_PATH" install
    [ "$status" -eq 0 ]
    [[ "$output" == *"Using package manager: pnpm"* ]]
    [[ "$output" == *"pnpm install"* ]]
}

@test "Detects yarn based on yarn.lock" {
    touch yarn.lock
    run bash "$SCRIPT_PATH" add express
    [ "$status" -eq 0 ]
    [[ "$output" == *"Using package manager: yarn"* ]]
    [[ "$output" == *"yarn add express"* ]]
}

@test "Detects bun based on bun.lockb" {
    touch bun.lockb
    run bash "$SCRIPT_PATH" run start
    [ "$status" -eq 0 ]
    [[ "$output" == *"Using package manager: bun"* ]]
    [[ "$output" == *"bun run start"* ]]
}

@test "Defaults to npm when no lock file is found" {
    run bash "$SCRIPT_PATH" install
    [ "$status" -eq 0 ]
    [[ "$output" == *"Using package manager: npm"* ]]
    [[ "$output" == *"npm install"* ]]
}

@test "Displays help and exits with status 1 when no command is provided" {
    run bash "$SCRIPT_PATH" --use npm
    [ "$status" -eq 1 ]
    [[ "$output" == *"Usage: npm-proxy.sh"* ]]
}

@test "Prefers npm when multiple lock files are present" {
    touch package-lock.json
    touch pnpm-lock.yaml
    run bash "$SCRIPT_PATH" install
    [ "$status" -eq 0 ]
    [[ "$output" == *"Using package manager: npm"* ]]
    [[ "$output" == *"npm install"* ]]
}

@test "Proxies command to the detected package manager" {
    touch pnpm-lock.yaml
    run bash "$SCRIPT_PATH" install
    [ "$status" -eq 0 ]
    [[ "$output" == *"Using package manager: pnpm"* ]]
    [[ "$output" == *"pnpm install"* ]]
}
