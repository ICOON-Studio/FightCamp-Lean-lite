# Q76 — A judo bout at time is decided by things judo does not score

Research only. No `.gd` touched. Delivered by Qwen 2026-09-13.

## The mechanism

When a judo bout reaches the end of its last round, `_close_round` in
`FightSimulation.gd` (line 2919) is called. It computes each fighter's round
score via `RoundScoring.round_points(profile, fighter)`, which multiplies the
fighter's per-round counters by the scoring profile's weights. For judo the
profile (in `combat_rulesets.json`) sets three weights to 1.0 and everything
else to 0.0:

- **positions** (1.0) — `position_points_round`, which accumulates 1.0 per
  landed control, pass or sweep (from `position_points` in the profile).
- **submissions** (1.0) — `submission_attempts_round`, incremented every time
  a submission attempt is made, regardless of whether it lands.
- **throws** (1.0) — `throw_points_round`, which accumulates points from
  throw bands (judo's single band: 1.0 at magnitude >= 14).

Damage, volume, knockdowns, control and takedowns are all weighted 0.0 for
judo. The result is that a judo round's score is the sum of position landings,
submission attempts and throw points. `RoundScoring.card` for the ippon style
returns these raw points directly — no 10-9 mapping.

The scorecards accumulate across rounds. When the last round ends,
`_close_round` calls `_finish_fight(fight_state, "", "DECISION")`. Inside
`_finish_fight` (line 3075), the DECISION path sums the per-round scores from
every scorecard. The side with the higher total wins. If the totals are equal,
winner_side stays empty — there is no tiebreak for judo. Karate's senshu
(initiative / first-unopposed-score) exists in the code but is not enabled for
judo's profile.

**There is no golden score.** A grep for "golden" across `FightSimulation.gd`
and `RoundScoring.gd` returns zero matches. A level contest at time simply
ends as a draw.

**There is no shido.** A grep for "shido" or "hansoku" across the same two
files returns zero matches. The only "penalty" hits are stamina penalties,
knockdown round penalties and weigh-in penalties — none of them are judo
penalties.

**JudoBoard.gd exists but is unused.** `JudoBoard.gd` is a standalone
RefCounted module implementing the full IJF Sport and Organisation Rules:
waza-ari, yuko, shido (third = hansoku-make), golden score, and a `decide`
function that compares waza-ari then yuko at time and sends a level contest to
golden score. It is well-built and rule-correct. But `FightSimulation.gd`
never imports, references or calls it. The simulation pipeline does not know
JudoBoard exists.

## The trap

The engine's 24 DECISION outcomes in the S1e measurement (16 IPPON, 24
DECISION from 40 bouts) are NOT "single waza-ari at time" in any judo sense.
They are decided by accumulated position points, submission attempt counts and
throw points — counters that real judo does not use to decide a bout at time.
A fighter who accumulated more top controls and more submission attempts wins
the "decision" even if their opponent threw more waza-ari. Mapping the engine's
DECISION count onto J26's 22.6% "single waza-ari at time" would be wrong.

## The anchors (J26)

Dopico-Calvo 2023, senior World Championships 2018-19-21, n = 2,340 contests:

| Outcome | Share |
|---|---|
| Ippon (any) | 46.2% |
| Single waza-ari at time | 22.6% |
| Waza-ari-awasete-ippon | 17.7% |
| 3rd shido | 13.5% |
| Golden score (any method) | ~21% |

Each anchor is quoted verbatim from `research/J26_IJF_MATTE_AND_ENDINGS.md`
lines 58-62 in the JSON delivery.

## Options

### Option a — Real scoring only

Decision counts only real judo scores: throw_points (waza-ari) and osaekomi
scores. Positions and submission attempts weighted 0 in the decision tally. A
level bout at time is a draw. Touches `round_points` and `combat_rulesets.json`.

Predicted direction: ippon same, waza_ari_at_time up (decisions now reflect
real judo scoring, so more bouts resolve as a clear waza-ari lead), golden_score
same (still absent), shido same (still absent).

### Option b — Real scoring plus golden score

Option a plus golden score: when real judo scores are level at time, the
contest enters golden score via `JudoBoard.decide`. First score in golden score
— yuko, waza-ari or ippon — wins the contest. Shido still absent. Touches
`round_points`, `_finish_fight`, `JudoBoard.gd` and `combat_rulesets.json`.

Predicted direction: ippon same, waza_ari_at_time down (some former decisions
become golden scores instead), golden_score up (new mechanism captures the
level-score contests), shido same.

### Option c — Real scoring plus golden score plus shido

Option b plus shido for passivity: repeated matte calls (unproductive ground,
already tracked by `_judo_ground_referee`) award a shido to the less active
fighter. Third shido is hansoku-make and the opponent wins. Uses
`JudoBoard.apply` for shido tracking and `JudoBoard.decide` for time expiry.
Touches `round_points`, `_finish_fight`, `_close_round`,
`_judo_ground_referee`, `JudoBoard.gd` and `combat_rulesets.json`.

Predicted direction: ippon same, waza_ari_at_time down, golden_score down
(some golden scores resolved by shido before any score), shido up (new
mechanism).

## Recommendation

**Option b.** It captures the two biggest structural gaps — real judo scoring
replacing position/submission counters, and golden score replacing the current
draw — without adding the complexity of a passivity penalty system. JudoBoard.gd
already implements both pieces; the integration work is wiring `_finish_fight`
to call `JudoBoard.decide` when scores are level, and switching `round_points`
to read only throw and osaekomi counters for judo. Option c is the complete
answer but shido tracking for passivity requires a definition of "less active"
that the engine does not yet have, and it is better built as a follow-up once
option b is measured against the J26 anchors.
