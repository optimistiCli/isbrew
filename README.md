# isbrew
A script that helps figure out if a file was installed by [HomeBrew](https://brew.sh).

## Usage
```
isbrew.sh [-h] [-f <path>] [-u] [-1] [-g] [-l] [-L] [-w] [<file>]
```

## Examples
### Update cache
Creates a complete list of files installed by [HomeBrew](https://brew.sh). Takes quite a bit of time. Should run before using `isbrew.sh` for the first time and then every time something is installed, updated or removed via [HomeBrew](https://brew.sh).
``` bash
$ isbrew.sh -u
Updating the HomeBrew files chache file.................................................. done!
```
### Search for a file
``` bash
$ isbrew.sh sed
gnu-sed (formula): /opt/homebrew/Cellar/gnu-sed/4.9/libexec/gnubin/sed

$ isbrew.sh /bin/dd
coreutils (formula): /opt/homebrew/Cellar/coreutils/9.5/libexec/gnubin/dd
```
### Include g\* binaries in search results
``` bash
$ isbrew.sh -g sed
gnu-sed (formula): /opt/homebrew/Cellar/gnu-sed/4.9/bin/gsed
gnu-sed (formula): /opt/homebrew/Cellar/gnu-sed/4.9/libexec/gnubin/sed
``` 
### Show only paths
``` bash
$ isbrew.sh -1 sed
/opt/homebrew/Cellar/gnu-sed/4.9/libexec/gnubin/sed

$ isbrew.sh -g1 dd
/opt/homebrew/Cellar/coreutils/9.5/bin/gdd
/opt/homebrew/Cellar/coreutils/9.5/libexec/gnubin/dd
```
### List found files
``` bash
$ isbrew.sh -l python
lrwxr-xr-x  1 user  group    62B Oct  1 04:05 /opt/homebrew/Cellar/python@3.12/3.12.7_1/libexec/bin/python -> ../../Frameworks/Python.framework/Versions/3.12/bin/python3.12
lrwxr-xr-x  1 user  group    62B Oct  7 07:02 /opt/homebrew/Cellar/python@3.13/3.13.0_1/libexec/bin/python -> ../../Frameworks/Python.framework/Versions/3.13/bin/python3.13

$ isbrew.sh -Lg sed
-rwxr-xr-x  1 user  group  188336 Nov  6  2022 /opt/homebrew/Cellar/gnu-sed/4.9/bin/gsed
lrwxr-xr-x  1 user  group      14 Nov  6  2022 /opt/homebrew/Cellar/gnu-sed/4.9/libexec/gnubin/sed -> ../../bin/gsed
```
### Check if some file came from Homebrew
``` bash
$ isbrew.sh -w python
Identical to: /opt/homebrew/Cellar/python@3.13/3.13.0_1/libexec/bin/python
$ isbrew.sh -w cargo
Exact same path as: /opt/homebrew/Cellar/rust/1.82.0/bin/cargo
$ isbrew.sh -w sudo
# No output
$ ln $(which cargo)
$ isbrew.sh -w cargo
Exact same file as: /opt/homebrew/Cellar/rust/1.82.0/bin/cargo
$ isbrew.sh -w1 python
/opt/homebrew/Cellar/python@3.13/3.13.0_1/libexec/bin/python
```
## Options
* `-h` Print help and exit
* `-f` Path to HomeBrew files chache file; ~/.isbrew.cache.xz if ommited
* `-u` Update HomeBrew files chache file; might take a few minutes
* `-1` Print out just file names, one per line
* `-l` Run found files through 'ls -lh'
* `-L` Run found files through 'ls -l'
* `-w` Compare file to found files
* `-g` Search also for g\<file\>; ex. 'gsed' when looking for 'sed'
## Installation
Just put the script somewhere on your `$PATH`, for example:
``` bash
sudo install isbrew.sh /usr/local/bin/
```

