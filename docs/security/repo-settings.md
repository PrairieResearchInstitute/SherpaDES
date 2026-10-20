# GitHub repository settings

These settings live in GitHub, not in git, so they are written down here and checked by a maintainer. Last verified: not yet.

## Settings to enable

| Setting | Where | Value |
| --- | --- | --- |
| Secret scanning | Settings, Code security | On |
| Push protection | Settings, Code security | On |
| Private vulnerability reporting | Settings, Code security | On |
| Dependabot alerts and security updates | Settings, Code security | On |
| Branch protection for `main` | Settings, Rules | Require a pull request, require the `Secret scan (full history)` and `Pre-commit hooks` checks, require code owner review, block force pushes and deletion |
| Two-factor authentication | Organization settings, Authentication security | Required for all members |
| Actions permissions | Settings, Actions | Read-only default token; allow only actions pinned by commit SHA |

## Check that the guards work

1. Locally: install the hooks (`pre-commit install`), stage a file containing a made-up `LUMEN_API_KEY=` line with a 40-character value, and confirm the commit is refused. Do not push it.
2. In CI: `bash tests/security/canary.sh` runs in the `Secret scan` job and fails if the scanner stops catching fake secrets.
3. On GitHub: confirm in Settings, Code security that push protection shows as enabled.
