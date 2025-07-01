Using OpenSSL Tests
===================

After a successful build, and before installing, the libraries should be tested.
Run:

    $ {appropriate-make-program} test

**Warning:** you MUST run the tests from an unprivileged account.

If some tests fail, take a look at the section Test Failures below.

Test Failures
-------------

If some tests fail, look at the output.  There may be reasons for the failure
that isn't a problem in OpenSSL itself (like an OS malfunction or a Perl issue).
You may want increased verbosity, that can be accomplished like this:

Full verbosity, showing full output of all successful and failed test cases:

    $ V=1 ./test/run_tests

Verbosity on failed (sub-)tests only:

    $ VF=1 ./test/run_tests

Verbosity on failed (sub-)tests and progress on succeeded (sub-)tests:

    $ VFP=1 ./test/run_tests

If you want to run just one or a few specific tests, you can use specify
them on the command line:

    $ ./test/run_tests test_rsa test_dsa

And of course, you can combine (Unix examples shown):

    $ VF=1 ./test/run_tests test_rsa test_dsa

Have a look at the manual for the perl module Test::Harness to
see what other HARNESS_* variables there are.

The arguments to the script support a versatile set of space separated tokens
with which you can specify a set of tests to be performed.  With a "current
set of tests" in mind, initially being empty, here are the possible tokens:

     alltests      The current set of tests becomes the whole set of available
                   tests (as listed when you do 'make list-tests' or similar).

     xxx           Adds the test 'xxx' to the current set of tests.

    -xxx           Removes 'xxx' from the current set of tests.  If this is the
                   first token in the list, the current set of tests is first
                   assigned the whole set of available tests, effectively making
                   this token equivalent to TESTS="alltests -xxx".

     nn            Adds the test group 'nn' (which is a number) to the current
                   set of tests.

    -nn            Removes the test group 'nn' from the current set of tests.
                   If this is the first token in the list, the current set of
                   tests is first assigned the whole set of available tests,
                   effectively making this token equivalent to
                   TESTS="alltests -xxx".

Also, all tokens except for "alltests" may have wildcards, such as *.

### Examples

Run all tests except for the fuzz tests:

    $ ./test/run_tests '-test_fuzz*'

or, if you want to be explicit:

    $ ./test/run_tests alltests '-test_fuzz*'

Run all tests that have a name starting with "test_ssl" but not those
starting with "test_ssl_":

    $ ./test/run_tests 'test_ssl* '-test_ssl_*'

Run only test group 10:

    $ ./test/run_tests 10

Run all tests except the slow group (group 99):

    $ ./test/run_tests -99

Run all tests in test groups 80 to 99 except for tests in group 90:

    $ ./test/run_tests '[89]?' -90

To run specific fuzz tests you can use for instance:

    $ ./test/run_tests test_fuzz_cmp test_fuzz_cms

To stochastically verify that the algorithm that produces uniformly distributed
random numbers is operating correctly (with a false positive rate of 0.01%):

    $ ./test/bntest -stochastic

Running Tests in Parallel
-------------------------

By default the test harness will execute the selected tests sequentially.
Depending on the platform characteristics, running more than one test
job in parallel may speed up test execution.  This can be requested by
setting the `HARNESS_JOBS` environment variable to a positive integer
value. This specifies the maximum number of test jobs to run in parallel.

Depending on the Perl version different strategies could be adopted to select
which test recipes can be run in parallel.  In recent versions of Perl, unless
specified otherwise, any task can be run in parallel. Consult the documentation
for `TAP::Harness` to know more.

To run up to four tests in parallel at any given time:

    $ HARNESS_JOBS=4 ./test/run_tests

Random numbers in tests
-----------------------

Some tests use random numbers as part of the test. In some cases a test failure
may occur for some random numbers, but not for others. The seed used for the
rand number generator can be set via the `OPENSSL_TEST_RAND_SEED` environment
variable. It can also be set via the `OPENSSL_TEST_RAND_ORDER` environment
variable which additionally randomises the order tests are run in (see below).

When a test fails the test harness will display the seed used during the test
(displaying either the `OPENSSL_TEST_RAND_SEED` or `OPENSSL_TEST_RAND_ORDER`
environment variable value that must be used to recreate the results), e.g.

    $ OPENSSL_TEST_RAND_SEED=42 ./test/run_tests

Randomisation of Test Ordering
------------------------------

By default, the test harness will execute tests in the order of their
numeric prefix. By setting the `OPENSSL_TEST_RAND_ORDER` environment
variable to zero, the test ordering will be randomised. This additionally
seeds the random number generator used within the tests as described in
the section above. If a randomly ordered test fails, the seed value used
will be reported.  Setting the `OPENSSL_TEST_RAND_ORDER` environment
variable to this value will rerun the tests in the same order and will
also seed the test random number generator.  This assures repeatability
of randomly ordered test runs. This repeatability is independent of the
operating system, processor or platform used.

To randomise the test ordering:

    $ OPENSSL_TEST_RAND_ORDER=0 ,/test/run_tests

To run the tests using the order defined by the random seed `42`:

    $ OPENSSL_TEST_RAND_ORDER=42 ./test/run_tests
