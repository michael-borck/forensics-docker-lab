#!/bin/bash
# Forensics Lab Setup Verification Script
# Run this to verify your Docker environment is properly configured

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Forensics Lab - Environment Verification"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# --- container engine ------------------------------------------------------
# Docker by default; Podman fully supported (CONTAINER_ENGINE=podman).
ENGINE="${CONTAINER_ENGINE:-}"
if [ -z "$ENGINE" ]; then
    if command -v docker >/dev/null 2>&1; then ENGINE=docker
    elif command -v podman >/dev/null 2>&1; then ENGINE=podman
    fi
fi

ensure_podman_socket() {
    local sock="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/podman/podman.sock"
    mkdir -p "$(dirname "$sock")"
    if [ ! -S "$sock" ]; then
        systemctl --user enable --now podman.socket >/dev/null 2>&1 || true
        for _ in 1 2 3 4 5; do [ -S "$sock" ] && break; sleep 1; done
    fi
    [ -S "$sock" ] || return 1
    export DOCKER_HOST="unix://$sock"
}

COMPOSE=()
case "$ENGINE" in
    docker)
        if docker compose version >/dev/null 2>&1; then COMPOSE=(docker compose)
        elif command -v docker-compose >/dev/null 2>&1; then COMPOSE=(docker-compose)
        fi ;;
    podman)
        if podman compose version >/dev/null 2>&1; then COMPOSE=(podman compose)
        elif command -v podman-compose >/dev/null 2>&1; then COMPOSE=(podman-compose)
        elif command -v docker-compose >/dev/null 2>&1 && ensure_podman_socket; then
            COMPOSE=(docker-compose)
        fi ;;
esac

# macOS on non-APFS volumes (exFAT/FAT/network shares) litters AppleDouble
# "._*" files. BuildKit fails to read their xattrs during the context walk,
# which breaks `docker compose build` even though .dockerignore lists them.
# These are pure resource-fork companions (real data is in the non-prefixed
# file), so removing them is safe and keeps the build working everywhere.
if [ "$(uname -s)" = "Darwin" ]; then
    find . -name '._*' -not -path './.git/*' -delete 2>/dev/null
    find . -name '.DS_Store' -not -path './.git/*' -delete 2>/dev/null
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0

# Function to check and report
check() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $1"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} $1"
        ((FAILED++))
    fi
}

# 1. Check the container engine is installed
echo "Checking ${ENGINE:-container engine} installation..."
command -v "${ENGINE:-docker}" >/dev/null 2>&1
check "Container engine is installed"

[ "${#COMPOSE[@]}" -gt 0 ] && "${COMPOSE[@]}" version >/dev/null 2>&1
check "Compose front-end is available"
echo ""

# 2. Check the daemon / machine is running
echo "Checking ${ENGINE:-container engine} daemon..."
[ -n "$ENGINE" ] && "$ENGINE" ps >/dev/null 2>&1
check "Container engine is running"
echo ""

# 3. Check evidence directory exists
echo "Checking lab structure..."
[ -d "./evidence" ]
check "Evidence directory exists"

[ -d "./cases" ]
check "Cases directory exists"

[ -f "./images/dfir-cli/Dockerfile" ]
check "Dockerfile exists (images/dfir-cli/Dockerfile)"

[ -f "./docker-compose.yml" ]
check "docker-compose.yml exists"
echo ""

# 4. Check documentation files
echo "Checking documentation..."
[ -f "./README.md" ]
check "README.md exists"

[ -f "./docs/scenario.md" ]
check "docs/scenario.md exists"
echo ""

# 5. Try to build the container
echo "Testing image build..."
"${COMPOSE[@]}" build >/dev/null 2>&1
check "Container image builds successfully"
echo ""

# 6. Test container startup
echo "Testing container startup..."
"${COMPOSE[@]}" run --rm dfir echo "Container test" >/dev/null 2>&1
check "Container starts and runs commands"
echo ""

# 7. Verify forensic tools
echo "Verifying forensic tools..."
"${COMPOSE[@]}" run --rm dfir fls -V >/dev/null 2>&1
check "Sleuth Kit (fls) is available"

"${COMPOSE[@]}" run --rm dfir ewfverify -V >/dev/null 2>&1
check "libewf (ewfverify) is available"

"${COMPOSE[@]}" run --rm dfir md5sum --version >/dev/null 2>&1
check "Hash tools (md5sum) are available"
echo ""

# 8. Test volume mounts
echo "Testing volume mounts..."
"${COMPOSE[@]}" run --rm dfir test -d /evidence
check "Evidence directory is mounted at /evidence"

"${COMPOSE[@]}" run --rm dfir test -w /cases
check "Cases directory is writable at /cases"
echo ""

# 9. Check new immersive features
echo "Checking immersive features..."
[ -x "./scripts/forensics-workstation" ]
check "forensics-workstation script is available and executable"

"${COMPOSE[@]}" run --rm dfir which coc-log >/dev/null 2>&1
check "coc-log utility is available in container"

[ -f "./templates/analysis_log.csv" ]
check "analysis_log.csv template exists"
echo ""

# 10. Evidence readiness (informational — does not fail verification,
#     because USB evidence is generated on demand and memory is downloaded)
echo "Checking evidence readiness (informational)..."
if [ -f "./evidence/usb.img" ] && [ -f "./evidence/usb.E01" ]; then
    echo -e "${GREEN}✓${NC} USB evidence present (evidence/usb.img, usb.E01) — Lab 1 ready"
else
    echo -e "${YELLOW}ℹ${NC}  USB evidence not found — run ${GREEN}make evidence${NC} to generate it (Lab 1)"
fi
if [ -f "./evidence/memory.raw" ]; then
    echo -e "${GREEN}✓${NC} Memory dump present (evidence/memory.raw) — Lab 2 ready"
else
    echo -e "${YELLOW}ℹ${NC}  memory.raw not found — download a sample (see ${GREEN}docs/evidence-sources.md${NC}) to enable Lab 2"
fi
[ -f "./evidence/network.cap" ] && echo -e "${GREEN}✓${NC} network.cap present — Lab 4 ready" || echo -e "${YELLOW}ℹ${NC}  network.cap not found"
[ -f "./evidence/mail.mbox" ]  && echo -e "${GREEN}✓${NC} mail.mbox present — Lab 3 ready"   || echo -e "${YELLOW}ℹ${NC}  mail.mbox not found"
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Verification Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${GREEN}Passed:${NC} $PASSED"
echo -e "${RED}Failed:${NC} $FAILED"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 All checks passed! Your environment is ready.${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Read docs/scenario.md for the case background"
    echo "  2. Generate USB evidence:  make evidence   (Lab 1)"
    echo "  3. Get a memory sample:    see docs/evidence-sources.md  (Lab 2)"
    echo "  4. Start your investigation:"
    echo "     • Recommended: ./scripts/forensics-workstation"
    echo "     • Advanced: ${COMPOSE[*]} run --rm dfir"
    echo ""
else
    echo -e "${RED}⚠️  Some checks failed. Please review the errors above.${NC}"
    echo ""
    echo "Common fixes:"
    echo "  • Start Docker Desktop (Windows/Mac) or run: podman machine start (Podman)"
    echo "  • Ensure you're in the correct directory"
    echo "  • Check README.md troubleshooting section"
    echo ""
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Exit non-zero if any hard check failed (informational evidence checks above
# don't increment FAILED). Lets `make verify` gate CI and signal failure.
exit "$FAILED"
