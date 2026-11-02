# Q24 — MUAY THAI ADAPTER: WHAT THE CLINCH SCORES, AND WHAT THE ADAPTER MUST REFUSE

**Task:** Q24. Research only. Owner: Qwen. Base: master after 9cf17de.
**Sources:** G39_THE_CLINCH.md §2 (IFMA/WMC/ABC-MT/stadium), §5, §6, §7.2;
G37_THE_ADAPTER_FOLD.md §0 (table shape), §4 (refusal format); engine anchors
as cited below. No `.gd` edits. No test run.

---

## 1. Verdict table

One row per engine emission. Columns: `Emit | Converts to | Article | Notes`.
The emission list is fixed by `GrappleAdapter._norm`
(`Godot/scripts/GrappleAdapter.gd:60`) and `_fold_grapple_ruleset`
(`Godot/scripts/RealtimeRoundStats.gd:159`).

| Emit | Converts to | Article | Notes |
|---|---|---|---|
| `clinch_engage` | `not_scored` | NONE PUBLISHED | Engaging a clinch is not a scoring event in any MT book. IFMA 29.1 scores a *skill* that hits, not the grip. |
| `clinch_break` | `not_scored` | NONE PUBLISHED | No seconds for a break. IFMA 26.3 commands YAEK; WMC §9 commands YAK. Neither publishes a duration (G39 §2.3). "5 seconds" is WFMC Oct 2024, not IFMA/WMC — G37 precedent refuses it. |
| `control` (units/s) | `not_scored` | NONE PUBLISHED | No point for clinch control duration. IFMA 29.1 scores skills, not hold time. The profile's `control: 0.8` weight (`Godot/assets/data/combat_rulesets.json:155`) is a judge factor, not an automatic tariff. |
| `takedown` | `not_scored` | NONE PUBLISHED | MT has no takedown tariff. Off-balancing is part of a strike's visible effect (IFMA 29.1 "force and intent to cause effect"). The profile's `takedowns: 1.5` (`combat_rulesets.json:156`) is a judge factor, not a point. |
| `throw` (grade 2 or 4, any seat) | `not_scored` | IFMA 29.2.2; WMC 14.3.5 | Dump without a weapon is explicitly not awarded points. A legal kick-sweep scores as the *strike* (the skill), not as a throw event. See §2 below for the foul question. |
| `position_change` | `not_scored` | NONE PUBLISHED | Ground position is not a scoring fact in MT. The books score skills that hit, not seats held. |
| `exposure` | `not_scored` | NONE PUBLISHED | UWW concept (turns / danger). No MT equivalent. |
| `submission_attempt` | `not_scored` | NONE PUBLISHED | MT has no submission scoring. The fold at `RealtimeRoundStats.gd:178` always increments `submission_attempts_round` as a fact counter regardless of adapter award — this remains correct. |
| `step_out` | `REFUSE` | G37 §4 | 1-D engine cannot produce an honest boundary fact. Same structural refuse as every other ruleset driven by this engine. Do not ship MT boundary points until the world is 2-D. |

**Cells that are `not_scored` and cells that are `REFUSE` are different.**
`not_scored` means the book was read and publishes no number for this event.
`REFUSE` means the book *does* publish a number (or a penalty) but the engine
cannot derive the fact the book asks for. `step_out` is REFUSE because MT
stadium rules and IFMA both have boundary concepts, but the engine's scalar
separation cannot serve them.

---

## 2. The foul question, answered explicitly

### What the engine emits

`GrappleAdapter._norm` (`Godot/scripts/GrappleAdapter.gd:60`) reads:

```
kind, seat, from_seat, grade, hold_seconds, finished, band, danger,
grand_amplitude, is_reversal, is_sweep, back_on_tatami
```

There is **no `via` value that says "hip throw"**. The `via` key exists in the
raw engine record (`GrappleAdapter.gd:72`) and is consumed only to detect
sweeps (`via == "sweep"` → `is_sweep`). It carries no technique class. A
`throw` event from the clinch arrives at the adapter as `grade: 2|4` plus a
landing seat. That is all.

