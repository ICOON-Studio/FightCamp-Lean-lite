# S23 — A man driven down his own base gets it back

**2026-09-20. R150 stage 5, the last of the balance arc.** `BalanceState.gd`
has carried the same sentence since R149 wrote it:

> direction is explicitly unmodelled. A break along a weak line and a break
> along a strong line are worth the same today — a known, recorded deficiency,
> not an oversight. orthodox/southpaw stance will define weak lines when the
> vector lands.

They are no longer worth the same. `FightStance.gd` — the blocker that sentence
named — has been live in both engines since S4e (3), and R150 §6 recorded that
nobody went back for it.

| | seam | before | after |
| --- | --- | --- | --- |
| a break carries a line | `BalanceState.apply_break` | `"direction": "unmodelled"`, always | the line it came in on, or an honest `unmodelled` |
| which break lands | `FightRealtime._run_impact` | every shock is a `stagger` | a shock down the CENTRE lands `kuzushi`, the short square |
| the flip | `FightStance.weak_line` | — | U18 D3's own: an open matchup has no centre line at all |
| the base taken outright | `_move_seat`, the sweep | unmodelled | `base` — no line left to be strong on |

**No magnitude moved and no force moved.** U18 D3 binds this stage — stance
flips *"which hand is the 'long' hand and which body kick is free"* and is **not
a damage multiplier** — so the lever is which of `BalanceState`'s four curves a
break lands on, never how deep it is.

---

## 1. THE FOURTH CAUSE FINALLY HAS A USER, AND IT IS S22's SHAPE AGAIN

`VALID_CAUSES` has been `["kuzushi", "sweep", "stagger", "stuffed_shot"]` since
the module was written. Before S22 the engine applied two of them; S22 gave
`stuffed_shot` its consumer. **`kuzushi` was the last one nothing in the game
could apply** — a square hold of 0.2–0.6 s, scaled by depth, with G59 §1a behind
it ("convert in 0.2–0.6 s or it is gone").

That is exactly the physical claim a strong line makes. A fighting stance is
STAGGERED, so the base runs lead foot to rear foot:

- driven **straight back down that line**, a man has a rear foot planted behind
  him. He posts, and he is back over his base before anybody can convert it.
- driven **across it**, he has no foot to post on, and that is the long
  `stagger` the engine already gives every shock.

At `SHOCKED_BALANCE_MAGNITUDE` (12.0, normalized 0.75) the strong line is gone
at **0.50 s** and the weak line at **1.60 s**. Same peak, same magnitude, same
`shock` — a different length of time off the base. The wiring test prints both.

---

## 2. THE BRIEF'S OBVIOUS BUILD WOULD HAVE HALVED CARRIED BREAK TIME

`Godot/tools/probe_weak_line_census.gd` ran the engine as it stood, changed
nothing, and counted what a weak-line rule could reach — 12 MMA bouts of the
S19 fixture, and 12 more with the striker declared SOUTHPAW so the matchup is
open at all (every fixture in this repo omits `stance`, so every fixture is
closed and a matchup-scoped rule measures exactly nothing against it):

```
  CLOSED (both orthodox)          ticks carrying a REAL break  0.82%
    action strikes 12,340, shocks 88
      lead_hand  thrown 11.30%   shocks  9 (10.23%)
      rear_hand  thrown 15.75%   shocks 17 (19.32%)
      kick       thrown  5.61%   shocks  5 ( 5.68%)
      unnamed    thrown 67.33%   shocks 57 (64.77%)
```

**The unnamed 64.77% is the whole argument.** The natural reading of "a man is
strong along his base" is that everything not named a cross-line blow travels
down the centre — and re-routing lead hand *plus* the unnamed remainder means
re-routing ~75% of every shock in the game from a 1.625 s decay to a 0.5 s
square. Carried break time falls by about half, and the force (`:2760`), shock
(`:2958`) and takedown-defence seams all read that.

