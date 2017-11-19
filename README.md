# set_prompt

An intelligent prompt for __zsh__ or __bash__ with status line
(window title) support

(C) Martin Väth (martin at mvath.de).
This project is under the BSD license.

### Description

This is a collection of scripts which allow you to use an intelligent prompt
for __zsh__ or __bash__ which also sets a corresponding hardstatus line
(if your terminal supports it).

For a demo printing a simple default prompt, execute this in your shell:
```
printf '\e[0;33mme\e[36m@\e[32mhost\e[36m(my text)\e[1;32m~/very/l' \
&& printf '\e[0;34m...\e[1;32mong/pathname\e[1;33m%%\e[0m\n'
```
Under __X__, __tmux__, or __screen__, the text will appear (slightly changed)
in addition as your window title (status line).

The above line only displays the simplest prompt: You can see more information
in the prompt if e.g. you are logged in by __ssh__, if you are in a directory
with a __git__ project, or if your last command exited unsuccessfully.
A configuration file is supported in which you can easily customize the prompt
(e.g. change colors or conditions), using standard shell code.

### Installation

To install these scripts, copy them somewhere into your `$PATH`;
the default configuration set_prompt.config can alternatively
also be copied into `/usr/local/etc` or `/etc`.
To get support for __zsh completion__, put the files of the subdirectory `zsh`
into your zsh's `$fpath`.

For Gentoo, there is an ebuild in the mv overlay (available over layman).

### Usage

The main program is

`set_prompt`

To get help for this program, call

`set_prompt -h`

The `set_prompt` program outputs a valid string for `PS1` for __zsh__
(or for __bash__ if the `-b` option is used).
If used with __zsh__, the prompt usually expects that the `PROMPT_SUBST`
option is actived (`setopt promptsubst`).

The `set_prompt` program can be either executed or sourced by __zsh__,
__bash__, or any other POSIX compatible shell.
If you source it, you should source it in a subshell, of course
(which happens automatically with ``` `...` ```).
The advantage of sourcing is that it is faster.
Note that even if sourced from __bash__, the `-b` option is not implied.

By default, the set_prompt program sources the configuration file

`set_prompt.config`

(which is searched in `/usr/local/etc/`, `/etc/`, and in your `$PATH`).
So you should customize that file for your taste (e.g. to define the colors).

There is a sample script

`set_prompt.sh`

for __bash__ and __zsh__.
You can either execute it and `eval` the output, like e.g.
```
if SOME_VARIABLE=`set_prompt.sh 2>/dev/null`
then	eval "$SOME_VARIABLE"
else	echo "set_prompt.sh not found" >&2
fi
```
or you can source it with

`. set_prompt.sh`

The latter has the disadvantage that it will die with an error if
set_prompt.sh cannot be found.
The above eval/sourcing of `set_prompt.sh` defines a function

`set_prompt`

which acts like the set_prompt program with the difference that is sends the
output directly to `$PS1` and that appropriate options are used by default.
(In particular, default options are set for broken bash versions.)
The `set_prompt.sh` script makes use of particular variables, so you might
want to look at the source and modify it for your needs before using it.

Finally, the prompt supports also the variable `$vcs_info_msg_0_` for __zsh__
(or optionally also for __bash__, although __bash__ does not support it
out-of-the-box):
This variable is set by `vcs_info` (`man zshcontrib` for help on the latter).
There is an example script

`git_prompt.zsh`

which can be either treated with `eval` or sourced, similarly as
`set_prompt.sh` above.
This script will then activate the mechanism for `vcs_info`.

The configuration from `git_prompt.zsh` uses `git_update` instead of `git`
if `git_update` is in your `$PATH`:

For security reasons, it is recommended to copy `git_update` into your `$PATH`,
because the latter will attempt to change (drop) permissions to those of
`GIT_UPDATE_USER` (defaults to `nobody`).
If `git_update` fails to change the permissions, `git` is **not** invoked for
security reasons. To drop this security measurement of `git_update`, you
can export an empty `GIT_UPDATE_USER`.

Since most users without privileges will want to support such an empty
`GIT_UPDATE_USER`, `git_prompt.zsh` will do this for you if it is not possible
to drop permissions to the user `nobody`.

`git_update` is a separate command so that you can adapt it to your needs and
you can also use it other programs.

For example, if you are an emacs user, you might want to put

`(setq vc-git-program "git_update")`

into your `~/.emacs` to get the same security mechanism also for emacs.
