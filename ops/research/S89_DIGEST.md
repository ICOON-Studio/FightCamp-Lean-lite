# S89 DIGEST - training floor step 5: the visiting pro, open-spar night, and a hired partner who really fights like him
Claude, 2026-09-26. Roadmap `now` from S88.

## Shipped
- **THE HIRED PARTNER MADE TRUE (Q191, re-measured).** Re-ran Q191's instrument with a NOISE arm (the real opponent
  again on fresh seeds - the floor no partner can beat), 3 bouts averaged per arm, columns scaled by the reference men's
  own spread, power_share dropped (it was 1 - jab_share). p50 distance to the real opponent, 10 different pairs per
  ruleset (FightOpponentGenerator men, real FightPlans), lower = closer:

  | ruleset | noise floor | S88 market | S89 style clone | random control |
  |---|---|---|---|---|
  | boxing | 0.58 | 1.64 | **1.22** | 1.62 |
  | kickboxing | 0.52 | 1.01 | **0.55** | 1.09 |
  | MMA | 0.68 | 1.15 | **0.71** | 1.07 |

  **The S88 card sold a label: stance + height + plan measured no closer than a random man in all three rulesets.**
  Fix: `SparPartnerMarket.candidates` takes `spec.model` (the opponent's stats and technique record) and builds a STYLE
  CLONE - the opponent's stat SHAPE (each stat's offset from his own mean) laid over the partner's own level, +-4 each,
  and the opponent's learned techniques less one higher-tier move (never an identical fighter; a model with no record
  gives a clone with none - the same default palette). KB and MMA now sit on the noise floor. **Boxing is closer but
  still 2x the floor** - Q191's own liveness check hinted why (a pressure fighter and an out-boxer 0.032 apart): the
  boxing plans barely separate -> Q192.
- **THE VISITING PRO (G120 s4-6).** A second floor event (FloorEvents, the S85 card): about once a month for a gym with a
  ring (`VISITING_PRO_DAILY` 1/30 - JUDGEMENT, G116 "rare"), sharing the one-open-event and cooldown rules. A pro one
  level above a house fighter the coach would put in (legal: discipline, sex, +-1 class, a record in his band, never a
  roster surname). LET HIM IN (+$45 day pass, G120's day pass) books a light spar through `spar_fight_setup`; NOT TODAY
  changes nothing, and is what an unanswered day does. When the spar settles - watched or not, ONE place in
  `_settle_spar` - the gym takes the day pass and reputation: +2 talk, +4 if the house man had the better of it, -3 if
  he was STOPPED ("the clip is already going round"). A news line says so.
- **OPEN-SPAR NIGHT (G120 s3, s6).** At tier 3+ the ring card has OPEN NIGHT FRIDAYS: ON/OFF. On Friday the day start
  books up to two house-vs-visitor pairs (each house man one outside fighter at his level, G117's caps still apply),
  light rounds - or one step harder when the visitor goes for the win (15%, JUDGEMENT on G120's "ego partners"). Each
  drop-in pays $30 (G120 $25-35 SOURCED); +1 reputation if the house man had the better, -1 if a visitor stopped him.
- **D34 acted on:** the HIRE row says what you buy - `name · level · stance, cm (his cm) · his plan, his strengths` and
  HIRE HIM FOR A DAY. The result card carries the visitor's line and "+$45 · reputation +2" on its own rows.
- Shared `_give_partner_record` (a hired partner and every visitor): market men had NO record, so the coach read every
  visitor as a raw beginner and refused every pairing - found by the new test, not by eye.

## Collected
- **U183 (Cursor):** all nine boxing footwork rows -> idle (no owned walk/run/dodge passes foot <= 0.10 m and knee <=
  0.12 m on f01); `boxing_footwork_clearance_test` + mutant; merge bar green here (2/2). Its accepted trap - the guard
  now SLIDES on footwork beats - is U184.
- **Q191 (Qwen):** instrument merged and reworked as above. As committed it could not run on master (it preloaded
  FightOpponentGenerator, which names the GameState autoload - needs `await process_frame` + `load()`), and its
  "kick_share" is really leg-TARGET landed share. Its recommendations 1-2 (stat shape, palette) are what shipped.
- **G122 (Grok):** `G122_WHAT_THE_WALLS_DO.md` - belts and portraits are EARNED, paper and neon BOUGHT; no study shows
  walls sell memberships. Feeds S90. **D34 (Dola):** `D34_FRESH_EYES_THE_WING.md`.

## Tests
- NEW `visiting_sparring_test` 0 failures: the rules (rate, cooldown, open event, NOT TODAY, outcome signs, ego step,
  open-night gating); a legal pro a level up, a stranger, never on the roster; NOT TODAY moves nothing; LET HIM IN books
  him; the day pass lands once; reputation moves by the outcome (10 -3 -> 7 on this seed: the leaked clip); WATCHED ==
  SETTLED field by field incl. the visitor line/cash/reputation; the day end settles nothing twice; open night refused
  below tier 3, not on a Monday, once a night, a house man per visitor, $30 each, real spars; the clone carries the
  model's shape (shape error < half a plain partner's), sits at the partner's level, knows the model's moves less one.
  **Three real mutants, all red:** NOT TODAY books; the clone ignores the model's stats; the outcome never applied.
- Subset (S88's gym_/training_floor/membership/smoke/spar/fight_camp/floor/wing/day_feed/career_loop/menu_clarity/
  home_pin + clip_binding/boxing_footwork + visiting): **27 tests, 26 green**, the red one was this test mid-edit; after
  the last edits visiting_sparring, gym_wing, training_floor_3d: 3/3. Nightly: `AgentComms/nightly/latest.txt`.

## Renders
`docs/previews/s89/floor_visiting_pro.png` (the event card, OPEN NIGHT switch, new HIRE row),
`floor_visit_result.png` (the pro's spar settled: result, landed, "+$45 · reputation +2").

## Assigned
U184 (Cursor): procedural step-drag footwork on top of the foot lock - feet plant and step low with the engine's
travel instead of sliding. Q192 (Qwen): do the fight plans make different fighters (boxing's 2x-floor gap) + the MMA
JABS row (FightBroadcast counts a jab only if the id contains "jab"; MMA jab share read ~0 in every bout). G123 (Grok):
decor as a game layer in shipped management games (S90). D35 (Dola): fresh eyes on the S89 renders.

## Not done
Decor (S90, G122 + G123). The boxing likeness gap waits on Q192.
