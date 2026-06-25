#!/bin/bash
# Forensics Lab Setup Verification Script
# Run this to verify your Docker environment is properly configured

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Forensics Lab - Environment Verification"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

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

# 1. Check Docker is installed
echo "Checking Docker installation..."
docker --version >/dev/null 2>&1
check "Docker is installed"

docker compose version >/dev/null 2>&1
check "Docker Compose is available"
echo ""

# 2. Check Docker daemon is running
echo "Checking Docker daemon..."
docker ps >/dev/null 2>&1
check "Docker daemon is running"
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
echo "Testing Docker build..."
docker compose build >/dev/null 2>&1
check "Docker image builds successfully"
echo ""

# 6. Test container startup
echo "Testing container startup..."
docker compose run --rm dfir echo "Container test" >/dev/null 2>&1
check "Container starts and runs commands"
echo ""

# 7. Verify forensic tools
echo "Verifying forensic tools..."
docker compose run --rm dfir fls -V >/dev/null 2>&1
check "Sleuth Kit (fls) is available"

docker compose run --rm dfir ewfverify -V >/dev/null 2>&1
check "libewf (ewfverify) is available"

docker compose run --rm dfir md5sum --version >/dev/null 2>&1
check "Hash tools (md5sum) are available"
echo ""

# 8. Test volume mounts
echo "Testing volume mounts..."
docker compose run --rm dfir test -d /evidence
check "Evidence directory is mounted at /evidence"

docker compose run --rm dfir test -w /cases
check "Cases directory is writable at /cases"
echo ""

# 9. Check new immersive features
echo "Checking immersive features..."
[ -x "./scripts/forensics-workstation" ]
check "forensics-workstation script is available and executable"

docker compose run --rm dfir which coc-log >/dev/null 2>&1
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
    echo "     • Advanced: docker compose run --rm dfir"
    echo ""
else
    echo -e "${RED}⚠️  Some checks failed. Please review the errors above.${NC}"
    echo ""
    echo "Common fixes:"
    echo "  • Start Docker Desktop (Windows/Mac)"
    echo "  • Run: sudo systemctl start docker (Linux)"
    echo "  • Ensure you're in the correct directory"
    echo "  • Check README.md troubleshooting section"
    echo ""
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
