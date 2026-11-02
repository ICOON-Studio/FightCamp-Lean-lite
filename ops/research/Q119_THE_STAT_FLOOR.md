# Q119 — The Stat Floor

**Agent:** Qwen · **Date:** 2026-09-21 · **Status:** complete

---

## Part 1 — Result

`grapple` now gets its own independent base + spread at generation, identical in
shape to every other stat. It is no longer the mean of the other six.

| Metric | Before (Q117) | After (Q119) |
|--------|---------------|--------------|
| Correlation with mean-of-six | 1.0000 | **0.3525** |
| No-weakness count (all ≥ 60) | 2 of 252 | 2 of 252 (unchanged) |
| Ceiling count (>2 stats > 90) | 0 of 252 | 0 of 252 (unchanged) |

The correlation of 0.3525 is defensible: a fighter's grappling IS partially
correlated with his overall talent in real life (better athletes tend to be
better at everything), but it is no longer deterministic. Under 0.6 is the
gate; 0.35 is in the right neighborhood — correlated but not enslaved.

**No engine code assumed grapple was bounded relative to the other stats.**
Every read of `grapple` in the engine (`FightRealtime.gd:3843`, `FightRealtime.gd:3844`,
`FightSimulation.gd:2651`, `GrappleResolve.gd` weighted sums) treats it as an
independent value in a weighted sum or linear scaling. No code computes
`grapple - mean(others)` or asserts `grapple ≈ average`. The change is safe.

---

## Part 2 — The Nine Grapple Ids, Traced

### 1. takedown

**Resolved by:** `GrappleResolve.takedown_resolve` (`GrappleResolve.gd:76`)

**Engine reads:**
- Attacker: `grapple` (0.45 standing / 0.55 clinch), `power` (0.20/0.10),
  `speed` (0.15), `technique` (0.10), `fight_iq` (0.10)
- Defender: `grapple` (0.40), `defense` (0.30), `speed` (0.15), `fight_iq` (0.15)
- Also: `kuzushi` (balance broken-ness), fatigue on both sides

**What would have to differ:** The attacker's grapple, power, speed, technique,
fight_iq AND the defender's grapple, defense, speed, fight_iq. Plus fatigue and
balance state.

**Offensive or defensive?** BOTH. The same `grapple` number weights the
attacker's offense (0.45/0.55) AND the defender's resistance (0.40). A good
grappler is automatically good at stopping takedowns — which is **false in the
sport** (specialists exist on both sides) and **false in the engine** (the
weights are independent coefficients, not a symmetric relationship).

### 2. throw

**Resolved by:** Same as takedown — `GrappleResolve.takedown_resolve` (`GrappleResolve.gd:76`).
Throws are takedowns from clinch stance in the engine.

**Same reads, same stats, same offensive/defensive problem.**

### 3. sweep

**Resolved by:** `GrappleResolve.position_resolve` (`GrappleResolve.gd:98`)

**Engine reads:**
- Attacker: `STANDING_OFF_WEIGHTS` — `grapple` (0.45), `power` (0.20),
  `speed` (0.15), `technique` (0.10), `fight_iq` (0.10)
- Defender: `DEF_WEIGHTS` — `grapple` (0.40), `defense` (0.30), `speed` (0.15),
  `fight_iq` (0.15)

**What would have to differ:** Same six stats as takedown, plus fatigue.

**Offensive or defensive?** BOTH. Same problem: one `grapple` on each side does
both jobs.

### 4. submission_attempt

**Resolved by:** `GrappleResolve.submission_advance` (`GrappleResolve.gd:122`)

**Engine reads (via `_submission_tick_advance`, `GrappleResolve.gd:147`):**
- Attacker: `grapple` + `technique` + `fight_iq` (sum, not weighted)
- Defender: `defense` + `grapple` + `fight_iq` (sum, not weighted)
- Also: fatigue on defender

**What would have to differ:** Attacker's grapple, technique, fight_iq AND
defender's defense, grapple, fight_iq.

**Offensive or defensive?** BOTH. The defender's `grapple` contributes to
`def_sum`, making a good grappler better at resisting submissions — which is
partially true in the sport (a good grappler knows how to defend) but the
engine gives it equal weight to `defense`, which is the actual defensive stat.

### 5. submission_finish

**Resolved by:** `GrappleResolve.submission_advance` at progress ≥ 100
(`GrappleResolve.gd:127`)

