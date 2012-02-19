#! /usr/bin/env sh
# (C) Martin V\"ath <martin@mvath.de>
#
# The first line is only for editors.
# This is an example script meant to be sourced by zsh or bash
# if in interactive mode.

# In this example, HOSTTEXT is an additional information about the HOST,
# and HOSTTEXTSAVE provides the previous such information.
# In particular, if HOSTTEXTSAVE != HOSTTEXT, we pass the argument "1" to
# set_prompt.config to denote that we want special colors for a changed host

set_prompt() {
	[ -z "${HOSTTEXT}" ] || set -- -e "(${HOSTTEXT})" "${@}"
	[ "${HOSTTEXTSAVE}" = "${HOSTTEXT}" ] || set -- "${@}" 1
	local t
	t="$(PATH="${PATH}:." . set_prompt "${@}" && echo /)" && PS1="${t%/}"
}

# For bash, we patch the above function to add the arguments -b.
# For broken bash versions, also add the argument -l0

if [ -n "${BASH}" ]
then	eval "$(funcdef="$(declare -f set_prompt)"
	if [ "${BASH_VERSINFO[0]}" -eq 3 ]  && [ "${BASH_VERSINFO[1]}" -eq 1 ] \
	&& [ "${BASH_VERSINFO[2]}" -le 17 ] && [ "${BASH_VERSINFO[3]}" -le 1 ]
	then	args='-bl0'
	else	args='-b'
	fi
	find='{'
	replace="${find}
set -- ${args} \"\${@}\"
"
	printf '%s' "${funcdef/${find}/${replace}}")"
fi
