# GitHub repository settings

These settings live in GitHub, not in git, so they are written down here and checked by a maintainer. Last verified: 2026-10-20 (all rows except two-factor authentication, which an organization owner still has to confirm).

## Settings to enable

| Setting | Where | Value |
| --- | --- | --- |
| Secret Protection (secret scanning, validity checks, extended metadata, generic patterns, AI-detected secrets) | Settings, Advanced Security | On |
| Push protection | Settings, Advanced Security | On; bypass allowed for anyone with write access while there is a single maintainer, switch to bypass requests once there are more |
| Private vulnerability reporting | Settings, Code security | On |
| Dependabot alerts and security updates | Settings, Code security | On |
| Ruleset `protect-main` | Settings, Rules | Active on the default branch with an empty bypass list. Require a pull request (0 approvals while there is a single maintainer; raise to 1 and require code owner review when there are more), require the `Secret scan (full history)` and `Pre-commit hooks` checks, block force pushes and deletion |
| Two-factor authentication | Organization settings, Authentication security | Required for all members |
| Actions permissions | Settings, Actions | Read-only default token; require actions to be pinned to a full-length commit SHA |

## Check that the guards work

1. Locally: install the hooks (`pre-commit install`), stage a file containing a made-up `LUMEN_API_KEY=` line with a 40-character value, and confirm the commit is refused. Do not push it.
2. In CI: `bash tests/security/canary.sh` runs in the `Secret scan` job and fails if the scanner stops catching fake secrets.
3. On GitHub: confirm in Settings, Code security that push protection shows as enabled.
