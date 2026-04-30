# Pop Sales Methodology

The shared brain that makes our SDRs and AEs faster, sharper, and saner.

This is the methodology our entire sales team uses to research prospects, prep for meetings, debrief after calls, and never drop a follow-up. It's encoded as Claude Cowork project instructions for daily team use, with optional Claude Code skills for power-user automation.

**Trained on 141+ real Pop sales meetings.** Five reference cases covering every prospect archetype we've encountered. Five-objection library with the working responses. Six prospect profiles with explicit disqualification criteria.

---

## Two ways to use this

### Path 1 — Claude Cowork (recommended for teams)

For sales teams using Claude desktop app. Zero learning curve. Everyone works in shared project threads. AE has visibility into every SDR's research automatically.

**Setup (~15 min):**

1. Get [Claude Teams plan](https://claude.ai/upgrade) for your team
2. Create a shared project named `pop-sales`
3. Copy the contents of [COWORK_PROJECT_INSTRUCTIONS.md](COWORK_PROJECT_INSTRUCTIONS.md) into the project's Instructions field
4. Upload the reference case files (`customer-discovery/references/*.md`) to the project's Files section
5. Set project memory with your company context (who you are, what you sell, ICP)
6. Invite your team

**Daily use:** SDR opens a new thread → "Discovery on {Name} {Company}" → methodology auto-applies → AE sees the thread in their sidebar.

### Path 2 — Claude Code (for AE power-user automation)

For AEs who want batch operations, MCP integrations, and CLI workflows. Not recommended for non-technical SDRs.

**Setup:** See [ONBOARDING.md](ONBOARDING.md). One-command install:

```bash
curl -fsSL https://raw.githubusercontent.com/ConsultaddHQ/pop-sales-skills/main/scripts/install.sh | bash
```

**Daily use:** `/customer-discovery`, `/meeting-prep`, `/meeting-debrief`, etc.

---

## What this gives you

Before this methodology:
- 30-60 minutes of research per prospect, often duplicated by SDR and AE
- Context lost at every handoff
- Generic discovery questions that waste the prospect's time
- Forgotten commitments and dropped follow-ups
- Each call starting from scratch

After:
- 3-5 minutes per prospect, AE-quality output every time
- Customer memory that compounds across the whole team
- Discovery questions grounded in actual research
- Every commitment captured, every follow-up drafted
- Each call building on everything we already know

---

## What's in here

```
.
├── README.md                            This file
├── COWORK_PROJECT_INSTRUCTIONS.md       Paste-ready instructions for Claude Cowork
├── ONBOARDING.md                        Day-1 setup for the Claude Code path
├── DAILY_WORKFLOW.md                    Morning, pre-call, post-call routines
├── CHEAT_SHEET.md                       One-page printable reference
├── customer-discovery/                  The discovery skill + 5 reference cases
│   ├── SKILL.md
│   └── references/
│       ├── case-brian-redtfeldt.md      Solo operator (boxing wedge)
│       ├── case-mauro-vacancy-rewards.md  B2B tech buyer outside ICP
│       ├── case-scott-mister-mac.md     Technical founder partnership
│       ├── case-regina-thermal-ledger.md  Non-technical founder pre-product
│       ├── case-elefit-store.md         Hiring-inflection decision gate
│       └── customer-profile-template.md
├── meeting-prep/                       The prep skill for ongoing deals + reference
│   ├── SKILL.md
│   └── references/
│       └── case-mister-mac-prep.md     5-meeting deal that pivoted to partnership
├── meeting-debrief/                     The debrief skill + email examples
│   ├── SKILL.md
│   └── references/
│       ├── email-examples.md
│       └── hiring-inflection-signals.md
└── scripts/install.sh                   Claude Code one-command setup
```

---

## Real wins this has produced

- **Brian Redtfeldt (Fitness Together):** Caught the boxing-specialty differentiator. Pitch landed in one meeting.
- **Regina (Thermal Ledger):** First call, she said "this is best case scenario here." Discovery sprint signed within 30 minutes.
- **EleFit (Sudheera):** Spotted the May 1 hiring inflection live. Pre-audit counter-move proposed before the deal could go cold.

These aren't generic wins. They're specific moments where the methodology caught something that would have been missed.

---

## Who this is for

- **Sales teams** — clone the methodology, adapt to your offering, ship a tighter discovery → debrief → follow-up loop
- **SDRs** — for pre-call research that catches what manual research misses
- **AEs** — for meeting prep on ongoing deals, debriefs, customer memory
- **Founders** — for visibility into pipeline and lessons-learned across the team

You don't need to be technical. The Cowork path is point-and-click. The Claude Code path needs one terminal command.

---

## Getting help

- **Stuck on Cowork setup?** See [COWORK_PROJECT_INSTRUCTIONS.md](COWORK_PROJECT_INSTRUCTIONS.md) — operational checklist at the top
- **Stuck on Claude Code setup?** See [ONBOARDING.md](ONBOARDING.md) → Troubleshooting
- **Want depth on a skill?** Each skill has a `SKILL.md` with full methodology
- **Found a bug or have an idea?** Open a GitHub issue or PR

---

## Built on

- [Claude Cowork](https://claude.ai) and [Claude Code](https://claude.ai/download) — the AI environment
- 141+ real Pop sales meetings analyzed via Granola
- Methodology drawn from 30 Minutes to President's Club, Gap Selling, Challenger, Jeremy Miner

License: [MIT](LICENSE). Use it, fork it, adapt it. If you find a pattern that improves the methodology, send a PR.
