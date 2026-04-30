# Slack Integration — Storage & Convention

This document is the source of truth for how Pop Sales Skills store and read customer data via Slack. All four skills (`/customer-discovery`, `/meeting-prep`, `/meeting-debrief`, `/deal-status`) follow these conventions.

---

## Channel naming convention

Every customer gets a Slack channel auto-created by the **CA AI Salesforce** app the moment an opportunity is created in Salesforce.

**Pattern:** `internal-{slug}-pop`

**Slug rules:**
- Lowercase
- Spaces → hyphens
- Special chars (commas, periods, slashes, ampersands) → removed
- Multiple consecutive hyphens collapsed to one
- "LLC", "Inc", "Corp", "Ltd" suffixes retained as-is (they appear in the channel names)
- Trim leading/trailing hyphens

**Examples:**

| Company name | Slug | Slack channel |
|---|---|---|
| Thunderbird Solar Supply LLC | `thunderbird-solar-supply-llc` | `#internal-thunderbird-solar-supply-llc-pop` |
| EleFit Store | `elefit-store` | `#internal-elefit-store-pop` |
| Earthline | `earthline` | `#internal-earthline-pop` |
| Mister Mac (Wimberley) | `mister-mac-wimberley` | `#internal-mister-mac-wimberley-pop` |
| Fitness Together — Boise | `fitness-together-boise` | `#internal-fitness-together-boise-pop` |

**Skills MUST search for the channel before creating one.** Channels are usually pre-created by the Salesforce bot; if a skill doesn't find one, it should:

1. Tell the user: "No channel found for {company}. Create the Salesforce opportunity first, or pass `--no-slack` to write locally."
2. NOT create channels itself (that's the Salesforce bot's job — keeps the workflow consistent).

---

## What the Salesforce bot pre-loads

When the channel is created, the bot posts:

```
:loudspeaker: New Opportunity Created!
Opportunity Summary:
*Name: {Company name}
*Stage: {Pre-Discovery / Discovery / Demo / Proposal / Closed Won / Closed Lost}
*Owner email: {AE email}
*Created On: {timestamp}
> Link: {Salesforce opportunity URL}
```

Skills should read this initial message to extract:
- The **canonical company name** (use this for canvases, not user input which may be malformed)
- The current **stage** from Salesforce
- The **assigned AE / owner**
- The **Salesforce opportunity link** (link to in canvases)

---

## Storage model

**One Slack channel per customer.** Inside each channel:

| Slack object | Purpose | Created/updated by |
|---|---|---|
| **Channel canvas** (the "main" canvas) | Customer Profile — living document, always-current state | All four skills append/update |
| **Standalone canvases** | Discovery briefs, meeting preps, meeting debriefs (one per run, dated) | The skill that produced them |
| **Channel messages** | Conversation, AI brief summaries (visible inline), commitments, links | All skills + humans |

### Customer Profile (channel canvas)

Single source of truth for the deal. Sections:

```markdown
# {Company Name} — Customer Profile

**Status:** {Pre-Discovery / Discovery / Demo / Proposal / Closed Won / Closed Lost}
**Owner:** {AE name + email}
**Salesforce:** {opportunity link}
**First contact:** {date}
**Last activity:** {date} — {type, brief outcome}

## Company Overview
<!-- Updated by /customer-discovery and /meeting-debrief -->

## Leadership & Decision Makers
<!-- Updated by /customer-discovery and /meeting-debrief -->

## Hidden Differentiator
<!-- Identified by /customer-discovery, validated by /meeting-debrief -->

## Vulnerability Signals
<!-- Why now. Updated as signals evolve. -->

## Open Commitments

**From us:**
- {item} — owed by {date} — STATUS

**From them:**
- {item} — owed by {date} — STATUS

## Activity Log
<!-- Append-only, newest first. -->

### {YYYY-MM-DD HH:MM} — {Meeting type / Discovery / Debrief} by {user}
{summary, link to standalone canvas if applicable}
```

### Standalone canvases per meeting

