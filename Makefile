.PHONY: start verify setup help evidence gui gui-stop

help:
	@echo "Digital Forensics Lab - Quick Commands"
	@echo ""
	@echo "Available commands:"
	@echo ""
	@echo "  make start      - Enter the forensic workstation (pulls prebuilt image)"
	@echo "  make evidence   - Generate USB evidence for Lab 1 (usb.img + usb.E01)"
	@echo "  make gui        - Start Autopsy in your browser (localhost:8080)"
	@echo "  make gui-stop   - Stop the Autopsy GUI"
	@echo "  make verify     - Verify your setup is correct"
	@echo "  make setup      - Build the image locally (optional; CI prebuilds it)"
	@echo ""
	@echo "Quick start:"
	@echo ""
	@echo "  git clone <repo> && cd forensics-docker-lab"
	@echo "  1. make start      (pulls the image, enters the workstation)"
	@echo "  2. make evidence   (generates Lab 1 USB image)"
	@echo "  3. make gui        (optional: browser Autopsy GUI)"
	@echo ""

setup:
	@echo "Building Docker containers for forensic analysis..."
	@echo ""
	docker compose build
	@echo ""
	@echo "✓ Build complete! Next: make evidence (Lab 1 USB image)"
	@echo ""

evidence:
	@echo "Generating USB forensic evidence for Lab 1..."
	@./scripts/make_usb_image.sh
	@echo ""
	@echo "✓ Evidence complete! For Lab 2 (Memory) you also need a memory sample"
	@echo "  — see docs/evidence-sources.md. Now: make verify / make start"

verify:
	@echo "Verifying forensics lab setup..."
	@echo ""
	@if command -v bash >/dev/null 2>&1; then \
		./scripts/verify_setup.sh; \
	else \
		call scripts\verify_setup.bat; \
	fi
	@echo ""

start:
	@if command -v bash >/dev/null 2>&1; then \
		./start.sh; \
	else \
		call start.bat; \
	fi

gui:
	@echo "Starting Autopsy GUI (browser)..."
	@docker compose up -d novnc autopsy
	@echo ""
	@echo "✓ Autopsy ready in your browser:  http://localhost:8080/vnc.html"
	@echo "  Stop with: make gui-stop"

gui-stop:
	@echo "Stopping Autopsy GUI..."
	@docker compose stop novnc autopsy
	@echo "✓ GUI stopped. (Your /cases and /evidence are unchanged.)"
