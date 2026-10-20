# Sherpa DES

Repository to deploy the Data Sherpa for DES (Dark Energy Survey) on ACCESS' Jetstream2.

Sherpa DES is a chat assistant for DES scientists. One model answers questions with citations from DES papers, queries file-level metadata for the survey's processed images and catalogs, and reads the collaboration's public software repositories. It runs on Open WebUI with Lumen (NCSA's private LLM service) and signs users in through CILogon.

> **Status: pre-release.** The repository currently holds the security baseline and an empty skeleton. Nothing here is ready to deploy.

## Layout

| Folder | Purpose |
| --- | --- |
| `apps/` | Deployable services (one folder per service, each with its own Dockerfile and tests) |
| `libs/` | Shared Python code |
| `tools/` | Command-line tools (`sherpactl`, ingestion) |
| `eval/` | Evaluation harness and report templates |
| `domains/des/` | Everything specific to DES: sources, manifests, schema guide, skills, prompts, golden questions |
| `owui/` | Open WebUI configuration as code (settings, models, tools) |
| `deploy/` | Compose files, environment templates and runbooks; the only place that knows about a specific host |
| `docs/` | Architecture, decision records (`adr/`), security notes, runbooks |
| `tests/` | Integration and security tests |

## Security

This repository is public, and anything committed stays in its history. Read [`docs/security/data-handling.md`](docs/security/data-handling.md) before adding files, install the pre-commit hooks (see [`CONTRIBUTING.md`](CONTRIBUTING.md)), and report vulnerabilities as described in [`SECURITY.md`](SECURITY.md).

## License

BSD 3-Clause. See [`LICENSE`](LICENSE).
