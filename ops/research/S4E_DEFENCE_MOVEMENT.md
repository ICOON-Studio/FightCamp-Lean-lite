# S4e (2) — DEFENCE AS A MOVEMENT DECISION: WHAT THE ENGINE DID, WHAT IT DOES NOW, AND WHAT IS STILL WRONG

Claude, 2026-09-15. Stage S4e (ENGINE FIRST, operator ruling 2026-09-14 night), the second of the five behaviours the
operator named. Measured with `Godot/tools/measure_defence.gd` through the production path (`FightRealtime.begin` /
`advance_tick`); gated by `Godot/tests/fight_defence_movement_test.gd`; the switch-off tripwire is
`Godot/tools/probe_evade_off.gd`.

## POPULATION

The SAME two bouts S4e (1) measured, so the two halves of the stage are comparable line for line. Both pairs
NON-IDENTICAL, both men LEGAL for the ruleset they fight under — differentiated by style and attributes inside it,
never by removing a technique the ruleset permits (operator rules 2026-09-12).

| bout | floor | A | B |
|---|---|---|---|
| BOXING, 8x180 s | ring, half_width 3.00 m (6 m square) | Out-boxer: reach 190, 188 cm, 79 kg, speed 72, power 48, defense 68 | Pressure fighter: reach 175, 177 cm, 80 kg, speed 52, power 70, defense 50 |
| MMA, 3x300 s | cage, half_width 4.55 m (9.1 m flat to flat) | Striker: reach 188, 185 cm, 84 kg, speed 68, grapple 35, defense 60 | Grappler: reach 180, 180 cm, 84 kg, speed 55, grapple 78, defense 58 |

30 seeds per variant per bout, round time only, rest excluded.

## WHAT WAS THERE BEFORE — C133 Q4, and it was not that defence was missing

Defence WAS a decision. It was taken at the wrong moment and in the wrong currency, and C133 named all four parts:

1. **THE ORDER.** `_run_impact` settles the attacker's technique, region and contact word FIRST; only then does the
   defender draw a guard and a second roll decide whether it worked (`FightRealtime.gd:1908`).
2. **THE CURRENCY.** `FightMoves.guard_outcome` can only DOWNGRADE — clean to absorbed, glancing to blocked or
   slipped — and can NEVER produce a miss. That is the operator's own split (a miss is the attacker's inability, a
   dodge is the defender's ability) and it is correct, but it means the defender can never make a blow fail.
3. **THE PALETTE.** `answering_guards` (`FightMoves.gd:1045`) deliberately DROPS every `GUARD_FOOTWORK` node, and the
   comment above `GUARD_FOOTWORK` says where the other half belongs: *"Footwork changes the geometry for the NEXT
   one"*. That half did not exist. Pivots and step-outs were in every fighter's palette and could do nothing.
4. **THE MOMENT.** C133's conclusion, verbatim: *"There is nowhere in the engine for a defence that is a MOVEMENT
   taken before contact."*

C133 also left the hard part open (its Open 2): *"A defence taken before contact needs the defender to know a blow is
coming; nothing today gives him that lookahead."*

## WHAT CHANGED

**The defensive movement is chosen on the DECISION cadence — twice a second, with no blow in flight.** `_run_evasion`
runs immediately after `_run_decision` and reads only what a fighter can see: how far away the other man is, whether he
has been throwing (his own `last_throw_tick`, stamped by R101 for his own rhythm), and his own legs and gas tank.

**There is no lookahead, and that is the answer to C133's Open 2.** He is never told what is coming. He moves because
he is in an exchange — because the other man has thrown inside the last `EVADE_ACTIVE_S` — and most of the time nothing
comes. In the boxing population **only about one movement in five ever meets a blow**; the rest are speculative, which
is what head movement is.

