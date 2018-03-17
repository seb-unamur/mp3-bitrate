# mp3-bitrate

## Description
Recursively searches for mp3 files in \<path\> and prints those that do not comply with the minimum \<bitrate\>.

## Requirements
Requires "mp3info".

On a Debian system:
```
$ su
# apt install mp3info
# exit
```

## Usage
Ensure the script is executable:
```
$ chmod 755 mp3-bitrate
```

Run script as follows:
```
./mp3-bitrate \<path\> \<min.bitrate\>
```
