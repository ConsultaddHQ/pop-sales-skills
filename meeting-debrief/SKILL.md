---
name: meeting-debrief
description: |
  Post-call processing skill. Takes a meeting transcript (from Granola or pasted), updates the customer profile with everything learned, logs commitments, captures objections, flags contradictions with prior research, and drafts the follow-up email. Designed to run within 2-3 minutes after a call ends so the AE or SDR never forgets anything and never misses a follow-up.

  ALWAYS use this skill when: the user pastes a meeting transcript, references a just-finished call, asks for a debrief, mentions a follow-up email, or says things like "write me a follow-up", "recap that call", "update the customer profile", "what did we learn", "draft the follow-up email".

  Writes back to the prospect's Slack channel (`#internal-{slug}-pop`). Updates the channel's main "Customer Profile" canvas with what was learned, creates a standalone "Meeting Debrief — {date}" canvas, and posts an inline message with the follow-up email draft so the AE can copy/paste to Gmail. This is how customer memory compounds across the team — 30 SDRs + 2 AEs all writing to the same channel canvases over time. See SLACK_INTEGRATION.md for full conventions.

  Output: (1) updated Customer Profile canvas with a new Activity Log entry, (2) standalone Meeting Debrief canvas, (3) draft follow-up email in markdown posted to the channel, (4) one-paragraph executive summary on stdout.
---

## Quick Start

```
/meeting-debrief                                          # Uses most recent Granola meeting
/meeting-debrief "Sudheera EleFit"                        # Searches Granola by name/company
/meeting-debrief {granola-meeting-id}                     # Direct Granola meeting ID
/meeting-debrief --paste                                  # Paste transcript directly
```

## Workflow

### Step 1: Find the meeting

Priority order:
1. If meeting ID provided → pull transcript via `mcp__granola__get_meeting_transcript`
2. If company/person name provided → `mcp__granola__list_meetings` with `time_range: this_week`, match by title, pull transcript
3. If nothing provided → `mcp__granola__list_meetings` with `time_range: this_week`, show user last 5 meetings, ask which one
4. If user passes `--paste` or provides transcript text → use it directly, skip Granola

If the meeting can't be found, ask the user to paste the transcript. Never invent details.

### Step 2: Identify the prospect and find the channel

