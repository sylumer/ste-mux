#!/bin/zsh

# ---------------
# Bitbar Settings
# ---------------
# <bitbar.title>Ste-Mux</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Stephen Millard</bitbar.author>
# <bitbar.author.github>sylumer</bitbar.author.github>
# <bitbar.desc>Personalised TMUX Manager for SwiftBar</bitbar.desc>

# -----------------
# SwiftBar Settings
# -----------------
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.refreshOnOpen>false</swiftbar.refreshOnOpen>

# --------------
# Initialisation
# --------------

STEMUXTMUXPLIST=".ste-mux"
if [[ "$SWIFTBAR" = '1' ]]; then
	# Running inside of Swift Bar
	STEMUXTMUXPLIST="${0:a:h}/$STEMUXTMUXPLIST"
else
	# Running outside of Swift Bar
	STEMUXTMUXPLIST="./$STEMUXTMUXPLIST"
fi
# If there is no PLIST file, set the default values
if [[ ! -f "$STEMUXTMUXPLIST.plist" ]]; then
	# Set the functions file
	defaults write "$STEMUXTMUXPLIST" "STEMUXFUNCTIONS" ".ste-mux-functions.sh"
	
	# Set the custom TMUX connections file
	defaults write "$STEMUXTMUXPLIST" "STEMUXTMUXCUSTOM" ".ste-mux-tmux-custom.sh"
	
	# Set te custom commands file
	defaults write "$STEMUXTMUXPLIST" "STEMUXCUSTOM" ".ste-mux-custom.sh"
	
	# Icons/text to use in the menu bar
	# No TMUX sessions
	ICON=$(echo "⛫" | base64)
	defaults write "$STEMUXTMUXPLIST" "STEMUXICON0" "$ICON"
	# >0 TMUX sessions
	defaults write "$STEMUXTMUXPLIST" "STEMUXICON1" "$ICON"
	
	# Set the default count of sessions to be symbols rather than numbers
	defaults write "$STEMUXTMUXPLIST" "STEMUXICONNUMSYMBOL" "true"

fi

# Some functions are kept in a separate file so that they can be shared by this script, and the custom
# commands script, or simply for personalisation.
# Default is based on the name of this file (with the addition of '-function') but dotted to hide it 
# from Swift Bar, and set as a shell file. The file should be executable and be located in the same folder
STEMUXFUNCTIONS=$(defaults read "$STEMUXTMUXPLIST" "STEMUXFUNCTIONS")

# Custom TMUX commands file name.
# Default is the base name of this file but dotted to hide it from Swift Bar, and set as a shell file.
# The file should be executable and be located in the same folder.
STEMUXTMUXCUSTOM=$(defaults read "$STEMUXTMUXPLIST" "STEMUXTMUXCUSTOM")

# Custom commands file name.
# Default is the base name of this file but dotted to hide it from Swift Bar, and set as a shell file.
# The file should be executable and be located in the same folder.
STEMUXCUSTOM=$(defaults read "$STEMUXTMUXPLIST" "STEMUXCUSTOM")

# The menu bar icons (or text) to use for when there are no or some TMUX sessions running on the local machine.
# The content is stored in base64
# Note the default setting is they are both the same, but you can modify your PLIST file to modify this.
STEMUXICON0=$(defaults read "$STEMUXTMUXPLIST" "STEMUXICON0")
STEMUXICON1=$(defaults read "$STEMUXTMUXPLIST" "STEMUXICON1")

# The menu bar count of sessions can be displayed as sumbols (true) or numbers (false)
STEMUXICONNUMSYMBOL=$(defaults read "$STEMUXTMUXPLIST" "STEMUXICONNUMSYMBOL")

# Load the functions file.
# The conditional block allows us to test the code preoperly inside and outside Swift Bar.
# It makes it quicker and easier for debugging doing this.
if [[ "$SWIFTBAR" = '1' ]]; then
	# Running inside of Swift Bar
	source "${0:a:h}/$STEMUXFUNCTIONS"
else
	# Running outside of Swift Bar
	source "./$STEMUXFUNCTIONS"
fi

