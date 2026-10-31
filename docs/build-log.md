# Build log

A running record of what was done, what it showed, and what to remember. Entries are keyed by the step numbers of the SherpaDES v1 implementation plan (a private document; its step IDs, such as 0.4 or 3.13, are the cross-reference). Decisions D1 to D15 are recorded in the plan; this log records results.

Rules for this file: it is public, so it holds numbers and findings, never keys, tokens, IP addresses, personal emails, user lists or data content. Raw terminal output stays out; keep the figures that matter.

Status: done, in progress, blocked (waiting on someone), not started.

## Index

| Step | What | Status | Date |
| --- | --- | --- | --- |
| 0.1 | Lumen reachable from the Mac and the VM | done | 20 Oct 2026 |
| 0.2 | Repo with security baseline | done | 20 Oct 2026 |
| 0.3 | Data in place and pinned | mostly done | 20 Oct 2026 |
| 0.4 | `sherpa-base` verified, DNS, database | done | 20 Oct 2026 |
| 0.5 | OSN bucket and rclone | blocked | 31 Oct 2026 |
| 0.6 | CILogon callback | not started | |
| 0.7 | Mac workbench and embedding speed | in progress | 31 Oct 2026 |
| 0.8 | Golden set v0 | not started | |
| review | Felipe's `sherpa-lab` changes, 20 to 30 Oct | done | 30 Oct 2026 |

## Phase 0

### 0.1 Lumen test (done, 20 Oct)

- The model list shows `glm-5.3`, and a chat reply arrives from both the Mac and the VM.
- Note: Lumen serves chat models only; there is no embeddings endpoint yet, so embeddings run on our side.

### 0.2 Repo and security baseline (done, 20 Oct)

- Merged as PR #1. Both CI checks (`Secret scan (full history)`, `Pre-commit hooks`) are green on `main`.
- GitHub settings verified: Secret Protection with validity checks, extended metadata, generic patterns, AI-detected secrets and push protection on; ruleset `protect-main` (pull request required, both checks required, no force pushes or deletion, empty bypass list); Actions token read-only and actions pinned to full commit SHAs. Two-factor for the organization is not yet confirmed by an owner. Details: `docs/security/repo-settings.md`.
- Notes for the future:
  - GitHub's current layout shows "Secret Protection" as one switch; push protection and the scanning options appear as sub-toggles after it is enabled.
  - `pre-commit run --all-files` only checks tracked files, so run `git add -A` first.
  - The gitleaks hook builds with Go on first use, so the first run is slow.
  - The merge button defaults to a merge commit. Squash is allowed; after a squash, delete the local branch with `git branch -D`.
  - `pre-commit` is installed system-wide with Python 3.12 (python.org), not in conda.

### 0.3 Data in place and pinned (mostly done, by 20 Oct)

- Data-Concierge copy to the Mac: 126.4 GB, transferred with `rsync` over ssh and verified against a size manifest (0 rsync errors; the wiki tarball, 35 GiB, matched).
- DuckDB file copied with a matching SHA-256 and made read-only. It has 12 tables; paths are relative to the archive roots.
- The archive images total about 369 TB (estimated from row counts times mean file sizes), so they cannot be mirrored; they stay on Taiga.
- Findings that affect later steps:
  - Release prefixes such as `Y6A2` differ from processing-run folders such as `Y5A1`; catalog counts exceed image counts.
  - `Y5A1` and `Y5A1_taiga` share no exposures (9,841,879 and 2,834,121 rows, overlap 0); the meaning of `Y5A1_taiga` is a question for Felipe (step 4.1).
  - One notes file in the data folder appears to contain credentials. Felipe was asked to rotate them; the file is never copied, printed or committed.
- `repos.tsv`, the commit SHAs of the 48 code repositories, was merged as PR #2 (`domains/des/repos.tsv`).
- Open: confirm that only public Slack channels are present (394 JSON files under `des_slack_public`) and that no private export came along.

### 0.4 `sherpa-base` verified (done, 20 Oct)

- DNS: `des.sherpa.ncsa.illinois.edu` is an alias of the base host; no CAA records restrict certificate authorities.
- `verify.sh` passes: volume mounted, Postgres 17 data on the volume, three containers healthy, pgvector 0.8.7.
- Database `des` exists with pgvector. The production Let's Encrypt certificate is valid after a staging test.
- Note: an old `des-smoke-web` container (plain nginx) still answers on the `des` hostname; remove it before the real deploy.

### 0.5 OSN bucket and rclone (blocked, 31 Oct)

- rclone v1.75.2 is installed on the Mac (system-wide).
- The OSN allocation page (project The Data Concierge, 2 TB, active until 25 Aug 2027) shows the quota only, with no bucket name, endpoint or keys. Either the bucket is not provisioned or a plain user cannot see its details.
- Waiting for: the PI to check his view of the allocation and, if needed, a request to OSN to provision the bucket.
- Notes: OSN creates one bucket per allocation, with a read/write and a read-only key pair; there is no snapshot or backup. The public Gold data lives in a different bucket. OSN drops long connections after 4 to 5 minutes, so use chunked transfers. The allocation ends on 25 Aug 2027, so backups there need a renewal plan.
- Until then, backups use the VM volume and the Mac.

### 0.6 CILogon (not started)

- Add the production callback to the existing CILogon client; one production client, no localhost client.

### 0.7 Mac workbench and embedding speed (in progress, 31 Oct)

- `uv` and the benchmark script (`bench_embed.py`, kept outside the repo) were prepared. It embeds a fixed sample of 256 chunks on the Mac's GPU and CPU in float32 with the lab's pinned model revision, and reports chunks per second and the cosine agreement between devices.
- Results to record here: chunks per second on each device, estimated hours for 81,982 chunks, question latency, parity (target: minimum cosine at least 0.9999).

### 0.8 Golden set v0 (not started)

- Include retrieval labels (question to paper and page) and the lab's open case: the S8 question where the study's own abstract ranks outside the top 8.

## Review of sherpa-lab, 20 to 30 Oct (done, 30 Oct)

- About 35 commits. The lab rebuilt papers search as its own service (Mistral Document AI extraction, ADS metadata, chunker v2, Qwen3-Embedding-0.6B on an H100, pgvector schema per collection, hybrid search, signed PDF links). Measured there: question embedding 250 to 300 ms and search 150 to 250 ms in the service; a CPU reranker needs 9 to 41 s, so it is excluded.
- Also new: a Y6 Gold 2.2 catalog service (691 million objects), a name resolver using three services with a cache after a CDS outage, nightly backups, Entra ID sign-in.
- Outcome: decisions D11 to D15 in the plan. Felipe's work is the reference; we reuse the extraction and metadata as inputs and rebuild the rest; Gold is v1.1; code may be copied with credit in a NOTICE file; the PDF-copy question (D15) is open.

## Open items

- Felipe: share the extracted Markdown, the ADS metadata and the baseline question file; rotate the credentials found in the data folder; answer the schema CHECK items and the `Y5A1_taiga` question; check the OSN allocation.
- You: create the Slack channel for sign-up alerts and name the approving admins; add the CILogon callback (0.6); confirm two-factor at the organization.
