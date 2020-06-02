#!/bin/sh

GIT_DIR=./.git
GIT_HOOKS_DIR=${GIT_DIR}/hooks
LOCAL_HOOKS_DIR=./hooks

declare -A HELP_FLAGS

HELP_FLAGS[help]="Usage: \e[32msh $0\e[0m"
HELP_FLAGS[gitdir]="\e[31m.git\e[0m directory not found. Not a git repository!\n"

usage() {
	flag=$1

	if [[ -n $flag ]]; then
		printf "${HELP_FLAGS[$flag]}"
		exit
	fi
}

move_hooks() {
	hook_dir=$1

	cp ${LOCAL_HOOKS_DIR}/$hook_dir/* $GIT_HOOKS_DIR
}

parse_args() {
	arg=$1

	if [[ ${!HELP_FLAGS[@]} =~ $arg ]]; then
		usage $arg
	elif [[ -d ${LOCAL_HOOKS_DIR}/$arg ]]; then
		 move_hooks
	else
		usage help
	fi
}

[[ ! -d $GIT_DIR ]] && usage gitdir

if [[ $# -ge 1 ]]; then
	for arg in $*; do
		parse_args $arg
	done
fi

echo "All done"
