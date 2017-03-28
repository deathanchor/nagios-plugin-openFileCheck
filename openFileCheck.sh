#!/bin/bash

# Checks specific process is not near set limits for process
# Written by Niko Janceski (@deathanchor)
#
# vim:noexpandtab
# vim:tabstop=4

critical=50
warning=60

usage="
	usage: $0 -c <CRITICAL> -w <WARNING> [ -f <PIDFILE> | -n <PROCESS_NAME> ]
	This will search a log file using grep -c and will alert with
	Critical or Warning if that many or more items were found.
	Defaults:
		<CRITICAL> = $critical (percentage)
		<WARNING> = $warning (percentage)
	Either:
		-f <pidfile> file that contains the pid to check (preferred)
		-n <process name grep pattern> to get pid info
"

while getopts ':c:w:f:n:' opt; do
	case $opt in
		c)
			critical=$OPTARG
			;;
		w)
			warning=$OPTARG
			;;
		n)
			processName=$OPTARG
			;;
		f)
			pidFile=$OPTARG
			;;
		\:)
			echo "-$OPTARG OPTION REQUIRES AN ARGUMENT"
			echo "$usage"
			exit 3
			;;
		\?)
			echo "UNKNOWN OPTION"
			echo "$usage"
			exit 3
			;;
	esac
done

shift $((OPTIND-1))  # This tells getopts to move on to the next argument.

if [[ -z $processName && -z $pidFile ]]; then
	echo "CRITICAL: Either -f or -n option required"
	exit 2
fi


if [ -z $processName ]; then
	if [ ! -r $file ]; then
		echo "CRITICAL: Cannot read $file"
		exit 2
	fi
	pid=`cat $pidFile`
else
	pid=`ps axf | grep $processName | grep -v -e grep -e $0 | head -1 | awk '{print $1}'`
	if [ -z $pid ]; then
		echo "CRITICAL: No process found with pattern '$processName'"
		exit 2
	fi
fi

limitfile="/proc/$pid/limits"

if [ ! -r $limitfile ]; then
	echo "CRITICAL: Cannot read limit file for processId $pid: $limitfile"
	exit 2
fi

maxOpenFileLimit=`grep 'Max open files' $limitfile | awk '{print $4}'`

currentOpenFiles=`find /proc/$pid/fd | wc -l`

remaining=$(( $maxOpenFileLimit - $currentOpenFiles ))

remainingPercentage=$(( $(( $remaining * 100 )) / $maxOpenFileLimit ))

if [[ $remainingPercentage -le $critical ]]; then
	echo "CRITICAL: ${remainingPercentage}% remaining file descriptors for process id $pid, $remaining remaining file descriptors from limit $maxOpenFileLimit"
	exit 2
elif [[ $remainingPercentage -le $warning ]]; then
	echo "WARNING: ${remainingPercentage}% remaining file descriptors for process id $pid, $remaining remaining file descriptors from limit $maxOpenFileLimit"
	exit 1
elif [[ $remainingPercentage -gt $warning ]]; then
	echo "OK: ${remainingPercentage}% remaining file descriptors for process id $pid, $remaining remaining file descriptors from limit $maxOpenFileLimit"
	exit 0
else
	echo "UNKNOWN: ${remainingPercentage}% remaining file descriptors for process id $pid, $remaining remaining file descriptors from limit $maxOpenFileLimit THIS SHOULD NOT HAPPEN"
	exit 3
fi


