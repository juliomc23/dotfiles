#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${HOME}/dotfiles_backup/$(date +'%Y-%m-%d-%H%M%S')}"

log() { printf "\n[+] %s\n" "$*"; }
warn() { printf "\n[!] %s\n" "$*" >&2; }

backup_and_copy() {
  local src="$1"
  local dest="$2"

  if [ -e "${dest}" ] || [ -L "${dest}" ]; then
    mkdir -p "${BACKUP_DIR}"
    log "Backup de ${dest} -> ${BACKUP_DIR}"
    mv "${dest}" "${BACKUP_DIR}/"
  fi

  mkdir -p "$(dirname "${dest}")"
  log "Copiando ${src} -> ${dest}"
  cp -r "${src}" "${dest}"
}

is_wsl() {
  grep -qi "microsoft" /proc/version 2>/dev/null
}

log "Instalación de entorno (Ubuntu/WSL)"

if is_wsl; then
  log "Entorno detectado: WSL (Ubuntu)"
else
  log "Entorno detectado: Ubuntu"
fi

# -------------------------
# Dependencias básicas de sistema
# -------------------------

log "Instalando dependencias de sistema (git, curl, build-essential)..."
sudo apt update
sudo apt install -y git curl build-essential

# -------------------------
# Homebrew en Linux
# -------------------------

if ! command -v brew >/dev/null 2>&1; then
  log "Homebrew no encontrado. Instalando Homebrew para Linux..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [ -d "/home/linuxbrew/.linuxbrew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [ -d "${HOME}/.linuxbrew" ]; then
    eval "$(${HOME}/.linuxbrew/bin/brew shellenv)"
  fi
else
  log "Homebrew ya está instalado."
  if [ -d "/home/linuxbrew/.linuxbrew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [ -d "${HOME}/.linuxbrew" ]; then
    eval "$(${HOME}/.linuxbrew/bin/brew shellenv)"
  fi
fi

log "Actualizando Homebrew..."
brew update

log "Instalando herramientas con Homebrew..."
brew install \
  zsh \
  neovim \
  zellij \
  tmux \
  zoxide \
  eza \
  atuin \
  yazi \
  zsh-syntax-highlighting \
  zsh-autosuggestions \
  zsh-vi-mode \
  lazygit

log "Instalando dotfiles desde ${REPO_DIR}"

# .config → ~/.config
if [ -d "${REPO_DIR}/.config" ]; then
  log "Procesando carpeta .config/"
  mkdir -p "${HOME}/.config"
  find "${REPO_DIR}/.config" -mindepth 1 -maxdepth 1 -print0 | while IFS= read -r -d '' item; do
    name="$(basename "${item}")"
    dest="${HOME}/.config/${name}"
    backup_and_copy "${item}" "${dest}"
  done
else
  warn "No se encontró ${REPO_DIR}/.config, se omite."
fi

# .zshrc → ~/.zshrc
if [ -f "${REPO_DIR}/.zshrc" ]; then
  backup_and_copy "${REPO_DIR}/.zshrc" "${HOME}/.zshrc"
else
  warn "No se encontró ${REPO_DIR}/.zshrc, se omite."
fi

# .tmux.conf → ~/.tmux.conf
if [ -f "${REPO_DIR}/.tmux.conf" ]; then
  backup_and_copy "${REPO_DIR}/.tmux.conf" "${HOME}/.tmux.conf"
fi

# Asegurar Homebrew en zsh
BREW_PREFIX="$(brew --prefix 2>/dev/null || true)"
if [ -n "${BREW_PREFIX}" ]; then
  SHELLENV_LINE="eval \"\$(${BREW_PREFIX}/bin/brew shellenv)\""

  if [ -f "${HOME}/.zprofile" ]; then
    if ! grep -Fq "${SHELLENV_LINE}" "${HOME}/.zprofile"; then
      log "Añadiendo Homebrew al entorno en ~/.zprofile"
      printf '\n%s\n' "${SHELLENV_LINE}" >>"${HOME}/.zprofile"
    fi
  else
    log "Creando ~/.zprofile con configuración de Homebrew"
    printf '%s\n' "${SHELLENV_LINE}" >"${HOME}/.zprofile"
  fi

  if [ -f "${HOME}/.zshrc" ] && ! grep -Fq "${SHELLENV_LINE}" "${HOME}/.zshrc"; then
    log "Añadiendo Homebrew al entorno en ~/.zshrc"
    printf '\n%s\n' "${SHELLENV_LINE}" >>"${HOME}/.zshrc"
  fi
fi

# Cambiar shell por defecto a zsh
if command -v zsh >/dev/null 2>&1; then
  ZSH_PATH="$(command -v zsh)"
  CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7 || echo "")"

  if ! grep -Fxq "${ZSH_PATH}" /etc/shells 2>/dev/null; then
    log "Añadiendo ${ZSH_PATH} a /etc/shells"
    echo "${ZSH_PATH}" | sudo tee -a /etc/shells >/dev/null
  fi

  if [ "${CURRENT_SHELL}" != "${ZSH_PATH}" ]; then
    log "Cambiando shell por defecto a zsh para el usuario ${USER}"
    chsh -s "${ZSH_PATH}" || warn "No se pudo cambiar la shell por defecto. Hazlo manualmente con: chsh -s \"${ZSH_PATH}\""
  else
    log "zsh ya es la shell por defecto."
  fi
else
  warn "zsh no está instalado correctamente."
fi

log "Instalación completada."