### Can we tell a legal MT sweep from an illegal hip throw?

**No.** G39 §6 item 12 names this refusal: "Whether the throw used a hip /
lift / reap (MT foul test) — no technique-class fact beyond `throw`." The
engine's clinch throw path (`FightRealtime.gd:1596`, `_grapple_clinch`)
resolves through `takedown_resolve` with clinch weights and produces a grade
and a landing seat. The technique that produced it is not carried.

What would be needed: a `technique_class` field on the throw event
distinguishing at minimum {kick_sweep, body_lock_dump, hip_throw,
judo_wrestling_toss}. The engine does not emit this today.

### The honest fold: `not_scored` for all throws

**Pick: `not_scored`.** Argued from the books:

1. **The base case is not_scored, not foul.** IFMA 29.2.2 and WMC 14.3.5
   both say a dump without a weapon is *not awarded points*. That is the
   default for any throw from the clinch that is not a foul. The foul is the
   exception, not the rule.

2. **A wrong foul is worse than a wrong not_scored.** A wrong foul deducts a
   point that never happened — it actively corrupts the scorecard. A wrong
   `not_scored` lets a foul pass unpenalised — the scorecard is incomplete but
   not false. G37 §4's precedent is explicit: "a plausible-looking wrong
   number is worse than an absent one."

3. **The majority of engine throws from a clinch are dumps, not hip throws.**
   The engine's clinch throw path is a generic resolution — it does not
   preferentially produce hip throws. In real MT, the clinch produces
   off-balancing dumps and kick-sweeps far more often than judo/wrestling
   throws. Marking all throws as foul would penalise the common case to catch
   the rare one.

4. **A legal kick-sweep scores as the strike, not the throw.** ABC Pro MT
   foul J makes a kick-sweep legal (top of foot / front of shin). When it
   lands with effect, the *skill* (the kick) scores under IFMA 29.1. The
   throw event is the aftermath, not the score. `not_scored` on the throw
   does not lose the score — the striking bus already carried it.

**The error this makes cheaper:** an unpenalised hip throw (the referee
should have called a foul but the adapter did not). This is a missing
penalty, not a fabricated one. The operator can add a foul layer later when
the engine carries technique class; the adapter cannot invent it now.

---

## 3. The three federations, where they disagree

### IFMA vs WMC vs ABC-MT

| Fact | IFMA v3.057 (May 2026) | WMC Rules | ABC Pro MT (Jul 2024) |
|---|---|---|---|
| Dump without weapon | 29.2.2: not awarded | 14.3.5: not awarded | Implicit from foul structure |
| Hip / lift / judo throw | 31.2.9 body lifting; 31.1.4 semi: hip throw, tackling body/legs | 15.2: "Throwing…using Judo and wrestling techniques" | K: no hip tosses, grape vining, reaping, lifting; N: no wrestling/judo holds |
| Hook legs with calf/ankle | 31.2.8: foul | Covered by 15.2 / 15.11 | J: sweep legal only as kick with top of foot/shin |
| Hold caught leg, walk | 31.2.19: >2 steps without skill = foul | 15.7: >2 steps without weapons | Same two-step cap |
| Clinch break seconds | 26.3: YAEK command, no seconds | §9: YAK command, no seconds | No seconds published |

**They agree on every cell that matters for the adapter.** The article numbers
differ; the verdicts do not. Dump = `not_scored`. Hip throw = `foul`. Break =
no clock. One adapter key serves all three.

### Stadium custom

G39 §2.4: Thai stadium judging (Rajadamnern / Lumpinee) historically weights
late-round clinch knees, off-balance, and dumps that "look like Muay Thai"
more than IFMA's skill-counter. That is culture and commentary, not a
published article with a number. **Stadium custom cannot be an adapter key**
because there is no English-language numbered rulebook to bind it to. The
adapter stays on IFMA/WMC/ABC-MT text.

