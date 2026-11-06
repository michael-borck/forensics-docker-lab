#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Build an offline student ZIP for the DFIR lab.
#
#   ./scripts/make-offline-zip.sh [out-dir]       (default: dist/offline)
#
# The ZIP contains the repo plus images/ (one tar per image, linux/amd64 and an
# images.txt). On a VDI where GHCR is blocked, students unzip it and run
# ./start.sh; the launcher loads images/ with podman load before starting.
# Needs a running Docker or Podman with registry access to build the pack.
# ---------------------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")/.."

find . -name "._*" -type f -delete 2>/dev/null || true

OUTDIR="${1:-dist/offline}"
PLATFORM=linux/amd64
SLUG=forensics-docker-lab

ENGINE="${CONTAINER_ENGINE:-}"
if [ -z "$ENGINE" ]; then
    if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then ENGINE=docker
    elif command -v podman >/dev/null 2>&1 && podman info >/dev/null 2>&1; then ENGINE=podman
    else echo "Need a running docker or podman to pull and save images."; exit 1
    fi
fi
echo "==> Engine: $ENGINE (packing for $PLATFORM)"

IMAGES="$(
    {
        awk '/^[[:space:]]+image:/ {print $2}' docker-compose.yml
        find . -name 'Dockerfile*' -not -path './dist/*' -not -path './.git/*' \
            -exec grep -hE '^FROM' {} + | awk '$2 !~ /\$/ {print $2}'
    } | tr -d '"' | sed -E 's/^\$\{[A-Za-z_][A-Za-z0-9_]*:-([^}]*)\}$/\1/' | sort -u
)"
[ -n "$IMAGES" ] || { echo "No images found in docker-compose.yml?"; exit 1; }
echo "$IMAGES" | sed 's/^/    /'

verify_arch() {
    local arch
    arch="$("$ENGINE" image inspect "$1" --format '{{.Architecture}}')"
    if [ "$arch" != "amd64" ]; then
        "$ENGINE" image rm "$1" >/dev/null 2>&1 || true
        "$ENGINE" pull --platform "$PLATFORM" "$1" >/dev/null
        arch="$("$ENGINE" image inspect "$1" --format '{{.Architecture}}')"
    fi
    [ "$arch" = "amd64" ] || { echo "!! $1 is '$arch', not amd64. Refusing to pack."; exit 1; }
}

STAGE="$(mktemp -d /tmp/offline-zip.XXXXXX)"
trap 'rm -rf "$STAGE"' EXIT
ROOT="$STAGE/$SLUG"
mkdir -p "$ROOT/images"

echo "==> Staging the repo ..."
rsync -a --exclude .git --exclude dist --exclude images --exclude '._*' ./ "$ROOT/"

echo "==> Pulling and saving images ..."
: > "$ROOT/images/images.txt"
while IFS= read -r ref; do
    [ -n "$ref" ] || continue
    file="$(printf '%s' "$ref" | tr '/:@' '___').tar"
    "$ENGINE" pull --platform "$PLATFORM" "$ref" >/dev/null \
        || { echo "!! pull failed: $ref"; exit 1; }
    if [ "$ENGINE" = "docker" ]; then
        "$ENGINE" save --platform "$PLATFORM" -o "$ROOT/images/$file" "$ref" \
            || { echo "!! $ref: no usable $PLATFORM content. Refusing to pack."; exit 1; }
    else
        verify_arch "$ref"
        "$ENGINE" save -o "$ROOT/images/$file" "$ref"
    fi
    printf '%s|%s\n' "$ref" "$file" >> "$ROOT/images/images.txt"
    echo "    $ref"
done <<EOF
$IMAGES
EOF
( cd "$ROOT/images" && sha256sum *.tar > manifest.sha256 )

mkdir -p "$OUTDIR"
ZIP="$(cd "$OUTDIR" && pwd)/$SLUG-offline.zip"
echo "==> Writing $ZIP ..."
rm -f "$ZIP"
( cd "$STAGE" && zip -rq "$ZIP" "$SLUG" )

echo
echo "Offline zip ready: $ZIP"
du -sh "$ZIP"
echo "Students: download, unzip, then ./start.sh — images/ is loaded automatically."
