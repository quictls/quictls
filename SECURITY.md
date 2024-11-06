# Security Policies and Procedures

This document outlines security procedures and general
policies for the QuicTLS project.

Thanks for helping to secure the internet!

## Reporting Security Issues

_Note:  Please do not report security vulnerabilities
through public GitHub issues._

Instead, please report them through Akamai's [bug
bounty
program](https://hackerone.com/akamai?type=team) or
reach out to
[security@akamai.com](mailto:security@akamai.com).

If you wish to encrypt your communications, please use
the [Akamai Security PGP
key](https://www.akamai.com/content/dam/site/en/documents/akamai/2023/akamai-security-general.pub).

## Vulnerabilities in Scope

Please note that we will only accept reports that meet
the OpenSSL “HIGH” and “CRITICAL”
[criteria](https://openssl-library.org/policies/general/security-policy/):

 * CRITICAL Severity. This affects common configurations
   and which are also likely to be exploitable. Examples
   include significant disclosure of the contents of
   server memory (potentially revealing user details),
   vulnerabilities which can be easily exploited remotely
   to compromise server private keys or where remote code
   execution is considered likely in common situations.

 * HIGH Severity. This includes issues that are of a
   lower risk than critical, perhaps due to affecting
   less common configurations, or which are less likely
   to be exploitable. These issues will trigger a new
   release of all supported versions.
 
Once we determine that a report is valid and
actionable, we will promptly notify OpenSSL and the
BoringSSL (Google) and LibreSSL (OpenBSD) forks,
typically within two or three business days.  We
intend to work with the reporter(s) to coordinate a
timeline for fixes and possible publication in line
with responsible disclosure best practices.

## What information to provide

Please include the following information in your
report:

* the type of issue (e.g., buffer overflow, use-after-free, out-of-bounds read, ...)
* full paths of source file(s) related to the manifestation of the issue
* the location of the affected source code (tag/branch/commit or direct URL)
* any special configuration required to reproduce the issue
* step-by-step instructions to reproduce the issue
* proof-of-concept or exploit code (if possible)
* impact of the issue, including how an attacker might exploit the issue

We will work with you on resolving the issue and may
then create a public GitHub issue to track the update
and ensure transparency after we have resolved the
vulnerability.

## Policy

The Akamai [Security Research
Agreement](https://www.akamai.com/content/dam/site/en/documents/akamai/2024/security-research-agreement.pdf)
(SRA) provides the general framework for how you are
permitted to engage in any effort arising from or
related to the security of the Akamai ecosystem. By
participating in any of Akamai’s programs, you agree
to be subject to the SRA.

For more information, please see the
[Akamai Vulnerability Reporting](https://www.akamai.com/global-services/support/vulnerability-reporting) website.
