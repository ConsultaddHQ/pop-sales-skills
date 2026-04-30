---
name: deal-status
description: |
  The pipeline-visibility skill. Two modes — single-prospect deep-dive, or full pipeline digest. Read-only synthesis of customer profiles to answer "where does this deal stand?" or "what's the state of every active deal?"

  ALWAYS use this skill when: the user asks "what's the status of {Company}", "show me my pipeline", "what should I work on next", "what's overdue", "where are we with {Name}", "give me a pipeline summary", "Monday standup view", or any variation asking for state across one or many deals.

  The skill is the AE's morning ritual and end-of-day check. Designed to surface what needs attention RIGHT NOW — overdue commitments, stalled deals, hiring-inflection windows about to pass, prospects with meetings in the next 7 days. Quiet about deals that are healthy.

  Read-only — never modifies customer profiles. Output is a digest the AE acts on; updates happen via /meeting-debrief, not here.
---

## Quick Start

```
/deal-status                                        # Pipeline digest (all active deals, attention-needed first)
/deal-status "Mister Mac"                           # Single prospect deep-dive
/deal-status mister-mac                             # Direct slug
/deal-status --all                                  # Full pipeline including healthy/quiet deals
/deal-status --stalled                              # Only stalled deals (>30 days inactive)
/deal-status --upcoming                             # Only deals with meetings in next 7 days
/deal-status --overdue                              # Only deals where we have overdue commitments
```

## Two modes

### Mode 1: Pipeline digest (default, no args)

Shows every active deal that needs attention. Surfaces:
- Overdue commitments from us (highest priority — trust risk)
- Deals stalling (>30 days no activity)
- Hiring-inflection windows about to pass
- Meetings scheduled in the next 7 days
- Soft-no deals that might be ready for re-engagement (>60 days since decline)

Quiet about healthy deals (recent activity, no overdue items, no upcoming meeting in the next 7 days). Use `--all` if you want the full picture.

### Mode 2: Single-prospect deep-dive

Shows full state of one prospect. Like a /meeting-prep brief but without the "what to do this meeting" bias — pure status. Useful for handoffs, quarterly reviews, or "remind me where this deal is" moments.

## Workflow

### Step 1: Identify scope

- If a prospect name/company/slug is provided → single-prospect mode
- If no args → pipeline digest, attention-needed only
- If a flag (--all, --stalled, --upcoming, --overdue) → filtered pipeline digest

### Step 2: Walk customer profiles

```
~/Google Drive/Customer Intelligence/
└── {company-slug}/
    ├── customer-profile.md          ← read this
    ├── discovery-{ts}.md            ← scan
    ├── meeting-prep-{ts}.md         ← scan
    └── meeting-notes-{ts}.md        ← scan
```

For each prospect, extract:

1. **Current stage** — from the latest entry's "Outcome" line. Map: 🟢 Advanced / 🟡 Held / 🟠 Stalled / 🔴 Soft no / ⚫ Lost. Default to "Discovery" if not set.
2. **Last activity date** — newest timestamp across all files in the folder.
3. **Days since last activity** — `today - last_activity`. Used for stall detection.
4. **Next meeting** — scan the latest activity log entry for a "Next meeting:" line. Pull date/time/timezone.
5. **Open commitments** — scan all activity log entries for unfulfilled commitments from us and them. Match against subsequent entries for delivery evidence.
6. **Qualification score** — from the latest re-score in the profile.
7. **Profile classification** — current profile (e.g., "Solo operator", "Partner opportunity").
8. **Hidden differentiator** — for context.
9. **Risk flags** — hiring inflection date passed without pre-audit, soft-no waiting for re-engagement, contradictions logged in lessons.

### Step 3: Categorize

Each deal goes into one of these buckets:

- 🔴 **Action needed now** — overdue commitments from us, or stalled deal showing decay
- 🟡 **Active, watch** — recent activity, next steps clear, no overdue items
- 🟢 **Healthy** — recent positive activity, advancing through stages
- 🟠 **Stalling** — 14-29 days since activity, no scheduled next step
- ⚫ **Stalled** — 30+ days since activity
- 🟣 **Re-engage candidate** — soft-no >60 days, may have changed context

### Step 4: Output

For pipeline digest, write a tight table at the top, organized by category. Quiet about healthy deals unless user asks for them.

For single-prospect, write the full state-of-deal report.

Save the digest to `~/.claude/skills/pop/deal-status-cache/digest-{YYYYMMDD-HHMM}.md` so the user has a paper trail of pipeline state over time. Useful for retros.

## Output Templates

### Pipeline Digest Output

