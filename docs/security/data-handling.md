# Data handling

This repository is public. This page says which kinds of material may enter it, and where everything else lives.

## Categories

| Category | Examples | In git? | Lives in |
| --- | --- | --- | --- |
| Code and configuration | Python, Dockerfiles, compose files, skills, prompts | Yes | This repository |
| Placeholders | `*.env.example` files with fake values | Yes | This repository |
| Public reference data | DES papers, the public DES software repositories, file-level metadata | No (size and provenance) | Developer machine, then the deployment volume; manifests (ids, checksums, pinned commit SHAs) are committed |
| Collaboration-internal content | DocDB documents, wiki pages, Slack messages | Never | Developer machine and the deployment volume only; shown only to approved users |
| Secrets | API keys, tokens, passwords, client secrets, webhook URLs, signing and private keys | Never | Secrets files on the host, outside the repository |
| Personal and environment data | User lists, email addresses, IP addresses, host inventories | Never | Secrets files or the database |

## Rules

1. Collaboration-internal content is never committed, baked into a Docker image, or used as a test fixture. Test fixtures use invented or clearly public text.
2. Evaluation outputs may quote public papers. They must not quote internal content, so run output is kept out of git (`eval/runs/`, `eval/reports/` are ignored) and shared reports are written by hand.
3. Secrets are passed through environment files on the host, never through the repository, an image layer or a command line that ends up in shell history.
4. Environment-specific values (host names, addresses, paths on a given machine) belong in `deploy/` templates as placeholders.
5. When in doubt, do not commit it. Ask a maintainer.

## How the rules are enforced

- `.gitignore` excludes data, key and environment files.
- Pre-commit hooks run gitleaks and refuse data files, keys and real env files.
- CI repeats those checks, scans the full history, and runs a canary that proves the scanner still catches fake secrets.
- GitHub secret scanning and push protection are enabled (see `repo-settings.md`).

## If something leaks

Rotate first, clean history second, and tell the maintainers. See `CONTRIBUTING.md`.
