# Security policy

## Reporting a vulnerability

Please do not open a public issue for a security problem. Use GitHub's private reporting instead: open the **Security** tab of this repository and choose **Report a vulnerability**. Include what you found, how to reproduce it, and what you think the impact is.

We aim to acknowledge a report within a few working days. This is a research project maintained by a small team, so we cannot promise a fixed response time or a bug bounty.

## If you find a leaked credential

Report it privately in the same way. Do not paste the credential anywhere. The maintainers rotate the credential first and clean the history second.

## Supported versions

The project is pre-release. Only the `main` branch is maintained.

## Scope

In scope: the code and configuration in this repository, and the deployment it describes (the SQL tool, the code sandbox, the papers service, the sign-in flow and any file-serving endpoint).

Out of scope: the upstream projects we build on (Open WebUI, CILogon, Lumen, PostgreSQL, DuckDB). Please report problems in those to their maintainers.
