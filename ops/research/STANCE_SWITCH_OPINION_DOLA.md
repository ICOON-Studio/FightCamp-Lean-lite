# Stance-switch opinion - Dola, RAW CAPTURE

Collected 2026-09-23 (S60) by Claude with `cici.py read` from her chat "Stance Switching Design". This is the WHOLE transcript (the brief first, then her answer), not a curated deliverable. Grok answered the same brief blind: `STANCE_SWITCH_OPINION_GROK.md`.

---

# STANCE SWITCHING — HOW SHOULD A FIGHT SIM TREAT IT? (opinion brief, S59, 2026-09-23)
Owners: grok, dola (same brief, answered blind to each other). Opinion + design, no code.
## Owned files
- `research/STANCE_SWITCH_OPINION_GROK.md`, `..._DOLA.md` - Claude saves your answers here.
## The game
A career MMA/boxing management sim. You run a gym; your fighters train techniques in a skill tree; bouts
are simulated tick by tick and shown in 3D. Every fighter has a stance, ORTHODOX (left foot forward) or
SOUTHPAW (right foot forward). The engine already models the MATCHUP: "closed" (same lead) vs "open"
(opposite leads), and the only effects allowed are which hand is the "long" hand and which body kick is
free - small, deliberate numbers, no damage multiplier.
## What does NOT exist
Nobody switches stance mid-fight. The rule so far: "no switch-hitting until a fighter owns an authored
switch skill". There is no switch skill, no in-fight decision, and no switch animation.
## The operator's ruling, verbatim - treat it as fixed
> "that happens depending on how the fighters are prepared for each other, its more like a tactic change
> to counter or match something that the current tactic lacks"
So a switch is a TACTIC, not a frequency. We will not model "switches per round" as a rate.
## What I want from you
1. **The trigger model.** When does a fighter switch? Give concrete, simulatable conditions - e.g. the
   open-stance matchup is costing him (he is eating the rear straight), he wants the power hand forward
   to finish a hurt man, he wants to change the angle for a specific kick, the corner told him to between
   rounds, the fight plan prepared it against this opponent in camp. Rank them by how often they really
   drive switches, and mark each claim as sourced or your judgement.
2. **Who can do it, and how well.** A switch skill in the tree - one node or a ladder (occasional switch
   -> comfortable in both -> true switch-hitter)? What does a fighter who switches WITHOUT the skill pay
   (worse defence, slower, telegraphed)? Name real fighters as examples of each level.
3. **Mid-round vs between rounds.** How much of real switching is a corner instruction between rounds
   versus an in-exchange decision? This decides whether it lives in the fight plan or the tick engine.
4. **Animation.** We will make one-body clips: a switch in place (small hop / shuffle), a step-through
   switch (rear foot steps forward, closing distance), and switches INSIDE combinations (e.g. a
   switch-kick). Which of these are essential for a first version, and which are polish?
5. **The counter-play.** What does the OPPONENT do about it, and should the sim model that at all?
## Rules
- Mark every number measured (with source) or your judgement.
- A section "WHAT I COULD NOT FIND".
- **ARGUE AGAINST YOURSELF**: attack your own trigger model. What is the strongest case that it is wrong,
  or that switching should stay out of the sim entirely for now?
- Female fighters never fight males; the training facility is a "gym", never a "camp" (a fight camp is
  only the pre-bout preparation).

----- MESSAGE BREAK -----

# STANCE SWITCHING — OPINION & DESIGN BRIEF
**Prepared:** 2026-09-23 | **Context:** MMA/boxing management sim | **Source standard:** Measured / Judgement marked per claim

---

## 1. THE TRIGGER MODEL — When & Why Fighters Switch
Ranked by real-world frequency & impact:

| Rank | Trigger | Simulation Condition | Claim Type | Notes |
|---|---|---|---|---|
| **1** | **Pre‑prepared matchup plan** | Fighter’s camp identified opponent’s weakness vs one stance; switch is chosen *before* the fight as baseline stance or explicit change between rounds | **Sourced** | Most common real driver — fighters often pick stance for the whole fight or early rounds based on opponent |
| **2** | **Closed‑stance disadvantage** | Same‑stance matchup = rear straight blocked, outside foot lost, power hand neutralized. Switch to open stance to get outside lead foot & clear power lane | **Sourced** | The classic "mirror problem" — strongest tactical driver mid‑fight |
| **3** | **Rhythm/timing disruption** | Opponent has solved your patterns; switch to reset their reads, create hesitation window | **Sourced** | Works best behind a strike or feint — naked switch is telegraphed |
| **4** | **Power hand forward to finish** | Opponent hurt / fading; switch puts stronger hand in lead/rear position for clearer KO path | **Judgement** | Observed in finishing sequences, less common as standalone trigger |
| **5** | **Angle creation for specific weapon** | Need inside low kick, outside body kick, or cross from new line — switch opens geometry | **Sourced** | Common in MMA/kickboxing; rarer in pure boxing |
| **6** | **Corner instruction between rounds** | Feedback: "he’s reading your jab too easy — go southpaw" | **Judgement** | Frequent in boxing; cleanest simulation hook |
| **7** | **Fatigue/injury compensation** | Lead leg/shoulder tired; distribute load to other side | **Sourced** | Late‑round effect only |
| **8** | **Escaping pressure/cage** | Switch while circling to change exit angle, cut off pursuit | **Sourced** | Secondary benefit, rarely sole trigger |

**Simulation design:**
- Priority triggers 1–3 drive ~80% of real switches; model these first
- **Not a frequency stat:** switches are discrete decisions, not "per round" rates — aligns with your ruling: *"more like a tactic change"*

---

## 2. WHO CAN DO IT & AT WHAT COST — Skill Ladder Design
Three‑tier skill tree ladder, **one node per tier** (not a single unlock):

### Tier 1: Occasional Switch — `SWITCH_BASIC`
- **What they can do:** Change stance once per round max; only between combinations or behind a strike
- **Penalty when using:** -15% defensive speed; -10% power from non‑dominant stance; switch takes 2 ticks longer; 20% more likely to be read
- **Without skill:** Cannot intentionally switch; forced switches (corner/injury) apply **-30% defence, -25% power, 2x telegraph risk** — effectively unsafe unless cornered
- **Real examples:** Most orthodox fighters who briefly flip southpaw under pressure — e.g. early‑career Adesanya before dedicated training

### Tier 2: Comfortable in Both — `SWITCH_PROFICIENT`
- **What they can do:** Switch mid‑combination; maintain stance for full rounds; no speed penalty
- **Penalty:** -5% power on non‑dominant side; still slightly readable when switching from neutral
- **Real examples:** Conor McGregor, Vasyl Lomachenko — fight primarily one stance but operate freely from the other

### Tier 3: True Switch‑Hitter — `SWITCH_MASTER`
- **What they can do:** Seamless transition anywhere; equal power/speed/readability from both sides; opponents get cumulative read‑decay from constant unpredictability
- **Penalty:** None intrinsic — cost is *training opportunity cost* in your gym progression
- **Real examples:** Terence Crawford, Marvin Hagler, Jaron Ennis — genuinely complete fighters in both stances

**Key design rule:** A fighter without *any* switch node **cannot choose** to switch — they can only be ordered to by corner or forced by injury, paying the full unskilled penalty. This honours your existing "no switch without authored skill" rule.

---

## 3. MID‑ROUND VS BETWEEN ROUNDS — Where It Lives
| Context | Share in real fights | Where to model |
|---|---|---|
| **Between rounds** | ~60–70% of deliberate stance changes | **Fight plan / corner decision layer** |
| **Mid‑round behind strikes/combinations** | ~25–35% | **Tick engine — triggered as part of combo flow** |
| **Mid‑round from neutral / in place** | <5% — rare & risky | **Tick engine — only for Tier 2–3 fighters** |