# A file to record the last custom command
# It is a dot file to ensure it does not show as a plugin to Swift Bar
STEMUXLOGFILE=".ste-mux-log.txt"
# The conditional block allows us to test the code preoperly inside and outside Swift Bar.
# It makes it quicker and easier for debugging doing this.
if [[ "$SWIFTBAR" = '1' ]]; then
	# Running inside of Swift Bar
	STEMUXLOGPATH="${0:a:h}/$STEMUXLOGFILE"
else
	# Running outside of Swift Bar
	STEMUXLOGPATH="./$STEMUXLOGFILE"
fi

# Store the name and parent folder of this script to use in our custom script file
# Because the SwiftBar meta-data-based scheduler works on cron syntax,
# the finest granularity is 1 minute, so to update more frequently, we need
# to rely on the filename syntax. So in case anyone changes the file name,
# we store it for use by the custom commands script as it will need to call 
# back to this one and it stops the user having to modify the script name in
# that file. We just handle it automatically.
export STEMUX=$0
export STEMUXFOLDER=${0:a:h}

# Attempt to clear the screen in case we choose to open to the terminal session
export TERM=xterm
clear &>/dev/null


# ----------
# Operations
# ----------
# If an argument is passed in to actively do something, clear any log file
if [[ ! -z "$1" ]]; then
	rm -f $STEMUXLOGPATH
fi
	
# If the first parameter passed to the script is to open a session, run this code block
if [[ "$1" = 'openSession' ]]; then
	tmux attach -t "$2"
fi

# If the first parameter passed to the script is to end a session, run this code block
if [[ "$1" = 'endSession' ]]; then
	tmux kill-session -t "$2"
fi

# If the first parameter passed to the script is to open a new unnamed session, run this code block
if [[ "$1" = 'newSessionAnonymous' ]]; then
	tmux
fi

# If the first parameter passed to the script is to open a new named session and stay attached, run this code block
if [[ "$1" = 'newSessionNamed-a' ]]; then
	echo tmux new -s "$2" "$3" > $STEMUXLOGPATH
	tmux new -s "$2" "$3"
fi

# If the first parameter passed to the script is to open a new detached named session, run this code block
if [[ "$1" = 'newSessionNamed-d' ]]; then
	echo tmux new -d -s "$2" "$3" > $STEMUXLOGPATH
	echo "$1" >> $STEMUXLOGPATH
	echo "$2" >> $STEMUXLOGPATH
	echo "$3" >> $STEMUXLOGPATH
	tmux new -d -s "$2" "$3"
fi

# If the first parameter passed to the script is to open a new SSH session, run this code block
if [[ "$1" = 'newSSHSession' ]]; then
	# $2 = user | $3 = server | $4 = port (optional)
	
	# Default the SSH port
	if [[ -z $4 ]]; then
		sshPort=22
	else
		sshPort=$4
	fi
	
	## SSH
	ssh $2@$3 -p $sshPort
fi


# If the first parameter passed to the script is to run an arbitrary terminal command run this code block
if [[ "$1" = 'runCmd' ]]; then
	# Custom commands are base64 encoded to avoid some problems with any referenced arguments (e.g. $1 $2) getting interpreted too early
	# by encoding them in the menu and decoding them here, we can ensure they are interpreted only at the right time.
	cmdToRun=$2
	cmdToRun=$(echo $cmdToRun | base64 -d)
	
	# Log the command for debugging
	echo $cmdToRun > $STEMUXLOGPATH
	echo "---" >> $STEMUXLOGPATH
	
	#R un the command and attempt to log any output
	eval ${cmdToRun} >> $STEMUXLOGPATH
fi


# If an argument is passed in to actively do something, play a noise
# This is an audible cue that the action has completed processing.
if [[ ! -z "$1" ]]; then
	afplay "/System/Library/Sounds/tink.aiff"
fi

# -----------------------------------------------
# Build Menus & Menu Items for Base TMUX Commands
# -----------------------------------------------

# If there are any TMUX sessions we need to add options to connect to or end those sessions
tmux list-sessions > /dev/null

