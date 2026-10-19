.DEFAULT_GOAL := install

STOW_PACKAGES := zshrc ghostty herdr ideavim

# Find Homebrew and its tools before shell startup files have been configured.
export PATH := $(PATH):/opt/homebrew/bin:/usr/local/bin

.PHONY: homebrew oh-my-zsh install update

homebrew:
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "Installing Homebrew..."; \
		installer="$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
		/bin/bash -c "$$installer"; \
	fi

oh-my-zsh: homebrew
	@if [ ! -f "$(HOME)/.oh-my-zsh/oh-my-zsh.sh" ]; then \
		command git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$(HOME)/.oh-my-zsh"; \
	fi

install: oh-my-zsh
	command brew bundle install --no-upgrade --file=homebrew/Brewfile
	command stow --verbose --no-folding --target="$(HOME)" $(STOW_PACKAGES)

update: oh-my-zsh
	command brew bundle install --file=homebrew/Brewfile
	ZSH="$(HOME)/.oh-my-zsh" /bin/zsh -f "$(HOME)/.oh-my-zsh/tools/upgrade.sh" -v minimal
	command stow --restow --verbose --no-folding --target="$(HOME)" $(STOW_PACKAGES)
