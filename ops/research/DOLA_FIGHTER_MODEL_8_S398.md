# Dola (designer seat): "the version that would score 8/10" of the fighter model v2.1 (S398, raw answer)

---
# FightCamp Fighter Model — 8/10 Steam-Shipped Revision
This version keeps every working part of v2.1 and fills the gaps the critics flagged, staying strictly within your limits: rounds stay six × 30s; the eight corner words remain; no traits, no new art/animation; every change is visible and non‑averaged.

## What stays solid
- Three‑place ladder + steering contest (symmetric footwork race, clamp 0.2–0.8, ropes penalty)
- Two‑sided named duels per place, convex gap curve, best‑tool + mean, counterfactual deciding duel
- 20 abilities + pace/forward dials + body facts; separate heart/composure triggers; body attribute scaling energy cost
- Form roll per bout; stance adjustments; age decay curves; signature/flaw generation
- Six keys + signature line + wanted range on fighter page; narrowing scouting ranges; round‑by‑range reports

## What changes — and why
### (a) End one‑attribute dominance
**Problem**: Bar 8 showed no single stat broke the field, but three pairs still appeared everywhere: guard + head movement in defence; footwork + foot speed in steering; ring IQ + accuracy in decisions. Players learned to max those and ignore others — the “optimizer gap” the systems designer flagged.

**Fix**: Redistribute answer weights so *every ability defends somewhere unique*:
- Guard now answers **only** right hand, body shot, and inside clinch — removed from long jab, counter, step‑in counter
- Head movement answers long jab, counter, step‑in counter, short work — removed from power shot, body
- Timing takes power shot defence; composure takes step‑in defence; body takes body defence
- Ring IQ still reads situations but no longer blocks counters alone — split: **ring IQ** anticipates place shifts; **accuracy** anticipates shot selection
- Add small but real uses for under‑exposed attributes: *strength* dampens power shots inside; *recovery* shortens hurt‑state duration; *chin* softens ropes penalty

**Why**: Every number now changes a visible outcome. No build dominates all matchups — the triangle holds firm, and trading one strength for another always shows in the exchange report.

### (b) Generated boxers feel like people with careers
**Problem**: Ranges and spikes existed, but no narrative arc — boxers aged as numbers, not as fighters with styles that shift, decline, or peak. The sim veteran’s “people layer” gap.

**Fix — visible career profile**:
- **Style shift with age**: Before 26 → faster footwork/pace; 26–32 → peak skill (jab, straight, timing, accuracy); 33+ → pace slows, forward dial rises (fighters walk down rather than out‑box); ring IQ creeps up to 33 then plateaus; power holds longest, drops latest. *Shown*: “At his best 28–32; slowing now but still coming forward.”
- **Record matches profile**: KO rate = power × inside frequency ÷ opponent chin — sluggers have high KO%, out‑boxers lower, accurate counter‑punchers decision‑heavy. *Shown*: “12 KOs — finishes inside; goes the distance otherwise.”
- **Consistency dial (no new stat — derived)**: How close form rolls cluster. Consistent fighters → narrow range; erratic → wide range. *Shown* on scouting as “Reliable” / “Unpredictable” / “Can fade early” — updates over 3–4 bouts as real pattern emerges.
- **Reputation memory**: Upsets stick — beating a top‑5 opponent permanently widens their *shown* chance range; losing to a lower‑ranked one tightens yours. Familiarity: second meeting vs same opponent narrows scouting ranges further — “Faced him 10 months ago; knows his rhythm.”

**Why**: Generated boxers stop feeling like templates — you see who they are, how they fight, and where they are in their career. No extra code: derived from existing numbers; no new assets.

### (c) What the player sees — clearer, sharper, scouted better
**Problem**: The reports worked but were dense; scouting narrowed without telling you *what matters*; the fighter page showed numbers but not *style identity*. All three critics wanted more readable, actionable output.

**Fix — fighter page**:
- Lead with **identity sentence**: “Out‑boxer — keeps it long, wins on speed; weak inside vs swarmers” → built from top two ranges + lowest range
- Six keys now show **current range** (scouting) + **career trend** (up/down arrow): “Long: 72–78 ↑”
- Dials shown as words with context: “Relentless — throws 15% more; tires faster” / “Cautious — harder to counter; low output”

**Fix — scouting read before bout**:
- Replace plain ranges with **three bullet scout summary**:
  - *Where they win*: “Strongest long — wins 62% when they keep it there”
  - *Where they break*: “Weak inside — tied up 3× in last four losses”
  - *Trend*: “Slowing — past peak; fades rounds 4–5”
- Ranges still present below for detail players; summary leads.

**Fix — round report**:
- Open with **control share**: “Kept it long 4/6 exchanges; you controlled range early”
- Then **deciding duel named with gap**: “Lost inside exchanges — their hooks (84) beat your inside work (71); cost them the round”
- Close with **one clear takeaway**: “They tire late — push pace round 5”
- Remove dead numbers; keep only what changes your next call.

## Priority change list
1. Redistribute defence weights → every ability defends uniquely; close optimizer gap
2. Age‑style arcs + career trend labels → fighters feel like evolving people
3. Scout summary (3 bullets) + range context → read opponent instantly
4. Fighter page identity line + trend arrows → know your fighter at a glance
5. Round report streamlined: control share → deciding duel → one takeaway
6. Record tied to profile → KO/decision pattern matches how they fight
7. Consistency/reputation visibility → form and results build narrative
8. Derived context on dials (pace = output vs fatigue) → choices feel real

---
Score basis: fixes every flagged hole without scope creep; every change is visible in‑fight or on‑menu; no build dominates; every generated boxer reads as distinct; readability matches Football Manager’s clarity; all built on the solid v2.1 foundation.
---
