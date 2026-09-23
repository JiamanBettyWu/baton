#!/bin/bash

set -eu

REPO_ROOT=$(cd "$(dirname "$0")/.." && pwd)

python3 - "$REPO_ROOT/plugin.json" "$REPO_ROOT/.claude-plugin/plugin.json" <<'PY'
import json
import sys
from pathlib import Path

portable_path = Path(sys.argv[1])
claude_path = Path(sys.argv[2])
portable_version = json.loads(portable_path.read_text(encoding="utf-8"))["version"]
claude_version = json.loads(claude_path.read_text(encoding="utf-8"))["version"]

if portable_version != claude_version:
    raise SystemExit(
        f"version mismatch: {portable_path.name}={portable_version}, "
        f".claude-plugin/{claude_path.name}={claude_version}"
    )

print(f"package metadata smoke tests passed (version {portable_version})")
PY
