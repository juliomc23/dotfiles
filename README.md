# 1) Dependencias mínimas
sudo apt update
sudo apt install -y git curl build-essential stow

# 2) Clonar el repo
git clone git@github.com:juliomc23/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 3) Ejecutar instalación completa
chmod +x install.sh
./install.sh
