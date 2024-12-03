EXTRA COMMANDS
==============

This directory has two commands because the QuicTLS installation does
not require Perl to be installed on the target platforms. The directory
tree here mirrors the main source tree.

The scripts are found in `apps` and should be usable stand-alone.
You have have to look at the "hashbang" line.

The documentation is in `doc/man1` and is in "POD" format.

The test scripts and data are in the `test` subdirectory.


CA.pl
------

This command is a claimed to be a more user-friendly wrapper
around the openssl `ca` command.


tsget.pl
--------

This command makes a timestamp request (as described in IETF RFC 3161)
and stores the resonse in a file.
