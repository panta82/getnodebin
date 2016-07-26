#!/usr/bin/env bash

THIS_DIR="$(dirname "$(readlink -f "$0")")"
TARGET=
TARGET_PATH="$THIS_DIR/target"

fatal() {
	echo "$@" >&2
	exit 1
}

usage() {
	cat <<END
Usage:

	$0 <target>

Where <target> is the system "hub" where you want node deployed.
Eg. "/usr/local" or "/home/joe/local"

We will also try to read target from a local file named "target".

END
}

load_target() {
	TARGET="$1"
	if [[ -z "$TARGET" ]] && [[ -f $TARGET_PATH ]]; then
		TARGET="$(cat $TARGET_PATH)"
	fi
	if [[ -z "$TARGET" ]]; then
		usage
		fatal "ERROR: No target specified"
	fi
}

verify() {
	[[ -d $THIS_DIR/bin ]] || fatal "ERROR: Invalid structure at $THIS_DIR"
	[[ -d $TARGET ]] || fatal "ERROR: No target path found at $TARGET"
}

_deploy_dir() {
	dir="$1"
	echo "    Deploying $dir..."
	mkdir -p $TARGET/$dir 
	if [[ ! -z $VERBOSE ]]; then
		cp -arv $THIS_DIR/$dir/. $TARGET/$dir/
	else
		cp -ar $THIS_DIR/$dir/. $TARGET/$dir/
	fi
}

deploy() {
	echo -e "Deploying to $TARGET"
	_deploy_dir bin
	_deploy_dir lib
	_deploy_dir share
	_deploy_dir include
	echo -e "Deploy done"
}

load_target $@
verify
deploy
