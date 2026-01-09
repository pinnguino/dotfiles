# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# Aliases
alias v='nvim'
alias c='clear'
alias l='lsd'
alias ls='lsd'
alias ll='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'

# Prompt

git_status() {
	if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		# Obtener nombre de la rama
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

		# Construir salida: Icono + Nombre + Indicadores
		if [ -n "$indicators" ]; then
			echo " $branch_name $indicators"
		else
			echo " $branch_name"
		fi
	fi
}

prompt_sign() {
	if [[ "$(whoami)" == "root" ]]; then
		echo "󰈸 "
	else
		echo "  "
	fi
}

COLOR_DIR='\[\e[1;38;2;187;154;247m\]'
COLOR_GIT='\[\e[38;2;122;162;247m\]'
COLOR_USER='\[\e[38;2;192;202;245m\]'
COLOR_SIGN='\[\e[38;2;158;206;106m\]'
RESET='\[\e[0m\]'

PROMPT_COMMAND='echo'
PS1="${COLOR_DIR}\w${RESET}  ${COLOR_GIT}\$(git_status)${RESET}\n"
PS1+="${COLOR_USER}\u${RESET} ${COLOR_SIGN}\$(prompt_sign)${RESET}"
if [ -z "$SSH_AUTH_SOCK" ]; then
	eval "$(ssh-agent -s)" > /dev/null
	# Añade la llave específica que creamos para GitHub
	ssh-add ~/.ssh/github 2>/dev/null
fi

# Autorun
# fastfetch
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
export PATH=$PATH:$HOME/go/bin
