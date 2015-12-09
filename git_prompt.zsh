#!/bin/zsh
# The above line is only meant for editors
# (C) Martin V\"ath <martin@mvath.de>

command -v git >/dev/null 2>&1 || return 0

: ${VCSBRANCH=} ${VCSSTATUS=}
: ${GIT_UPDATE=:} ${GIT_UPDATE_USER=nobody}
export GIT_UPDATE_USER

GitUpdate() {
	VCSBRANCH=
	VCSSTATUS=
	[[ ${GIT_UPDATE-} = [yYtT1:]* ]] || return 0
	if command -v GitUpdateUser >/dev/null 2>&1
	then	GitUpdateUser || return 0
	fi
	local -aU a
	a=()
	local i
	for i in ${(@f)"$("$(command -v git_update 2>/dev/null || echo git)" \
		status --porcelain -sb 2>/dev/null)"}
	do	case $i[2] in
		('#')	VCSBRANCH=${i[4,$#i]};;
		(' ')	a+=$i[1];;
		(*)	a+=$i[2];;
		esac
	done
	VCSSTATUS=${(j::)a}
}

GitUpdateChpwd() {
	GitUpdate
	git_update_done=:
}

GitUpdatePrecmd() {
	if [[ -n ${VCSBRANCH:++}${VCSSTATUS:++} ]]
	then	[[ -n ${git_update_done-} ]] && git_update_done= || GitUpdate
	fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd GitUpdateChpwd
add-zsh-hook precmd GitUpdatePrecmd

git_update_done=
[[ ${1-} = '-n' ]] || GitUpdateChpwd
