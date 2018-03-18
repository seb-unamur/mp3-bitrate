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
bitrate=44		# Default bitrate when argument is missing
deletenullsize=1	# When set, empty files are automatically removed
deletelowbitrate=0	# When set, lowquality files are automatically removed

# /!\ DO NOT CHANGE WHAT FOLLOWS UNLESS YOU KNOW WHAT YOU ARE DOING /!\
path="$(pwd)/"		# Default path when argument is missing

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
for file in $(find $path*); do
	# Only process files ending with .mp3 or .MP3
	if [[ ( ! -d "$file" ) && ( "$file" =~ \.mp3$ || "$file" =~ \.MP3$ ) ]]; then
		
		# If file size is null
		if [[ ! -s $file ]]; then
			if [[ "$deletenullsize" == 1  ]]; then
				(>&2 echo "EMPTY FILE DELETED: $file")
				rm "$file"
			fi
		
		# If file size is not null	
		else
			filebitrate=$(mp3info -x "$file" 2> /dev/null | grep Audio: | cut -d, -f2 | cut -dk -f1 | tr -d '[:space:]')
			
			# If no bitrate has been parsed
			if [[ -z "$filebitrate" ]]; then
				(>&2 echo "BITRATE ERROR (\"$filebitrate\"): $file")
			
			# If bitrate has been parsed
			else
				if [[ "$filebitrate" -lt "$bitrate" ]]; then
					echo ">>> LOW QUALITY FILE FOUND ($filebitrate kHz): $file"
					if [[ "$deletelowbitrate" == 1 ]]; then
						rm $file
					else
						rm -i $file
					fi
				fi
			fi
		fi
	fi
	echo
done
echo

##### PROCESS: CLEAN UP
# Resume files listing
IFS=$IFSbackup
