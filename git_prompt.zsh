#! /bin/zsh
# The above line is only meant for editors
# (C) Martin V\"ath <martin@mvath.de>

command -v git >/dev/null 2>&1 || return 0

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
	for i in ${(@f)"$(u=${GIT_UPDATE_USER-nobody}
	[[ -z $u ]] || USERNAME=$u >/dev/null 2>&1
	git status --porcelain -sb 2>/dev/null)"}
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
	if [[ -n "$VCSBRANCH$VCSSTATUS" ]]
	then	[[ -n ${git_update_done-} ]] \
			&& unset git_update_done || GitUpdate
	fi
}

typeset -aU chpwd_functions
typeset -aU precmd_functions
chpwd_functions+=GitUpdateChpwd
precmd_functions+=GitUpdatePrecmd
GIT_UPDATE=:
if [[ ${1-} != '-n' ]]
then	GitUpdateChpwd
else	unset git_update_done
fi
