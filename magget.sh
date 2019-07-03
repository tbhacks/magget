#!/bin/bash

function usage {
	echo "USAGE: magget.sh [-t] [-d DIR] {magpi|wireframe|hackspace}"
	echo
	echo "-d DIR: DIR will be created if it does not exist and PDFs"
	echo "will be downloaded there."
	echo "-t: Dry run, do not create DIR or download PDFs."
	echo
	exit
}

while getopts ":td:" o; do
	case "$o" in
		t)  DRYRUN=1;;
		d)
			DIR="$OPTARG";;
		*)
			usage
	esac
done
shift $((OPTIND-1))

# Default to working directory
if [ -z "$DIR" ]; then
	DIR=.
fi

MAG=${1,,}
[[ $MAG == magpi || $MAG == wireframe || $MAG == hackspace ]] || usage

# Create directory if it doesn't exist
if [ ! -d "$DIR" ]; then
	if [ -z "$DRYRUN" ]; then
		mkdir $DIR
	fi
fi

# Setup variables depending on magazine
case "$MAG" in
	magpi)
		URL="https://www.raspberrypi.org/magpi/issues/"
		PAT="\.pdf"
		;;
	wireframe)
		URL="https://wireframe.raspberrypi.org/issues"
		PAT="full_pdfs"
		;;
	hackspace)
		URL="https://hackspace.raspberrypi.org/issues"
		PAT="full_pdfs"
		;;
	*)
esac

# Get file listing
echo "Fetching $MAG from $URL"

# Get PDF URLS
HTML=$(curl $URL 2> /dev/null)

# Last sed prevents an SSL error with curl for MagPi
URLS=$(echo "$HTML" | sed -n 's/href="[^"]*'"$PAT"'[^"]*"/\n&/gp' |\
sed -n 's/^href="\([^"]*\)".*/\1/gp' |\
sed -e 's/https:\/\/raspberrypi\.org/https:\/\/www\.raspberrypi\.org/'\
| sort)

# Download PDF Files
for rfname in $URLS; do
	# Get filename from URL
	fname=$(echo "$rfname" | sed -n 's/.*\/\([^\/]*\.pdf\).*/\1/p')

	# Simple check if file already exists, doesn't check contents.
	if [ ! -e $DIR/$fname ]; then
		echo "Retrieving $rfname"
		if [ -z "$DRYRUN" ]; then
			curl -o $DIR/$fname $rfname
		fi
	fi
done