That is the silent global nerf S21 and S22 were each saved from, arrived at a
third time from a third direction. **Eight-for-eight on this arc's briefs being
wrong about something, and the measurement is again the only reason it was
caught.**

So the rule reads the hand and nothing else. `FightRealtime` derives `hand` from
the catalogue's own `limb`, else `hand_for_family`, and **leaves it EMPTY rather
than guessing** (S4e (3)) — so an unnamed blow names no line, keeps its
`stagger`, and is byte-identical. The engine declining to claim a glove it
cannot derive is the same discipline as declining to claim a line.

**The other half was measured and refused too.** A clean rear hand turns a man
whether or not it hurts him, so a weak-line blow could *start* a break where
none exists today. Rear hands are 15.75% of 12,340 strikes; breaking on them
would have taken the break population from 88 a pair of bouts to several
hundred. That is the same defect with its sign flipped, and it is not in this
stage.

---

## 3. THE FLIP IS U18 D3's OWN, AND IT IS WHAT MAKES THIS A STANCE FEATURE

`FightStance.draw_factor` already says the sentence this stage needs: in an open
matchup *"the rear hand is on the short line and the body kick to the open side
is free; the jab has to travel across the body to land."*

So the centre line only exists when the two men mirror each other:

| | CLOSED | OPEN |
| --- | --- | --- |
| lead hand | `back` — down the shared centre, **strong** | `lead_side` — around his lead side |
| rear hand | `lead_side` — crosses the body | `rear_side` — reaches past him |

No hand lands the same line in both matchups, and **no blow in an open bout is
ever re-routed to the short curve**. The census confirms it end to end: the OPEN
row after the build is byte-identical to the OPEN row before it — 2,979 break
ticks, 85 shocks, no `kuzushi` — while the closed row moved.

---

## 4. BEFORE AND AFTER, AGAINST A ZEROED CONTROL

`Godot/tools/s23_control_run.py` empties `STRONG_LINES`, so `break_cause`
re-routes nothing and the engine is master's arithmetic exactly; it restores by
hash in `finally`, like S21's and S22's.

```
  CLOSED                    before      after
    ticks with a REAL break   0.82%      0.80%
      kuzushi                 0.00%      0.02%
      stagger                 0.75%      0.71%
      stuffed_shot            0.06%      0.06%
      sweep                   0.01%      0.01%
    shocks                      88         93
      of which lead hand         9          9
  OPEN                      2,979 break ticks / 85 shocks, UNCHANGED
```

A rare-event feature: the re-route reaches 10.23% of shocks and takes ~2.4% off
carried break time, against the ~50% the obvious build would have taken.

---

## 5. THE RE-PINS, AND TWO CHECKS THAT WERE MEASURING THE WRONG THING

**`judge_panel_test` — three cards, all boxing** (`boxing_7`, `boxing_9`,
`boxing_23`), parsed out of the test's own printed actual by
`tools/s21_repin_judge_cards.py` and re-pinned only where two runs agreed.
Boxing is where the lead hand is a large share of what is thrown, so boxing is
where a lead-hand re-route shows up; the MMA and muay thai cards did not move.

