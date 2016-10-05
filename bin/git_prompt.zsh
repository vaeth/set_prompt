#!/bin/zsh
# The above line is only meant for editors
# (C) Martin V\"ath <martin@mvath.de>

() {
	local s1 s2
	s1='%B%F{magenta}:%s:%b'
	s2='%c%u%m%f'
	zstyle ':vcs_info:*' actionformats $s1'|%a'$s2
	zstyle ':vcs_info:*' formats $s1$s2
}
# We check for changes except for those repositories where this is too costly:
# Presumably, these are "linux" and "gentoo"
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*:*:*linux*' check-for-changes false
zstyle ':vcs_info:*:*:*gentoo*' check-for-changes false

zstyle ':vcs_info:*' stagedstr ':S'
zstyle ':vcs_info:*' unstagedstr ':U'
zstyle ':vcs_info:git*:*:*' patch-format ':%a'
zstyle ':vcs_info:git*:*:*' nopatch-format ':%a'

# If git_update is in the path, use that for git
if (($+commands[git_update]))
then	zstyle ':vcs_info:git*:*:*' command $commands[git_update]
fi

# If GIT_UPDATE_USER is not set and we cannot drop permissions to "nobody",
# we export an empty GIT_UPDATE_USER to make git_update work without attempting
# to change permissions.
[[ -n "${GIT_UPDATE_USER++}" ]] || (
	USERNAME=nobody && [[ $USERNAME == nobody ]]
) >/dev/null 2>&1 || export GIT_UPDATE_USER=

autoload -Uz vcs_info add-zsh-hook
add-zsh-hook precmd vcs_info
