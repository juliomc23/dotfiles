#!/usr/bin/env bash
set -euo pipefail

# =========================================================
# Paths
# =========================================================
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { printf "\n[+] %s\n" "$*"; }
warn() { printf "\n[!] %s\n" "$*" >&2; }

# =========================================================
# Detect OS (solo log)
# =========================================================
is_wsl() {
  grep -qi "microsoft" /proc/version 2>/dev/null
}

log "Detectando entorno..."

if is_wsl; then
  log "Entorno detectado: WSL (Ubuntu)"
else
  log "Entorno detectado: Ubuntu"
fi

# =========================================================
# Homebrew (Linux)
#  (git, curl, build-essential y stow se instalan ANTES, fuera del script)
# =========================================================
if ! command -v brew >/dev/null 2>&1; then
  log "Homebrew no encontrado. Instalando..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ -d "/home/linuxbrew/.linuxbrew" ]; then
  BREW_PREFIX="/home/linuxbrew/.linuxbrew"
elif [ -d "${HOME}/.linuxbrew" ]; then
  BREW_PREFIX="${HOME}/.linuxbrew"
else
  warn "No se pudo detectar Homebrew prefix"
  exit 1
fi

eval "$("${BREW_PREFIX}/bin/brew" shellenv)"

log "Actualizando Homebrew..."
brew update

# =========================================================
# Packages
# =========================================================
log "Instalando herramientas con Homebrew..."

brew install \
  zsh \
  neovim \
  tmux \
  zoxide \
  eza \
  atuin \
  yazi \
  lazygit \
  starship \
  fzf \
  fd \
  ripgrep \
  gcc \
  opencode \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  zsh-vi-mode

# =========================================================
# Zprofile (Homebrew env)
# =========================================================
ZPROFILE="${HOME}/.zprofile"
BREW_LINE="eval \"\$(${BREW_PREFIX}/bin/brew shellenv)\""

if [ ! -f "${ZPROFILE}" ] || ! grep -Fq "${BREW_LINE}" "${ZPROFILE}"; then
  log "Configurando Homebrew en ~/.zprofile"
  printf '\n%s\n' "${BREW_LINE}" >>"${ZPROFILE}"
fi

# =========================================================
# Tmux Plugin Manager
# =========================================================
TPM_DIR="${HOME}/.tmux/plugins/tpm"

if [ ! -d "${TPM_DIR}" ]; then
  log "Instalando Tmux Plugin Manager (TPM)..."
  git clone https://github.com/tmux-plugins/tpm "${TPM_DIR}"
else
  log "TPM ya está instalado"
fi

# =========================================================
# Default shell → Zsh (brew)
# =========================================================
ZSH_PATH="${BREW_PREFIX}/bin/zsh"

if [ -x "${ZSH_PATH}" ]; then
  if ! grep -Fxq "${ZSH_PATH}" /etc/shells; then
    log "Añadiendo ${ZSH_PATH} a /etc/shells"
    echo "${ZSH_PATH}" | sudo tee -a /etc/shells >/dev/null
  fi

  CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7 || true)"

  if [ "${CURRENT_SHELL}" != "${ZSH_PATH}" ]; then
    log "Cambiando shell por defecto a zsh"
    chsh -s "${ZSH_PATH}" || warn "No se pudo cambiar la shell automáticamente"
  else
    log "zsh ya es la shell por defecto"
  fi
else
  warn "zsh no encontrado en ${ZSH_PATH}"
fi

# =========================================================
# Dotfiles con Stow
# =========================================================
log "Creando symlinks de dotfiles con Stow..."

cd "${REPO_DIR}"

# Asumiendo paquetes:
#  zsh/.zshrc
#  tmux/.tmux.conf
#  wezterm/.wezterm.lua
#  config/.config/{atuin,lazygit,nvim,opencode,yazi,starship.toml}
stow zsh tmux wezterm config

log "Instalación completada correctamente 🎉"
log "Reinicia la sesión o ejecuta: exec zsh"
