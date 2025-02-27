# Dotfiles

My file configuration to work with nvim, zellij and zsh

## Installation

Follow these steps to get everything working

### 1.- Install Homebrew and run everything Homebrew recommends to do.

```bash
/bin/bash -c “$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)”
```

### 2.- Install zsh and the next plugins

```bash
brew install zsh zsh-autosuggestions zsh-syntax-highlighting
```

### 2.- Add to /etc/shells zsh as your shell

```bash
echo “$(which zsh)” | sudo tee -a /etc/shells
```

### 3.- Install zellij

```bash
brew install zellij
```

### 4.- Install eza and starship

```bash
brew install eza starship
```

### 5.- Finally clone the repository and move the .config folders and the .zshrc file to your home directory which should be your home directory

```bash
mv dotfiles/.config dotfiles/.zshrc ./
```
