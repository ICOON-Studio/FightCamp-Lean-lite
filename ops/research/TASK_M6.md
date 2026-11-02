# TASK M6 — THE HOLD: A BODY THAT CANNOT BE BOOKED (Maria)

**Status: COMPLETE 2026-09-06** (delivered by Maria, landed by Claude). Assigned 2026-09-06. Art direction only. No `.gd`, no
`.tscn`, no `HANDOFF.md`, no `Godot/assets/data/` edits, no runtime bitmaps.
Claude writes your HANDOFF block and marks the task done, as with M4/M5.

Model: top tier, effort medium, Fast off. Same setting M5 shipped on.

## Why this exists

M4 and M5 dressed the night a fight ends. This dresses the eight weeks after.

The engine already knows a fighter can be too hurt to compete, and it says so
in six places, and **not one of them looks like anything.** After a stoppage,
`BodyReadiness` stamps `medical_hold_until_week` on the athlete;
`evaluate_competition_clearance()` then refuses every booking with a typed
reason and a `weeks_remaining` count; `ManagementOverview` and
`ProfileRevampPanel` print it. J3 ruled the medical layer the **number one**
thing to build next — and the honest finding on landing it was that most of the
state is already there. What is missing is that a hold currently reads as a
grey error string in a list, when it is the most consequential thing that
happens to a fighter between bouts.

You are dressing a **state a body is in**, not an error. That distinction is
the whole brief.

## What is engine-true today (design against this, invent nothing)

Read the anchors; every number below is live.

**Six regions**, `body_readiness_rules.json`:
`head_neck`, `torso_core`, `left_arm`, `right_arm`, `left_leg`, `right_leg`.

**Three bands**, `BodyReadiness.readiness_band()`:
green `>= 80`, amber `>= 60`, red below.

**Two different clearances, and they disagree on purpose:**

| Gate | Rule |
|------|------|
| `evaluate_training_clearance()` | Every region green (`>= 80`). All-or-nothing. Rest and recovery stay available while it is blocked. |
| `evaluate_competition_clearance()` | Stricter and **per region**: `head_neck` 90, `torso_core` 85, the four limbs 80. Plus fatigue `<= 85`. Plus the hold. |

A fighter can therefore be **cleared to train and refused a fight**, or cleared
for neither. That gap is a design object, not an edge case — it is what a
recovering fighter's week actually looks like.

**Five typed refusals** the screens receive, each carrying its own numbers:

- `region_below_competition_threshold` — `{region, value, required}`
- `region_below_training_threshold` — `{region, value, required}`
- `medical_hold_active` — `{until_week, weeks_remaining, reason}`
- `athlete_injured` — status flag, no numbers
- `fatigue_above_competition_limit` — `{value, required_max}`

**The hold is a time gate that region recovery cannot waive** — the code says
so in a comment. Resting to green does not shorten it.

**Where the hold comes from:** `fight_profiles` in the rules JSON carry
`medical_hold_weeks` — 1 after a decision, 4 after a stoppage. Design the
surface around **"until week N / N weeks remaining"**, which is what the state
actually holds. Do not draw a calendar of medical dates, do not invent a
"cleared by" examination step, and do not put a doctor's name anywhere: J3's
D6 ruled the real-world lift is a **clearance**, not a day count, and the fact
that the code currently uses a week count is a known open call, not something
art should harden into a picture.

**A forecast exists**: `BodyReadiness.forecast_weeks_to_training()` returns
weeks-to-training under a chosen activity. That is a real number you may dress.
There is no forecast to *competition*. Do not draw one.

## What to design

1. **The hold badge, three severities in one family.** Held (a live
   `medical_hold_active`), Not cleared (regions/fatigue below the competition
   bar but no hold), and Cleared. One shape, read at a glance in a roster row
   at small size. This is the primary deliverable.
2. **The six-region body read.** M1's Cage Desk language applied to a body:
   six regions, three bands, the two different thresholds visible at once —
   because "green for training, red for the cage" is the state most fighters
   in a gym are actually in. Show a `head_neck` at 84: green to train, under
   the 90 the cage wants. That single case is the board that proves the design.
