# Daily Workflow

The rhythm of an SDR or AE day. Print this or keep it in a tab.

---

## Morning routine (15-20 min)

**Before your first call of the day:**

1. Open Claude Code. Type `claude` in Terminal.
2. **Run the pipeline digest first:**

```
/deal-status
```

This shows you what needs attention TODAY across the whole pipeline. Overdue commitments at the top (the trust-killers), meetings this week, stalling deals. The bottom of the digest gives you a recommended sequence for the morning.

3. Address overdue commitments before any new outreach. If your digest shows 3+ overdue items, that's a delivery cadence problem — block 90 minutes to clear them all in one session.

4. Open your calendar. Identify every prospect you'll talk to today.

5. For each prospect:

```
/customer-discovery "Contact Name" "Company Name" "City State"
```

4. Skim the TL;DR of each brief. Don't read the whole thing yet — that's for right before the call.
5. Flag any prospect with qualification score ≤2/5 to your AE. They might want to disqualify and move on.
6. Send the brief Drive links to your AE in Slack: `[Acme Brief](drive-link) — qual 4/5, hiring inflection signal`

**Time investment:** 3-5 min per prospect × 5 prospects = 15-25 min total. Saves you 30-60 min per call later.

---

## Pre-call routine (2-5 min)

**Right before each meeting:**

1. Open the discovery brief for this prospect.
2. Read the **TL;DR** (one paragraph).
3. Read the **Hidden Differentiator** section.
4. Skim the **Discovery Questions** — pick 3 to actually ask.
5. Read the **Do NOT Pitch** section. Burn it into your brain.
6. Open the **Sources** section in another tab so you can quote specifics if it comes up naturally.

**For ongoing deals (meeting #2 and beyond), run:**

```
/meeting-prep "Company Name"
```

The skill reads the full customer profile + all prior debriefs + Granola transcripts and produces a prep brief with:
- ⚠ Open commitments (especially OVERDUE ones from us — biggest meeting-killer)
- The move for THIS meeting (advance / hold / save / decide / re-engage)
- Deal timeline
- Predicted questions grounded in prior moments
- Likely objections + working responses
- A 30-second cold-read for context

Read in 2-3 minutes, walk into the call, do the move.

---

## During the call

The skill outputs are silent partners. You're the one talking. A few things to keep in mind:

- **Acknowledge before reframing.** Don't argue with objections. Validate them, then offer a different lens. The five-objection library in the brief gives you the exact moves.
- **Surface the hidden differentiator naturally.** Don't say "I noticed you grew up boxing." Say "How'd you get into Apple training in the first place?" Let them tell you their own story.
- **Listen for new vulnerability signals.** New things that emerge live. You'll capture them in the debrief.
- **Capture commitments.** Both sides. "I'll send X by Friday" / "She'll send Y by Monday." These end up in the debrief.

---

## Post-call routine (3-5 min)

**Within 1 hour of the call ending:**

1. In Claude Code:

```
/meeting-debrief
```

(With no arguments, it pulls your most recent Granola meeting automatically.)

2. The skill will:
   - Pull the transcript from Granola
   - Identify the prospect
   - Update `customer-profile.md` with what was learned
   - Capture commitments from both sides
   - Re-score qualification (did it go up or down?)
   - Flag risks (no next meeting scheduled? Hiring inflection? Contradicts prior research?)
   - Draft your follow-up email

3. Review the email draft. Edit if needed.

4. Send the email immediately. Speed beats polish.

5. If your AE took the call, ping them: "Debrief done, profile updated, draft email ready for review."

**Time investment:** 5 min after each call. Saves 20-30 min of recall and writing later. Zero dropped follow-ups.

---

## End-of-day routine (5 min)

**Before logging off:**

1. Skim the customer profiles you updated today.
2. Look for anything you forgot to act on:
   - Did you send the email you drafted?
   - Did you add the next meeting to your calendar?
   - Are there commitments you owe to deliver tomorrow?

3. Update your CRM (or spreadsheet, whatever Pop uses) with any deal stage movement.

4. Tomorrow's meetings: glance at them so your morning routine starts fast.

---

## Skill quick reference

| You want to... | Run this |
|---|---|
| Pipeline digest — what needs attention now | `/deal-status` |
| State of one specific deal | `/deal-status "Company"` |
| Research a new prospect before a call | `/customer-discovery "Name" "Company" "Location"` |
| Prepare for an ongoing deal (meeting #2+) | `/meeting-prep "Company"` |
| Update profile and draft email after a call | `/meeting-debrief` |
| Generate a one-pager for a prospect | `/pop-one-pager "Company"` |
| Get coached during a live call | `/live-sales-coach` *(in Claude Cowork)* |

---

## Common situations

**"I have a call in 10 minutes and no brief."**
Run `/customer-discovery` right now. It takes 1-2 minutes. Read the TL;DR + Hidden Differentiator. Walk in.

**"The brief got something wrong."**
The skill is wrong. Tell us. Paste in #pop-skills with what was wrong and what should have been there. Skills get sharper with feedback.

**"The prospect is clearly not a fit."**
Check the disqualification flags. If the brief marks "POOR FIT," don't pursue. Move on. Saving an hour of your time is more valuable than chasing a no.

**"I forgot to debrief and now it's the next day."**
Still run `/meeting-debrief`. Use the meeting ID from Granola if you remember it. Better late than never. The customer profile is forever.

**"My AE wants to know what's happening with all my prospects."**
Each prospect's `customer-profile.md` has the full history. Send the link, or run `/deal-status` (coming soon) to get a digest.

---

## What good looks like

By week 2, an SDR using these skills should be able to:
- Run discovery on 5 prospects in 20 minutes (down from 2-3 hours manually)
- Walk into every call already knowing the prospect's hidden differentiator
- Send follow-up emails within 30 minutes of the call ending
- Never drop a commitment

By week 4, you should be:
- Catching insights the brief misses (which means you're feeding back into the skill)
- Recognizing new prospect archetypes that aren't in the reference cases yet
- Suggesting improvements to the methodology

When you start doing the second list, you're not just using the system. You're improving it. That's when you're a senior SDR/AE.
