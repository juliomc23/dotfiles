# ==========================
# 🟦 Environment Initialization
# ==========================

# Homebrew (Linuxbrew)
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Starship prompt
eval "$(starship init zsh)"

# Zoxide smart cd
eval "$(zoxide init zsh)"

# Bun
export PATH="/home/julio/.bun/bin:$PATH"
[ -s "/home/julio/.bun/_bun" ] && source "/home/julio/.bun/_bun"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Atuin
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi


# ==========================
# 🟦 Plugins
# ==========================

# Autosuggestions
source /home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting
source /home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Vi-mode navigation
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh


# ==========================
# 🟦 Aliases
# ==========================

alias ls='eza --icons'
alias lsa='eza -la --icons'
alias lg='lazygit'


function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

export EDITOR=nvim
eval "$(atuin init zsh)"
