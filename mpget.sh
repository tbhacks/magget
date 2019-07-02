#!/bin/sh

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
URL="https://www.raspberrypi.org/magpi-issues/"
echo "Fetching from $URL"

# Get PDF filenames
HTML=$(curl $URL 2> /dev/null)

FNAMES=$(echo $HTML | sed -e 's/<a href="[^"]*\.pdf">/\n&/gp' | \
sed -n 's/^<a href="\([^"]*\.pdf\)">.*/\1/gp')

# Download PDF Files
for fname in $FNAMES; do
	# Simple check if file already exists, doesn't check contents.
	if [ ! -e $DIR/$fname ]; then
		echo "Retrieving $URL$fname"
		curl -o $DIR/$fname $URL$fname
	fi
done
