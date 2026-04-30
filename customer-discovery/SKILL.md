---
name: customer-discovery
description: |
  Deep pre-call research on a prospect company and contact. Produces a discovery brief that catches hidden differentiators, vulnerability signals, and research-grounded talking points. The goal is to walk into the call already knowing the prospect's real edge, real pain, and real timing — instead of discovering it mid-conversation.

  ALWAYS use this skill when: the user provides a company name, contact name, or LinkedIn URL and asks for research, discovery, prep, or a customer brief. Also trigger on phrases like "research this prospect", "prep for this meeting", "who is this company", "discovery brief", "what do we know about", or when the user pastes raw lead info (email + company) and expects research output.

  This is a GENERAL skill that works for any B2B prospect, any industry, any ICP. It auto-detects the prospect profile (solo operator, B2B buyer, technical founder, enterprise, etc.) and shapes the output accordingly. Specific playbooks for recurring industries should be added as reference cases over time.

  Output: structured markdown brief written to stdout AND to the prospect's Slack channel as a canvas. Slack channels follow the pattern `#internal-{slug}-pop` and are auto-created by the CA AI Salesforce bot when an opportunity is created. The skill writes a "Discovery Brief — {date}" canvas, updates the channel's main "Customer Profile" canvas, and posts an inline summary message. See SLACK_INTEGRATION.md for full conventions.
---

## Quick Start

```
/customer-discovery "Brian Redtfeldt" "Fitness Together" "Boise Idaho"
/customer-discovery "scott@mistermac.us"
/customer-discovery "https://www.linkedin.com/in/mauro-rodriguez-ab968392/"
```

Inputs: any combination of company name, contact name, title, email, LinkedIn URL, location, industry. Minimum: company name OR a LinkedIn URL OR an email. Everything else helps.

## Workflow

### Step 1: Parse inputs, ask for missing basics

Accept whatever the user provided. If the bare minimum (company name) is missing, ask once. Never invent facts.

If an email is provided, extract the company from the domain. If a LinkedIn URL is provided, use that as the starting point for contact research.

### Step 2: Research the company

Use WebSearch to gather:

1. **Core business** — what do they actually do, not what their tagline says. Revenue model, who pays them, what they charge.
2. **Size and stage** — employee count, years in business, locations, solo/team/franchise/corporate/enterprise.
3. **Recent signals (last 6 months)** — hiring, funding, new locations, layoffs, leadership changes, product launches, press, review shifts, website updates.
4. **Parent / franchise relationship** — if it's a franchise, subsidiary, or partner of a larger entity, understand that dynamic. Where does the local operator have autonomy?
5. **Local competitive landscape** — who else operates in their geography doing similar work? How does this prospect differentiate (or fail to)?

### Step 3: Research the contact

Use WebSearch (LinkedIn, personal website, interviews, podcasts, articles):

1. **Professional background** — current role, tenure, prior roles, career trajectory.
2. **Personal history / origin story** — how did they get here, any pivots, what shaped them.
3. **Specialties and passions** — what do they talk about publicly that isn't their core service? Side skills, hobbies, unusual backgrounds. **This is often the hidden differentiator.**
4. **Decision-making power** — are they the owner/founder, a VP, an operator, or an employee? Can they sign for the price range in play, or do they need sign-off?
5. **Communication style signals** — formal/informal, technical fluency, writing style from posts.
6. **AI posture** — curious, skeptical, enthusiastic, sophisticated, building-their-own, never-heard-of-it. Read this from their posts, the tools they use, their past statements.

### Step 4: Classify the prospect profile (CRITICAL)

Assign ONE primary profile. This drives everything else. Profiles are derived from 141+ real sales calls:

