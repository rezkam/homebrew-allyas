# Homebrew Tap for allyas

Personal shell aliases for macOS, distributed via Homebrew.

## Installation

```bash
# Add the tap
brew tap rezkam/allyas

# Install allyas
brew install allyas
```

## Setup

After installation, add this line to your shell configuration:

**For zsh** (`~/.zshrc`):
```bash
[ -f $(brew --prefix)/etc/allyas.sh ] && . $(brew --prefix)/etc/allyas.sh
```

**For bash** (`~/.bashrc` or `~/.bash_profile`):
```bash
[ -f $(brew --prefix)/etc/allyas.sh ] && . $(brew --prefix)/etc/allyas.sh
```

Then reload your shell:
```bash
source ~/.zshrc  # for zsh
source ~/.bashrc # for bash
```

## Usage

Once installed and configured, all aliases are available in your terminal. Try:

```bash
ll        # List files with details
gs        # Git status
ga .      # Git add all
..        # Go up one directory
```

See the complete list of aliases at [rezkam/allyas](https://github.com/rezkam/allyas).

## Updating

To get the latest aliases:

```bash
brew update && brew upgrade allyas
```

Your shell will automatically use the updated aliases (no need to reload).

## Uninstalling

```bash
# Uninstall the formula
brew uninstall allyas

# Remove the tap (optional)
brew untap rezkam/allyas

# Remove the source line from your shell config
# (Edit ~/.zshrc or ~/.bashrc and remove the allyas line)
```

## How It Works

- This tap contains only the Homebrew formula
- The formula points to releases from [rezkam/allyas](https://github.com/rezkam/allyas)
- When you install, Homebrew downloads the aliases from a tagged release
- The formula is automatically updated when new releases are created

## Features

- ✅ **Single source of truth**: All aliases in one place
- ✅ **Version controlled**: Track changes via Git
- ✅ **Easy installation**: Install with a simple `brew` command
- ✅ **Automatic updates**: Get new aliases with `brew upgrade`
- ✅ **Cross-shell compatible**: Works with both bash and zsh
- ✅ **Cross-architecture**: Works on both Apple Silicon and Intel Macs
- ✅ **Sourced, not copied**: Aliases are evaluated from a central location

## Requirements

- macOS
- Homebrew installed
- bash or zsh shell

## Source Code

This is a Homebrew tap (distribution repository). For source code, issues, and contributions, see:
- **Source repository**: [rezkam/allyas](https://github.com/rezkam/allyas)

## Troubleshooting

### Aliases not working after install

Make sure you:
1. Added the source line to your shell config
2. Reloaded your shell (`source ~/.zshrc` or `source ~/.bashrc`)
3. The file exists: `ls -la $(brew --prefix)/etc/allyas.sh`

### Updates not showing

```bash
# Force reinstall
brew reinstall allyas

# Reload shell
source ~/.zshrc  # or ~/.bashrc
```

### Finding the installed file

```bash
# On Apple Silicon
ls -la /opt/homebrew/etc/allyas.sh

# On Intel
ls -la /usr/local/etc/allyas.sh

# Universal (works on both)
ls -la $(brew --prefix)/etc/allyas.sh
```

## License

MIT
