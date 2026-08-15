#!/usr/bin/env bash
# galaxy.yml's version and the newest CHANGELOG heading must agree.
#
# This exists because they silently disagreed once: two PRs changed the same `version:` line,
# the merge resolved it in favour of one side and kept the other's changelog entry, and the
# result was a valid-looking file that could not be released. A version conflict is the one
# kind that does NOT leave a marker for someone to resolve, so nothing surfaced it.
set -euo pipefail

galaxy=$(sed -n 's/^version:[[:space:]]*["'"'"']\{0,1\}\([0-9][^"'"'"']*\)["'"'"']\{0,1\}[[:space:]]*$/\1/p' galaxy.yml | head -1)
changelog=$(sed -n 's/^##[[:space:]]\{1,\}\([0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}\).*$/\1/p' CHANGELOG.md | head -1)

if [ -z "$galaxy" ]; then
  echo "could not read a version from galaxy.yml" >&2
  exit 1
fi
if [ -z "$changelog" ]; then
  echo "could not find a '## x.y.z' heading in CHANGELOG.md" >&2
  exit 1
fi

if [ "$galaxy" != "$changelog" ]; then
  cat >&2 <<EOF
galaxy.yml says $galaxy but the newest CHANGELOG.md heading is $changelog.

Whichever is right, they have to agree or the release is cut at the wrong
version -- or cannot be cut at all. If a merge resolved the version line in
favour of the other branch, this is that.
EOF
  exit 1
fi

echo "version OK: galaxy.yml and CHANGELOG.md both say $galaxy"
