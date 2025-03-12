# Dotfiles

My file configuration to work with nvim, zellij and zsh

## First of all

Update bash

```bash
sudo apt-get update
sudo apt-get upgrade
```

## Installation

Follow these steps to get everything working

### 1.- Install Homebrew and run everything Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Add Hombrew to your shell configuration and restart your shell

```bash

echo >> /home/test/.bashrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/test/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

source .bashrc
```

### 3.- Install build-essential

```bash
sudo apt-get install build-essential
```

### 4.- Install this plugins

```bash
brew install nvim gcc fzf fd ripgrep zsh zsh-autosuggestions zsh-syntax-highlighting zellij eza starship zoxide
```

### 5.- Add to /etc/shells zsh as your shell

```bash
echo "$(which zsh)" | sudo tee -a /etc/shells

chsh -s $(which zsh)
```

### 6.- Install Iosevka Term Nerd Font

### 7.- Finally clone the repository and move the .config folders and the .zshrc file to your home directory which should be your home directory

```bash
mv dotfiles/.config dotfiles/.zshrc ./
```
