<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
SPDX-License-Identifier: MIT
pf-cli-managed: yes
-->

[Español](docs/es/SECURITY.md) · [Українська](docs/uk/SECURITY.md)

# Security Policy

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public issues, discussions, or change requests.**

Report them by emailing **<damian.buho@proton.me>**.

Please include as much of the following as you can — it helps us triage and resolve the report faster:

- The type of issue (e.g. buffer overflow, SQL injection, cross-site scripting)
- Affected version(s)
- The impact of the issue, including how an attacker might exploit it
- Step-by-step instructions to reproduce the issue
- The location of the affected source code (tag, branch, commit, or direct URL)
- Full paths of the source file(s) related to the issue
- Any configuration required to reproduce the issue
- Relevant log files, if possible
- Proof-of-concept or exploit code, if possible

We aim to acknowledge reports within 30 days and to coordinate
disclosure once a fix is available.

## Encrypting a Report

If you would like to send us an encrypted report, follow these steps.

Import our public key:

```sh
gpg --keyserver keys.openpgp.org --recv-keys B64C122EE16C3746
```

Verify the fingerprint matches before you trust it:

```sh
gpg --fingerprint B64C122EE16C3746
```

The output must show:

```text
6F19 7084 3C9E 8406 AD70  0467 B64C 122E E16C 3746
```

Encrypt your message to us:

```sh
gpg --encrypt --armor --recipient B64C122EE16C3746 message.txt
```

## Bug Bounty

F5M / I2P does not currently run a bug bounty programme. We still welcome
responsibly disclosed reports — see the contact channel above.

## Acknowledged Vulnerabilities

The following findings were reviewed and are intentionally suppressed (a fix
depends on an upstream release, or the advisory does not apply to this project):

| ID | Reason |
| --- | --- |
| CVE-2026-10050 | unfixable upstream dependency; fixable only via upstream release |
| CVE-2026-1605 | unfixable upstream dependency; fixable only via upstream release |
| CVE-2026-2332 | unfixable upstream dependency; fixable only via upstream release |
| GHSA-355h-qmc2-wpwf | unfixable upstream dependency; fixable only via upstream release |
| GHSA-xxh7-fcf3-rj7f | unfixable upstream dependency; fixable only via upstream release |
