# Stance-switch opinion - Grok (Expert), verbatim

Source: grok.com/c/8298ed0e-05ac-4362-a0e4-c5ef19088e36, collected 2026-09-23 (S60) by Claude via the
grok.com API from the in-app browser. Brief: `TASK_STANCE_SWITCH_OPINION.md` (same brief as Dola's, blind).

---

**Treat a switch as a planned stance change that flips closed/open.** Not a per-round rate. That matches how the useful switches actually work, and it stays inside the geometry you already simulate (long hand + free body kick).

### 1. Trigger model

A switch fires when the **current stance is the wrong tool for a job the fight plan already named**. Concrete, simulatable conditions, ranked by how often they really drive a *lasting* switch.

**A. Fight-plan / preparation (most common lasting switch)** — sourced
Pick the lead before the first bell, or lock a new lead at a reset, because this opponent's tape said so. Crawford fought Spence southpaw because Spence's southpaw record was thin. He started Brook orthodox, then opened round 3 southpaw after the early rounds weren't his.
Coach line that matches your operator: switch to *change the question*, not to fix a round you are already losing.

**B. Geometry is costing him (common)** — sourced + judgement
Open stance, eating the rear straight / losing the outside foot. Closed stance, jab dead, wants the open-side rear hand or the free kick. Open matchups put both rear hands on a cleaner centreline; outside lead foot decides the angle.
Judgement: this is the #1 *in-fight* reason among non-stylists. Not "I switch a lot." It is "this picture is wrong."

**C. Weapon the current lead cannot throw cleanly (common in MMA, less in boxing)** — sourced
Step-through so the rear kick lands as the new lead, or switch to put the power hand on the open lane. Sandhagen walked a right straight into southpaw to fire the left body kick on the open side. Switch-kick is the same idea: skip, load the old lead, kick.

**D. Finish / cut off a hurt man (occasional, high value)** — sourced
Hagler's turn-shift: opponent circles off the power side, he faces them and is suddenly orthodox with the door closed. Same family as a Tyson linear shift. Power hand becomes the new lead or the new rear on purpose.

**E. Safe reset: exit, clinch break, ref separates you (occasional)** — sourced
Hop-switch on a 45° exit; switch as you peel off frames; Hagler changing lead while the ref is still between them.
Safest window. Mid-pocket switch is when people get clipped.

**F. Corner between rounds (real, but usually ratifies A–B)** — sourced thinly
Corners spend the middle of the break on one or two tactical notes. Crawford–Brook is the clean documented "new stance next round." I did not find a pile of "switch southpaw this round" quotes. Judgement: the corner *authorises* the tactic; the fighter often feels it first.

**G. Hurt lead leg / busted hand (rare)** — mentioned, not measured
Listed as a reason to change lead. No count of how often it decides a fight.

**Do not trigger on:** boredom, "mix it up," a hidden switches-per-minute stat. That is the Cruz/Sandhagen *identity*, not the tactic. Sandhagen had a counted **14 switches in round 2** before the 1:03 KO — one analyst, one fight, ~every 4.5s. That is style, not a rule you want as a clock.

---

### 2. Who, and the cost of doing it cold

**Ladder, not one node.** Diesel Gym is blunt: the fighter who is equal from both sides is a myth; each lead has different weapons.

| Level | What they can do | Without it / below it they pay | Examples |
|---|---|---|---|
| 0 none | Anyone can put the other foot forward | Square, slow, telegraphed; weak new jab; kick-check and takedown sit open; clipped in the step. Default coaching advice is *don't*. | Most of the roster |
| 1 authored switch | Hold the other lead for a **planned sequence or one round** | Still worse defence and slower first 2–3 strikes after the change | Fury (uses it, not defined by it); Tyson (shifts, does not live there) |
| 2 comfortable both | Whole rounds either side; defence transfers | Small read delay only | Ward; Joanna Jędrzejczyk; Nick Diaz orthodox-from-lefty |
| 3 switch-hitter | Switch *inside* the action (exit, step-through strike, mid-combo) without losing the guard | Almost none if timed; still get clipped if they hop in the pocket | Hagler, Crawford, Adesanya, Cruz, Dillashaw, Sandhagen, Allazov |

Judgement on the unpaid cost (no measured % exists): **defence and first-strike speed**, not a damage multiplier. That stays consistent with your "no damage multiplier" rule. MMA-specific extra: a squared switch is a shot.

Southpaw base rates (measured, not switcher rates): ~10% of people are left-handed; elite combat is higher — male boxers southpaw **17%** (1,779 / 10,445), female boxers **12.5%** (164 / 1,314), MMA sample **18.7%** (393 / 2,100). Another boxing sample: **20%** of 2,549, **25%** of the top 340. Left-handers also win more often (a random lefty out-rates a random righty **54%** of the time). That is *stance rarity*, not a switch-skill bonus.

---

### 3. Mid-round vs between rounds

**Lasting tactic → fight plan / between rounds.**
**One-off weapon → tick engine, and only if skill ≥ 1.**

Most switches that *change the rest of the fight* start a round or follow a reset (Brook round 3; Hagler off the clinch break). Mid-exchange switching is what level-3 people *are*. If you put that in the tick engine for everyone, you have rebuilt Sandhagen's 14-count as a rate, which you already ruled out.

Practical split:
- Plan layer: preferred lead vs this opponent; "if open-stance rear straight is landing, flip at next reset."
- Tick layer (gated): step-through on a committed strike, switch-kick, exit hop. No background timer.

Judgement: **~2/3 of meaningful switches are reset/round; ~1/3 are in-exchange — and almost all of that third is the stylists.** Not measured.

---

### 4. Animation

**v1 essential**
1. **Step-through** (rear foot walks forward, closes distance). This *is* the shift. It is the offensive switch.
2. **Kick-landing switch** (rear kick / switch-kick leaves the kicking foot as the new lead). You already care which body kick is free. Without this clip the MMA side of the tactic is a lie.

**Polish**
- In-place hop/shuffle (looks like switching; worst defensively).
- Punch-combo walk-through (Crawford 1-2 then new-lead power).
- Turn-shift / pivot off an escape.
- Clinch-break or ref-break stance change.

Do not ship hop-in-place as the only clip. Coaches treat a naked hop in the pocket as the mistake.

---

### 5. Counter-play — model a little, or the button is free

Yes, model the **window**, not a second AI personality.

Sourced punishments:
- Mid-switch = clip window. Regular switchers *do* get caught; Slack lists Dillashaw/Dodson, Cruz/Faber, Hamed as the tax.
- Chasing the new outside foot with no punch = check hook / level change.
- MMA: wrestlers shoot the squared step. (Coaching comment, not a study.)

Sim version that stays small: while feet are exchanging, the switcher is easier to hit and easier to change level on. After the new lead is set, the existing closed/open numbers apply and the opponent gets a short **read delay** before their long-hand / free-kick logic updates. High-IQ opponents (judgement: high fight IQ + southpaw experience) shrink that delay and widen the clip window. Low-IQ opponents keep fighting the old picture for a few exchanges — that *is* why the tactic works.

Do not have the opponent auto-switch with you. Mirror-switching is rare and turns the feature into noise.

---

### WHAT I COULD NOT FIND

- Any dataset of "switches per fight / per round" across a roster. Sandhagen's 14 is one counted round.
- Win-rate delta for *switch-hitters vs single-stance fighters*. Southpaw vs orthodox is measured; switching is not.
- How often corners explicitly order a stance change vs the fighter doing it and the corner nodding.
- How often a damaged lead leg or hand forces the change.
- A measured defence/speed penalty for an unskilled switch.
- A clean female-only switching study (Joanna is an example, not a rate).

---

### Attack the model

**Strongest case it is wrong:** you already simulate the only legal effects (long hand, free body kick). A mid-fight switch is just "flip those two flags." Adding triggers, a skill ladder, clip windows, and three animations is a lot of surface for a change most fighters never make. Jeffries' default is *don't switch*. Slack's tax is *you will get clipped*. Diesel Gym's warning is *you will own two bad stances*.

**Strongest case to leave it out for now:** the operator already defined the good version — preparation vs this opponent. That is "start (or restart) the fight in the other lead." You can ship that with **zero tick-engine switching** and one stance-choice in the fight plan. Mid-round clips and switch-kicks are how highlight reels work; they are also how you accidentally install a frequency. Sandhagen's round is the trap: once those clips exist, every player will want that rhythm, and you will be forced to score it.

If you add anything, add **plan-layer lead choice + one authored step-through at a reset**, gated on a tree node. Leave hop-in-place and mid-combo switching until the 3D actually needs them.
