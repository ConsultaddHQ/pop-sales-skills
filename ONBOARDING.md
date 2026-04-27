# Welcome to Pop Sales Skills 👋

If you're reading this, you're about to skip a year of sales-rep learning curve.

The tools in here are how our team turns raw leads into closed deals faster than any sales team your size has a right to. They're built on real wins from real meetings. By the end of today, you'll have run your first pre-call research and you'll see why everyone here uses these every day.

**Plan:** 30 minutes total. 10 minutes setup, 20 minutes first prospect. Then you're live.

---

## Before we start: why this exists

Most sales tools tell you what to do. This one does the work with you.

When you research a prospect by hand, you spend 30-60 minutes per company. Most of that time is finding the same information any SDR could find. The 5 minutes that matter — the ones where you spot the prospect's real edge, the unspoken pain, the timing pressure they haven't named — usually get cut because there's no time left.

These skills do the boring 25 minutes for you so you can spend your 5 on the part that matters.

A real example. Our founder met with **Brian Redtfeldt**, a personal trainer in Boise, in April. The SDR's manual brief said "social media + content creation pain." Generic. The skill would have caught — and the AE eventually discovered live on the call — that Brian grew up boxing, offers boxing specialty training, but doesn't market it. **Nobody else in Boise markets a boxing trainer.** That single insight was the whole pitch. Brian signed because we walked in already knowing his edge.

That's the difference. Not "more research." Sharper research.

---

## Step 1 — Install Claude Code (5 min)

You'll need Claude Code on your machine. It's the AI environment our skills run in.

