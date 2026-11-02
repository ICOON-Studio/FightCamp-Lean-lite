# TASK U59 — CURSOR — WHAT THE ENGINE WROTE DOWN AND NEVER READ

Model: Composer, **medium effort**. Owner: cursor.
Test tier: **RESEARCH. ONE REPORT, and at most ONE THROWAWAY MEASUREMENT SCRIPT.
NO SHIPPED `.gd` IS EDITED. NO TEST IS TOUCHED. NO PARSE GATE, NO TEST RUN, NO
GODOT AT ALL** — if you do not write a `.gd`, there is nothing to gate.

## Owned files

- `research/U59_THE_UNREAD_EFFECTS.md` — **NEW. Yours alone.**
- `Godot/tools/audit_technique_effects.py` — **OPTIONAL, NEW, yours alone.** A
  plain Python script, not GDScript, because this is a data question and Godot
  is not needed to answer it. Write it only if it helps you; the report is the
  deliverable.

Nothing else. **Do NOT edit `technique_catalog.json`, `FightSimulation.gd`,
`GrappleResolve.gd`, `FightMoves.gd`, any script under `Godot/scripts/`, any
test, or `HANDOFF.md`.** `GameState.gd` is 12,938 lines — you do not need it,
never open it.

**THIS TASK PROPOSES. IT DOES NOT IMPLEMENT.** A run that edits a shipped script
has failed even if the change is right.

## Why this exists

The operator pushed back on a takedown being decided by wrestling alone. Their
words: *"dont we have counters? like knees or dodge... how good is the execution
of the takedown, is it one leg double leg, how strong is the fighter attempting
the takedown and how good balance and strength the defender has to defend or
avoid it or counter it."*

Checking that produced a much larger finding. **Measured across
`Godot/assets/data/technique_catalog.json` and every `.gd` in `Godot/scripts/`:**

```
140 distinct effect keys across 554 authored entries
 85 keys /  370 entries  are named somewhere in code
 55 keys /  184 entries  are named NOWHERE
```

**A third of the effect data in the catalogue is referred to by no code.** Not
inert — two GENERIC consumers exist — but none of the 55 is modelled as the
thing it says it is:

- `FightSimulation._technique_magnitude` (`FightSimulation.gd:2639`) sums the
  **absolute value of every effect**, so all 554 feed a technique's total
  magnitude.
- A region function around `FightSimulation.gd:2144-2156` buckets effects by
  **SUBSTRING** — anything containing `head`, `leg`, `body`, `liver` or `torso`.

**And the unread third is coherent rather than random. It is the counter and
rhythm layer of the game**, authored in full and implemented nowhere:

| effect | techniques | | effect | techniques |
|---|---:|---|---|---:|
| `balance_break` | 16 | | `feint` | 7 |
| `combo_speed` | 14 | | `surprise` | 7 |
| `counter_damage` | 12 | | `cut_chance` | 6 |
| `score_or_damage` | 11 | | `opponent_stamina` | 6 (−10..−5) |
| `finish_chance` | 10 | | `pushback` | 6 |
| **`stop_hit`** | **10** | | `counter_accuracy` / `combo_accuracy` | 5 / 5 |
| `rhythm_control` | 4 | | `tempo` / `precision` / `counter_chain` | 3 / 3 / 3 |
| `intercept` | 2 | | `kick_counter` | 2 |
| `counter_timing` | 1 | | `reaction_punish` | 1 |

Plus a long tail of 1- and 2-technique keys. **Balance appears three separate
ways and all three are unread**: `balance_break` (16), a bare `balance` (1),
`kick_balance` (1).

**`stop_hit` on ten techniques IS the operator's knee-on-the-shot.** It is
written down. Nothing reads it.

## THE JOB — THREE QUESTIONS, IN THIS ORDER

### 1. TRIAGE THE 55. Which are intended mechanics, which are authoring noise?

Reproduce the count first — **do not take the numbers above on trust, they are
this session's and a number quoted in a task file is not a measurement.** Two
task files carried a wrong clip count forward last week and a whole audit was
nearly run against a quarter of a pack.

Then sort every unread key into exactly one of:

- **MECHANIC** — it names a real fight behaviour, it is authored across enough
  techniques to matter, and wiring it would change how fights play.
  `finish_chance` (10) and `cut_chance` (6) read this way.
- **DUPLICATE** — it means the same thing as an effect that IS read, under a
  different name, and the honest fix is to rename the data rather than write
  code. Check each against the 85 that ARE named before calling anything new.
- **NOISE** — a one-off that accumulated as the catalogue grew and carries no
  design intent. `angle_reset` on one technique reads this way.

**Give the count in each bucket and the reasoning per key in one line.** A table
of 55 rows with a one-line verdict each is the right shape. Where you cannot
tell, say **NOT FOUND** rather than guessing — that is a perfectly good verdict
and we want it explicitly.

### 2. THE SUSPECTED DEFECT. Confirm or refute it.