**Engine reads:** `FINISH_P = 1.0 / 7.0` — a flat probability. **No stat read
at the finish moment itself.** The stats matter only for getting TO 100 (via
submission_tick_advance above).

**What would have to differ:** Nothing at the finish moment — it's a coin flip
weighted by `FINISH_P`. The path to 100 depends on the same stats as
submission_attempt.

**Offensive or defensive?** Neither at the finish. The path there is offensive.

### 6. escape

**Resolved by:** `FightSimulation._resolve_escape_attempt` (`FightSimulation.gd:2664`)

**Engine reads:**
- `execution_quality` (passed in, derived from `technique` stat + discipline
  proficiency — `FightSimulation.gd:1527`)
- `_top_control_norm` (`FightSimulation.gd:2651`) — reads opponent's `grapple`
  and discipline proficiency
- `escape_chance = 0.3 + execution_quality * 0.35 - top_control`

**What would have to differ:** Escaper's technique + proficiency. Opponent's
grapple + proficiency.

**Offensive or defensive?** OFFENSIVE. The escaper's technique drives the
escape. The opponent's grapple resists it. But the escaper's own grapple is NOT
read — only the opponent's.

### 7. control

**Resolved by:** `FightSimulation._top_control_norm` (`FightSimulation.gd:2651`)

**Engine reads:**
- Top fighter's `grapple` (normalized to 0-1)
- Top fighter's best grappling discipline proficiency
- Returns `(grapple_norm + best_mastery) * 0.5`

**What would have to differ:** The top fighter's grapple and his best grappling
discipline proficiency.

**Offensive or defensive?** OFFENSIVE. Control is what the top fighter does to
the bottom fighter. Only the top fighter's stats are read.

### 8. clinch_break

**Resolved by:** Same as takedown/throw but from clinch stance — uses
`CLINCH_OFF_WEIGHTS` (`GrappleResolve.gd:27`) and `DEF_WEIGHTS`.

**Engine reads:** Same as takedown but with clinch-specific weights:
- Attacker: `grapple` (0.55), `power` (0.10), `speed` (0.15), `technique` (0.10),
  `fight_iq` (0.10)
- Defender: `grapple` (0.40), `defense` (0.30), `speed` (0.15), `fight_iq` (0.15)

**What would have to differ:** Same six stats as takedown.

**Offensive or defensive?** BOTH. Same problem.

### 9. stand_up

**Resolved by:** Same as escape — `FightSimulation._resolve_escape_attempt`
(`FightSimulation.gd:2664`). A stand-up is an escape that returns to STANDING
phase.

**Same reads as escape.**

---

## The Minimum Stat Floor — Derived from the Code

Summing across the nine ids, the engine reads these distinct stats to resolve
grapple:

| Stat | Read by | Role |
|------|---------|------|
| `grapple` | takedown, throw, sweep, submission_attempt, control, clinch_break | Offense AND defense |
| `power` | takedown, throw (standing only) | Offense only |
| `speed` | takedown, throw, sweep, clinch_break | Offense AND defense |
| `technique` | submission_attempt, escape (via execution_quality) | Offense |
| `fight_iq` | takedown, throw, sweep, submission_attempt, clinch_break | Offense AND defense |
| `defense` | takedown, throw, sweep, submission_attempt, clinch_break | Defense only |

**The floor is SIX independent stats** to resolve all nine grapple ids: grapple,
power, speed, technique, fight_iq, defense. Conditioning is NOT read by any
grapple resolution (it affects fatigue, which affects all stats indirectly, but
is not a direct read).

But the current engine uses ONE `grapple` number for both offense and defense
in six of the nine ids. If we split offensive grappling from defensive
grappling, the floor becomes **SEVEN**: grapple_offense, grapple_defense,
power, speed, technique, fight_iq, defense.

---

## The Three-Way Cross-Check

| Our engine's needs | BJJ vocabulary (14) | Sport separately measures |
|--------------------|---------------------|---------------------------|
| `grapple` (offense) | Takedowns, Submissions, Sweeps, Passing, Top Pressure, Back Attacks, Leg Locks | Takedown accuracy (FightMetric) |
| `grapple` (defense) | Sub Defense, Guard, Scrambles | Takedown defense (FightMetric) |
| `power` | — (implicit in all) | — |
| `speed` | Scrambles, Flexibility | — |
| `technique` | Technique | — |
| `fight_iq` | Composure | — |
| `defense` | Sub Defense, Guard | — |
| `conditioning` | Heart | — |

