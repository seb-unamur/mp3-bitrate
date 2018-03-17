# mp3-bitrate

## Description
Recursively searches for mp3 files in \<path\> and prints those that do not comply with the minimum \<bitrate\>.  Bitrate is given in kHz.

When ommited:
- \<path\> is the current directory;
- \<bitrate\> is 44kHz.

Delete empty files (file size = 0).

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
./mp3-bitrate <path> <min.bitrate>
```

### Example

List low quality (\<44kHz) files in a text file; and error messages in the terminal
```
./mp3-bitrate /media/NAS/Music/ > out.txt
```