- `FightMoves.movement_guards` — the mirror of `answering_guards`: keeps EVADE and FOOTWORK, drops BLOCK. The two sets
  OVERLAP on EVADE on purpose: a man can slip at a blow already in flight (R102's channel) and he can slip on his own
  beat before one is thrown (this). Same technique, two clocks.
- `FightMoves.movement_answers(kind, region, band)` — pure geometry, no draw. EVADE answers `head_neck` only; FOOTWORK
  answers any region from MID or LONG and never from POCKET; BLOCK answers nothing here.
- `FightRealtime._run_evasion` — the choice, off its own stream `_rng_evasion` (`SEED_EVASION`), TWO draws per man per
  decision tick taken unconditionally. A man with no trained movement still takes his head off the line: R101's unnamed
  fallback, one level across, without which every bout with no ruleset id — most of this project's seeded tests — would
  have no defensive movement at all.
- `FightRealtime._run_impact` — reads the live window BEFORE the defender is asked anything, spends NO draw, and
  produces `slipped`: the defender's word, never `missed`. The event now carries `defence` (the catalogue node) and
  `defence_timing` (`pre_contact` for this, `answered` for R102's roll, empty for a blow nobody defended).
- `FightRealtime._run_movement` — a FOOTWORK movement carries the BODY. The step reuses S4e (1)'s open-room probe
  (`_circle_direction`) with half a step away from the man throwing, at the retreat throttle, for the ticks the movement
  lasts. His intent is untouched, so his stamina and his next decision are unaffected.

**`EVADE_BASE_P` and `EVADE_SPAN_P` are the only numbers tuned, and they were tuned to a published rate.** Everything
else — the window length, the reset, how long after a punch a man counts as being in an exchange — is AUTHORED and
labelled as such in the source.

## THE REALISM RULES, AND WHICH ARE GATED

| rule | tier | stands on |
|---|---|---|
| R19 defensive_movement_rate | **GATED** | **DOCUMENTED**: ~3.6 defensive movements per fighter per minute against ~21 punches per minute (Davis et al., elite amateur boxing, defence coded hand / trunk / foot; G54 §3 — *"the only defensive-action rate with a denominator"*). The FIGURE is documented; the BAND (half to double) is AUTHORED, because one study published one number and no spread. |
| R19a movement_answers_its_own_line | **GATED** | GEOMETRY. A slip moves the head off one line and is not a defence against a body shot or a low kick; nobody steps out of a punch already in the pocket. |
| R20 chosen_before_contact | **GATED** | ORDERING of the engine's own tick. Every `pre_contact` answer traces to a movement opened on a strictly earlier tick, and the median lead is measured. |
| R21 engine_uses_the_same_rule | **GATED** | GEOMETRY (engine). Every answer in a live bout is re-checked against the pure function, so the consumer cannot carry a second copy of the rule. |
| R22 evade_window_is_an_ab | **GATED** | A/B of the engine against itself. |
| R23 connect_and_striking_defence | REPORT | **DOCUMENTED** but a DIFFERENT DENOMINATOR: CompuBox league connect ~30–35% of TOTAL punches thrown (G54 §5); UFC significant accuracy 40–49% of ATTEMPTS (J20 D2, 8,337 bouts). This engine's denominator is BUILT IMPACTS. Reported, never tuned toward. |

**G54 wrote the warning this stage answers**, before there was anything to warn about: *"Our defender will act far more
often than that if his roll fires on every incoming blow — name that gap rather than hiding it."* The gap is now closed
in the only direction that is honest: the RATE is calibrated to the published rate and the accuracy it produces is
reported wherever it lands.

## BEFORE AND AFTER (30 seeds per variant per bout, round time only, rest excluded)

`base` is the engine as S4e (1) left it, `window` is the defensive movement with the body NOT carried, `window_step`
is the shipped configuration. A merge is not its branches, so the step has its own column.

| bout | variant | movements / fighter / min | per 100 incoming blows | answered pre-contact | connect% | Str. Def. | endings of 30 |
|---|---|---|---|---|---|---|---|
| BOXING | base | 0.00 | 0.0 | 0 | 47.3% | 52.7% | 25 decision / 5 KO |
| BOXING | window | **3.44** | 13.0 | 851 (2.65% of built) | 45.9% | 54.1% | 19 decision / 11 KO |
| BOXING | window_step | **3.43** | 13.0 | 825 (2.41% of built) | 46.2% | 53.8% | 24 decision / 6 KO |
| MMA | base | 0.00 | 0.0 | 0 | 47.0% | 53.0% | 25 decision / 4 sub / 1 KO |
| MMA | window | **2.86** | 10.2 | 311 (1.36% of built) | 46.4% | 53.6% | 22 decision / 4 sub / 4 KO |
| MMA | window_step | **2.80** | 9.9 | 271 (1.20% of built) | 46.6% | 53.4% | 22 decision / 4 sub / 4 KO |

**THE RATE LANDS ON THE ANCHOR IN THE SPORT THE ANCHOR CAME FROM.** Boxing reads 3.44 and 3.43 defensive movements per
fighter per minute against Davis's 3.6 for elite amateur boxing. MMA reads 2.80–2.86 and is REPORTED, not gated: it is
a different sport, and its men spend time on the floor and out of range where a slip is not a thing you do.

**FOUR MOVEMENTS IN FIVE MEET NOTHING.** Boxing: 4,448 movements, 825 of them answered a blow — 19%. That is the shape
of the behaviour, not a defect in it. A fighter moves his head because he is in an exchange; most of the time the punch
does not come, and an engine where every defensive movement was spent on a blow would be a reaction model with a
movement's name on it.

**PER 100 INCOMING BLOWS THE ENGINE IS BELOW DAVIS, AND THE REASON IS PACE, NOT DEFENCE.** Davis's pair is 3.6
movements against 21 punches a minute — 17 per 100. This engine throws **26.4 built impacts per fighter per minute**,
26% more than that, so the same 3.6 movements a minute buy only 13 per 100. The pace is a known engine finding (R100
measured whole-bout speed at 2.26x a real boxer's; R102 left connect% at 46% against CompuBox's 30–35%), and this
stage did not touch it.

**WHAT IT DID TO ACCURACY, REPORTED AND NOT TUNED.** connect% 47.3% -> 45.9% (boxing) and 47.0% -> 46.4% (MMA);
`slipped`'s share of built impacts 11.0% -> 13.3% in boxing. Both move TOWARD the documented bands and neither reaches
them, because what is too accurate here is the attacker's ladder, which this stage deliberately did not touch.

**THE STOPPAGE COUNT MOVED AND NO DIRECTION IS CLAIMED.** Boxing KOs over the same 30 seeds read 5 -> 11 -> 6 across
the three variants. Eleven is not a finding at n=30 and neither is six: a movement change reshuffles every trajectory,
and the three columns are what a reshuffle looks like. It is recorded here so the next stage does not rediscover it as
a trend. The individual judge cards that moved are re-pinned below.

**THE GROUND FIGHT GOT BUSIER IN MMA, AND THAT IS NOT EXPLAINED.** Grapple events over the same 30 seeds: 1,004 ->
1,203 -> 1,397. The movement is chosen only when both men are STANDING and the pre-contact answer is refused in a
clinch or on the floor, so nothing in this stage touches the grapple stream directly — it is the trajectories moving.
Recorded, not claimed, and the fixture-level sweep below found the promotion rate unchanged.


## THE TRIPWIRE: WITH THE SWITCHES OFF, IS THIS THE SAME FIGHT?

`tools/probe_evade_off.gd` checksums the whole event log of three seeded boxing bouts — tick, actor, region, contact
word, force, shock and the wear ledger — and ignores the two keys this stage added.

| engine | switches | events | sha256 |
|---|---|---|---|
| HEAD (S4e (1)) | n/a | 3,924 | `0c65e24b623957293d797fd2356462756e264ab7ea581f201bb28cf3aa4b0772` |
| S4e (2) | off | 3,924 | `0c65e24b623957293d797fd2356462756e264ab7ea581f201bb28cf3aa4b0772` |
| S4e (2) | on | 3,406 | `3dcd99bcc548314a5942939fa5c45d84527edde23ce6cc96dbd67ad9b3f0c7ff` |

**Byte-identical with the switch off**, over 3,924 events, against HEAD's own scripts restored from git. A new stream
and two event keys changed nothing else, and the A/B is an A/B.

## WHAT ELSE MOVED, REPORTED RATHER THAN TUNED

- **THE JUDGE PANEL, `judge_panel_test.gd`'s thirteen realtime cards.** All thirteen moved and all thirteen were
  re-pinned from the test's own printed actual, each reproducible across the two runs the test itself makes. Three of
  them — `boxing_11`, `boxing_20` and `kickboxing_13` — were round-one-to-round-three KOs and are now decisions, which
  LOOKS like "men who move their heads get knocked out less". **The 30-seed population says that is not a finding**:
  boxing KOs read 5 -> 11 -> 6 across the three variants. Thirteen cards moving is what a movement change does to
  thirteen seeded trajectories; the direction three of them happen to take is not evidence of anything, and it is
  recorded here so nobody quotes it as one.
- **T11's PAIR, RE-FOUND BY SWEEPING, AND BOXING NO LONGER HAS A SPLIT AT ALL.** `judge_panel_test`'s T11 asserts the
  panel is not decorative by naming one bout of each non-unanimous kind. `tools/find_r101_seeds.gd -- panel` swept the
  same 62-v-64 fixture, 300 seeds per ruleset: **boxing** 181 unanimous, 84 stopped, 21 unanimous_draw, 8 majority
  (32 35 63 124 149 242 280 294), 6 majority_draw and **NO split**; **kickboxing** 231 unanimous, 32 stopped, 32
  unanimous_draw, 3 majority (172 197 228), 1 majority_draw and **one split_draw — seed 19**. There is no `split` in
  600 bouts. The pair is now kickboxing 19 (split_draw) and boxing 32 (majority), and the assertion was STRENGTHENED
  rather than relaxed: the three judges must now be shown disagreeing on BOTH bouts, not only the first.
- **THE GRAPPLE BEAT, `fight_beat_grapple_test.gd`.** It went red, and the cause was NOT this stage. An independent
  sweep (`tools/probe_grapple_beats.gd`, the test's own fixture) measured how often a window holds ground work and no
  strike at all — the only thing that can promote a grapple beat: **2 of 40 bouts (5%) before the stage, 7 of 200
  (3.5%) after**, with grapple EVENTS in 37 of 40 and 177 of 200 both ways and the event totals within 1% (1,508 v
  1,493 over the same 40 seeds). Twelve consecutive seeds were carrying a one-in-twenty claim; S4e (2) moved every
  trajectory and the luck ran out. **The fixture was widened with two seeds the sweep found (611051, 611072) and the
  measured rarity is recorded in the test**, rather than re-pinning to a seed that happens to pass.
- **`fight_realtime_test` is GREEN** — its R101/R84/U34 seed families survived this stage untouched, which is the first
  time in three stages that has happened.

## THE SUITE, THE TWO REDS, AND WHAT THE LEG SHARE TURNED OUT TO BE

`python Godot/tools/run_tests.py --jobs 4 --timeout 1800` read **296 total, 7 fails** on the first pass. Five are the
reds master already had and `AgentComms/last_suite.json` already recorded at 295/5: `athlete_development_test`,
`fight_pair_live_test`, `fight_scoring_test`, `fight_stage_presenter_contract_test` and `fight_stage_realism_test`.

Two were mine — `fight_realtime_test` (6 failures) and `grapple_adapter_test` (7) — and both were re-run serially and
reproduced exactly, 6 of 6 and 7 of 7, so neither was a `--jobs 4` artefact. **The cause was the standing-only
correction**, which landed on top of a subset that had already run green: a pre-contact answer is refused unless the
men are STANDING, because a window opened at range must not answer a short clinch strike. That is the right rule and
it moved every MMA and judo trajectory a second time. Re-running the touched subset after the LAST edit rather than
the biggest one is the lesson, and it is in the handover.

### One was an invented constant, and the catalogue said so

The footwork movement carried the body out at `_circle_direction() - toward * 0.5` — a lateral step plus **half a step
straight back**, which nothing asked for. Every effect word that makes a catalogue node FOOTWORK is an ANGLE or
MOBILITY word — `mobility`, `first_step`, `boundary_control`, `opponent_mobility`, `angle_attack`, `angle_entry`
(`FightMoves.gd:949`) — and not one of them is a retreat. Backing straight up is what the `retreat` INTENT already is.
The step is now purely lateral: a pivot.

It had cost a number. `tools/probe_leg_share.gd` on `fight_realtime_test`'s own C85 fixture and seeds: the backward
half-step pushed LONG-band ticks 4,535 → 4,318 and ground events 1,987 → 2,509, and leg strikes are thrown at LONG and
MID, so the landed leg share fell. With the pivot the bands come back (LONG 4,759, ground 2,174).

### The other was not a regression at all, and the check had been asleep on it

| variant | landed head / body / leg | landed leg COUNT |
|---|---|---|
| base (S4e (1)) | 50.1% / 41.7% / **8.2%** | 695 |
| S4e (2), pivot | 49.3% / 42.9% / **7.8%** | 696 |

**The leg COUNT did not move — 696 against 695.** The share fell because the denominator grew: defensive movement
lengthens fights (16,014 → 16,910 built impacts over the same 20 seeds) and the extra time goes to the ground, where
nobody kicks a leg. And the check's floor was 8%, so the engine had been sitting 0.2pp above it without anybody
knowing.

**The check said "near R84's 12% baseline" and the engine has not been near 12%.** Worse, the number it should be
judged against is not 12% either: J20 D3 puts the real UFC target mix at **61-65% head / 19-23% body / 14-18% leg**
(8,375 fights, 12 divisions, 1993-2025). The engine reads roughly **49 / 43 / 8** — too little head, twice the body,
half the legs.

**`TARGET_WEIGHTS` IS NOT THE LEVER, AND THAT WAS MEASURED RATHER THAN ASSUMED.** A calibration pass took the MMA leg
weight from 0.12 to 0.25 — more than double — and moved the delivered share only **7.8% → 9.4%**. The reason is
`FightMoves._regions_for` (`:658`): a node's regions come from its OWN effect words (`head_damage` 85/15,
`body_damage` 85/15 the other way, `leg_damage` 45/45/10), and the ruleset table is consulted only for a node that
hints nothing, plus the `kick_damage` spread. The delivered mix is decided by WHICH TECHNIQUES GET PICKED. The
calibration pass was reverted and the finding is recorded in the source beside the constant.

So the check is now two statements instead of one that was quietly both: a **REGRESSION gate** at 6-10%, tighter than
the 8-16% it replaces and anchored on what the engine actually delivers, and a **REPORT line printed on every run**
naming J20 D3's band and the gap. Raising the delivered mix is a technique-selection stage and it is named in the
roadmap.

### The five seed families, re-found by sweeping — never relaxed, never picked to match

| pin | was | now | what the sweep says |
|---|---|---|---|
| `_test_the_fight_ends` goes the distance | 7001 | **7002** | 30 of 40 seeds reach the final bell — a three-in-four property, not luck |
| a knockdown occurs | 19003 19007 19008 19011 | **19002 19005 19006 19010** | 207 shocks, 16 knockdowns, 14 of 40 seeds carry one (R101: 195 / 19 / 16) |
| three-knockdown TKO | 77058 77085 77144 | **77076 77093 77149** | 18 of 400, against R84 19 / R86 8 / R101 20 / R102 14 / S4e (1) 13 — the rule got MORE reachable |
| judo third shido | 94006 94013 94019 | **94006 94007 94013** | ippon 14 / shido 13 / DECISION 66 of 100, against S4e (1)'s 13 / 15 / 68 |
| muay thai witness | 93003 | **93002** | 14 of 400 land exactly one throw on a unanimous decision; methods SUBMISSION 147 / DECISION 209 / KO 44, against S4e (1)'s 156 / 193 / 51 |

**AND THE PIVOT MOVED TWO MORE, WHICH IS THE SAME LESSON A THIRD TIME.** `judge_panel_test` and
`fight_beat_grapple_test` had already been re-pinned earlier in the session, before the backward half-step came out;
taking it out moved every trajectory again and both went red. Re-found the same way:

- **The judge panel's thirteen cards**, from the test's own printed actual, and **T11 got STRONGER rather than
  weaker**. An hour earlier the 600-bout sweep found NO `split` in either ruleset and T11 had to fall back on a
  `split_draw`; with the pivot in, boxing has two splits (49, 141) and kickboxing three (12, 37, 273). T11 is back to
  the pair it has always wanted - a SPLIT and a MAJORITY, one ruleset each - and the compromise is retired.
- **The grapple beat's promoting seeds**: 611051 and 611072 stopped promoting, and `probe_grapple_beats.gd` found four
  in 120 (3.3%) on the pivot engine. The test now carries all four and the re-sweep command, because a 3%
  phenomenon pinned to named seeds will move on ANY movement change and the next person should re-sweep rather than
  guess.

Two of those tallies are worth reading as findings rather than bookkeeping. **The three-knockdown TKO got more
reachable, not less** (13 → 18 of 400): a man who slips is a man the bout has time to drop three times, where before
he was stopped outright. And **muay thai lost submissions and knockouts to decisions** (156/193/51 → 147/209/44),
which is what a defence that takes blows away does to a sport. Neither was tuned toward.

## Open — what this stage did NOT fix

1. **The rate is calibrated to ELITE AMATEUR BOXING and applied to everyone.** Davis's 3.6/min is boxing; the MMA
   population is reported against it and gated by nothing. `TASK_U109` (between-punch footage rates: stance switches,
   direction changes, resets, level changes and head movement per minute) is what would give MMA its own figure, and it
   needs the PC — its seventeen MediaPipe tracks are not in the repo.
2. **No study bounds the WINDOW.** How long a slip lasts, how long a man needs before the next one, and how much of a
   fighter's defence is movement rather than a guard are all AUTHORED here. G54 searched and found nothing at punch
   resolution.
3. **A movement answers one blow and then it is spent.** A real slip can beat the second punch of a combination as it
   comes back; this one cannot. That is deliberate — the alternative is one roll buying a whole exchange — but it is a
   simplification and it is not in any study.
4. **The defender's own offence is untouched while he moves.** There is no commitment cost yet: a man who has just
   slipped can throw on the same beat. Commitment is the NEXT behaviour on the operator's list (feints and
   commitment), and `last_throw_tick` is where C133 says its until-tick belongs.
5. **The judge panel's own T11 fixture is two men who differ in ONE stat** (`fight_iq` 62 v 64, everything else
   identical). It predates this stage and it exists because a split decision needs closely matched men, but it sits
   uncomfortably beside the operator's identical-fighters rule and should be looked at when that test is next opened.
6. **The room has not seen any of this.** A defensive movement has no clip: the presenter shows `slipped` the way it
   always has. Recording the live room is a PC job — `--write-movie` under `--headless` ABORTS in this container and
   writes a 0-byte file (measured, not assumed), so the operator's verdict on how it LOOKS is owed and cannot be taken
   here.
