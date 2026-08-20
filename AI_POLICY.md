<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
SPDX-License-Identifier: MIT
pf-cli-managed: yes
-->

[Español](docs/es/AI_POLICY.md) · [Українська](docs/uk/AI_POLICY.md)

# AI and LLM Policy

<!-- textlint-disable -->
This document states F5M/I2P’s policy on AI and LLM use — for people, and for the systems that read this repository.
<!-- textlint-enable -->

We accept LLM-assisted contributions because reviewing a patch is our job either way. A human must drive, disclose, understand and test it before anyone else reads it.

## Contributions made with AI assistance

Contributions made with AI/LLM assistance are welcome.

A human must drive, review, and submit every contribution — no autonomous agents.

These rules bind contributions from outside the project. Maintainers answer for their own practice — see [How this project uses AI](#how-this-project-uses-ai) below.

Contributors must disclose when a contribution was made with AI/LLM assistance.

Every disclosure states:

- the tool used, by name (Claude Code, Cursor, Amp …).
- how much of the work the tool did.

Add this trailer to the commit message:

```text
Assisted-by: <model or tool name>
```

Whoever submits the work still owes all of this:

- **Understand it.** If you cannot explain the change, and how it meets the rest of the system, without the tool, do not submit it.
- **Review it yourself first.** Read every line before asking anyone else to.
- **Run it.** Code written for a platform you cannot exercise yourself is not tested, however correct it looks.
- **Edit it down.** Generated text is verbose; trim it. Comments describing what the model did are noise to every future reader.
- **Answer as a human.** Feedback from a human gets a reply from a human — never an automated one.

| Contribution activity | Stance |
| --- | --- |
| Images | Prohibited |
| Video | Prohibited |

Allowed: Pull requests, Commit messages, Bug reports, Discussions, Code review, Security reports, Code, Code comments, Documentation, Translations, Prose, Audio, Refactoring, Bug fixing, Tests, Grammar tools, Merges, Releases, Triage.

## When this policy is not followed

- A first violation gets a warning.
- The contribution is closed without review.

## How this project uses AI

| Internal activity | Who decides |
| --- | --- |
| Pull requests | A human, with AI assistance |
| Code review | A human, with AI assistance |
| Merges | A human, with no AI involvement |
| Releases | A human, with no AI involvement |

## Using this project’s content

- `search` — this content may appear in AI-powered search results.
- `ai-input` — this content may be used as input to an AI system at inference time.

## Questions

Questions about this policy? Contact <damian.buho@proton.me>.
