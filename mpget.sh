#!/bin/bash

# Optional destination directory
if [ -z "$1" ]; then
	DIR=.
else
	DIR=$1
fi

# Create directory if it doesn't exist
if [ ! -d "$DIR" ]; then
	mkdir $DIR
fi

# Get file listing
URL="https://www.raspberrypi.org/magpi/issues/"
echo "Fetching from $URL"

# Get PDF filenames
HTML=$(curl $URL 2> /dev/null)

# Last sed prevents an SSL error with curl
URLS=$(echo "$HTML" | sed -n 's/href="[^"]*\.pdf/\n&/gp' |\
sed -n 's/^href="\([^"]*\)".*/\1/gp' |\
sed -e 's/https:\/\/raspberrypi\.org/https:\/\/www\.raspberrypi\.org/'\
| sort)

# Download PDF Files
for rfname in $URLS; do
	# Get filename from URL
	fname=$(echo "$rfname" | sed -n 's/.*\/\([^\/]*\.pdf\).*/\1/p')

	# Simple check if file already exists, doesn't check contents.
	if [ ! -e $DIR/$fname ]; then
		echo "Retrieving $fname"
		curl -o $DIR/$fname $rfname
	fi
done
