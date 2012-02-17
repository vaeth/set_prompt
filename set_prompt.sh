#! /usr/bin/env sh
# (C) Martin V\"ath <martin@mvath.de>
#
# The first line is only for editors.
# This is an example script meant to be sourced by zsh or bash
# if in interactive mode.

# In this example, HOSTTEXT is an additional information about the HOST,
# and HOSTTEXTSAVE provides the previous such information.
# In particular, if HOSTTEXTSAVE != HOSTTEXT, we pass an argument to the
# set_prompt.config to denote that we want special colors

set_prompt() {
	[ "${HOSTTEXTSAVE}" = "${HOSTTEXT}" ] || set -- "${@}" 1
	[ -z "${HOSTTEXT}" ] || set -- -e "(${HOSTTEXT})" "${@}"
	local t
	t="$(PATH="${PATH}:" . set_prompt "${@}" && echo /)" && PS1="${t%/}"
}

# For bash, we patch the above function to add the arguments -b.
# For broken bash version, also add the argument -l0

if [ -n "${BASH}" ]
then	if [ "${BASH_VERSINFO[0]}" -eq 3 ]  && [ "${BASH_VERSINFO[1]}" -eq 1 ] \
	&& [ "${BASH_VERSINFO[2]}" -le 17 ] && [ "${BASH_VERSINFO[3]}" -le 1 ]
	then	# Prompt expansion is buggy in these bash releases. Example:
		# PS1='$(echo "Strange \[\e[0;32m\]Prompt\[\e[0m\] ")'
		eval "$(a=$(declare -f set_prompt)
		b='{'
		c='{ set -- -bl0 "${@}"
		'
		printf '%s' "${a/${b}/${c}}")"
	else	eval "$(a=$(declare -f set_prompt)
		b='{'
		c='{ set -- -b "${@}"
		'
		printf '%s' "${a/${b}/${c}}")"
	fi
fi
