#!/usr/bin/env bash
# Pop Sales Skills — One-command installer for non-technical team members.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/ConsultaddHQ/pop-sales-skills/main/scripts/install.sh | bash
#
# What it does:
#   1. Checks Claude Code is installed
#   2. Clones the skills repo to ~/.claude/skills/pop/
#   3. Verifies everything works
#
# Note: Customer memory lives in Slack channels (#internal-{slug}-pop), not
# a local folder. The Slack MCP must be authenticated separately in Claude
# Code. Local fallback folder ~/customer-intelligence/ is created lazily
# only if Slack MCP is unavailable at skill-run time.

set -euo pipefail

# ---- Colors and helpers -----------------------------------------------------

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

ok()   { echo -e "${GREEN}✓${NC} $*"; }
info() { echo -e "${BLUE}→${NC} $*"; }
warn() { echo -e "${YELLOW}⚠${NC} $*"; }
err()  { echo -e "${RED}✗${NC} $*"; }

# ---- Configuration ----------------------------------------------------------

REPO_URL="${POP_SKILLS_REPO:-https://github.com/ConsultaddHQ/pop-sales-skills.git}"
SKILLS_DIR="$HOME/.claude/skills/pop"
LOCAL_FALLBACK_DIR="$HOME/customer-intelligence"

# ---- Banner -----------------------------------------------------------------

cat <<'BANNER'

╔════════════════════════════════════════════════════════════╗
║                                                            ║
║         Pop Sales Skills — Installer                       ║
║         The shared brain for SDRs and AEs                  ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝

BANNER

# ---- Step 1: Check Claude Code ---------------------------------------------

info "Step 1/4: Checking Claude Code installation..."

if command -v claude >/dev/null 2>&1; then
  ok "Claude Code is installed."
else
  err "Claude Code is not installed."
  echo ""
  echo "  Please download and install Claude Code first:"
  echo "    https://claude.ai/download"
  echo ""
  echo "  After installing, sign in with your work email and re-run this script."
  exit 1
fi

# ---- Step 2: Check git ------------------------------------------------------

info "Step 2/4: Checking git..."

if command -v git >/dev/null 2>&1; then
  ok "git is installed."
else
  err "git is not installed."
  echo ""
  echo "  Install git first:"
  echo "    Mac:     xcode-select --install"
  echo "    Windows: https://git-scm.com/download/win"
  echo "    Linux:   sudo apt install git  (or your distro's equivalent)"
  exit 1
fi

# ---- Step 3: Clone the skills repo -----------------------------------------

info "Step 3/4: Installing the skills..."

mkdir -p "$HOME/.claude/skills"

if [[ -d "$SKILLS_DIR" ]]; then
  warn "Existing skills directory found at $SKILLS_DIR"
  echo "       Updating to latest version..."
  cd "$SKILLS_DIR"
  if git pull --ff-only 2>/dev/null; then
    ok "Skills updated to latest version."
  else
    warn "Could not auto-update. The existing copy might have local changes."
    warn "If you want a clean install, delete $SKILLS_DIR and re-run this script."
  fi
else
  if git clone --depth 1 "$REPO_URL" "$SKILLS_DIR" 2>&1 | tail -3; then
    ok "Skills cloned to $SKILLS_DIR"
  else
    err "Failed to clone the skills repo."
    echo ""
    echo "  Common fixes:"
    echo "  - Check your internet connection"
    echo "  - Make sure you have access to the repo: $REPO_URL"
    echo "  - Ask in #pop-skills if you can't access the repo"
    exit 1
  fi
fi

# ---- Step 4: Confirm Slack MCP guidance -------------------------------------

info "Step 4/4: Slack integration check..."

mkdir -p "$LOCAL_FALLBACK_DIR"
ok "Local fallback folder ready: $LOCAL_FALLBACK_DIR"
echo "       (used only when Slack MCP is unavailable)"
echo ""
echo "  Customer memory lives in Slack channels matching #internal-{slug}-pop"
echo "  (created automatically by the CA AI Salesforce bot)."
echo ""
echo "  IMPORTANT: After this install, you must authenticate the Slack MCP"
echo "  inside Claude Code so the skills can read/write Slack canvases."
echo "  This happens once per machine, in Claude Code's MCP settings."

# ---- Final verification -----------------------------------------------------

echo ""
info "Verifying installation..."

if [[ -f "$SKILLS_DIR/customer-discovery/SKILL.md" ]] \
   && [[ -f "$SKILLS_DIR/meeting-debrief/SKILL.md" ]]; then
  ok "All skills present and ready."
else
  err "Skills are missing. Something went wrong."
  echo "  Try deleting $SKILLS_DIR and re-running this script."
  exit 1
fi

# ---- Success message --------------------------------------------------------

cat <<EOF

${GREEN}╔════════════════════════════════════════════════════════════╗${NC}
${GREEN}║                                                            ║${NC}
${GREEN}║   ✓ Pop Sales Skills installed successfully.               ║${NC}
${GREEN}║                                                            ║${NC}
${GREEN}╚════════════════════════════════════════════════════════════╝${NC}

  Next steps:

  1. Open Claude Code:        ${BLUE}claude${NC}

  2. Try your first command:  ${BLUE}/customer-discovery "Tesla"${NC}
                              (just to test — pick any company)

  3. Read the day-1 guide:    ${BLUE}cat $SKILLS_DIR/ONBOARDING.md${NC}

  4. Print the cheat sheet:   ${BLUE}cat $SKILLS_DIR/CHEAT_SHEET.md${NC}

  Need help? Slack #pop-skills or ask your AE.

  Welcome to Pop. Let's go.

EOF
