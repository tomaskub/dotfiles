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
without upgrading existing packages, then link the Zsh, Ghostty, Herdr, IdeaVim, Git and GitHub CLI and mitmproxy configurations into your home directory:

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

## Restore Neovim configuration

`make install` installs Neovim from the Brewfile. Its configuration lives in the
separate [tomaskub/nvim repository](https://github.com/tomaskub/nvim) and needs a
one-time restore after installation. With GitHub SSH access configured, run:

```sh
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}"
git clone git@github.com:tomaskub/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
nvim
```

Before cloning, check for an existing `nvim` directory or symlink at that path.
If it is already a checkout of `tomaskub/nvim`, keep it and use the update steps
below. Otherwise, back it up and move it before cloning. Do not clone over an
existing configuration. If SSH access is unavailable, use
`https://github.com/tomaskub/nvim.git` as the clone URL instead.

The first launch bootstraps lazy.nvim and installs the configured plugins, so it
needs network access. The plugin definitions, lockfile, and Xcode integration
stay in the Neovim repository. Follow that repository for any additional plugin
setup. Installing the dotfiles alone does not set up Xcode or its debugger.

Update the configuration separately from `make update`:

```sh
git -C "${XDG_CONFIG_HOME:-$HOME/.config}/nvim" status --short
git -C "${XDG_CONFIG_HOME:-$HOME/.config}/nvim" pull --ff-only
```

Review and commit or back up local edits before pulling. `--ff-only` stops if the
local branch has diverged. To update plugins, open Neovim and run `:Lazy`; review
changes to `lazy-lock.json` in the Neovim repository. Neither Make target nor Stow
manages this separate checkout.
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
Zsh using its own updater, update Powerlevel10k, and refresh the links for added
or removed configuration files:

```sh
git pull
make update
```

## GitHub CLI

Stow manages `~/.config/gh/config.yml`, preserving SSH transport, Neovim editing,
interactive prompt preferences, and the `gh co` alias for `gh pr checkout`.
Before the first install on an existing machine, back up and move only a
conflicting `~/.config/gh/config.yml`, then run `make install`.
Keep the `~/.config/gh` directory in place.

`hosts.yml` contains account authentication and stays local. The attachment
configuration in `attach.yml` also stays local to its source machine. Neither
file is managed by Stow. Authenticate separately on each new machine with
`gh auth login`; existing authentication and attachment settings remain in place.

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

## Utility configuration

### mitmproxy

The Brewfile installs mitmproxy. Stow links only `~/.mitmproxy/config.yaml`, which
selects the [horizontal console layout](https://docs.mitmproxy.org/stable/concepts/options/).
Back up and move an existing `config.yaml` before `make install`, then launch
`mitmproxy` to load it. Keep `~/.mitmproxy` as a real directory so private keys,
certificates, command history, and captured traffic remain local. The package's
ignore rules allow only `config.yaml` into version control.

On a new machine, mitmproxy [generates its own CA on first launch](https://docs.mitmproxy.org/stable/concepts/certificates/).
Configure your client proxy and certificate trust manually if needed. Review any
configuration saved from the interactive options editor before committing it;
the linked file must contain only settings safe to share.

### OpenSpec

The reviewed `~/.config/openspec/config.json` contains only generated telemetry
notice state and an anonymous identifier. It has no portable preferences to
restore, so setup leaves it local and OpenSpec recreates it as needed. Do not
copy the identifier between machines or add the generated file to a Stow package.
The [configuration reference](https://github.com/Fission-AI/OpenSpec/blob/main/docs-lab/reference/configuration/config-json.md)
describes those fields and optional telemetry controls.

If needed, install the CLI separately with the Brewfile's Node installation,
following the [OpenSpec installation instructions](https://github.com/Fission-AI/OpenSpec#quick-start):

```sh
npm install -g @fission-ai/openspec@latest
```

Run `openspec init` only inside the project that needs it. Project specs and agent
integration files belong to that project.
