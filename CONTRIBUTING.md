# Contributing

This repository is public. Anything you commit stays visible forever, including in history, so the rules below are strict.

## Set up the guards before your first commit

```bash
python -m pip install pre-commit      # or: uv tool install pre-commit
pre-commit install
```

The hooks scan for secrets and refuse data files, keys and real `.env` files. CI runs the same checks on every pull request, plus a full-history secret scan.

## Never commit

- Secrets of any kind: API keys, tokens, passwords, client secrets, webhook URLs, signing keys, private keys, real `.env` files. Commit `*.env.example` files with placeholders instead.
- Data: corpus files, PDFs, DuckDB or Parquet files, database dumps, model weights, Slack, DocDB or wiki content, and evaluation outputs that quote private text.
- Environment details: IP addresses, internal host names, personal email addresses, lists of users.

See [`docs/security/data-handling.md`](docs/security/data-handling.md) for what lives where.

## Pull requests

`main` is protected: changes arrive by pull request, CI must pass, and a code owner reviews. Keep pull requests small and say what you tested.

## If you committed a secret

1. Rotate the credential immediately. Assume it is compromised.
2. Tell a maintainer.
3. Only then clean the history. Removing it from git does not make it safe again.
