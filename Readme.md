
If you want something simpler than Homebrew—just a lightweight way to use your own Bash repos from GitHub—there are excellent purpose‑built tools.

## bpkg (Bash Package Manager)

[bpkg](https://github.com/bpkg/bpkg) is a tiny, npm‑inspired package manager for Bash. It uses a `package.json` file (optional) and can install directly from GitHub.

### 1. Install bpkg

```bash
# One‑liner installation
curl -fsSL https://raw.githubusercontent.com/bpkg/bpkg/master/setup.sh | bash
```

Or, if you prefer Homebrew: `brew install bpkg`.

### 2. Prepare your repository

Your repo can be as simple as a folder with `.sh` files.  
Optionally, add a `package.json` to specify metadata and main file:

```json
{
  "name": "my-bash-utils",
  "version": "1.0.0",
  "description": "My personal Bash utilities",
  "main": "init.sh",
  "scripts": ["lib/*.sh"]
}
```

If you don't provide a `package.json`, bpkg will source all `.sh` files in the repo root.

### 3. Install your own package

```bash
bpkg install yourusername/my-bash-utils
```

This clones the repo into `~/.bpkg/packages/yourusername/my-bash-utils`.

### 4. Use it in a script

```bash
#!/usr/bin/env bash

# Source the package (sources all .sh files or the "main" defined in package.json)
source "$(bpkg prefix)/yourusername/my-bash-utils/init.sh"

# Now call your functions
my_cool_function
```

You can also use `bpkg run` to execute commands defined in package.json, but sourcing is what you need for libraries.

