# npm-proxy.sh

A bash script that proxies npm commands to the appropriate package manager (npm, pnpm, yarn, or bun)
based on detected lock files in your project directory. If no lock file is found, it prompts you to
choose a package manager.

## Usage

1. Download the script and make it executable:

```bash
curl -O https://raw.githubusercontent.com/chrislow/multi-npm-proxy-script/main/npm-proxy.sh && chmod +x ./npm-proxy.sh
```

2. Add the script to your zsh or bash profile:

```bash
echo "alias npm='~/path/to/npm-proxy.sh'" >> ~/.zshrc
```