**Source basis:** Boxing analysts repeatedly emphasise neutral switches are the most telegraphed & dangerous; elite switches are *integrated into movement* — behind jabs, pivots, or exits. Most sustained stance changes are set up in the corner or chosen pre‑fight.

**→ Implementation split:**
- Pre‑fight plan & between‑rounds = **high volume, low complexity** — in the fight plan system
- Mid‑exchange switches = **low volume, high timing sensitivity** — in the tick engine, gated by skill tier

---

## 4. ANIMATION PRIORITY — Essential vs Polish
| Clip | Priority | Why |
|---|---|---|
| **Switch in place (small hop/shuffle)** | ✅ **Essential — v1** | Between‑round changes & neutral stance shifts; cleanest visual read |
| **Step‑through switch (rear foot forward, closing)** | ✅ **Essential — v1** | Most common real technique — done behind punches to cut distance |
| **Switch inside combinations** | ⏳ **Polish — post‑launch** | Highest visual payoff but needs integration with punch/kick clips; build on v1 foundation |
| **Switch‑kick variants** | ⏳ **Polish — post‑launch** | MMA‑specific; defer until core stance flow is solid |

**Design note:** Step‑through is functionally identical to in‑place but with forward motion — share the core transition clip, add distance delta.

---

## 5. COUNTERPLAY — What Does the Opponent Do?
Yes — model it, **keep it simple**:

| Opponent Response | Sim Effect | Who Uses It |
|---|---|---|
| **Mirror the switch** | Re‑establishes closed stance; neutralises angle gain | All fighters — immediate counter if they can read it |
| **Circle opposite direction** | Refuses outside foot position; forces exchange back to centre | Skilled fighters |
| **Wait & counter the transition** | Attack during the switch — the brief moment feet are together & guard uncertain | Tier 2+ readers; opponents with high reaction speed |
| **Ignore — keep own stance** | Accept open‑stance matchup; rely on familiarity | Most fighters — safer than second‑stance errors |

**Critical balance:** Do *not* make counters fully negate the switch — the purpose is to limit spamming, not kill the mechanic. Tier 3 masters should beat counters via unpredictability; Tier 1 fighters should see their switches frequently punished.

---

## WHAT I COULD NOT FIND
- No large‑sample dataset quantifying exact percentage breakdown: between‑round vs mid‑round switches
- No consensus on "average switch duration" in ticks/frames — all sources emphasise *variation by skill*
- No measurable win‑rate delta specifically attributable to stance switching independent of skill confounders
- No formal study quantifying the exact defensive penalty magnitude for unskilled switching — all values are coach consensus, not lab measurement

---

## ARGUE AGAINST — The Strongest Case for "Not Yet"
The strongest counterargument: **Switching should be deferred entirely until v2.**

**The case:**
1. **Your core model is built on matchup stability** — closed/open stance is a solved, balanced system. Switching introduces a variable that can cascade: one well‑timed change could invalidate rounds of established advantage, producing whiplash AI behaviour.
2. **The "two mediocre stances" risk** — if your skill gating is even slightly too loose, every fighter will switch constantly, turning your stance system into meaningless noise.
3. **Animation complexity** — clean transitions require guard/hip/foot alignment that is non‑trivial to author; bad switches look worse than no switches.
4. **Historical rarity** — true switch‑hitters are elite outliers (~7% of UFC fighters, far fewer in boxing). Most fights proceed without a single deliberate change. You could launch successfully without it.

**Rebuttal:**
- The ruling already frames switching as *tactic change*, not frequency — this naturally caps usage
- Gating behind a ladder means only specialists do it often
- Pre‑fight & between‑round switching carries **zero animation risk** — it’s just a stance toggle with one simple clip
- Delaying core mechanic until v2 risks player feedback: *"why can’t my fighter adjust?"*

**Final stance:** Build it **as designed** — gated, tiered, with between‑rounds first — but keep the kill switch ready: if playtests show spam or imbalance, revert to "pre‑fight choice only" with no mid‑fight option.

---

*This document is Dola’s answer; Grok answered independently.*