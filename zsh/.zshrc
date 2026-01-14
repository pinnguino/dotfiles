# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt nomatch
unsetopt autocd beep extendedglob notify
bindkey -e
# End of lines configured by zsh-newuser-install

## Aliases ##
alias v='nvim'
alias c='clear'

# Better ls
alias l='lsd'
alias ls='lsd'
alias ll='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'

# Better cat
alias cat='batcat'

# Git aliases
alias g='git'
alias gst='git status'
alias gbr='git branch'
alias gci='git commit'
alias gad='git add'
alias glg='git log --pretty=format:"%C(magenta)%h%Creset -%C(red)%d%Creset %s %C(dim green)(%cr) [%an]" --abbrev-commit'

## Completion ##
autoload -Uz compinit
compinit

## Prompt ##
git_status() {
	# Verificar si estamos en un repo git
	if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		# Nombre de la rama (limpio, sin el icono interno para controlarlo mejor)
		local branch_name=$(git branch --show-current 2> /dev/null)
		local status_output=$(git status --porcelain -b 2>/dev/null)
		local upstream_info=$(echo "$status_output" | head -n 1)
		local indicators=""

		# Ahead / Behind
		[[ "$upstream_info" =~ "ahead" ]] && indicators+="↑"
		[[ "$upstream_info" =~ "behind" ]] && indicators+="↓"

		# Deleted, Untracked, Modified, Staged
		echo "$status_output" | grep -qE "D | D" && indicators+="x"
		echo "$status_output" | grep -q "^??" && indicators+="?"
		echo "$status_output" | grep -q "^ M" && indicators+="!"
		echo "$status_output" | grep -qE "^(M|A|R|C) " && indicators+="+"

		if [ -n "$indicators" ]; then
			echo " $branch_name $indicators"
		else
			echo " $branch_name"
		fi
	fi
}

# --- Prompt Sign ---
prompt_sign() {
	if [[ "$EUID" -eq 0 ]]; then
		echo "󰈸 "
	else
		echo "  "
	fi
}

# Enable function expansion in zsh prompt
setopt PROMPT_SUBST

PROMPT='
%F{#BB9AF7}%~%f  %F{#7AA2F7}$(git_status)%f
%F{#C0CAF5}%n%f %F{#9ECE6A}$(prompt_sign)%f'

RPROMPT='%F{#7AA2F7}%K{#7AA2F7}%F{#1A1B26}%B zsh %b%f%k'

# --- SSH Agent ---
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

## PATH
export PATH="$HOME/.local/bin:$PATH"
# export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
# export PATH="$PATH:$HOME/go/bin"

# Plugins
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