### Adapter key count

**One key: `mt`.** It serves IFMA amateur/Olympic, WMC professional, and ABC
Pro MT because the three books produce the same verdict for every engine
emission. The `ADAPTER_FOR` map would carry:

```
"muay_thai": "mt",
```

The three competition_rulesets_v2.json ids (`muay_thai_ifma_combat`,
`muay_thai_ifma_technical`, `muay_thai_wmc_professional`) all resolve to the
same discipline id `muay_thai` in combat_rulesets.json, so one key is
sufficient.

---

## 4. Ready-to-paste block

GDScript `const` block in G39 §9's style. Every cell from §1. A later task
types this straight into `GrappleAdapter.gd` without a decision left in it.

```gdscript
# Q24 — Muay Thai adapter fold. not_scored = book publishes no number.
# REFUSE = engine cannot derive the fact the book asks for.
# foul = book penalises it; the engine cannot detect it (see §2).
# All sources: IFMA Rules & Regulations v3.057 (11 May 2026),
# WMC Rules §14–15, ABC Unified Rules of Professional Muay Thai (Jul 2024).

const MT_CLINCH := {
	"clinch_engage":    "not_scored",     # NONE PUBLISHED — grip is not a skill
	"control_units":    "not_scored",     # NONE PUBLISHED — hold time is not a score
	"clinch_break":     "not_scored",     # NONE PUBLISHED — YAEK has no seconds
	"takedown":         "not_scored",     # NONE PUBLISHED — no MT takedown tariff
	"throw":            "not_scored",     # IFMA 29.2.2; WMC 14.3.5 — dump without weapon
	"throw_hip_throw":  "foul",           # IFMA 31.2.8-10; WMC 15.2; ABC-MT K/N — REFUSE: engine cannot detect
	"position_change":  "not_scored",     # NONE PUBLISHED — ground position not a MT score
	"exposure":         "not_scored",     # NONE PUBLISHED — UWW concept, no MT equivalent
	"submission_attempt": "not_scored",   # NONE PUBLISHED — MT has no submission scoring
	"step_out":         "REFUSE",         # G37 §4 — 1-D engine, same structural refuse
	"use_grade_for_score": false,         # grade 2/4 is engine arithmetic, not a MT tariff
}
```

**Inventions labelled:**

- `throw_hip_throw: "foul"` — the book publishes this foul, but the engine
  cannot detect it. The adapter never emits it from a real bout. It is in the
  block so a later task that adds technique class knows the cell is ready.
- `use_grade_for_score: false` — explicit refusal to convert engine grade into
  MT points. The grade is takedown-arithmetic, not a MT tariff.

---

## 5. What this changes in our engine, with anchors

### The `ADAPTER_FOR` entry

`Godot/scripts/RealtimeRoundStats.gd:29` — add one line:

```gdscript
const ADAPTER_FOR := {
	"judo": "ijf",
	"freestyle_wrestling": "uww",
	"greco_roman": "uww",
	"bjj": "ibjjf",
	"mma": "abc",
	"muay_thai": "mt",         # Q24
}
```

### `GrappleAdapter.scores_grappling`

`Godot/scripts/GrappleAdapter.gd:103`:

```gdscript
static func scores_grappling(ruleset: String) -> bool:
	return ruleset == "ijf" or ruleset == "uww" or ruleset == "ibjjf"
```

This function asks "does this adapter key score grappling in **points**?" It
returns false for `"abc"` (MMA — evidence only). For `"mt"` the answer is the
same: MT does not score grappling in points. **No change needed.** The
function correctly returns false for any key not in the list. A build task
that adds `"mt"` to the adapter does not need to add it here.

### `FightRealtime._scores_grappling`

`Godot/scripts/FightRealtime.gd:1434`:

```gdscript
static func _scores_grappling(profile: Dictionary) -> bool:
	var weights: Dictionary = profile.get("weights", {})
	for key in ["takedowns", "throws", "positions", "submissions"]:
		if float(weights.get(key, 0.0)) > 0.0:
			return true
	return false
```

