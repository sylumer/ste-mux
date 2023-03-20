#!/bin/zsh
# This file gets executed by ste-mux.sh, so you can use it to add your own custom tmux commands
# There are two clearly marked sections. One you should leave alone, and one you can feel free to edit.

# -----------------------------------------------------
# ⬇ ⬇ ⬇ ⬇ ⬇ WARNING: DO NOT EDIT THIS SECTION ⬇ ⬇ ⬇ ⬇ ⬇ ~/Web && bundle exec jekyll serve
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

# TMUX named sessions
echo "-----"

# ------
# When uncommented, the example command below would set up an entry called "Start my work session", in a TMUX session
# called "DayJob". When run, it would display the date and time on two lines, and the tmux session would be attached.

# namedSessionAddition "$OSP" "my work" "DayJob" "date '+DATE: %Y-%m-%d%nTIME: %H:%M:%S'" "true"
# ------

# ------
# When uncommented, the example command below would set up an entry called "Start my website session", in a TMUX session 
# called "Web". When run, it would change to a directory and run a Jekyll web server, and the tmux session would be detached.

# namedSessionAddition "$OSP" "my website" "Web" "cd ~/Web && bundle exec jekyll serve" "false"
# ------

# ---------------------------------------------
# ⬆ ⬆ ⬆ ⬆ ⬆ PLEASE EDIT THIS SECTION ⬆ ⬆ ⬆ ⬆ ⬆
# --------------------------------------------