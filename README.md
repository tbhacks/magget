# pimags
Quick and dirty script for downloading Raspberry Pi magazines.

```
USAGE: magget.sh [-t] [-d DIR] {magpi|wireframe|hackspace}

-d DIR: DIR will be created if it does not exist and PDFs
will be downloaded there.
-t: Dry run, do not create DIR or download PDFs.
```

Use magget.sh to download magazines. Takes an optional
argument to a destination directory which will be created if it does not
exist. Otherwise it downloads to the working directory.

The code is not very elegant, efficient, or robust. It may stop working
if Raspberry Pi changes how these magazines are stored or accessed. It
currently works, but use at your own risk, and always respectfully.