The muay_thai scoring profile (`combat_rulesets.json:152-159`) has:

```json
"takedowns": 1.5,
"throws": 0.0,
"positions": 0.0,
"submissions": 0.0
```

`takedowns: 1.5 > 0.0` → **returns true**. **No change needed.** The function
correctly says "this bout grapples" because the profile tells the judges to
consider takedowns as a factor.

### Does a muay thai bout in this engine grapple at all today?

**Yes.** `_scores_grappling` returns true (takedowns weight 1.5). The state's
`grappling` flag is set true at `FightRealtime.gd:389`. The clinch engages,
throws are resolved at `FightRealtime.gd:1596`, and grapple events are written
to the log.

**But the fold is wrong.** `ADAPTER_FOR` has no `"muay_thai"` entry
(`RealtimeRoundStats.gd:29`), so `fold()` at line 93 falls to `_fold_grapple`
(line 135) — the engine's own units. Under muay thai today:

- A throw adds `grade` (2 or 4) to `throw_points_round` and 1 to
  `takedowns_round`
- Control seconds convert to `control_score` at 80 units per point
- Position changes add `points` to `position_points_round`

These are **plausible numbers that are wrong.** G39 says the book scores none
of this, and the throw itself may be a foul. This is the exact failure R85
named for taekwondo, one file over.

### Tests that would move

`grep -rln 'muay_thai' Godot/tests/` returns these files. The ones relevant
to a grapple adapter build:

- `Godot/tests/judge_panel_test.gd` — has a `muay_thai_17` fixture (line 69,
  336, 387, 450). Tests the judge panel with muay_thai ruleset. A build task
  adding the adapter would need to verify the panel still reads correct
  (zeroed) grappling counters for muay_thai.
- `Godot/tests/fight_plans_test.gd` — references `muay_thai_khao` and
  `muay_thai_mat` plans (lines 67, 165). The Muay Khao plan is labelled
  "grappling" emphasis (line 209 of `signature_battle_test.gd`). A build task
  should verify the plan's grappling emphasis still reads correctly when the
  adapter zeroes the counters.

No current test specifically asserts on muay_thai grapple fold values. A
build task would need to **add** assertions, not move existing ones.

---

## 6. Open questions (three, each with a default)

**Q1. Evidence counts (like ABC) instead of pure `not_scored`?** The muay_thai
profile weights `takedowns: 1.5` and `control: 0.8` for the judges. If the
adapter folds everything to zero, those weights are never exercised. An
alternative is to fold as `evidence` (like ABC at `GrappleAdapter.gd:327`):
counts for the judges, never automatic points. **Default: `not_scored` for
now.** The ABC evidence model was a deliberate choice for MMA (G37 §1.D);
extending it to MT is a product decision the operator should make explicitly,
not by accident. A later task can flip the cells to `evidence` with the
operator's say-so.

**Q2. Stall clock for the MT clinch.** G39 §2.3 and Q2 both say: no published
seconds in IFMA or WMC for a clinch break. The engine's stall clock
(`FightRealtime.gd:1596`, `STALL_FIRE_TICKS`) fires regardless of ruleset.
Should the MT adapter map stall to a consequence (referee break, warning) or
leave it as an engine-internal event? **Default: no consequence.** The stall
event fires and the log records it; the adapter does not convert it to a
score or penalty. Matches G39 Q2's "no tick trigger" for the MT-facing path.

**Q3. Technique class for the foul layer.** The engine's throw event carries
no technique class, so the adapter cannot detect a hip throw (foul). Should a
later task add a `technique_class` field to the throw event, and if so, who
owns it — `FightRealtime._grapple_clinch` or `takedown_resolve`? **Default:
defer.** This is a module design question, not an adapter question. The
adapter block in §4 already has the `throw_hip_throw: "foul"` cell ready; a
later task fills it when the engine carries the fact.

---

*End Q24.*
