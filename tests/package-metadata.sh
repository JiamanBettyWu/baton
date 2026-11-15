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

# Every reference file a skill links to must exist, and every reference file
# must be linked from its skill: a procedure nobody is sent to is never read.
import re

root = portable_path.parent
for skill in sorted(root.glob("skills/*/SKILL.md")):
    body = skill.read_text(encoding="utf-8")
    linked = set(re.findall(r"\]\((references/[^)#]+)\)", body))
    present = {
        str(p.relative_to(skill.parent))
        for p in skill.parent.glob("references/*")
        if p.is_file() and not p.name.startswith(".")
    }
    if linked != present:
        raise SystemExit(
            f"{skill.relative_to(root)}: reference links {sorted(linked)} "
            f"do not match files {sorted(present)}"
        )

print(f"package metadata smoke tests passed (version {portable_version})")
PY
