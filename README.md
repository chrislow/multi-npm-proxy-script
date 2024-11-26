# npm-proxy.sh

A bash script that proxies npm commands to the appropriate package manager (npm, pnpm, yarn, or bun)
based on detected lock files in your project directory. If no lock file is found, it prompts you to
choose a package manager.
