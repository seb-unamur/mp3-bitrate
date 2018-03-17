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
bitrate=320
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
echo "Search bitrate: $bitrate kbps"
echo

##### PROCESS: INITIALIZATION
# Prepare files listing
IFSbackup=$IFS
IFS=$'\n'

##### PROCESS: FILES LISTING
# List files
for file in $(ls -AR $path*); do
	#if [[ $file =~ \.mp3$ ]]; then
	if [[ $file =~ \.mp3$ || $file =~ \.MP3$ ]]; then
		filebitrate=$(mp3info -x $file | head -n 7 | tail -n 1 | cut -b 14-16)
		if [[ $filebitrate -lt $bitrate  ]]; then
			echo ">>> ($filebitrate < $bitrate kbps): $file"
		fi
	fi
done

##### PROCESS: CLEAN UP
# Resume files listing
IFS=$IFSbackup
