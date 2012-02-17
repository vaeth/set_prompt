#! /bin/zsh
# The above line is only meant for editors
#
# (C) Martin V\"ath <martin@mvath.de>
#
# This script is meant to be sourced by zsh.
# Then the variables VCSBRANCH and VCSSTATUS are updated at directory changes.

if command -v git >/dev/null 2>&1
then	# Install only if git is available
GitUpdate() {
	VCSBRANCH=''
	VCSSTATUS=''
	local i
	local -aU a
	a=()
	for i in ${(@f)"$(git status --porcelain -sb 2>/dev/null)"}
	do	case $i[2] in
		('#')	VCSBRANCH=${i[4,$#i]}
			continue
		;;
		esac
		a+=($i[2])
	done
	for i in $a
	do	VCSSTATUS+=$i
	done
}
GitUpdateChpwd() {
	GitUpdate && git_update_done=:
}
GitUpdatePrecmd() {
	if [[ -n "$VCSBRANCH$VCSSTATUS" ]]
	then	[[ -n $git_update_done ]] && git_update_done='' || GitUpdate
	fi
}
typeset -aU chpwd_functions
typeset -aU precmd_functions
chpwd_functions+=GitUpdateChpwd
precmd_functions+=GitUpdatePrecmd
GitUpdate
git_update_done=''
fi
