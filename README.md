# nagios-plugin-openFileCheck

Check open file limit for a specific process

## Overview

This is a simple Nagios check bash script for checking the number of open file descriptors a process is using in relation to the soft maximum limit set for the process. This is particularly useful for monitoring mongod processes for numerous databases generated on the fly.

## Authors

### Main Author

Niko The Dread Pirate (@deathanchor)

## Installation

Install script into your nagios plugins for use with nagios checks.

## Usage

```
	usage: ./openFileCheck.sh -c <CRITICAL> -w <WARNING> [ -f <PIDFILE> | -n <PROCESS_NAME> ]
	This will search a log file using grep -c and will alert with
	Critical or Warning if that many or more items were found.
	Defaults:
		<CRITICAL> = 50 (percentage)
		<WARNING> = 60 (percentage)
	Either:
		-f <pidfile> file that contains the pid to check (preferred)
		-n <process name grep pattern> to get pid info
```