```markdown
# Pipeline Status — {today's date}

**Active deals:** {N total} ({M needing attention})

---

## ⚠ Action needed NOW ({count})

These have overdue commitments from us. Address before any new outreach.

| Prospect | Stage | What we owe | Owed since | Days late |
|---|---|---|---|---|
| Scott Baker (Mister Mac) | Partnership | Screen-monitoring video | 2026-04-17 | 13 |
| {Prospect} | {Stage} | {Item} | {Date} | {N} |

## 📅 Meetings this week ({count})

Pre-call prep needed. Run /meeting-prep on each before the call.

| When | Prospect | Stage | Open question |
|---|---|---|---|
| 2026-05-05 1:00 PM CT | Scott Baker | Partnership | Pre-audit deliverables |
| 2026-05-06 11:00 AM ET | Sudheera (EleFit) | Hiring-inflection | Pre-audit before May 1 hires |

## 🟠 Stalling ({count}) — 14-29 days inactive

Worth a re-engagement touch in next 5-10 days.

| Prospect | Stage | Last activity | Suggested move |
|---|---|---|---|
| {Prospect} | {Stage} | {Date} | {Re-engagement angle} |

## ⚫ Stalled ({count}) — 30+ days inactive

Triage: revive, downgrade, or close out.

| Prospect | Stage | Last activity | Why stalled |
|---|---|---|---|
| {Prospect} | {Stage} | {Date} | {Stated reason or speculation} |

## 🟣 Re-engagement candidates ({count})

Soft-no >60 days. Worth a low-touch reconnect to check if context shifted.

| Prospect | Why declined | Days since | Re-engagement trigger |
|---|---|---|---|
| {Prospect} | {Reason} | {N} | {What's changed since} |

## 📊 Quick metrics

- Discovery stage: {N}
- Demo: {N}
- Proposal: {N}
- Commit: {N}
- Stalled: {N}
- Active commitments from us: {N} (overdue: {N})
- Active commitments from them: {N} (overdue: {N})

---

## Healthy deals (quiet, no action needed)

{N deals advancing normally — see /deal-status --all to view them.}
```

### Single-Prospect Output

```markdown
# Deal Status: {Contact} — {Company}

**Stage:** {Discovery / Demo / Proposal / Commit / Stalled / Partnership / Lost}
**Profile:** {current profile + reclassification history if any}
**Qualification:** {N}/5 (latest re-score)
**Last activity:** {N days ago, type, brief outcome}
**Next meeting:** {date/time or "NOT SCHEDULED" with risk flag}

## ⚠ Open Commitments

**From us:**
- 🔴 {Item} — overdue since {date}
- ⏳ {Item} — due by {date}

**From them:**
- 🔴 {Item} — overdue since {date}
- ⏳ {Item} — due by {date}

## TL;DR

One paragraph: who they are, where the deal is, what's at stake, biggest risk.

## Activity Timeline

| Date | Type | Outcome | Key takeaway |
|---|---|---|---|
| {date} | {type} | {emoji} | {one-line} |

## Hidden Differentiator (status)

{Original insight, validated/refuted/replaced status}

## Risks

- {Specific risk 1}
- {Specific risk 2}

## Suggested next move

One-line. What should the AE do next? Schedule a meeting? Send a deliverable? Wait?
```

## Quality Bar

A digest is GOOD when:
- The "Action needed NOW" section is at the top and is short
- Overdue commitment dates are exact, not "a while ago"
- Each row is one line, scannable
- Healthy deals are quiet (or hidden)
- Next moves are specific, not vague

A digest is BAD when:
- It dumps 30 deals in flat alphabetical order
- It pads sections that should be empty
- It uses "high/medium/low" hand-waves instead of specific dates
- It reads like a CRM export, not a Monday morning briefing

## Special Cases

### "What about prospect X?" mid-pipeline-mode

If during a pipeline digest the user says "tell me more about Scott Baker," switch to single-prospect mode for that one. Don't lose the pipeline context.

### Empty pipeline (new install)

If `~/Google Drive/Customer Intelligence/` is empty or doesn't exist:

> "No customer profiles found. Run /customer-discovery on your first prospect to start building the pipeline."

### Stalled deal triage

For deals in the ⚫ Stalled bucket, the AE has three choices:
- **Revive** — find a re-engagement trigger (the prospect's context may have changed; their LinkedIn / press / hiring may have shifted since the last touch)
- **Downgrade** — move to "Re-engagement candidates" with a 60-day hold
- **Close out** — mark as Lost, freeze the profile, archive

The skill should suggest one based on the deal's history. AE can override.

### Mass overdue commitments

If 3+ deals show overdue commitments from us, that's a process problem, not a deal problem. Flag it:

> "🚨 You have 5 overdue commitments across the pipeline. This is a delivery problem, not a deal problem. Recommend setting aside 90 minutes today to clear all of them in one session."

## Integration with other skills

- **Morning ritual:** `/deal-status` (pipeline digest) → identify what to work on first
- **Mid-pipeline:** `/deal-status "Company"` → quick state check on a specific deal
- **Before any meeting:** `/meeting-prep "Company"` → full prep brief
- **After any meeting:** `/meeting-debrief` → updates the profile, which feeds back into the next /deal-status run

The flow:
```
Morning:    /deal-status           ← what needs attention
Pre-call:   /meeting-prep          ← full prep for the call
Post-call:  /meeting-debrief       ← capture what changed
End of day: /deal-status --upcoming ← what's tomorrow
```

## Reference

See `references/example-pipeline-digest.md` for an annotated example showing what a good digest looks like across a mixed pipeline of healthy, stalling, and overdue deals.