# TMUX list sessions will fail (code 1 = fail, code 0 = success) if no sessions
if [[ $? = 0 ]]; then
	# We have one or more existing sessions
	# Build an array of session names and a count of attached sessions
	sessions="$(tmux list-sessions -F#S)"
	sessionNameArray=(${(ps:\n:)"$(echo $sessions)"})
	attachedSessionCount=$(tmux list-sessions | grep "(attached)" | wc -l)
	
	# Menu bar text
	ICON=$(echo $STEMUXICON1 | base64 -d)
	SESSIONCOUNT=${#sessionNameArray}
	# Check the type of numeric output on the menu bar (true = symbolic characters | false = numeric characters)
	if [[ "$STEMUXICONNUMSYMBOL" = "true" ]]; then
		# Symbols - most compact output
		case $SESSIONCOUNT in
			1 )
				ICON="$ICON⓵"
			;;
			2 )
				ICON="$ICON⓶"
			;;
			3 )
				ICON="$ICON⓷"
			;;
			4 )
				ICON="$ICON⓸"
			;;
			5 )
				ICON="$ICON⓹"
			;;
			6 )
				ICON="$ICON⓺"
			;;
			7 )
				ICON="$ICON⓻"
			;;
			8 )
				ICON="$ICON⓼"
			;;
			9 )
				ICON="$ICON⓽"
			;;
			* )
				ICON="$ICON+⃝"
		esac
	else
		# Colon followed by numbers - most verbose output
		ICON="$ICON:$SESSIONCOUNT"
	fi
	echo "$ICON"
	echo "---"
	
	# TMUX menu contains details about TMUX sessions
	echo TMUX
	
	# First sub item is the number of attached sessions
	# This is just a listing of which TMUX sessions are already attached in a level 2 sub menu
	# These are for info and non-actionable
	echo "--$attachedSessionCount Attached Sessions: | color=white"
	tmux list-sessions | grep "(attached)" | awk 'BEGIN{FS=":"}{print "----"$1}'
	
	# Level 1 sub menu Separator
	echo "-----"
	
	# Lists the sessions that are available to attach to in a level 2 sub menu
	# These are actionable
	echo "--Attach to..."
	for i in "${sessionNameArray[@]}"
	do
			echo "----Attach to session: $i | bash='$0' param1=openSession param2=$i terminal=true"
	done
	
	# Lists the sessions that are available to kill to in a level 2 sub menu
	# These are actionable
	echo "--Terminate..."
	for i in "${sessionNameArray[@]}"
	do
		echo "----Kill session: $i | bash='$0' param1=endSession param2=$i terminal=false"
	done
	
	# Level 1 sub menu Separator
	echo "-----"
	
	# Always include the standard TMUX session addition
	# This will create and attach to the session
	echo "--Start New TMUX session | bash='$0' param1=newSessionAnonymous terminal=true"
	
else
	# We have no existing sessions
	sessionNameArray=()
	
	# Menu bar text
	ICON=$(echo $STEMUXICON0 | base64 -d)
	echo "$ICON"
	echo "---"
	
	# TMUX menu contains details about TMUX sessions
	echo TMUX
	echo "---"
	
	# Always include the standard session addition
	echo "--Start New TMUX session | bash='$0' param1=newSessionAnonymous terminal=true"
fi

# Add Custom TMUX Commands
# First, we build the appropriate file path.
# This allows us to test the code properly inside and outside Swift Bar.
# It makes it quicker and easier for debugging doing this.
if [[ "$SWIFTBAR" = '1' ]]; then
	# Running inside of Swift Bar
	CUSTOMTMUXFILE=$(realpath "${0:a:h}/$STEMUXTMUXCUSTOM")
else
	# Running outside of Swift Bar
	CUSTOMTMUXFILE=$(realpath "./$STEMUXTMUXCUSTOM")
fi

# Second, if the file actually exists, run it to add additional custom commands
if [[ -f "$CUSTOMTMUXFILE" ]]; then
	echo "---"
	"$CUSTOMTMUXFILE"
fi


# --------------------------------------------
# Build Menus & Menu Items for Custom Commands
# --------------------------------------------
# Call the custom commands file in case we have any commands in it

# First, we build the appropriate file path.
# This allows us to test the code properly inside and outside Swift Bar.
# It makes it quicker and easier for debugging doing this.
if [[ "$SWIFTBAR" = '1' ]]; then
	# Running inside of Swift Bar
	CUSTOMFILE=$(realpath "${0:a:h}/$STEMUXCUSTOM")
else
	# Running outside of Swift Bar
	CUSTOMFILE=$(realpath "./$STEMUXCUSTOM")
fi

# Second, if the file actually exists, run it to add additional custom commands
if [[ -f "$CUSTOMFILE" ]]; then
	"$CUSTOMFILE"
fi
