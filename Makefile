.DEFAULT_GOAL := install

STOW_PACKAGES := zshrc ghostty herdr

# Find Homebrew and its tools before shell startup files have been configured.
export PATH := $(PATH):/opt/homebrew/bin:/usr/local/bin

.PHONY: homebrew install update

homebrew:
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "Installing Homebrew..."; \
		installer="$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
		/bin/bash -c "$$installer"; \
	fi

install: homebrew
	command brew bundle install --no-upgrade --file=homebrew/Brewfile
	command stow --verbose --no-folding --target="$(HOME)" $(STOW_PACKAGES)

update: homebrew
	command brew bundle install --file=homebrew/Brewfile
	command stow --restow --verbose --no-folding --target="$(HOME)" $(STOW_PACKAGES)
