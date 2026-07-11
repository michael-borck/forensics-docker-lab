#!/bin/bash
# macOS: double-click to launch the forensic workstation in Terminal.
cd "$(dirname "$0")" || exit 1
exec ./start.sh