**`judge_panel_test` T11 — RE-FOUND, never re-pinned green** (R85's rule), by
re-running `tools/find_s4f_seeds.gd -- panelwide` unchanged. Both of S21's
examples went unanimous. Seeds 301..900, same 62-v-64 fixture:

```
  BOXING      2 splits (414, 728)          8 majorities (422 500 528 564 802 826 831 876)
  KICKBOXING  3 splits (408, 525, 798)     3 majorities (488, 496, 785)
```

Both families occur in both rulesets, so the pair stays a SPLIT and a MAJORITY,
one ruleset each, each the first hit ascending: **boxing 414** and **kickboxing
488**. Nothing relaxed.

**AND THE THINNING REVERSED.** Boxing splits have run 5 (S4f) -> 2 (S4m) -> 1
(S21) and are back to 2; boxing majorities 11 -> 6 -> 8. S21 recorded the
thinning and named its own cause — a broken base ends more fights inside the
distance, and a fight that ends early hands in no card to disagree over. S23
shortens how long a man carries the most common break, which is that cause
running backwards. The count moving back with it is a check on the mechanism,
not a coincidence.

**Two checks in `fight_balance_state_wiring_test` were corrected, and both
corrections pass against the control as well as the build** — which is what
tells a fix from a tune:

- *"a man on a broken base is shocked by a larger share of the blows he takes"*
  read `state["shocks"]` — the WHOLE FIGHT's counter, both men — against blows
  landed on the victim alone. The numerator and the denominator were different
  people. Both halves now come off the same log entries. It inverted on a 3%
  margin when S23 moved fight content, which is how it was found.
- *"no man without a live break carries more than the commitment cost"* read
  `fight_seconds` AFTER `advance_tick`, one tick past the instant
  `_refresh_balance` sampled at. On a decaying stagger that 50 ms cost a hair
  and was tolerated in the comment; a square curve has no hair, so it showed up
  as a field of 0.75 against a live value of 0.0 on 3 of 14,869 ticks. **The
  offset was the artefact, not the curve** — nothing inside the engine reads
  across it, because everything in tick T reads either the field refreshed at T
  or `kuzushi_at` at T itself. The check now reads at the engine's own instant.

The third red was the wired-cause whitelist, widened by the last of the four:
all of `VALID_CAUSES` is now applied by the engine and the module has no unused
curve left.

---

## 6. WHAT IS STILL OPEN

- **THE STUFFED SHOOTER IS DELIBERATELY LEFT `unmodelled`** (`:3507`). He is
  arguably driven back down his own base, which would re-route him too — but the
  census measured the shock seam and not that one, and shipping a second
  re-route off the back of one measurement is how a rare-event feature becomes a
  global one.
- **ALL NINE BALANCE MAGNITUDES ARE STILL AUTHORED AGAINST NO TARGET** — eight
  from S19–S22 plus nothing new here (S23 adds no number at all; both curves
  were already in the module with G59 behind them). Calibration is S24 and it is
  the arc's biggest open thing.
- **THE KICK NAMES NO LINE.** `hand` is empty for every kick by construction, so
  the 5.6% of strikes that are kicks keep their `stagger`. U18 D3's "which body
  kick is free" is about the DRAW, which `draw_factor` already spends it on; a
  direction for a kick wants a `limb`-based rule and its own measurement.
- **NOTHING READS THE DIRECTION FIELD BUT `break_cause`.** That is deliberate —
  R149 found balance built three times and wired zero — but the room and the
  stage director could now be told which way a man was put off his base.

---

## 7. THE SUITE

```
SUITE total=310 fails=6
  athlete_development_test.gd              baseline
  fight_pair_live_test.gd                  baseline - PARKED by the operator's 2026-09-15 ruling
  fight_scoring_test.gd                    baseline
  fight_stage_presenter_contract_test.gd   baseline - PARKED, same ruling
  fight_stage_realism_test.gd              baseline
  judge_panel_test.gd   rc=-15             NOT AN ASSERTION - see below
```

**`rc=-15` is a SIGTERM and it is mine.** The run caught `judge_panel_test`
mid-bout on a T11 seed I had referenced in the check without registering in
`_realtime_bout`'s own `specs` table, so it was printing `Invalid access to
property or key 'boxing_414'` in a loop. Registered, and re-run standalone:
`judge_panel_test: 0 failure(s)`, with `T11 ... boxing seed 414 is a SPLIT` and
`T4/T8R nine seeded bouts ... all identical` both OK.

**The run also passed `fight_ring_position_test.gd`**, which has been one of the
six baseline names since S22. So the verified state is **five** of the baseline
six, against a ceiling of six, and `AgentComms/last_suite.json` records five
with a note saying exactly this.

---

## 8. TEST COMMAND

```
python Godot/tools/run_tests.py --only balance --jobs 3
```
