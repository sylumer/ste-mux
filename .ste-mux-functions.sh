#!/bin/zsh

# -----------
# Script Info
# -----------
# Public Repo: https://github.com/sylumer/ste-mux
# Author: Stephen Millard (https://thoughtasylum.com)
# Version: 1.0

# This file gets executed by ste-mux, so you can use it to add your own custom commands.
# It must be stored alongside the set-mux script.

# === FUNCTIONS START ===
# Build the commands for named sessions
namedSessionAddition()
{
	# Only give the option to start a named session if the session is not already running
	if ! (( $nameArray[(Ie)$2] )); then
		if [ $5 = true ]; then
			# Run and stay attached
			echo "--Start $2 session 􁐍 | bash='$1' param1=newSessionNamed-a param2='$3'  param3='$4' terminal=$5"
		else
			# Run and detach
			echo "--Start $2 session 􁅃 | bash='$1' param1=newSessionNamed-d param2='$3'  param3='$4' terminal=$5"
		fi
		
	fi
}

# Build the commands for an SSH session
sshSessionAddition()
{
	if [[ $6 = 0 || -z "$6" ]]; then
		prefix=""
	else
		prefix=$(printf '--%.0s' {1..$count})
	fi
	
	echo "$prefix""SSH to $2 | bash='$1' param1=newSSHSession param2=$3  param3='$4' param4=$5 terminal=true"
}


# Build the command to run an arbitrary command to run in the background
runCommand()
{	
	if [[ $4 = 0 || -z "$4" ]]; then
		prefix=""
	else
		prefix=$(printf '--%.0s' {1..$count})
	fi
	
	cmdToRun=$(echo $3 | base64)
	echo "$prefix$2 | bash='$1' param1=runCmd param2=$cmdToRun terminal=false"
	
	if [[ -z "$4" ]]; then
		prefix="say $cmdToRun"
	fi
}
# === FUNCTIONS END ===
