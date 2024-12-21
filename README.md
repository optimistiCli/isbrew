# isbrew
A script that helps figure out if a file was installed by [HomeBrew](https://brew.sh).

## Usage
```
isbrew.sh [-h] [-f <path>] [-u] [-1] [-g] [<file>]
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
ls -lh $(isbrew.sh -g1 sed)
-rwxr-xr-x  1 ish  admin   184K Nov  6  2022 /opt/homebrew/Cellar/gnu-sed/4.9/bin/gsed
lrwxr-xr-x  1 ish  admin    14B Nov  6  2022 /opt/homebrew/Cellar/gnu-sed/4.9/libexec/gnubin/sed -> ../../bin/gsed
```
### Check if some executables come from Homebrew
``` bash
$ for x in sed python make automake; do
    for y in $(isbrew.sh -1g "$x"); do
        cmp -s "$(which "$x")" "$y" \
        && echo "$x is $y"
    done
done
python is /opt/homebrew/Cellar/python@3.13/3.13.0_1/libexec/bin/python
automake is /opt/homebrew/Cellar/automake/1.17/bin/automake
```
## Options
* `-h` Print help and exit
* `-f` Path to HomeBrew files chache file; ~/.isbrew.cache.xz if ommited
* `-u` Update HomeBrew files chache file; might take a few minutes
* `-1` Print out just file names, one per line
* `-g` Search also for g\<file\>; ex. 'gsed' when looking for 'sed'
## Installation
Just put the script somewhere on your `$PATH`, for example:
``` bash
sudo install isbrew.sh /usr/local/bin
```

