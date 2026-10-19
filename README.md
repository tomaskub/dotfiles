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
without upgrading existing packages, then link the Zsh, Ghostty, Herdr, and
mitmproxy configurations and the yt-smzr example into your home directory:

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

## Utility configuration

### yt-smzr

The `yt-smzr` package links `~/.yt-smzr.toml.example`. It preserves the OpenRouter
provider and model selection and the local Ollama endpoint and timeout. Copy it
to the active path once, skipping the copy if `~/.yt-smzr.toml` already exists:

```sh
cp -n ~/.yt-smzr.toml.example ~/.yt-smzr.toml
```

The active file remains local because the application's settings screen replaces
it when saving. `make update` refreshes the example without overwriting saved
choices. Keep `OPENROUTER_API_KEY` in `~/.config/zsh/secrets.env` as described above,
then open a new terminal. API keys never belong in the TOML file. The saved model
must be available to your OpenRouter account; edit the local file to select
another model. `YT_SMZR_SUMMARIZATION_PROVIDER` and
`YT_SMZR_SUMMARIZATION_MODEL` override the saved choices.

Install [yt-smzr from its source repository](https://github.com/tomaskub/yt-smzr)
separately. The Brewfile provides uv, FFmpeg, and Node for its workflow. In a new
checkout:

```sh
git clone https://github.com/tomaskub/yt-smzr.git ~/workspace/yt-smzr
cd ~/workspace/yt-smzr
uv python install 3.12
uv sync --locked
uv run yt-smzr tui
```

Its default `.yt-smzr/` output directory contains the database, transcripts, and
summaries relative to the working directory. Keep it outside this repository.
Ollama is optional for the selected OpenRouter provider. To use it, start
`ollama serve`, install a model yourself, and change the local provider and model
settings. Setup does not download models or start services.

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
