# Dotfiles

## Install

On a new Mac, start with the [official Homebrew installer](https://brew.sh/).
It runs using the Bash and curl included with macOS and attempts to install the
Xcode Command Line Tools if they are missing. These provide Git and Make; the full
Xcode application is not required.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

The installer may prompt for confirmation and your administrator password. Follow
its instructions to add Homebrew to your shell environment, then clone this
repository:

```sh
git clone https://github.com/tomaskub/dotfiles.git ~/workspace/dotfiles
cd ~/workspace/dotfiles
```

Install Oh My Zsh if it is missing, install the packages in `homebrew/Brewfile`
without upgrading existing packages, then link the Zsh, Ghostty, Herdr, Git, and IdeaVim
configurations into your home directory:

```sh
make install
```

Both Make targets also check for Homebrew and install it if it is missing, but
Make must already be available. Use the installer above first on a fresh Mac.

Oh My Zsh is cloned into `~/.oh-my-zsh` without creating a starter `.zshrc`,
changing your login shell, or launching a new shell. Stow installs this
repository's `.zshrc`. Autosuggestions and syntax highlighting are installed
through the Brewfile. Open a new terminal after installation to load the setup.

Stow is included in the Brewfile. It links individual files and keeps directories
as real directories. If an existing configuration conflicts with a link, Stow
reports the conflict. Back up and move the conflicting file before retrying.

## Zsh login initialization

The `zshrc` Stow package also links `~/.zprofile`. Login shells initialize
Homebrew, add `~/.local/bin` and `~/.rbenv/bin` to `PATH`, and initialize rbenv
once. Homebrew is located through `PATH` or its standard Apple silicon and Intel
installation paths. Ruby versions remain local and are not installed by this
configuration.

Before installing over an existing setup, back up and move any conflicting
`~/.zprofile`, then run `make install` or `make update`. Open a new login terminal
to load it. Interactive shell settings remain in `~/.zshrc`.

## Git configuration

The `git` Stow package links `~/.gitconfig` and `~/.gitignore`. It selects Neovim
as the editor, ignores `.DS_Store` globally, and configures the Git LFS filters.
Neovim and Git LFS are included in the Brewfile.

Before installing over an existing setup, back up and move any conflicting
`~/.gitconfig` and `~/.gitignore` files. Keep those backups until you have moved
any identity, credentials, machine-specific settings, and extra ignore patterns
you need into local configuration.

Personal names and email addresses are not tracked. The managed configuration
includes `~/.gitconfig.local` last so it can supply identity and override shared
settings. Create or edit that file on each machine, replacing the example values:

```sh
git config --file ~/.gitconfig.local user.name "Your Name"
git config --file ~/.gitconfig.local user.email "you@example.com"
```

Use `--file ~/.gitconfig.local` for future local changes. Commands using
`git config --global` can modify the tracked configuration through its symlink.
Keep credentials in your credential helper or local configuration. For additional
ignore patterns, set `core.excludesfile` in `~/.gitconfig.local` to a separate
local ignore file, including `.DS_Store` if you still want to ignore it.

## IdeaVim

Install and enable the IdeaVim plugin in your JetBrains IDE. The setup links
`ideavim/.ideavimrc` to `~/.ideavimrc`, enabling relative line numbers and the
absolute number on the current line. See the [IdeaVim option reference](https://github.com/JetBrains/ideavim/wiki/set-commands).
Restart the IDE after installing the configuration.

## Update

Pull the latest dotfiles, install or upgrade the listed packages, update Oh My
Zsh using its own updater, and refresh the links to account for added or removed
configuration files:

```sh
git pull
make update
```

## Local secrets

After `make install`, create your secrets file manually. Skip the copy command if
you already have a `~/.config/zsh/secrets.env` file:

```sh
cp -n ~/.config/zsh/secrets.zsh.example ~/.config/zsh/secrets.env
chmod 600 ~/.config/zsh/secrets.env
nvim ~/.config/zsh/secrets.env
```

Fill in your API keys in `secrets.env`, leaving the tracked example empty. The
local file stays outside this repository and is not managed by Stow or either
Make target. Repeat this step on each machine that needs these credentials.

Open a new terminal to load the values. The shell also starts normally without a
secrets file.
