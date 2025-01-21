#include <assert.h>
#include <stdio.h>

#include <openssl/bio.h>
#include <test/testutil.h>

#if defined OPENSSL_SYS_WINDOWS
#define TEST_HAVE_FMEMOPEN 0
#else
#define TEST_HAVE_FMEMOPEN 1
#endif

#define TEST_MAXBUF 3

static const struct test {
    size_t bufsiz;
    const char *fmt;
    int arg;
    int expect;
} tests[] = {
    { 3, "%d", 1, 1 },
    { 3, "%d", 11, 2 },
    { 3, "%d", 111, -1 },
#if !defined OPENSSL_SYS_WINDOWS
    /*
     * Windows doesn't return -1 on bad wchar_t, continuing to process the
     * remaining format specification (though it does set EILSEQ). In this
     * case it returns 0. Just skip rather than accommodate in test logic.
     */
    { 3, "%lc", -2, -1 },
#endif
};

static void
test_post(int *pass, int *fail, int ok)
{
	*pass += !!ok;
	*fail += !ok;
}

#if TEST_HAVE_FMEMOPEN
static int
test_bio_vprintf(void)
{
    char buf[TEST_MAXBUF];
    int pass = 0, fail = 0;
    for (size_t i = 0; i < OSSL_NELEM(tests); i++) {
        /* adjust test to account for lack of NUL involvement */
        struct test T = tests[i];
        T.bufsiz--;
        assert(sizeof buf >= T.bufsiz);

        FILE *fp = NULL;
        if (!TEST_ptr(fp = fmemopen(buf, T.bufsiz, "w"))) {
            TEST_perror("fmemopen");
            test_post(&pass, &fail, 0);
            continue;
	}
        setbuf(fp, NULL); /* stdio buffering might hide error until fflush */

        BIO *bio = NULL;
        if (!TEST_ptr(bio = BIO_new_fp(fp, BIO_NOCLOSE))) {
            TEST_openssl_errors();
            test_post(&pass, &fail, 0);
            fclose(fp);
            continue;
        }

        /* BIO_printf just passes through to BIO_vprintf */
        int result = BIO_printf(bio, T.fmt, T.arg);
        /*
         * BIO_write returns 0, not -1, on failure to complete a write, and
         * various BIO_printf implementations, including ours at comment
         * time, pass the return value to the caller. Fix-up here rather
         * than complexify our test specifications.
         */
        if (result == 0)
            result = -1;
        test_post(&pass, &fail, TEST_int_eq(result, T.expect));

        if (!BIO_free(bio))
	    TEST_openssl_errors();
        if (0 != fclose(fp))
	    TEST_perror("fclose");
    }
    return !fail && pass > 0;
}
#endif

static void
call_bio_vsnprintf(int *pass, int *fail, const struct test *T, const char *fmt, ...)
{
    char buf[TEST_MAXBUF];
    va_list ap;
    va_start(ap, fmt);
    assert(sizeof buf >= T->bufsiz);
    test_post(pass, fail, TEST_int_eq(BIO_vsnprintf(buf, T->bufsiz, fmt, ap), T->expect));
    va_end(ap);
}

static int
test_bio_vsnprintf(void)
{
    int pass = 0, fail = 0;
    for (const struct test *T = tests; T < &tests[OSSL_NELEM(tests)]; T++) {
        call_bio_vsnprintf(&pass, &fail, T, T->fmt, T->arg);
    }
    return !fail && pass > 0;
}

static int
test_bio_snprintf(void)
{
    char buf[TEST_MAXBUF];
    int pass = 0, fail = 0;
    for (const struct test *T = tests; T < &tests[OSSL_NELEM(tests)]; T++) {
        assert(sizeof buf >= T->bufsiz);
        test_post(&pass, &fail, TEST_int_eq(BIO_snprintf(buf, T->bufsiz, T->fmt, T->arg), T->expect));
    }
    return !fail && pass > 0;
}

int
setup_tests(void)
{
#if TEST_HAVE_FMEMOPEN
    ADD_TEST(test_bio_vprintf);
#endif
    ADD_TEST(test_bio_snprintf);
    ADD_TEST(test_bio_vsnprintf);
    return 1;
}