| Profile | Signals | Sale shape |
|---|---|---|
| **Solo operator / small business** | Founder = only operator. <10 employees. Service-based. Pain is visibility, time, or manual ops. | Retail plan, simple onboarding, content/marketing-led |
| **Non-technical founder (pre-product)** | Zero-to-one stage, bootstrap budget, about to hire engineer or give equity for tech capability, customer demand waiting on product | Fractional CTO positioning, discovery sprint as credit, milestone billing, non-equity alternative |
| **Founder-led SMB with existing tech stack** | Has HubSpot/Salesforce/etc., team in place, API-fluent, quantified workflow pain, ROI-focused | Per-workflow pricing, integration-led, discovery sprint entry |
| **Technical founder** | Builds their own tools, skeptical of hype, evaluates engineering, may pivot to partnership | Custom work or partnership, prove technical depth, non-equity preferred |
| **Government / RFP / Enterprise** | 100+ employees, procurement process, formal RFP, multi-stakeholder, compliance requirements | Pilot → champion → contract, longer cycle, formal responses |
| **Partner opportunity** | Has distribution, wants rev share, not a direct buyer | Partnership framing, not customer framing |
| **POOR FIT / DISQUALIFY** | See Step 4b below | Do not pursue. Document reason. |

Name the profile explicitly in the brief. Output shape adapts to the profile.

### Step 4b: Disqualification check (CRITICAL — saves the AE's time)

If any of these apply, classify as POOR FIT and say so explicitly. The skill should not produce a sales brief for disqualified prospects — it should produce a "do not pursue" flag with reasoning.

| Disqualifier | Example | Why |
|---|---|---|
| **Relationship-core business** | MLM operator, personal-coaching business, psychotherapist | Their value IS the human relationship. AI can't touch the bottleneck. |
| **No product, no channel** | Pre-launch founder with "idea" but no customers yet | "I can't make an agent if you're not selling anything." |
| **Lifestyle business, no growth ambition** | 72-year-old owner comfortable with current operational limits | No motivation to change. Will say no politely. |
| **Just exploring, no budget** | "We're curious about AI generally" with no specific pain or decision timeline | Will waste 2 hours, close at zero. |
| **Wrong-time personal circumstance** | Major life event, business sale in progress, legal issues | Bandwidth is elsewhere. Not now. |

When disqualifying, BE EXPLICIT in the brief: "DO NOT PURSUE — {reason}. Alternative: {what might re-qualify them later}."

### Step 4c: Qualification signals (predicts closing)

Prospects who CLOSE have 2+ of these. The skill should surface each signal found in the research:

1. **Quantified pain** — they can name numbers (hours, dollars, percentages). Not vague frustration.
2. **Failing workaround** — they tried a VA, a tool, a process. It broke. They have data on why.
3. **Revenue target + timeline** — "$5k/month in 3 months," launch deadline, quarterly goal.
4. **Founder doing the manual work personally** — pain is felt, not delegated.
5. **Proactive reach-out signal** — they responded fast, asked smart questions, mentioned timing urgency.

Fewer than 2 signals → probably a "maybe" at best. Flag the gap in the brief's "What We Still Don't Know" section.

### Step 5: Identify hidden differentiators

This is the step most SDRs miss. Go past the surface:

- What is this person/business uniquely positioned to offer that competitors cannot?
- What have they lived, built, or worked on that shapes how they operate?
- What is searchable and memorable about them that ISN'T in their marketing?
- What would make them stand out in their market if we leaned into it?

**Always ask:** if I had to explain why this prospect is different from the 50 other companies like them, in 2 sentences, what would I say? If you can't, research more.

### Step 6: Identify vulnerability signals (why NOW)

These are the timing-based reasons to buy this quarter vs. next year:

