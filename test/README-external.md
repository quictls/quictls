Running external test suites with QuicTLS
-----------------------------------------

It is possible to integrate external test suites into QuicTLS's test
framework.  This capability is considered a developer option and does
not work on all platforms.  By default no external tests are done, you
must configure the build with `NO_EXTERNAL_TESTS` turned off.

Python PYCA/Cryptography test suite
===================================

This python test suite runs cryptographic tests with a local QuicTLS build as
the implementation.

First checkout the `PYCA/Cryptography` module into `./pyca-cryptography` using:

    $ git submodule update --init

The tests will run in a python virtual environment which requires virtualenv
to be installed.

    $ V=1 ./test/run_tests test_external_pyca

Some tests target older (<=1.0.2) versions so will not run. Other tests target
other crypto implementations so are not relevant. Currently no tests fail.

krb5 test suite
===============

Much like the PYCA/Cryptography test suite, this builds and runs the krb5
tests against the local QuicTLS build.

You will need a git checkout of krb5 at the top level:

    $ git clone https://github.com/krb5/krb5

krb5's master has to pass this same CI, but a known-good version is
krb5-1.15.1-final if you want to be sure.

    $ cd krb5
    $ git checkout krb5-1.15.1-final
    $ cd ..

krb5's tests will then be run as part of the rest of the suite, or can be
explicitly run (with more debugging):

    $ V=1 ./test/run_tests test_external_krb5

krb5 will automatically adapt its test suite to account for the configuration
of your system.  Certain tests may require more installed packages to run.  No
tests are expected to fail.

GOST engine test suite
======================

Much like the PYCA/Cryptography test suite, this builds and runs the GOST engine
tests against the local QuicTLS build.

You will need a git checkout of gost-engine at the top level:

    $ git submodule update --init

GOST engine tests will then be run as part of the rest of the suite, or can be
explicitly run (with more debugging):

    $ V=1 ./test/run_tests test_external_gost_engine

OQSprovider test suite
======================

Much like the PYCA/Cryptography test suite, this builds and runs the OQS
(OpenQuantumSafe -- www.openquantumsafe.org) provider tests against the
local QuicTLS build.

You will need a git checkout of oqsprovider at the top level:

    $ git submodule update --init

OQSprovider tests will then be run as part of the rest of the suite, or can be
explicitly run (with more debugging):

    $ V=1 ./test/run_tests test_external_oqsprovider

The environment variable `OQS_SKIP_TESTS` can be set to select tests and
algorithms to be skipped, e.g. as follows:

    $ OQS_SKIP_TESTS=kyber ./test/run_tests test_external_oqsprovider

The names of all supported quantum-safe algorithms are available at
<https://github.com/open-quantum-safe/oqs-provider#algorithms>

Updating test suites
====================

To update the commit for any of the above test suites:

- Make sure the submodules are cloned locally:

    $ git submodule update --init --recursive

- Enter subdirectory and pull from the repository (use a specific branch/tag if required):

    $ cd `<submodule-dir>`
    $ git pull origin master

- Go to root directory, there should be a new git status:

    $ cd ../
    $ git status
      ...
      #       modified:   `<submodule-dir>` (new commits)
      ...

- Add/commit/push the update

    $ git add `<submodule-dir>`
    $ git commit -m `"Updated <submodule> to latest commit"`
    $ git push