Each `/customer-discovery`, `/meeting-prep`, `/meeting-debrief` run produces a standalone canvas:

- `Discovery Brief — {YYYY-MM-DD}`
- `Meeting Prep — {YYYY-MM-DD}`
- `Meeting Debrief — {YYYY-MM-DD}`

These are pinned in the channel for easy reference.

### Inline message summary

After creating each canvas, the skill posts a short Slack message in the channel with:

- Link to the canvas
- 2-3 line summary of the key takeaway
- Tag the AE / owner if there's an action needed

This makes the AI's output visible without opening canvases.

---

## Slack MCP tools the skills use

| MCP tool | What it does | Used by |
|---|---|---|
| `slack_search_channels` | Find a channel by name pattern | All skills (locate the channel) |
| `slack_read_channel` | Read recent messages in a channel | `/meeting-prep`, `/meeting-debrief`, `/deal-status` |
| `slack_create_canvas` | Create a new canvas in a channel | All skills writing output |
| `slack_read_canvas` | Read existing canvas content | `/meeting-prep`, `/deal-status` (read prior canvases) |
| `slack_update_canvas` | Update existing canvas content | `/meeting-debrief` (append to Customer Profile) |
| `slack_send_message` | Post a message in a channel | All skills (post inline summaries) |
| `slack_send_message_draft` | Draft a message without sending | `/meeting-debrief` (draft follow-up email as Slack DM to user before they send) |

---

## Fallback behavior

If the Slack MCP is unavailable or the channel cannot be found, skills fall back to local file output at:

```
~/customer-intelligence/{slug}/customer-profile.md
~/customer-intelligence/{slug}/discovery-{ts}.md
~/customer-intelligence/{slug}/meeting-prep-{ts}.md
~/customer-intelligence/{slug}/meeting-debrief-{ts}.md
```

The skill warns the user: "Slack unavailable, wrote local file at {path}. Sync to channel {channel} when reconnected."

This keeps the workflow unbroken when offline or during MCP outages.

---

## Future: Coda integration

Pop is a Coda company. Structured pipeline data (deal stage, qualification score, ARR potential, last activity, owner) belongs in a Coda doc, not in Slack canvases.

**Status:** Coda integration deferred to v2.

**When v2 ships, the skills will additionally:**

- Read the Coda pipeline row for the prospect on each run (current stage, last update, ARR estimate)
- Update the Coda row on stage transitions, qualification re-scores, and meeting completions
- Use Coda as the structured source of truth for `/deal-status` pipeline digests

**Until then:**

- Coda updates are manual
- `/deal-status` reads stage info from the Salesforce bot's initial channel message (which reflects Salesforce's stage)
- The Slack channel canvas is the single source of truth for unstructured customer memory

**Path to v2:**

1. Coda's API is well-documented (https://coda.io/developers/apis/v1)
2. We can either wait for an official MCP or build a thin custom MCP server using `mcp-developer` tools
3. The skills' `Step 12: Write output` sections are designed so adding Coda is purely additive — no rewrite needed when the integration ships

---

## When the Salesforce bot didn't fire

Edge case: a salesperson is talking to a prospect before opportunity creation, so no channel exists yet.

**Skill behavior:** ask the user to create the Salesforce opportunity first. Don't auto-create channels — that breaks the team's discipline of "Salesforce → channel → AI" sequencing.

**Acceptable workaround:** if the user explicitly passes `--no-slack`, the skill writes locally and reminds the user to create the SF opportunity later.

---

## Summary cheat sheet

```
Slug a company name:        lowercase + hyphens + retain LLC/Inc
Find the channel:           #internal-{slug}-pop  (search via Slack MCP)
Read customer history:      slack_read_channel + slack_read_canvas
Write a brief:              slack_create_canvas (standalone) + slack_send_message (inline summary)
Update profile:             slack_update_canvas (channel canvas, append section)
Channel doesn't exist:      ask user to create Salesforce opportunity first
MCP fails:                  fall back to ~/customer-intelligence/{slug}/
```
