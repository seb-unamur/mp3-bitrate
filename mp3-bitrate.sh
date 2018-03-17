#!/bin/bash
#
###############################################################################
# It requires 'mp3info' to be installed.
#
###############################################################################
# DESCRIPTION
# -----------
#
# List files in the given directory which are encoded with a quality lower than
# the supplied limit
#
###############################################################################
# USAGE
# -----
#
# ./mp3-bitrate <path> <bitratelimit>
#
###############################################################################


##### DEFAULT SETTINGS
bitrate=44
path="$(pwd)/"

##### MISSING ARGUMENTS
# Missing path
if [[ ! -z "$1" ]]; then
	path=$1
fi
# Missing bitrate
if [[ ! -z "$2" ]]; then
	bitrate=$2
fi

##### SETTINGS IN USE
echo "Search path   : $path"
echo "Search bitrate: < $bitrate kHz"
echo "========================================================================"
echo "Please wait while recursive search ..."

##### PROCESS: INITIALIZATION
# Prepare files listing
IFSbackup=$IFS
IFS=$'\n'

##### PROCESS: FILES LISTING
# List files
#for file in $(ls -AR $path*); do
for file in $(find $path*); do
	if [[ ( ! -d "$file" ) && ( $file =~ \.mp3$ || $file =~ \.MP3$ ) ]]; then
		filebitrate=$(mp3info -x $file 2> /dev/null | grep Audio: | cut -d, -f2 | cut -dk -f1 | tr -d '[:space:]')
		if [[ -z "$filebitrate" ]]; then
			(>&2 echo "BITRATE ERROR (\"$filebitrate\"): $file")
		else
			if [[ "$filebitrate" -lt "$bitrate" ]]; then
				echo ">>> ($filebitrate kHz): $file"
			fi
		fi
	fi
done
echo

##### PROCESS: CLEAN UP
# Resume files listing
IFS=$IFSbackup
