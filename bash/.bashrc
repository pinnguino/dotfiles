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
		# Git branch
		local branch_name=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/')

		# Git status
		local status_output=$(git status --porcelain -b 2>/dev/null)

		# Upstream info
		local upstream_info=$(echo "$status_output" | head -n 1 | grep "^##")
		
		local indicators=""

		# If the local branch is ahead (the remote branch is behind)
		if echo "$upstream_info" | grep -q "\[ahead [0-9]\+\]"; then
			indicators+="↑"
		fi

		# If the remote branch is ahead (the local branch is behind)
		if echo "$upstream_info" | grep -q "\[behind [0-9]\+\]"; then
			indicators+="↓"
		fi		

		# Deleted files #
		if echo "$status_output" | grep -q "D " || echo "$status_output" | grep -q " D"; then
			indicators+="x"
		fi

		# Unstaged changes #
		# Untracked files
		if echo "$status_output" | grep -q "^??"; then
			indicators+="?"
		fi

		# Modified files
		if echo "$status_output" | grep -q "^ M"; then
			indicators+="!"
		fi


		# Staged changes #
		# M = Modified, A = Added, D = Deleted (staged), R = Renamed, C = Copied
		if echo "$status_output" | grep -q "^M " || \
			echo "$status_output" | grep -q "^A " || \
			echo "$status_output" | grep -q "^R " || \
			echo "$status_output" | grep -q "^C "; then
		indicators+="+"
		fi

		
		local full_git_info="$branch_name"
		if [ -n "$indicators" ]; then
			full_git_info+=" ${indicators}"
		fi
		echo "${full_git_info}"
	fi
}

prompt_sign() {
	if [[ "$(whoami)" == "root" ]]; then
		echo "󰈸 "
	else
		echo "  "
	fi
}

PROMPT_COMMAND='echo'
PS1='\[\e[1;38;2;187;154;247m\]\w\[\e[0m\]  '						# cwd
PS1+='\[\e[38;2;122;162;247m\]$(git_status)\[\e[0m\]\n'			# git status
PS1+='\[\e[38;2;192;202;245m\]\u\[\e[0m\] '						# username
PS1+='\[\e[38;2;158;206;106m\]$(prompt_sign)\[\e[0m\]'			# prompt sign

# Autorun
# fastfetch
