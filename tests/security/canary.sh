#!/usr/bin/env bash
# Canary test: the gitleaks configuration must still catch fake secrets, and must
# stay quiet on clean text. Fake secrets are assembled at run time, so this
# repository never contains one.
#
# Uses a local `gitleaks` binary if present, otherwise the pinned Docker image.
set -euo pipefail

cd "$(dirname "$0")/../.."
IMAGE="${GITLEAKS_IMAGE:-ghcr.io/gitleaks/gitleaks:v8.30.1}"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir "$tmp/env" "$tmp/slack" "$tmp/clean" "$tmp/out"

rand_hex() { openssl rand -hex "$(( $1 / 2 ))"; }

printf 'LUMEN_API_KEY=%s\n' "$(rand_hex 40)" > "$tmp/env/canary.env"
printf 'url = "https://hooks.slack.com/services/T%s/B%s/%s"\n' \
  "$(rand_hex 8 | tr 'a-f' 'A-F')" "$(rand_hex 8 | tr 'a-f' 'A-F')" "$(rand_hex 24)" > "$tmp/slack/canary.txt"
printf 'LUMEN_API_KEY=change-me-in-your-environment\nThis directory holds ordinary text.\n' > "$tmp/clean/ok.txt"

scan() { # $1 = directory to scan, $2 = report name
  if command -v gitleaks >/dev/null 2>&1; then
    gitleaks dir "$1" --config .gitleaks.toml --no-banner --redact --exit-code 0 \
      --report-format json --report-path "$tmp/out/$2.json" >/dev/null 2>&1
  else
    docker run --rm \
      -v "$1:/scan:ro" -v "$PWD/.gitleaks.toml:/gitleaks.toml:ro" -v "$tmp/out:/out" \
      "$IMAGE" dir /scan --config /gitleaks.toml --no-banner --redact --exit-code 0 \
      --report-format json --report-path "/out/$2.json" >/dev/null 2>&1
  fi
}

status=0
check_caught() { # $1 = report name, $2 = expected pattern
  if grep -q "$2" "$tmp/out/$1.json" 2>/dev/null; then
    echo "ok: $1 canary was caught"
  else
    echo "FAIL: $1 canary was NOT caught" >&2; status=1
  fi
}

scan "$tmp/env" env;     check_caught env "sherpa-env-secret-assignment"
scan "$tmp/slack" slack; check_caught slack "RuleID"
scan "$tmp/clean" clean
if grep -q "RuleID" "$tmp/out/clean.json" 2>/dev/null || [ ! -f "$tmp/out/clean.json" ]; then
  echo "FAIL: clean text was flagged (or the scan did not run)" >&2; status=1
else
  echo "ok: clean text passes"
fi

exit "$status"
