#! /bin/zsh
# The above line is only meant for editors
#
# (C) Martin V\"ath <martin@mvath.de>
#
# This script is meant to be sourced by zsh.
# Then the variables VCSBRANCH and VCSSTATUS are updated at directory changes,
# using "git status".
# If the function GitUpdateUser is defined, it is called before "git status";
# "git status" is only called if GitUpdateUser returns a zero exit status.
# Before calling "git status", it is attempted to become user
# $GIT_UPDATE_USER (default: nobody). Set GIT_UPDATE_USER='' to avoid this.
# You can (temporarily) avoid the whole functionality by unsetting GIT_UPDATE
# (or setting it to "false" or an empty value.)

if command -v git >/dev/null 2>&1
then	# Install only if git is available
GitUpdate() {
	VCSBRANCH=''
	VCSSTATUS=''
	[[ ${GIT_UPDATE} = [yYtT1:]* ]] || return 0
	[[ $(whence -w GitUpdateUser) != 'GitUpdateUser: function' ]] \
		|| GitUpdateUser || return 0
	local i
	local -aU a
	a=()
	for i in ${(@f)"$(u=${GIT_UPDATE_USER-nobody}
	[[ -z $u ]] || USERNAME=$u >/dev/null 2>&1
	git status --porcelain -sb 2>/dev/null)"}
	do	case $i[2] in
		('#')	VCSBRANCH=${i[4,$#i]}
			continue
		;;
		esac
		a+=$i[2]
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
	then	[[ -n ${git_update_done-n} ]] \
			&& unset git_update_done || GitUpdate
	fi
}
typeset -aU chpwd_functions
typeset -aU precmd_functions
chpwd_functions+=GitUpdateChpwd
precmd_functions+=GitUpdatePrecmd
VCSBRANCH=''
VCSSTATUS=''
GIT_UPDATE=:
unset git_update_done
fi
