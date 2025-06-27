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

git_status() {
    # Check if cwd is a git repository
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        return
    fi

	# Get branch name and status
    local branch_name=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    local status_output=$(git status --porcelain -b 2>/dev/null)

    local indicators=""
    local upstream_info=$(echo "$status_output" | head -n 1)

	# If the local branch is ahead
    if [[ "$upstream_info" =~ \[ahead\ [0-9]+\] ]]; then
        indicators+="↑"
    fi

	# If the remote branch is ahead
    if [[ "$upstream_info" =~ \[behind\ [0-9]+\] ]]; then
        indicators+="↓"
    fi

	# Removed files
    if [[ "$status_output" =~ D\  || "$status_output" =~ \ D ]]; then
        indicators+="✗"
    fi

	# Untracked files
    if [[ "$status_output" =~ \n\?\? || "$status_output" =~ ^\?\? ]]; then
        indicators+="?"
    fi

	# Modified files (unstaged)
    if [[ "$status_output" =~ \n\ M || "$status_output" =~ ^\ M ]]; then
        indicators+="!"
    fi

	# Staged changes
    if [[ "$status_output" =~ \n[MARC]\  || "$status_output" =~ ^[MARC]\  ]]; then
        indicators+="+"
    fi
    
    local full_git_info=" ${branch_name}"
    # local full_git_info=" ${branch_name}"
	

    if [ -n "$indicators" ]; then
        full_git_info+=" ${indicators}"
    fi
    echo "${full_git_info}"
}

prompt_sign() {
	if [[ "$(whoami)" == "root" ]]; then
		echo "󰈸 "
	else
		echo " "
	fi
}

# Prompt
PROMPT_COMMAND='echo'
PS1='\[\e[1;38;2;187;154;247m\]\w\[\e[0m\]  '						# cwd
PS1+='\[\e[38;2;122;162;247m\]$(git_status)\[\e[0m\]\n'			# git status
PS1+='\[\e[38;2;192;202;245m\]\u\[\e[0m\] '						# username
PS1+='\[\e[38;2;158;206;106m\]$(prompt_sign)\[\e[0m\]'			# prompt sign

# Autorun
# fastfetch
