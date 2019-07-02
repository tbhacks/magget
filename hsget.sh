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
URL="https://hackspace.raspberrypi.org/issues"
echo "Fetching from $URL"

# Get PDF URLS
HTML=$(curl $URL 2> /dev/null)

URLS=$(echo $HTML | sed -e 's/href="[^"]*full_pdfs[^"]*"/\n&/gp' | \
sed -n 's/^href="\([^"]*full_pdfs[^"]*\)">.*/\1/gp' | sort | uniq)

# Download PDF Files
for rfname in $URLS; do
	# Get filename from URL
	fname=$(echo $rfname | sed -n 's/.*\/\(.*\.pdf\).*/\1/p')
	
	# Simple check if file already exists, doesn't check contents.
	if [ ! -e $DIR/$fname ]; then
		echo "Retrieving $fname"
		curl -o $DIR/$fname $rfname
	fi
done
