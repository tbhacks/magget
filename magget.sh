#!/bin/bash

# Default to downloading MagPi
if [ -z "$1" ]; then
	MAG=magpi
else
	MAG=$1
fi

# Optional destination directory
if [ -z "$2" ]; then
	DIR=.
else
	DIR=$2
fi

# Create directory if it doesn't exist
if [ ! -d "$DIR" ]; then
	mkdir $DIR
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
echo "Fetching from $URL"

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
		curl -o $DIR/$fname $rfname
	fi
done
