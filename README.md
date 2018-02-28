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
	Checks max file limit of process and number of open file handles process is using.
	Defaults:
		<CRITICAL> = 40 (percentage)
		<WARNING> = 50 (percentage)
	Either:
		-f <pidfile> file that contains the pid to check (preferred)
		-n <process name grep pattern> to get pid info (first pid found gets used)
```