**Where all three agree:**
- Takedowns (offensive grappling) — our `grapple` offense, BJJ Takedowns,
  FightMetric takedown accuracy
- Takedown defense (defensive grappling) — our `grapple` defense, BJJ Sub
  Defense/Guard, FightMetric takedown defense

**Where only BJJ has it (candidates):**
- Sweeps, Passing, Guard, Top Pressure, Scrambles, Submissions, Back Attacks,
  Leg Locks, Flexibility, Composure, Heart — these are all partly covered by
  our existing stats but not isolated

**Where only we have it:**
- `power` in grappling — the engine reads it for takedown entry (standing only).
  The sport does not separately measure "power in grappling" but it is real: a
  strong wrestler's takedown entry is different from a technical judoka's.

---

## Attack vs Defense — The Core Problem

**Every one of the nine grapple ids reads `grapple` on BOTH sides except:**
- `escape` / `stand_up`: only the opponent's grapple is read (defensive)
- `control`: only the top fighter's grapple is read (offensive)
- `submission_finish`: no stat read at the finish moment (flat probability)

**The six ids that read grapple on both sides:** takedown, throw, sweep,
submission_attempt, clinch_break, and (indirectly) all of them via the shared
`grapple` stat.

**This means a fighter with high `grapple` is automatically good at:**
- Shooting takedowns AND stuffing takedowns
- Attempting submissions AND defending submissions
- Breaking clinches AND resisting clinch breaks
- Controlling position AND escaping control

**In the sport, these are distinct skills.** Marcelo Garcia had elite guard
passing but was not known for takedown defense. Khabib Nurmagomedov had elite
takedown offense but his submission defense was tested separately. The engine
collapses all of this into one number.

---

## The Rule That Keeps This Honest

**Every new stat must land with its engine read in the SAME stage. No stat
ships decorative.**

Q117 measured all seven current stats LIVE with zero decorative and zero
write-only. Every stat has at least one engine read that changes fight outcomes.
This property is the thing being protected here. Ten dead BJJ attributes bolted
on for a prettier screen would destroy it — they would be stored, displayed,
and never read by any resolution function. A stat that does not change a fight
outcome is not a stat; it is a label.

The floor of six (or seven, if split) is not a wishlist. It is the minimum
number of independent values the engine's current resolution functions need to
produce different outcomes for different fighters. Adding more than the floor
requires adding engine reads FIRST, then the stat. Never the reverse.

---

## fight_iq — Confirmed Derived

Q117's note is correct: `fight_iq` is DERIVED, not stored directly.

`AthleteDevelopment.derive_fight_iq` (`AthleteDevelopment.gd:664`) computes the
displayed value from five weighted terms:
- experience (0.40) — from win/loss/draw record
- depth (0.25) — from discipline_proficiency sum
- breadth (0.13) — from competent discipline count
- application (0.10) — from learned technique count
- ring_trained (0.12) — from raw `stats.fight_iq`

The raw `stats.fight_iq` field exists and is raised only by sparring/ring_craft
training modifiers. It contributes 12% to the displayed value. The other 88%
comes from career outcomes, not from the stat sheet.

**This means only FIVE of the seven original stats carry independent information
at generation:** power, technique, speed, defense, conditioning. fight_iq is
mostly derived from career. grapple was the mean of the other six (now fixed in
Part 1).

After Part 1, the independent count is **SIX**: power, technique, speed,
defense, conditioning, grapple. fight_iq remains derived.

---

## The Floor, Stated Plainly

The engine needs **six independent stats** to resolve all nine grapple ids:
grapple, power, speed, technique, fight_iq, defense.

If offensive grappling and defensive grappling are split (as the sport
separately measures takedown accuracy and takedown defense), the floor becomes
**seven**: grapple_offense, grapple_defense, power, speed, technique, fight_iq,
defense.

The list is the operator's call and Claude's to synthesise. This digest
produces the floor and the cross-check, not a final stat list.

---

## Gate

`python research/Q119_check.py` exits 0. It re-generates the 252-fighter
population, re-derives the correlation (0.3525), asserts saturation counts, and
verifies every file:line in the Part 2 read table still resolves.
