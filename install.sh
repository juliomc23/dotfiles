#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${HOME}/dotfiles"
BACKUP_DIR="${HOME}/dotfiles_backup/$(date +'%Y-%m-%d-%H%M%S')"
CONFIG_SOURCE="${REPO_DIR}/.config"
ZSH_SOURCE="${REPO_DIR}/.zshrc"

# -------------------------
# Helpers
# -------------------------

log() { printf "\n[+] %s\n" "$*"; }
warn() { printf "\n[!] %s\n" "$*" >&2; }

backup_and_link() {
  local src="$1"
  local dest="$2"

  if [ -e "${dest}" ] || [ -L "${dest}" ]; then
    mkdir -p "${BACKUP_DIR}"
    log "Backup de ${dest} -> ${BACKUP_DIR}"
    mv "${dest}" "${BACKUP_DIR}/"
  fi

  mkdir -p "$(dirname "${dest}")"
  ln -s "${src}" "${dest}"
  log "Enlace creado: ${dest} -> ${src}"
}

is_wsl() {
  grep -qi "microsoft" /proc/version 2>/dev/null
}

# -------------------------
# Comprobaciones iniciales
# -------------------------

log "Inicio de bootstrap para dotfiles"

if ! command -v git >/dev/null 2>&1; then
  warn "git no está instalado. Instalando git..."
  sudo apt update
  sudo apt install -y git
fi

if ! command -v curl >/dev/null 2>&1; then
  warn "curl no está instalado. Instalando curl..."
  sudo apt update
  sudo apt install -y curl
fi

if [ ! -d "${REPO_DIR}" ]; then
  warn "El repositorio ${REPO_DIR} no existe."
  warn "Clónalo con: git clone https://github.com/juliomc23/dotfiles.git \"${REPO_DIR}\""
  exit 1
fi

if is_wsl; then
  log "Entorno detectado: WSL sobre Windows"
else
  log "Entorno detectado: Ubuntu (no WSL)"
fi

# -------------------------
# Homebrew para Linux
# -------------------------

if ! command -v brew >/dev/null 2>&1; then
  log "Homebrew no encontrado. Instalando Homebrew para Linux..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Añadir brew al entorno actual
  if [ -d "/home/linuxbrew/.linuxbrew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [ -d "${HOME}/.linuxbrew" ]; then
    eval "$(${HOME}/.linuxbrew/bin/brew shellenv)"
  fi
else
  log "Homebrew ya está instalado."
  # Asegurar que brew está en el entorno actual
  if command -v brew >/dev/null 2>&1; then
    if [ -d "/home/linuxbrew/.linuxbrew" ]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [ -d "${HOME}/.linuxbrew" ]; then
      eval "$(${HOME}/.linuxbrew/bin/brew shellenv)"
    fi
  fi
fi

# -------------------------
# Paquetes con brew
# -------------------------

log "Actualizando Homebrew..."
brew update

log "Instalando herramientas con Homebrew..."
brew install \
  neovim \
  tmux \
  zellij \
  yazi \
  atuin \
  lazygit \
  fastfetch \
  eza \
  zoxide \
  starship \
  zsh \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  zsh-vi-mode

# -------------------------
# Enlaces de configuración
# -------------------------

log "Creando enlaces simbólicos de configuración..."

# .config completo (carpeta)
if [ -d "${CONFIG_SOURCE}" ]; then
  # Recorre todo lo que haya dentro de .config del repo
  find "${CONFIG_SOURCE}" -maxdepth 1 -mindepth 1 -print0 | while IFS= read -r -d '' item; do
    name="$(basename "${item}")"
    dest="${HOME}/.config/${name}"
    backup_and_link "${item}" "${dest}"
  done
else
  warn "No se encontró ${CONFIG_SOURCE}. Omite enlace de .config."
fi

# .zshrc
if [ -f "${ZSH_SOURCE}" ]; then
  backup_and_link "${ZSH_SOURCE}" "${HOME}/.zshrc"
else
  warn "No se encontró ${ZSH_SOURCE}. Omite enlace de .zshrc."
fi

# -------------------------
# Asegurar brew en la shell
# -------------------------

BREW_PREFIX="$(brew --prefix 2>/dev/null || true)"

if [ -n "${BREW_PREFIX}" ]; then
  # Añade el shellenv de brew a .zprofile/.zshrc si no existe
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

# -------------------------
# Cambiar shell por defecto a zsh
# -------------------------

if command -v zsh >/dev/null 2>&1; then
  CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7 || echo "")"
  ZSH_PATH="$(command -v zsh)"

  if [ "${CURRENT_SHELL}" != "${ZSH_PATH}" ]; then
    log "Cambiando shell por defecto a zsh para el usuario ${USER}"
    chsh -s "${ZSH_PATH}" || warn "No se pudo cambiar la shell por defecto. Hazlo manualmente con: chsh -s \"${ZSH_PATH}\""
  else
    log "zsh ya es la shell por defecto."
  fi
else
  warn "zsh no se encontró en el sistema después de la instalación."
fi

log "Bootstrap completado. Cierra y abre la terminal (o sesión) para aplicar todos los cambios."

