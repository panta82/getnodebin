#!/usr/bin/env bash

THIS_DIR="$(dirname "$(readlink -f "$0")")"
VERSIONS_DIR="versions"

URL_ROOT="https://nodejs.org/dist/v"
FILENAME_PREFIX="node-v"
FILENAME_SUFFIX_86="-linux-x86.tar.xz"
FILENAME_SUFFIX_64="-linux-x64.tar.xz"

VERSION=
DEFAULT_VERSION= #not used

PREFIX=
DEFAULT_PREFIX="/usr/local"

fatal() {
	echo "$@" >&2
	exit 1
}

usage() {
	cat <<END
getnodebin - Install node binary distributions on linux

Usage:

    $0 <version> [prefix]

Where:
    
    - <version> is full node version you want installed (eg. "6.0.0").
    
    - [prefix] is system "hub" where you want node installed.
      This defaults to "/usr/local". For local installations,
      recommended is "/home/user/local".

END
}

try_display_help() {
	local arg="$1"
	if [[ $arg = '-h' || $arg = '--help' ]]; then
		usage
		exit 0
	fi
}

load_version() {
	VERSION="$1"
	local version_regex='[0-9]+\.[0-9]+\.[0-9]+'
	if [[ -z "$VERSION" ]]; then
		VERSION="$DEFAULT_VERSION"
	fi
	if [[ -z $VERSION ]]; then
		usage
		fatal "ERROR: Version not supplied"
	fi
	if ! [[ $VERSION =~ $version_regex ]]; then
		fatal "ERROR: Invalid version string ($VERSION)"
	fi
}

load_prefix() {
	PREFIX="$2"
	if [[ -z "$PREFIX" ]]; then
		PREFIX="$DEFAULT_PREFIX"
	fi
	if [[ -z "$PREFIX" ]]; then
		usage
		fatal "ERROR: No prefix specified"
	fi
}

_verify_command() {
	command -v "$1" >/dev/null 2>&1 || fatal "ERROR: Command $1 not available."
}

verify() {
	[[ -d $PREFIX ]] || fatal "ERROR: No prefix path found at $TARGET"
	_verify_command wget
	_verify_command uname
	_verify_command tar
}

install() {
	local machine="$(uname -m)"
	local filename="${FILENAME_PREFIX}${VERSION}"
	if [[ $machine = 'x86_64' ]]; then
		filename="${filename}${FILENAME_SUFFIX_64}"
	else
		filename="${filename}${FILENAME_SUFFIX_86}"
	fi
	local url="${URL_ROOT}${VERSION}/$filename"
	local install_dir=$THIS_DIR/$VERSIONS_DIR
	
	mkdir -p $install_dir

	echo -e "\nDownloading $url"
	rm -f "$install_dir/$filename"
	wget -q -O"$install_dir/$filename" "$url"

	echo -e "Unpacking $install_dir/$filename"
	local unpacked_directory=$(tar --exclude="*/*" -tf $install_dir/$filename| head -n 1)
	unpacked_directory=${unpacked_directory%/}
	( cd $install_dir && tar xaf $install_dir/$filename )

	local unpacked_path="${install_dir}/${unpacked_directory}"
	echo -e "Setting up deployment..."
	echo "$PREFIX" > "$unpacked_path/target"
	cp -f "$THIS_DIR/deploy.sh" "$unpacked_path/"

	"$unpacked_path/deploy.sh"

	echo -e "Cleaning up"
	rm -f "$install_dir/$filename"

	echo -e "\nDone. Node v$VERSION was installed under $PREFIX\n"
}

try_display_help $@
load_version $@
load_prefix $@
verify
install
