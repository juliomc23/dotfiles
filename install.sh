#!/usr/bin/env bash
set -euo pipefail

# =========================================================
# Paths
# =========================================================
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date +'%Y-%m-%d-%H%M%S')"
BACKUP_DIR="${HOME}/dotfiles_backup/${TIMESTAMP}"

log() { printf "\n[+] %s\n" "$*"; }
warn() { printf "\n[!] %s\n" "$*" >&2; }

# =========================================================
# Utils
# =========================================================
is_wsl() {
  grep -qi "microsoft" /proc/version 2>/dev/null
}

backup() {
  mkdir -p "${BACKUP_DIR}"
  mv "$1" "${BACKUP_DIR}/"
}

link() {
  local src="$1"
  local dest="$2"

  if [ -L "${dest}" ]; then
    if [ "$(readlink "${dest}")" = "${src}" ]; then
      log "Symlink correcto: ${dest}"
      return
    else
      log "Symlink incorrecto, moviendo a backup: ${dest}"
      backup "${dest}"
    fi
  elif [ -e "${dest}" ]; then
    log "Archivo existente, moviendo a backup: ${dest}"
    backup "${dest}"
  fi

  mkdir -p "$(dirname "${dest}")"
  ln -s "${src}" "${dest}"
  log "Symlink creado: ${dest} → ${src}"
}

# =========================================================
# Detect OS
# =========================================================
log "Detectando entorno..."

if is_wsl; then
  log "Entorno detectado: WSL (Ubuntu)"
else
  log "Entorno detectado: Ubuntu"
fi

# =========================================================
# System dependencies
# =========================================================
log "Instalando dependencias básicas del sistema..."
sudo apt update
sudo apt install -y --no-install-recommends \
  git \
  curl \
  build-essential

# =========================================================
# Homebrew (Linux)
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

eval "$(${BREW_PREFIX}/bin/brew shellenv)"

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
# Dotfiles (symlinks)
# =========================================================
log "Instalando dotfiles (symlinks)..."

# .config/*
if [ -d "${REPO_DIR}/.config" ]; then
  find "${REPO_DIR}/.config" -mindepth 1 -maxdepth 1 -print0 |
    while IFS= read -r -d '' item; do
      name="$(basename "${item}")"
      link "${item}" "${HOME}/.config/${name}"
    done
else
  warn "No existe .config en el repo"
fi

# ~/.zshrc
[ -f "${REPO_DIR}/.zshrc" ] && link "${REPO_DIR}/.zshrc" "${HOME}/.zshrc"

# ~/.tmux.conf
[ -f "${REPO_DIR}/.tmux.conf" ] && link "${REPO_DIR}/.tmux.conf" "${HOME}/.tmux.conf"

# ~/.wezterm.lua (solo link, no instalación)
[ -f "${REPO_DIR}/.wezterm.lua" ] && link "${REPO_DIR}/.wezterm.lua" "${HOME}/.wezterm.lua"

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

log "Instalación completada correctamente 🎉"
log "Reinicia la sesión o ejecuta: exec zsh"
