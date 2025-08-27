# Colors
$color_cwd = $PSStyle.Foreground.FromRGB(187, 154, 247)
$color_git = $PSStyle.Foreground.FromRGB(122, 162, 247)
$color_username = $PSStyle.Foreground.FromRGB(192, 202, 145)
$color_prompt_sign = $PSStyle.Foreground.FromRGB(158, 206, 106)

# Aliases
function Lsd-l {lsd -l}
function Lsd-a {lsd -a}
function Lsd-la {lsd -la}

New-Alias -Name v -Value nvim -Force
New-Alias -Name c -Value cls -Force
New-Alias -Name touch -Value New-Item -Force
New-Alias -Name l -Value lsd -Force
New-Alias -Name ll -Value Lsd-l -Description "lsd" -Force
New-Alias -Name la -Value Lsd-a -Description "lsd" -Force
New-Alias -Name lla -Value Lsd-la -Description "lsd" -Force

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$adminRole = ([Security.Principal.WindowsBuiltInRole]::Administrator)
$isAdmin = $currentPrincipal.IsInRole($adminRole)

function prompt {
	# CWD
	$path = (Get-Location).Path.Replace($env:USERPROFILE, "~")

	# Git info
	$gitStatusOutput = & { git status --porcelain=v1 --ignore-submodules 2>$null }

	if ($LASTEXITCODE -eq 0) {
		$branch = & { git rev-parse --abbrev-ref HEAD 2>$null }

		$untracked = $false
		$modified = $false
		$deleted = $false

		foreach ($line in $gitStatusOutput) {
			if ($line[0] -eq '?' -or $line[1] -eq '?') {
				$untracked = $true
			}
			if ($line[0] -eq 'M' -or $line[1] -eq 'M') {
				$modified = $true
			}
			if ($line[0] -eq 'D' -or $line[1] -eq 'D') {
				$deleted = $true
			}
		}

		$git_info = "   $branch "
		if($untracked) { $git_info += "?"}
		if($modified) { $git_info += "!"}
		if($deleted) { $git_info += "x"}
	}
	# Username and prompt sign
	if ($isAdmin) {
		$user = "admin"
	}
	else {
		$user = $env:USERNAME
	}
	$prompt_sign = ""
	"`n$($color_cwd)$($path)$($color_git)$($git_info)`n$($PSStyle.Reset)$($user)$($color_prompt_sign) $($prompt_sign) "
}