- **Personnel changes** — losing a key person, leadership shift, recent hire who wants to make a mark
- **Hiring-decision signals** — active job posts, "about to hire," considering equity for capability, "we're looking for" language
- **Hiring-inflection decision gate** — prospect is hiring a team in the next 30 days that will be the decision committee. Deal is gated until they arrive, AND tools the new hires bring become your default competition. Counter-move: pre-audit DELIVERED before the new team starts, so when they arrive you're the advisor with data, not a vendor competing with their chosen tools.
- **Seasonal dynamics** — client cycles, annual renewals, fiscal calendar pressure
- **Growth stall signals** — flat revenue, stale website, dormant socials, falling reviews
- **Build-vs-buy pivots** — moving from internal tools to vendors (or vice versa)
- **Clock-starting events** — recent platform migration, new funding, leadership change (needs to show ROI soon)
- **Distribution-is-the-asset** — customer demand waiting on product (reverse of normal). Speed-to-ship beats feature completeness.
- **Life stage signals** — recent pivot, market entry, exit planning, bar exam / personal timeline constraints

Apply the **5 Whys** (Jeremy Miner's method) to the strongest signal. Keep asking "why does that matter?" until you reach the financial or emotional core.

### Step 7: Identify anti-patterns — what NOT to pitch

Some offerings will destroy the prospect's moat or alienate them. Flag these explicitly.

Examples:
- Prospect's moat is human-touch → DO NOT pitch customer-facing AI
- Prospect explicitly rejects custom builds → DO NOT pitch engineering POCs
- Prospect has invested in a specific platform → DO NOT suggest replacing it
- Prospect is technical founder → DO NOT over-explain AI basics

A "Do Not Pitch" section in the brief prevents mid-call disasters.

### Step 8: Map offering fit

For whatever product/service offerings are relevant to the caller's company, map each offering to this prospect:

```
| Offering | Fit (H/M/L) | Evidence |
|---|---|---|
| {offering name} | H/M/L | {specific evidence from research} |
```

**Be ruthless about LOW fit.** Don't pad the table. If an offering doesn't fit this prospect, mark it LOW and say why. If the retail offerings don't fit at all (e.g., prospect is outside the ICP), flag that loud and propose alternative framing (partnership, custom, different pricing model).

**Recommended entry:** one sentence. Which offering, which angle, why it lands.

**Default close move (use when profile fits):** $3-5k discovery sprint, refundable as credit toward Phase 2 build. Milestone-based billing thereafter. This is the single most effective urgency lever across the sales corpus — converts "thinking about it" into "let's start." Use when:
- Prospect is a solo operator, non-technical founder, or founder-led SMB
- Budget is <$20k for the whole project
- Timeline pressure exists (launch, revenue target, hiring decision this week)

**Do NOT default to discovery sprint when:**
- Prospect is government/RFP/enterprise (formal procurement process takes over)
- Prospect is technical founder evaluating partnership (rev share deal, not POC)
- Prospect is DISQUALIFIED (see Step 4b — don't waste a sprint on a no-fit)

### Step 9: Generate discovery questions (grounded, not generic)

Write 5-8 discovery questions the caller should ask. Each MUST reference specific research findings. Generic questions waste the prospect's time and reveal you didn't prepare.

Bad: "What are your biggest marketing challenges?"

Good: "I saw {company} corporate handles brand-level social, but for {location} specifically — where does your marketing end and where do you wish it could pick up, especially around {specific angle from research}?"

### Step 10: Predict objections + draft first responses

Based on the research, predict 2-4 objections likely to come up. For each, draft a first-response line using acknowledge-and-reframe (30MPC-style), not argue-against.

**The five objections you'll hear most (derived from real call data):**

| Objection | Working response pattern |
|---|---|
| "AI can't replace human connection" | Acknowledge honestly ("at this point we're not there yet") + reframe AI as operational support behind the relationship, not the relationship itself. Probe for repeatable pattern-based tasks. |
| "We're not ready / testing first" | Validate the timing ("you're not buying a hammer before you know where the nails are") + schedule a follow-up for after their internal test. Don't push. |
| "What does this cost / will there be ROI?" | Flexible pricing tiers + low-risk discovery sprint entry ($3-5k, refundable toward Phase 2). Reframe: "the real cost is not the discovery fee, the team's attention is." |
| "I can still tell it's AI" (post-demo) | Acknowledge the delay is intentional listening behavior + note customizable models + emphasize scale advantage ("10k calls in 2 weeks"). |
| "I need to see proof / references" | Offer case studies + propose a tailored written scope doc specific to their situation (not a generic pitch). |

When drafting objections for this specific prospect, start from the list above and customize with their specific context. Don't reinvent — 141 calls of data says these five account for the overwhelming majority.

### Step 11: Flag what's still unknown

Explicitly list 3-8 things you couldn't determine from public sources. These MUST be asked on the call because no amount of research will answer them:

- Current budget / spend
- Specific metrics (churn rate, LTV, conversion rate)
- Decision process (solo call or committee)
- Prior vendor experience
- Timeline pressure (why now, not next quarter)

### Step 12: Write output to Slack

Write the discovery brief to THREE locations:

1. **stdout** — shown to the user as formatted markdown
2. **Standalone canvas in the customer's Slack channel** named `Discovery Brief — {YYYY-MM-DD}`
3. **Channel's main "Customer Profile" canvas** — append a new entry to the Activity Log section, update Hidden Differentiator / Vulnerability Signals / Open Commitments sections with new info

**Find the channel:**

1. Slug the company name per the rules in `SLACK_INTEGRATION.md`
2. Search Slack for the channel: `#internal-{slug}-pop` (use `mcp__claude_ai_Slack__slack_search_channels`)
3. If found: read existing canvases, write new ones in the channel
4. If NOT found: tell the user "No channel found for {company}. Create the Salesforce opportunity first (the CA AI Salesforce bot auto-creates the channel), or pass `--no-slack` to write locally."

**Read the bot's pinned channel introduction** to extract the canonical Salesforce-side data:
- Company name (use this verbatim, not user input which may be malformed)
- Current Salesforce stage
- Owner email
- Salesforce opportunity link

Reference these in the Customer Profile canvas header.

**Inline summary message:** after creating the canvas, post a short message in the channel with a link to the canvas and a 2-line summary (profile classification, qualification score, recommended entry). Tag the owner if action is needed before the call.

**Fallback (Slack MCP unavailable or channel doesn't exist):**

Write to `~/customer-intelligence/{company-slug}/discovery-{YYYYMMDD-HHMM}.md` and warn:
"Slack unavailable, wrote local file. Sync to channel `#internal-{slug}-pop` when reconnected."

## Output Template

**If POOR FIT (disqualified in Step 4b):** produce a short "Do Not Pursue" brief with the disqualification reason, any alternative framing that might re-qualify them later, and nothing else. Don't waste pages on a prospect who won't close.

**If qualified:** use the full template below.

```markdown
# Discovery Brief: {Contact Name} — {Company Name}

**Generated:** {timestamp}
**Prospect Profile:** {Solo operator / Non-technical founder / Founder-led SMB / Technical founder / Government-Enterprise / Partner}
**Qualification Signals:** {X of 5} — {list which ones}
**For AE:** {if known}
**Prepared by:** {OS username or whoami}

## TL;DR

One paragraph. The hook. Read this in 30 seconds and walk into the call ready. Name the profile, qualification strength, hidden differentiator, vulnerability signal, and recommended entry point.

## Company Snapshot

- **Business:** {what they actually do}
- **Size / stage:** {people, years, revenue signals}
- **Revenue model:** {who pays, how much, how often}
- **Parent / franchise:** {if relevant}
- **Location:** {city, state, country}
- **Website:** {URL}

## Contact Snapshot

- **Name, title:** {...}
- **Decision power:** {solo / needs committee sign-off / budget-approver / evaluator}
- **Background:** {2-3 sentences on their journey}
- **LinkedIn:** {URL}
- **Communication style:** {formal/casual, direct/diplomatic, technical/non-technical}
- **AI posture:** {curious / skeptical / sophisticated / builds-their-own / novice}

## Qualification Signals

Of the 5 signals that predict closing, this prospect shows:

- [ ] Quantified pain (specific numbers) — {evidence or "not found"}
- [ ] Failing workaround (tried something, broke) — {evidence or "not found"}
- [ ] Revenue target + timeline — {evidence or "not found"}
- [ ] Founder doing manual work personally — {evidence or "not found"}
- [ ] Proactive reach-out signal — {evidence or "not found"}

**Score: {N}/5.** {"Strong close probability" if ≥3, "Moderate — probe gaps" if 2, "Weak — likely maybe or no" if ≤1}

## Hidden Differentiator

{The edge. The story. The unused angle. What makes this prospect memorable. Cite the research source.}

## Vulnerability Signals (why now)

- {Signal 1 with evidence and date/source}
- {Signal 2 with evidence and date/source}
- {Signal 3 with evidence and date/source}

**5 Whys applied to the strongest signal:**

- Surface: {initial signal}
- Why? {...}
- Why? {...}
- Why? {...}
- Why? {...}
- **Core:** {the financial/emotional bottom}

## Offering Fit

| Offering | Fit | Evidence |
|---|---|---|
| {offering 1} | H/M/L | {specific evidence} |
| {offering 2} | H/M/L | {specific evidence} |
| {offering 3} | H/M/L | {specific evidence} |

**Recommended entry:** {one sentence — which offering, which angle, why it lands}

## Do NOT Pitch

- {Anti-pattern 1 — offering or framing that would destroy the prospect's moat or alienate them, with reason}
- {Anti-pattern 2}

## Discovery Questions

Each grounded in research. Each references a specific finding.

1. {Question}
2. {Question}
3. ...

## Likely Objections

| Objection | First response (acknowledge + reframe) |
|---|---|
| {objection} | {response} |
| {objection} | {response} |

## What We Still Don't Know

- {Gap 1}
- {Gap 2}
- {Gap 3}

## Conversation Starters

- {Rapport builder grounded in research}
- {Another angle}

## Sources

- {URL 1 — what it told us}
- {URL 2 — what it told us}
```

## Quality Bar

A brief is GOOD when:

- The **Hidden Differentiator** names something the prospect would be surprised we found
- **Vulnerability signals** are timing-based (why now, not just why)
- **Discovery questions** reference specific research findings — no generic pain-point questions
- **Offering fit** is evidence-based, ruthless about LOW fit, explicit about ICP mismatch
- **Do Not Pitch** section exists and prevents a specific foreseeable mistake
- The **TL;DR** is a paragraph an AE can read in 30 seconds before the call

A brief is BAD when:

- It reads like a Wikipedia summary
- Pain points are generic category pains, not this specific prospect's
- Discovery questions could apply to any prospect in the category
- Hidden differentiator is missing or is "they care about customers"
- Sources aren't cited
- Every offering is marked HIGH fit (padding the table)

## Reference Cases

Optional — read these to see how the skill handles different prospect profiles:

- `references/case-brian-redtfeldt.md` — Solo operator (Fitness Together, boxing angle)
- `references/case-mauro-vacancy-rewards.md` — B2B tech buyer outside retail ICP (HubSpot integrations)
- `references/case-scott-mister-mac.md` — Technical founder, partner not customer (anti-pattern: customer-facing AI)
- `references/case-regina-thermal-ledger.md` — Non-technical founder pre-product (fractional CTO + discovery sprint close, best-case outcome)

Add more reference cases as you encounter new prospect profiles. The skill improves when new patterns are codified, not when the core methodology is rewritten.

## Post-Call Feedback Loop

After running this skill and taking the actual call, update `customer-profile.md` with anything the brief missed. Specifically:

- What surprised you on the call that wasn't in the brief?
- What pain was bigger (or smaller) than predicted?
- What objection came up that wasn't on the list?
- What hidden differentiator emerged that wasn't in the research?

Log these in the Activity Log with a `LESSONS` tag. Over time, scan the lessons to identify patterns and tune the skill.
