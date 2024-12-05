EXTRA COMMANDS
==============

This directory has two commands because the QuicTLS installation
does not require Perl to be installed on the target platforms.

The documentation is in stand-alone `POD` format. The scripts should
also be usable stand-alone, but verify the "hashbang" line at the
start of the files.

CA.pl, CA.pod
-------------

This command is a more friendly wrapper around the openssl `ca` command.


tsget.pl, tsget.pod
-------------------

This command makes a timestamp request (as described in IETF RFC 3161)
and stores the resonse in a file.
