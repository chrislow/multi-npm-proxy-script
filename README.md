# npm-proxy.sh

A bash script that proxies npm commands to the appropriate package manager (npm, pnpm, yarn, or bun)
based on detected lock files in your project directory. If no lock file is found, it prompts you to
choose a package manager.

## Installation

1. Download the script and make it executable:

```bash
curl -O https://raw.githubusercontent.com/chrislow/multi-npm-proxy-script/main/npm-proxy.sh && chmod +x ./npm-proxy.sh
```

2. (Optional) Add the script to your zsh or bash profile:

```bash
echo "alias npmx='~/path/to/npm-proxy.sh'" >> ~/.zshrc
```

## Usage

```bash
# Force the usage of a specific package manager
npm-proxy.sh --use pnpm install

# Otherwise just use it like your normal package manager (it will run the right one based on your project)
npm-proxy.sh install
```
