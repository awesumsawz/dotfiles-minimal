# ==================================================
# TOOL CONFIGURATIONS
# ----START-----------------------------------------
# fzf
eval "$(fzf --zsh)"
# starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)" 
# zoxide
eval "$(zoxide init zsh)"
# thefuck
eval "$(thefuck --alias fix)"
# eza
export EZA_CONFIG_DIR="$HOME/.config/eza"
export LS_COLORS="$(vivid generate dracula)"
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# ----END-------------------------------------------
