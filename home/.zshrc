# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="bureau"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# My global vars
export PATH="$HOME/.config/nvim/lsp_servers/lua-language-server/bin:$PATH"
