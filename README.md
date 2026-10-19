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
without upgrading existing packages, then link the Zsh, Ghostty, and Herdr
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

## Powerlevel10k prompt

Both Make targets clone [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
if missing into `~/.oh-my-zsh/custom/themes/powerlevel10k`. If you export
`ZSH_CUSTOM`, they use its `themes/powerlevel10k` directory instead, matching
Oh My Zsh. `make install` leaves an existing theme checkout unchanged;
`make update` updates it with `git pull --ff-only`.

The Zsh package links `~/.p10k.zsh` and loads the preserved rainbow, single-line
prompt with transient and instant prompts enabled. Before installing over an
existing setup, back up and move any conflicting `~/.p10k.zsh` and `~/.zshrc`.
Then run `make install` or `make update` and open a new terminal.

The saved prompt uses Nerd Font v3 icons and Powerline glyphs. Install and select
MesloLGS NF in each terminal's font settings using the
[Powerlevel10k font instructions](https://github.com/romkatv/powerlevel10k#fonts).
Font selection remains a manual step. Instant prompt caches are generated locally
under `${XDG_CACHE_HOME:-$HOME/.cache}` and are not tracked.

## Update

Pull the latest dotfiles, install or upgrade the listed packages, update Oh My
Zsh using its own updater, update Powerlevel10k, and refresh the links for added
or removed configuration files:

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
