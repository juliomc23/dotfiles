# Dotfiles

Configuración personal de desarrollo **portable, reproducible e idempotente** basada en **symlinks**.

Pensada para mover todo el flujo de trabajo a cualquier PC (Linux / WSL) sin perder configuración.

---

## 🚀 Instalación rápida

```bash
git clone https://github.com/juliomc23/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

📌 El script:

* Instala dependencias
* Crea **enlaces simbólicos** (no copias)
* Hace **backup automático** si existen configs previas
* Es **re-ejecutable** sin romper nada

---

## 🧠 Filosofía

* ❌ Nada de copias → **symlinks**
* ❌ Nada de Oh My Zsh (bloat)
* ✅ Zsh limpio + plugins explícitos
* ✅ Homebrew solo en `.zprofile`
* ✅ Un solo script (`install.sh`)

---

## 📦 Incluye

### Shell & Prompt

* **Zsh** (Homebrew)
* **Starship** (prompt)
* **zsh-autosuggestions**
* **zsh-syntax-highlighting**
* **zsh-vi-mode**

### Terminal workflow

* **Tmux** + TPM (Plugin Manager)
* **Catppuccin** (via TPM)
* **Zoxide** (cd inteligente)
* **Atuin** (historial avanzado)
* **Eza** (ls moderno)
* **Yazi** (file manager)
* **LazyGit** (Git TUI)

### Dev tools

* **Neovim** (config en `.config/nvim`)
* **fzf**, **fd**, **ripgrep**
* **gcc / build-essential**

⚠️ **WezTerm NO se instala automáticamente**

* Solo se crea el symlink a `~/.wezterm.lua`
* La instalación se hace manualmente (empresa / PowerShell)

---

## 📁 Estructura del repo

```text
.dotfiles/
├── .config/
│   ├── nvim/
│   ├── yazi/
│   ├── atuin/
│   ├── lazygit/
│   └── ...
├── .tmux.conf
├── .zshrc
├── .wezterm.lua
├── install.sh
└── README.md
```

---

## 🔧 Qué hace exactamente `install.sh`

* Detecta Ubuntu / WSL
* Instala dependencias del sistema
* Instala Homebrew (Linux)
* Instala herramientas con Homebrew
* Crea **symlinks seguros** (con backup previo)
* Configura Homebrew en `.zprofile`
* Instala **TPM** (Tmux Plugin Manager)
* Cambia la shell por defecto a **zsh (brew)**

Backups se guardan en:

```text
~/dotfiles_backup/YYYY-MM-DD-HHMMSS/
```

---

## 🎨 Tmux + Catppuccin (IMPORTANTE)

Después de instalar en un PC nuevo:

1. Abre tmux:

   ```bash
   tmux
   ```

2. Instala los plugins (una sola vez):

   ```text
   Ctrl + b  →  Shift + I
   ```

3. Recarga la config:

   ```text
   Ctrl + b  →  r
   ```

👉 **Sin esto, Catppuccin NO se cargará** (es comportamiento normal de tmux).

---

## 🔄 Actualizar configuración

```bash
cd ~/.dotfiles
git pull
./install.sh
```

Los cambios se reflejan automáticamente gracias a los **symlinks**.

---

## 🐛 Troubleshooting

### Tmux no carga el theme

* Asegúrate de haber ejecutado `Ctrl+b + I`
* Verifica que existen plugins en `~/.tmux/plugins/`

### Cambios en dotfiles no se reflejan

* Verifica que el archivo es un **symlink**:

  ```bash
  ls -l ~/.zshrc
  ```

### Zsh no es la shell por defecto

```bash
chsh -s $(brew --prefix)/bin/zsh
```

---

## 📌 Notas finales

Este repo está pensado para:

* Devs que usan **tmux + nvim**
* Entornos corporativos (WSL / restricciones)
* Reproducibilidad sin magia

Si algo se rompe, **el script no borra nada**, siempre hace backup primero.

---

🚀 *Clona, ejecuta y sigue trabajando como en tu máquina principal.*
