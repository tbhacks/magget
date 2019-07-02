# pimags
Quick and dirty scripts for downloading Raspberry Pi magazines.

Use mpget.sh to download issues of MagPi, wfget.sh for issues of
Wireframe, and hsget.sh for issues of HackSpace. All take an optional
argument to a destination directory which will be created if it does not
exist. Otherwise they download to the working directory.

The code is not very elegant, efficient, or robust. It may stop working
if Raspberry Pi changes how these magazines are stored or accessed. It
currently works, but use at your own risk, and always respectfully.