From the transcript, identify:
- **Company name** (look for the prospect company, not Bharat's company "Pop")
- **Primary contact name**
- **Other attendees on either side**

Slug the company name per SLACK_INTEGRATION.md rules. Search Slack for `#internal-{slug}-pop` via `mcp__claude_ai_Slack__slack_search_channels`.

- **If channel exists:** read the main Customer Profile canvas. You'll extend it. Read prior canvases (Discovery Brief, prior preps) for context.
- **If channel does NOT exist:** flag to the user: "No Slack channel for {company}. Either the Salesforce opportunity wasn't created (CA AI Salesforce bot creates channels automatically), or this prospect is outside our normal flow. Pass `--no-slack` to write locally, or create the SF opportunity first."
- **If channel exists but Customer Profile canvas is empty/missing:** create a fresh Customer Profile canvas from the template structure in SLACK_INTEGRATION.md, flag to user: "No prior discovery run for {company}. Creating Customer Profile now. Run /customer-discovery before future meetings to pre-load context."

### Step 3: Extract from the transcript (10 fields)

For each field below, extract what the transcript reveals. Use direct quotes where possible. If a field isn't present in the transcript, mark it "not discussed" rather than inventing.

1. **Participants** — who was on the call, from both sides. Titles if stated.

2. **Meeting goal / context** — what was this meeting supposed to accomplish? Discovery? Demo? Follow-up? Proposal review? Close?

3. **Confirmed vs. contradicted** — did anything the prospect said CONFIRM or CONTRADICT the prior discovery brief? Specifically:
   - Did the predicted hidden differentiator hold up?
   - Did the predicted pains match?
   - Did unexpected pains emerge?
   - Did the predicted profile classification hold (e.g., solo operator vs. founder-led SMB)?

4. **New information surfaced** — things learned in the call that weren't in the pre-call research. Include direct quotes.

5. **Pains quantified** — specific numbers, hours, percentages, dollar amounts. These are qualification signals for future deals in the same category.

6. **Objections raised and how they were handled** — map to the five-objection library from /customer-discovery:
   - AI can't replace human connection
   - Not ready / too early
   - Cost / ROI
   - I can tell it's AI
   - Need proof / references

   If a NEW objection type appeared, flag it as "new pattern — consider adding to skill."

7. **Commitments made — PROSPECT side**: things the prospect said they would do. With deadline if stated.
   - e.g., "Sudheera will send product list by EOD Friday"
   - e.g., "Scott will evaluate the screen-capture video and respond by next call"

8. **Commitments made — US side**: things Bharat/team said they would do. With deadline.
   - e.g., "Bharat will send scope document by Monday"
   - e.g., "Chetan will record a 2-minute demo of the chat tool and share via email"

9. **Next meeting** — date, time, timezone, participants, topic if stated. If not scheduled, flag "NEXT MEETING NOT SCHEDULED — this is a risk."

10. **Deal stage movement** — did the deal advance, stall, or stall-politely (soft no)? Pick one:
    - 🟢 **Advanced** — moved to next stage (discovery → demo, demo → proposal, proposal → commit)
    - 🟡 **Held** — same stage, next step clear
    - 🟠 **Stalled** — same stage, next step vague or gated (e.g., waiting for team hire)
    - 🔴 **Soft no** — prospect politely declined or disqualified themselves
    - ⚫ **Lost** — explicit no

### Step 4: Apply the Hiring-Inflection check

If the prospect mentioned hiring a team that will influence the decision (see `references/hiring-inflection-signals.md`), flag the deal as gated and recommend the pre-audit counter-move in the email draft.

### Step 5: Apply the qualification re-score

Re-score the prospect against the 5 qualification signals from /customer-discovery. If the score changed (up or down) from pre-call, note why. A score drop is a signal to de-prioritize; a rise means accelerate.

### Step 6: Write updates to Slack

Three writes:

**A. Update the channel's main Customer Profile canvas** via `mcp__claude_ai_Slack__slack_update_canvas`. Append a new Activity Log section. Never overwrite prior sections. Format:

```markdown
### {YYYY-MM-DD HH:MM} -- {Meeting type} with {attendees} by {your name}

**Outcome:** {🟢/🟡/🟠/🔴/⚫} {one-line status}

**What we learned:**
- {new info 1}
- {new info 2}

**Pains quantified:**
- {specific number / quote}

**Objections raised:**
- {objection}: handled by {approach}. Verdict: {resolved / deferred / unresolved}

**Commitments — prospect:**
- {what they said they'd do} by {when}

**Commitments — us:**
- {what we said we'd do} by {when}

**Next meeting:** {date/time or "NOT SCHEDULED — RISK"}

**Qualification re-score:** {N}/5 ({change from pre-call, if any})

**Flags:**
- {anything that contradicts prior research}
- {hiring-inflection if applicable}
- {new objection pattern if applicable}
```

Also update these sections in the Customer Profile canvas (if the call revealed new info):
- **Company Overview** — any new facts about the business
- **Leadership & Decision Makers** — new people identified, decision power confirmed
- **Business Priorities & Challenges** — confirmed pains move from "likely" to "confirmed" (tag with `[CONFIRMED on DATE]`)
- **Our Relationship** — update deal stage, budget signals, timeline
- **Hidden Differentiator** — if the call revealed or refuted the predicted differentiator
- **Vulnerability Signals** — new signals learned, or old ones confirmed
- **Open Commitments** — add new commitments from this call, mark prior commitments as DELIVERED if applicable

**B. Create a standalone Meeting Debrief canvas** via `mcp__claude_ai_Slack__slack_create_canvas` named `Meeting Debrief — {YYYY-MM-DD}`. Contents: full debrief output (the markdown template below).

**C. Post an inline message in the channel** with the follow-up email draft formatted for copy-paste, plus a 2-line summary of the deal stage change. Tag the AE / owner.

**Fallback:** if Slack MCP is unavailable, write locally to `~/customer-intelligence/{slug}/meeting-debrief-{ts}.md` and warn the user.

### Step 7: Draft the follow-up email

Write a follow-up email grounded in the specific call. Not generic.

**Email structure (use this exactly):**

```
Subject: {specific reference to the call, max 60 chars}

Hi {first name},

{1 sentence: warm opening specific to the call — reference something they said or a moment from the meeting, not "great meeting today"}

{1-2 sentences: confirm what we agreed to / what's next}

{Action items in a short bulleted list, split by "from us" and "from you" if both have items}

{Small value-add — a specific insight, link, stat, or preview related to THEIR business — NOT a generic marketing blurb}

{Next meeting confirmation with time + timezone}

Talk soon,
{Signature}
```

**Quality rules:**
- Subject line references a specific thing from the call ("Next steps: EleFit AEO + May audit plan" not "Follow-up")
- Opening line references something specific (their boxing specialty, their May 1 hire, their India traction)
- Action items are concrete with dates — no "I'll send over something soon"
- Value-add is a REAL value-add, not a generic line about AI
- Maximum ~6-8 sentences of body text + action items. Short wins.

**If it's a "stalled" or "hiring-inflection" deal, the email MUST include the pre-audit counter-move.**

**If it's a "soft no" or "lost" deal, the email is short and gracious — thank them, leave the door open, stop.**

### Step 8: Return to the user

Output three things to stdout, in this order:

1. **Executive summary** — one paragraph. What happened, deal stage, biggest takeaway, one-line next step.

2. **Full activity log entry** — the markdown block that was appended to the customer profile. Shown so the user can sanity-check before it propagates to the shared folder.

3. **Follow-up email draft** — in a single markdown code block, ready to copy-paste into Gmail.

Also tell the user:
- The profile path that was updated
- Any flags raised (contradicted prior research, new objection pattern, hiring-inflection, etc.)

## Quality Bar

A debrief is GOOD when:
- Every commitment with a deadline is captured (both sides)
- The outcome stage is correctly classified (advanced / held / stalled / soft-no / lost)
- Objections are mapped to the five-objection library (so we see which ones are most common)
- The follow-up email references SPECIFIC things from the call (not generic)
- The email gets sent within 1-2 hours of the call ending

A debrief is BAD when:
- "Great meeting, looking forward to next steps" generic openings
- Commitments are fuzzy without deadlines
- The profile update overwrites prior sections instead of appending
- New information isn't distinguished from pre-call research
- The email is longer than ~150 words

## Integration with other skills

- **Before a meeting:** /customer-discovery (for net-new prospects) or /meeting-prep (for ongoing deals) — produces the brief
- **After a meeting:** /meeting-debrief (this one) — captures what happened
- **At any time:** /deal-status — shows current state across all meetings for a prospect
- **When drafting deliverables:** /pop-one-pager — generates proposal using the updated customer profile

## Lessons-Learned Feedback Loop

Every debrief has a hidden job: teaching the system what's working and what's not.

At the end of the Activity Log entry, if anything notable happened, add a `**LESSONS:**` section:

```markdown
**LESSONS:**
- {what the pre-call brief missed and should have caught}
- {a new pattern that could be added to /customer-discovery or /meeting-prep}
- {an objection handling that worked particularly well or poorly}
```

Over time, scan customer profiles for `LESSONS:` tags to identify patterns worth encoding back into the skills.

## Shared Memory Notes

All customer profiles live in `~/Google Drive/Customer Intelligence/{company-slug}/`. On first use on a new machine, the skill will create this folder if it doesn't exist. On machines without Google Drive mounted, it falls back to `~/customer-intelligence/`.

When multiple team members run `/meeting-debrief` on the same prospect (e.g., an SDR's initial call and an AE's follow-up), the profile compounds. Each entry is timestamped and attributed — no merges, no conflicts, append-only.

## Reference

See `references/email-examples.md` for examples of good vs. bad follow-up emails grounded in real Pop sales calls.