The substring bucketer matches `head` / `leg` / `body` / `liver` / `torso`
anywhere in an effect's NAME. So:

- **`head_route`** (4 techniques) is counted as head-directed
- **`body_score`** (1 technique) is counted as body damage

A route to the head is not damage to the head, and a score is not damage.
**Read `FightSimulation.gd:2144-2156` and say whether these are being
mis-bucketed, and what else in the 140 trips the same rule.** Grep the full key
list for those five substrings and report every hit, not just these two. If the
bucketing is intended, say so — the comment may settle it.

### 3. THE TWO DESIGN QUESTIONS. Rank options, do not pick a winner.

**(a) BALANCE: an eighth ATTRIBUTE, or a per-tick STATE?**
The canonical attribute list is `STAT_KEYS` —
`power, technique, speed, defense, conditioning, fight_iq, grapple` — identical
in four files (`GameState.gd:182`, `Aging.gd:67`, `AthleteDevelopment.gd:34`,
`DevelopmentPanel.gd:28`). Balance is not among them.

- As an **ATTRIBUTE**, some fighters are permanently harder to take down and to
  sweep. It is a save-format change and it touches development, ageing and every
  screen that lists stats — **price that reach, it is the expensive half.**
- As a **STATE**, a man who has just been teeped is briefly easier to shoot on.
  Nothing persists between fights. **`balance_break: 14` on a throw against
  `balance_break: 5` on a teep reads as though it was authored for exactly
  this** — say whether the spread of values supports that reading.

Say what each costs, what each buys, and **what it would take to ship the
cheaper one first without blocking the other.**

**(b) THE COUNTER LAYER: can a shot be met with a strike?**
Today it cannot. `GrappleResolve.takedown_resolve` weights attacker
`grapple .45 / power .20 / speed .15 / technique .10 / fight_iq .10` standing
against defender `grapple .40 / defense .30 / speed .15 / fight_iq .15`, both
fatigued — pure grappling on both sides. A stuffed shot (`takedown_attempt`,
callout "TAKEDOWN STUFFED") costs the sprawler stamina and nothing else.

**Where would `stop_hit` / `intercept` / `counter_damage` enter?** Read
`FightRealtime.gd` around **`:2070-2095`** — that window is the whole takedown
branch and is short. **Do not read that file whole; it is large.** Say:

- at which point in that branch a defender's counter would be resolved
- what it would read off the technique the defender holds
- what happens on a success — does the takedown simply fail, or does the
  defender land a blow that goes through the normal impact path and can itself
  shock or knock down?
- **and the safety rule it must not break: a seeded fight's verdict, scorecards
  and stoppage must stay byte-identical unless the operator rules otherwise.**
  Adding a counter CHANGES FIGHT OUTCOMES — that is the point of it — so say
  plainly that it is a behaviour change and cannot be shipped as a silent one.

## The report

`research/U59_THE_UNREAD_EFFECTS.md`. Lead with the three counts
(MECHANIC / DUPLICATE / NOISE), then the defect verdict, then the two design
questions with options ranked and priced.

**LABEL EVERY CLAIM**: `MEASURED` for anything your script printed, `INFERENCE`
for anything you concluded, `NOT FOUND` for anything you could not determine.

**DO NOT PICK A WINNER on the two design questions.** Rank them and say what each
costs. U57 did this correctly for the grapple cadence and it is why that report
is usable — the operator makes the ruling from your table. A report that
recommends one option and does not price the others is the failure mode here.

## Done means

- `research/U59_THE_UNREAD_EFFECTS.md` written, counts first.
- The 55-row triage table present, with a verdict per key.
- `git status -s` FIRST (another agent's WIP may be pre-staged), then
  `git add --` your explicit path(s) only. Never `audio_exports/`.
- Commit ending `Co-Authored-By: Cursor <noreply@cursor.com>`, then push.
  **PUSH TO master IF YOU CAN; if you end up on a branch, name it in your final
  message** — you left HEAD on `cursor/u57-grapple-promotion` last time and
  `git push origin master` then reports "Everything up-to-date" while nothing
  lands.
- One line of mail:
  `python Tools/agent_comms.py send --from cursor --to claude --subject U59-done --body "<hash> keys=<n> unread=<n> mechanic=<n> duplicate=<n> noise=<n> bucketer_defect=<confirmed|refuted>"`
- Do NOT edit `HANDOFF.md` — Claude writes your block.

## The one trap for this task

**AN EFFECT THAT NO CODE NAMES IS NOT THEREBY DEAD, AND SAYING SO WOULD BE THE
FAILURE.** Every one of the 554 still feeds `_technique_magnitude`, so removing
one would change how big a technique is and could move a seeded fight. **Your
triage is about DESIGN INTENT, not about safety to delete** — and nothing in this
task authorises deleting anything from the catalogue. If a key is NOISE, say it
is noise and say what it would cost to remove it; do not remove it.
