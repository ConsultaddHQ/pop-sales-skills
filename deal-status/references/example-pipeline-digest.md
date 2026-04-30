# Example: Pipeline Digest Output

This is what `/deal-status` should produce on a Monday morning for an AE managing 12 active deals at varying stages. It uses the actual prospects we've referenced across the methodology (Brian, Mauro, Scott, Regina, EleFit) plus hypothetical ones to show the full distribution.

The point of this example: the AE reads the top of the digest in 30 seconds and knows what to do today. Healthy deals stay quiet. Risks scream.

---

# Pipeline Status — 2026-05-04

**Active deals:** 12 (4 needing attention)

---

## ⚠ Action needed NOW (3)

These have overdue commitments from us. Address before any new outreach.

| Prospect | Stage | What we owe | Owed since | Days late |
|---|---|---|---|---|
| **Scott Baker (Mister Mac)** | Partnership | Screen-monitoring video + MSA draft | 2026-04-17 | 17 |
| **Sudheera (EleFit Store)** | Hiring-inflection | Pre-audit (Shopify + Amazon US/IN ranking) | 2026-04-25 | 9 |
| **Tom (PowerStream Solutions)** | Discovery | AI services proposal doc | 2026-04-13 | 21 |

> 🚨 You have 3 overdue commitments from us. The Scott video has been outstanding for 17 days and is the highest trust risk — that one shows up first in the May 5 meeting tomorrow if not delivered today.

## 📅 Meetings this week (4)

Pre-call prep needed. Run /meeting-prep on each before the call.

| When | Prospect | Stage | Open question |
|---|---|---|---|
| **Tue May 5, 1:00 PM CT** | Scott Baker (Mister Mac) | Partnership | Did we send the video? Pre-audit on first deal? |
| **Wed May 6, 11:00 AM ET** | Sudheera (EleFit Store) | Hiring-inflection | Pre-audit deliverable, before May 1 hires onboard |
| **Wed May 6, 1:15 PM ET** | Regina (Thermal Ledger) | Scope clarification | She's sending MVP scope — review and respond |
| **Thu May 7, 9:00 AM MT** | Brian Redtfeldt (Fitness Together) | Proposal | Pricing review meeting |

## 🟠 Stalling (2) — 14-29 days inactive

Worth a re-engagement touch in next 5-10 days.

| Prospect | Stage | Last activity | Suggested move |
|---|---|---|---|
| Mauro (Vacancy Rewards) | Discovery | 2026-04-15 (19 days) | Send specific HubSpot agent demo — he wanted to see something concrete |
| Travis (AI scraping) | Discovery | 2026-04-06 (28 days) | Light check-in: "Did you settle on an approach for the competitive intelligence project?" |

## ⚫ Stalled (1) — 30+ days inactive

Triage: revive, downgrade, or close out.

| Prospect | Stage | Last activity | Why stalled |
|---|---|---|---|
| Cody (Solar pump calculator) | Scoping | 2026-04-21 (13 days) | Refundable POC closed but no kickoff scheduled. Recommendation: send kickoff invite this week. |

## 🟣 Re-engagement candidates (1)

Soft-no >60 days. Worth a low-touch reconnect to check if context shifted.

| Prospect | Why declined | Days since | Re-engagement trigger |
|---|---|---|---|
| Tanner (Amway) | Relationship-core, AI can't touch the bottleneck | 12 (too soon) | Skip until 60 days. Re-engagement trigger: only if AI capability shifts to support relationship work, not replace it. |

## 📊 Quick metrics

- Discovery stage: 4
- Demo: 2
- Proposal: 2
- Commit: 1
- Partnership: 2
- Stalled: 1
- Active commitments from us: 8 (overdue: 3)
- Active commitments from them: 5 (overdue: 1 — Sudheera owes a yes/no on pre-audit)

---

## Healthy deals (quiet, no action needed)

3 deals advancing normally:
- Highland Destinations / Unreal Events (just clarified scope, kickoff this week)
- Hudson & Crane (slide gen demo well-received, awaiting their internal review)
- One unnamed Webflow prospect (early discovery stage, recent activity)

Run `/deal-status --all` to see them in detail.

---

## Today's recommended sequence

Based on the pipeline state, here's a suggested order for today:

1. **Send Scott the screen-monitoring video** (10 min — biggest trust risk, must clear before tomorrow's call)
2. **Run pre-audit work for Sudheera** (90 min — ranking analysis across Shopify + Amazon US/IN, deliverable due before her May 1 hires arrive)
3. **Send Tom the proposal doc** (30 min — 21 days overdue, deal cooling)
4. **Run /meeting-prep on Scott** (5 min — for tomorrow's call)
5. **Send light re-engagement to Mauro** (5 min — 19 days quiet, before he stalls)

Estimated time: ~2.5 hours to clear all overdue items + prep tomorrow.

---

## What this digest does well

1. **Overdue commitments are at the top, not buried.** The AE sees Scott's 17-day video first.
2. **Specific dates, not "a while ago."** Days-late counts make priority obvious.
3. **Healthy deals are quiet.** No noise from things working.
4. **Recommended sequence at the bottom.** Translates "what needs attention" into "what to do this morning."
5. **Process problems flagged.** "🚨 3 overdue commitments" tells the AE this is a delivery cadence issue, not just deal-by-deal.
6. **Re-engagement timing rules are explicit.** Tanner is "too soon" — the digest doesn't waste the AE's time.

## What this digest avoids

- ❌ Listing every deal alphabetically with no priority signal
- ❌ Vague "high priority" tags without dates
- ❌ Burying actionable items in a long table
- ❌ Padding healthy deals with "no update" rows
- ❌ Asking the AE to interpret status rather than handing them the priority order