1. Go to [claude.ai/download](https://claude.ai/download)
2. Download the version for your OS (Mac or Windows)
3. Open the installer and follow the prompts
4. When it opens, sign in with your work email

That's it. You should now have a Claude Code app on your machine.

✓ **Checkpoint:** Open Claude Code. You should see a chat interface. If you do, you're good.

---

## Step 2 — Install the skills (3 min)

This is the one terminal command you need. Don't worry — you'll only do this once.

1. Open the **Terminal** app
   - **Mac:** Press `Cmd + Space`, type "Terminal", press Enter
   - **Windows:** Press the Windows key, type "Terminal", press Enter

2. Copy and paste this command, then press Enter:

```bash
curl -fsSL https://raw.githubusercontent.com/ConsultaddHQ/pop-sales-skills/main/scripts/install.sh | bash
```

3. The installer will:
   - Check that Claude Code is installed ✓
   - Clone the skills to `~/.claude/skills/pop/` ✓
   - Set up your shared customer folder ✓
   - Print a success message ✓

If anything fails, see the [Troubleshooting](#troubleshooting) section at the bottom.

✓ **Checkpoint:** When the script finishes, you should see a green message like:

```
✓ Pop Sales Skills installed successfully.
✓ Run `claude` and try `/customer-discovery` to test.
```

---

## Step 3 — Test that it works (2 min)

Let's prove the install worked with a test run.

1. Still in your Terminal, type:

```bash
claude
```

2. Claude Code opens. In the chat, type:

```
/customer-discovery "Tesla"
```

(Yes, Tesla. We're just testing.)

3. Watch what happens. The skill will:
   - Search the web for Tesla
   - Identify the company profile
   - Pull recent news, leadership, signals
   - Produce a structured discovery brief

It'll take 1-2 minutes. While it runs, you'll see a progress indicator.

✓ **Checkpoint:** You should see a multi-section brief with TL;DR, Company Snapshot, Contact Snapshot, Hidden Differentiator, etc. If you do, **you're done with setup.** Everything works.

If something looks off, paste the output to your AE or in #pop-skills and someone will help.

---

## Step 4 — Your first real prospect (15 min)

Now do it for real.

1. Pick a prospect from your day's leads. Any one. Don't overthink it.

2. In Claude Code, run:

```
/customer-discovery "Contact Name" "Company Name" "City State"
```

For example:
```
/customer-discovery "Sarah Chen" "Acme Logistics" "Austin Texas"
```

3. Wait 1-2 minutes. The brief will appear in the chat AND save to:

```
~/Google Drive/Customer Intelligence/acme-logistics/discovery-{timestamp}.md
```

4. Read the brief. Pay attention to these sections:
   - **TL;DR** — read this first. If a 30-second read doesn't give you the hook, the brief failed.
   - **Hidden Differentiator** — the boxing-style insight. The thing nobody else is telling them.
   - **Qualification Signals** — score out of 5. If 3+, this is a strong lead. If 1-2, probe gaps. If 0, consider disqualifying.
   - **Discovery Questions** — these are GROUNDED. Use them on the call.
   - **Do NOT Pitch** — anti-patterns. Read this BEFORE the call. Saves you from saying the wrong thing.

5. Send the brief link to your AE before the call. They'll thank you.

✓ **Checkpoint:** You ran the skill on a real prospect. The brief is in the shared folder. Your AE has it. Welcome to the team.

---

## Your daily workflow

See [DAILY_WORKFLOW.md](DAILY_WORKFLOW.md) for the full version. The short version:

**Every morning (15-20 min):** Run `/customer-discovery` on each prospect you're calling that day.

**After every call (3-5 min):** Run `/meeting-debrief`. It pulls the call transcript from Granola, updates the customer profile, and drafts your follow-up email.

**Before every call (AE only, 2 min):** Run `/meeting-prep` to load all prior context for ongoing deals. (Coming soon — for now, read the latest entry in `customer-profile.md`.)

Print [CHEAT_SHEET.md](CHEAT_SHEET.md) and put it next to your monitor. That's the one-page reference.

---

## What to expect in your first week

**Day 1-2:** You'll feel slow. You're learning when to invoke each skill. That's normal.

**Day 3-4:** You'll start trusting the briefs. You'll skip skills that don't fit (e.g., disqualified prospects).

**Day 5+:** The system disappears. You'll just be a sharper SDR/AE. The skill outputs feel like your own thinking — because they're trained on the methodology our team uses.

By week 2, your prospects will start saying things like "you really did your homework" and "this is the most prepared sales call I've had in a while." That's the moment.

---

## Troubleshooting

**Problem: The install script fails with "command not found: curl".**
Solution: You're probably on Windows. Open PowerShell instead of Terminal and use this command:
```powershell
iwr -useb https://raw.githubusercontent.com/ConsultaddHQ/pop-sales-skills/main/scripts/install.sh | iex
```

**Problem: Claude Code doesn't recognize `/customer-discovery`.**
Solution: The skill files probably aren't in the right place. Check that `~/.claude/skills/pop/customer-discovery/SKILL.md` exists. If it doesn't, re-run the install script.

**Problem: I get a "permission denied" error.**
Solution: The install script needs to write to `~/.claude/`. Make sure you're not running as a different user. On Mac, you may need to grant Terminal permission in System Settings → Privacy & Security → Files and Folders.

**Problem: The brief came out generic / wrong / weird.**
Solution: Skills get sharper with feedback. Paste the bad output into Slack #pop-skills with what you expected instead. Someone will tune the skill.

**Problem: Where do my customer profiles save?**
Solution: `~/Google Drive/Customer Intelligence/{company-slug}/customer-profile.md`. If you don't have Google Drive for Desktop installed, they save to `~/customer-intelligence/{company-slug}/` and the install script will warn you.

**Problem: I'm scared of the terminal.**
Solution: That's fine. The terminal is a tool, not a test. You only use it for the install command (one time) and to launch Claude Code (`claude`). After that, everything happens in the Claude chat interface like a normal app. You got this.

---

## Where to go next

- [DAILY_WORKFLOW.md](DAILY_WORKFLOW.md) — the rhythm of every day
- [CHEAT_SHEET.md](CHEAT_SHEET.md) — print and pin
- [customer-discovery/SKILL.md](customer-discovery/SKILL.md) — the deep dive on the discovery skill
- [meeting-debrief/SKILL.md](meeting-debrief/SKILL.md) — the deep dive on debriefs

If you want to know WHY a skill does something the way it does, the SKILL.md files explain it. They're long. Read them when you want depth, not on day 1.

---

## A note from your founder

We hired you because we think you can be one of the best at this. The methodology in these skills is what took our team years of trial and error to figure out. By using these from day 1, you're starting where we ended up — and you'll go further than we did.

Don't be afraid to push back on the skills when they're wrong. Don't be afraid to suggest a new pattern. Don't be afraid to ask. Every question makes the system better for the next person.

Welcome to Pop. Let's go.

— Bharat