3. **The refusal, said properly.** The booking screen's "you cannot book this
   fighter" moment: which of the five reasons fired, with its numbers, and in
   what order they read when several fire at once. A stacked refusal (hold +
   two red regions + fatigue) must not become a wall of grey text.
4. **The roster at a glance.** A gym of ten athletes where three are held, two
   are training-clear only, and five are ready. The board has to answer "who
   can I book this week" without opening a profile.
5. **The week the hold lifts.** The countdown, and the moment it reaches zero.
   This is the one place warmth is earned in the whole pack — a fighter coming
   back available is good news and should look like it. Not gold (M5 spends
   gold ×1 on the verdict word); pick the token and defend it.
6. **Honest empties and unknowns.** A fighter with no fight history and a full
   green body. A legacy save whose `medical_hold_reason` is `""` — the hold is
   real and the reason is missing, and that must not render as an error.
7. **What this is NOT allowed to become.** Explicitly show the anti-pattern you
   rejected: a medical chart, a hospital screen, an injury with a diagnosis. The
   game has regions and numbers, not diagnoses. If a board would need a
   diagnosis to work, it is the wrong board.

## Continuity rules

- **Extends M1/M2 Cage Desk tokens and M4/M5 chrome.** Same panel, line, text,
  muted and dim roles. If the existing token map cannot carry a body read, say
  so in the spec and show the extension — as M5 did for the judge columns.
- **`BAD` is for the doctor, per M5.** A medical hold is the one place M5's
  doctor-stop red has a natural second home; decide whether it takes it or
  whether a hold is amber, and write the reason down. Do not use both.
- **Gold ×1 is spent elsewhere.** Nothing in this pack takes gold.
- **`GO` green is CONTINUE only** (M5). Cleared-to-fight is not a CONTINUE
  button and must not borrow its green without saying why.
- No judge, no fight-night, no scorecard surface. This is the gym, between
  bouts.

## What this must NOT do

- No `.gd` / `.tscn` / `HANDOFF.md` / `Godot/assets/data/` edits.
- No invented body regions, bands, thresholds, hold lengths or recovery rates.
- No diagnoses, no injury names, no anatomy illustration, no medical iconography
  that implies a specific condition.
- No doctor as a character, no named practitioner, no real person's name.
- No new mechanic proposals dressed as boards. If the design wants a state the
  engine does not have, label it **DESIGNED AHEAD** exactly as M5 labelled its
  designed-ahead stamps.

## Deliverables

```
research/M6_THE_HOLD.md                       (spec, incl. token map)
DesignLibrary/screens/medical/m6_*.png              (boards, 1920x1080)
_maria_delivery/M6_THE_HOLD.zip                     (staging)
_maria_delivery/CLAUDE_LAND_NOTE_M6.md
research/CLAUDE_LAND_NOTE_M6.md
```

`DesignLibrary/screens/medical/` is a new folder — create it. Send
`ART READY M6` to `claude` in the mailbox when the files are pushed.

## Anchors (read these; every number in this brief comes from them)

- `Godot/scripts/BodyReadiness.gd:34-43` — `medical_hold_until_week`,
  `medical_hold_reason` and their migration.
- `Godot/scripts/BodyReadiness.gd:70-77` — `readiness_band()`, the three bands.
- `Godot/scripts/BodyReadiness.gd:99-117` — training clearance, all-or-nothing.
- `Godot/scripts/BodyReadiness.gd:118-145` — competition clearance, the five
  typed refusals, the per-region table, the fatigue cap.
- `Godot/scripts/BodyReadiness.gd:316` — `forecast_weeks_to_training()`.
- `Godot/assets/data/body_readiness_rules.json` — regions, thresholds,
  `fight_profiles.*.medical_hold_weeks`.
- `Godot/scripts/ManagementOverview.gd:60,374,440` — how the roster reads it now.
- `Godot/scripts/ProfileRevampPanel.gd:378,614,910,1393,1462` — how the profile
  reads it now. `:614` is the line that collapses hold and `status == "injured"`
  into one boolean; your badge family is what lets those separate.
- `research/M5_SCORECARD_THREE_JUDGES.md` — the token map and the gold /
  `GO` / `BAD` rules you are continuing.
- `research/J3_THE_DECISION_QUEUE.md` D6 and the priority ruling — why
  the lift is a clearance and not a day count.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/M6_THE_HOLD.md
```
