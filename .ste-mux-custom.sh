#!/bin/zsh
# This file gets executed by ste-mux.sh, so you can use it to add your own custom commands
# There are two clearly marked sections. One you should leave alone, and one you can feel free to edit.

# -----------------------------------------------------
# ⬇ ⬇ ⬇ ⬇ ⬇ WARNING: DO NOT EDIT THIS SECTION ⬇ ⬇ ⬇ ⬇ ⬇
# -----------------------------------------------------
# Set the Original Script Path
# This was set in case the update frequency in the file name needs to be changed.
# It will automatically track through to here where it is needed.
OSP=$STEMUX

# Include the functions file we use to simplify the build entries
STEMUXTMUXPLIST="$STEMUXFOLDER/.ste-mux"
STEMUXFUNCTIONS=$(defaults read "$STEMUXTMUXPLIST" "STEMUXFUNCTIONS")
source $STEMUXFOLDER/$STEMUXFUNCTIONS
# -----------------------------------------------------
# ⬆ ⬆ ⬆ ⬆ ⬆ WARNING: DO NOT EDIT THIS SECTION ⬆ ⬆ ⬆ ⬆ ⬆
# -----------------------------------------------------


# ---------------------------------------------
# ⬇ ⬇ ⬇ ⬇ ⬇ PLEASE EDIT THIS SECTION ⬇ ⬇ ⬇ ⬇ ⬇
# ---------------------------------------------

# Custom Terminal Commands
echo "---"
echo Custom Commands
runCommand "$OSP" "--Say Hello" "say Hello. I am stee mux"
runCommand "$OSP" "Open Terminal" "open -a Terminal" 1
runCommand "$OSP" "Copy Desktop file listing" "ls -hal ~/Desktop | pbcopy" 1
runCommand "$OSP" "Kill all Jekyll processes" 'ps aux | grep jekyll | awk '"'"'{print $2}'"'"' | xargs kill -9' 1

# ------
# When uncommented, the example command below would set up an entry called "SSH: Mac Mini".
# When run, it would attempt to open an ssh-session for user hal9000 on a server called macmini (on local), via port 22.

# sshSessionAddition "$OSP" "SSH: Mac Mini" "hal9000" "macmini.local" "22"
# ------

# ---------------------------------------------
# ⬆ ⬆ ⬆ ⬆ ⬆ PLEASE EDIT THIS SECTION ⬆ ⬆ ⬆ ⬆ ⬆
# ---------------------------------------------