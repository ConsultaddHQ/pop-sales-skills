---
name: meeting-prep
description: |
  Pre-meeting brief for ONGOING deals (meeting #2 and beyond). Different from /customer-discovery, which is for net-new prospects. /meeting-prep reads the full customer profile, all prior meeting debriefs, all Granola transcripts in chronological order, and produces a tight prep brief: where the deal stands, open commitments from both sides, predicted questions, the move for THIS meeting.

  ALWAYS use this skill when: the user references an upcoming meeting on a prospect they've already met with, asks for prep on a deal in progress, or says things like "prep me for the {Name} call", "what do we need to do for this meeting", "what's the status on {Company}", "remind me what we owe them".

  Designed for AEs walking into back-to-back meetings. Output is optimized for a 2-3 minute read with the must-reads (TL;DR, Open Commitments, The Move) at the top. Deep history is below for those who want it.

  Reads from the same shared customer profile folder as /customer-discovery and /meeting-debrief. Each prospect's `customer-profile.md` is the source of truth for deal state.
---

## Quick Start

```
/meeting-prep "Scott Baker"                          # Searches customer profiles by name
/meeting-prep "Mister Mac"                           # Searches by company
/meeting-prep mister-mac                             # Direct slug
/meeting-prep --calendar                             # Auto-detects next meeting from calendar
```

## When to use this vs /customer-discovery

| Situation | Skill |
|---|---|
| First meeting with a prospect, no prior history | `/customer-discovery` |
| Second meeting or later, prior history exists | `/meeting-prep` |
| Prospect was researched but not yet met with | `/customer-discovery` (refresh research) |
| Deal stalled and you're trying to reactivate | `/meeting-prep` (analyzes prior moves) |
| Lost deal, exploring re-engagement | `/meeting-prep` with focus on what changed |

If you're not sure, just run it. The skill will tell you "this looks like net-new, run /customer-discovery instead" if there's no prior history.

## Workflow

### Step 1: Find the customer profile

Priority order:
1. If a slug or full path provided → read directly
2. If a name/company provided → fuzzy-search `~/Google Drive/Customer Intelligence/` for matching folder
3. If `--calendar` flag → check the user's next 3 calendar events, match against existing profiles
4. If no match → tell the user "no prior history for {Name}. Run /customer-discovery for net-new prospects."

If multiple matches, ask the user to pick.

### Step 2: Read the full deal history

Once the profile is identified:

1. Read the entire `customer-profile.md`
2. List all `discovery-*.md` and `meeting-prep-*.md` and `meeting-notes-*.md` files in the folder, chronologically
3. Pull recent Granola transcripts via `mcp__granola__list_meetings` filtering by company name (last 90 days)
4. For each transcript, read it via `mcp__granola__get_meeting_transcript`

The goal: full chronological picture of every interaction.

### Step 3: Reconstruct the deal timeline

Build a table of every interaction:

| Date | Meeting type | Participants (us / them) | Outcome | Key takeaway |
|---|---|---|---|---|
| 2026-02-18 | Initial outreach | Sumit / Scott | Scheduled discovery | "We can build internally" |
| 2026-03-02 | Discovery call | Ankit / Scott | Budget signal $5-8k | Apple support bottleneck |
| ... | ... | ... | ... | ... |

This table goes in the brief.

### Step 4: Extract open commitments (CRITICAL — this is the brief's headline)

Scan every prior meeting note + transcript for explicit commitments:

**From us:**
- "Bharat will send the screen-monitoring video by next call"
- "Chetan will record a demo of the chat tool"

**From them:**
- "Scott will evaluate the video and respond"
- "Mauro will send the QuickBooks tool spec"

For each commitment, judge whether it was DELIVERED based on subsequent meeting notes / transcripts:
- ✅ Delivered (date + evidence)
- 🔴 NOT DELIVERED (overdue) — biggest risk going into the call
- ⏳ In progress (not yet due)

Flag every NOT DELIVERED item at the top of the brief. These are the meeting-killers.

### Step 5: Re-classify and re-score

The deal may have evolved since the original discovery brief:

- **Profile reclassification?** Did Scott shift from "Technical founder customer" to "Partner opportunity" (yes — proven case)? Note the shift.
- **Qualification re-score?** Are the 5 signals stronger or weaker than at first contact?
- **Hidden differentiator still relevant?** Or did the conversation reveal a different real edge?
- **Vulnerability signals refreshed?** New ones emerged? Old ones cooled?

### Step 6: Predict THIS meeting

Based on the deal stage and the unresolved threads from prior meetings:

- **What will they ask?** Predict 3-5 specific questions, grounded in what's outstanding.
- **What objections are likely?** Map to the 5-objection library, pick the 2-3 most probable for this stage.
- **What proof / artifacts will help?** Demo? Reference case? Pricing structure? Scope doc?

### Step 7: Define THE MOVE for this meeting

Every meeting has a goal. Be explicit about it:

- 🟢 **Advance** — push to next deal stage (discovery → demo, demo → proposal, proposal → commit, commit → close)
- 🟡 **Hold** — maintain momentum, don't push, build trust
- 🟠 **Save** — deal is stalling, what's the unblocking move
- 🔴 **Decision** — force a yes/no
- ⚫ **Re-engage** — deal went cold, what's the trigger to revive

State the move clearly. The AE walks in with one job, not five.

### Step 8: Identify risks specific to this meeting

Things that could go wrong:
- Unfulfilled commitments from us → trust erosion
- Hiring-inflection moment passed → pre-audit window closed
- Competitor mentioned in last meeting → did they evaluate yet?
- Champion left the company → who's the new contact?
- Budget cycle change → "we'll revisit next quarter" risk
- Scope creep → are we still pitching what they want?

### Step 9: Write the prep brief

See output template below. Optimize for the AE who has 2-3 minutes between back-to-back meetings.

### Step 10: Save and surface

Write the brief to:
`~/Google Drive/Customer Intelligence/{company-slug}/meeting-prep-{YYYYMMDD-HHMM}.md`

Show it on stdout in the chat. Highlight the ⚠ open commitments at the top.

## Output Template

```markdown
# Meeting Prep: {Contact} — {Company}

**Upcoming meeting:** {date / time / type / participants}
**Prior history:** {N meetings since {first contact date}}
**Deal stage:** {Discovery / Demo / Proposal / Commit / Stalled / Re-engagement}
**Qualification:** {N}/5 (was {prior}/5 at first contact, change reason: {...})
**Profile:** {current profile, note if reclassified}

## ⚠ MUST-READ: Open Commitments

**From us — OWED:**
- 🔴 {Specific item} — owed since {date} — STATUS: {delivered / not delivered}
- ⏳ {Specific item} — due by {date}

**From them — OWED:**
- 🔴 {Specific item} — owed since {date}
- ⏳ {Specific item} — due by {date}

If anything is 🔴 NOT DELIVERED on our side, that is the FIRST thing to address in the meeting. Don't pretend it didn't happen.

## TL;DR

One paragraph: who they are, what we sell them, where the deal stands, what's at stake THIS meeting, the move.

## The Move This Meeting

🟢/🟡/🟠/🔴/⚫ — One sentence. The single goal of this conversation.

How we get there: 2-3 specific actions.

## Deal Timeline

| Date | Type | Outcome | Key takeaway |
|---|---|---|---|
| {date} | {type} | {🟢/🟡/🟠/🔴/⚫} | {1-line} |
| {date} | {type} | {emoji} | {1-line} |

## Predicted Questions

Each grounded in unresolved threads from prior meetings:

1. {Question} — because {context from a prior meeting}
2. ...

## Likely Objections

| Objection | Working response |
|---|---|
| {From the 5-objection library, picked for this stage} | {Acknowledge + reframe} |

If a NEW objection pattern is likely (something the 5-library doesn't cover), flag it.

## Profile Refresher (30-second cold-read for AE)

Who they are, what they do, why they care, what we've already done. Three sentences max.

## Hidden Differentiator (status check)

Original: {what was identified pre-call}
Status: {still the hook? Replaced by something else? Validated by them on a call?}

## Vulnerability Signals (refreshed)

- {Signal} — still hot? cooled? new development?

## Risks for This Meeting

- {Specific risk 1, with mitigation if applicable}
- {Specific risk 2}

## Recommended artifacts to bring

- {Demo}
- {Reference case}
- {Pricing structure}
- {Scope doc}

Whichever helps move the deal.
```

## Quality Bar

A prep brief is GOOD when:
- The Open Commitments section is at the TOP and 🔴 items are flagged loudly
- The Move is one specific action, not "advance the deal"
- Predicted questions reference specific prior moments
- The 30-second cold-read actually works as a cold-read
- The whole brief is readable in 2-3 minutes

A prep brief is BAD when:
- It re-pitches what was already covered (the AE already knows)
- It asks discovery questions you already have answers for
- It misses an unfulfilled commitment (worst possible failure mode)
- It hedges on the move ("could be advance, could be hold")
- It's longer than 2 pages

## Special Cases

### Stalled deal (>30 days since last meeting)

Don't pretend everything is fine. The brief should explicitly say "this deal has stalled — here's what we know about why, here's the unblocking move." Common stalls:
- Hiring-inflection passed without us delivering pre-audit → admit it
- Budget cycle ended → re-engage at start of next cycle
- Champion left → identify new contact
- Competitor won → ask how it's going, plant seed for round 2

### Hiring-inflection deal

If the prior meeting flagged a hiring inflection (new team starting on date X):
- Has X passed? If yes, did we deliver the pre-audit? If not, we're now competing with whatever tools the new hires brought.
- If X hasn't passed yet, the meeting should reinforce the pre-audit offer.

### Soft-no / re-engagement

If the deal previously got a soft no:
- What was the stated reason for declining?
- What's changed since then in their business or ours?
- The meeting should be light, no pitch, just a reconnect with one specific reason for the timing.

### Partnership deals (Scott Baker pattern)

If the deal pivoted from customer to partner:
- The "deal stage" framework doesn't quite apply. Use a different lens:
  - Are commitments balanced (we owe them / they owe us)?
  - Is there a first specific opportunity to ship together?
  - Is the rev-share structure agreed in principle?

## Integration with other skills

- **Before any meeting:** /meeting-prep (this skill) — produces the prep brief
- **First meeting only:** /customer-discovery — for net-new prospects
- **After any meeting:** /meeting-debrief — captures what happened, drafts follow-up
- **For full deal status across pipeline:** /deal-status (coming) — digest view

## Reference Cases

See `references/case-mister-mac-prep.md` for the canonical example: a 5-meeting deal that pivoted from customer to partner, where prior commitments and stage shifts are critical context for any prep.
