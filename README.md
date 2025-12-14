# Dotfiles

Mi configuración personal para desarrollo.

## 🚀 Instalación rápida

```bash
git clone https://github.com/juliomc23/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## 📦 Incluye

- **Zsh** con Oh My Zsh - shell moderno
- **Starship** - prompt personalizado
- **Eza** - ls moderno con colores
- **Zoxide** - cd inteligente
- **Yazi** - file manager terminal
- **Atuin** - historial de comandos mejorado
- **Neovim** - editor con configuración LazyVim
- **Tmux** - multiplexor de terminal
- **Zellij** - workspace moderno
- **LazyGit** - interfaz git visual
- **Fastfetch** - información del sistema
- **Bun** - runtime JavaScript/TypeScript
- **NVM** - gestor de Node.js

## 🔧 Instalación manual

Si prefieres instalar paso a paso:

### 1. Clonar repositorio
```bash
git clone https://github.com/juliomc23/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Instalar dependencias

**Ubuntu/Debian:**
```bash
# Instalar Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Instalar dependencias del sistema
sudo apt update
sudo apt install build-essential curl file git

# Instalar paquetes
brew install zsh tmux neovim starship zellij yazi atuin lazygit fastfetch eza zoxide zsh-autosuggestions zsh-syntax-highlighting zsh-vi-mode

# Instalar herramientas adicionales
curl -fsSL https://bun.sh/install | bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
```

**macOS:**
```bash
brew install zsh tmux neovim starship zellij yazi atuin lazygit fastfetch eza zoxide zsh-autosuggestions zsh-syntax-highlighting zsh-vi-mode

# Instalar herramientas adicionales
curl -fsSL https://bun.sh/install | bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
```

### 3. Crear enlaces simbólicos
```bash
ln -sf ~/.dotfiles/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/.dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/.dotfiles/.config/zellij ~/.config/zellij
ln -sf ~/.dotfiles/.config/yazi ~/.config/yazi
ln -sf ~/.dotfiles/.config/atuin ~/.config/atuin
ln -sf ~/.dotfiles/.config/lazygit ~/.config/lazygit
ln -sf ~/.dotfiles/.config/fastfetch ~/.config/fastfetch
ln -sf ~/.dotfiles/.config/starship.toml ~/.config/starship.toml
```

## 🐛 Solución de problemas

### Error: comando no encontrado
Asegúrate de que los binarios estén en tu PATH:
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
```

### Neovim no encuentra plugins
Ejecuta dentro de Neovim:
```vim
:Lazy sync
```

### Zsh no es el shell por defecto
```bash
chsh -s $(which zsh)
```

## 🔄 Actualizar configuración

```bash
cd ~/.dotfiles
git pull
./install.sh
```
