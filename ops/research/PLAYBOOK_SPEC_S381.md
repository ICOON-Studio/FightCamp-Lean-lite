# Playbook spec v2 - one page, the real plan enterable, wired to training (S381)

Status: design spec, approved scope (operator "Yes, add them" + "make sure everything wires with training too").
Builds on v1 (the merged one-page spec, S381 workflow wifi9vfka `result.spec`) and keeps every v1 rule this file does not
change. Inputs read: the v1 spec + mockup (`E:/FightCamp/tmp/s381/gameplan/playbook_one_page.html/.png`), the real-plan
research (S381 workflow wnhtzvv74 `maps[3]`, `ops/research/REALPLANS_S341.md`), the Rune Coliseum notes
(`E:/FightCamp/tmp/ref_study/rune-coliseum/FOR_PLAYBOOK.md`), the camp design (S381 workflow wuc6i9nyf `final`) and the
code on master `edc03163` plus branch `claude/camp2` (`a8315d0e`: FilmEdge, PlanLines.answers, WeekPhase.film_night,
halved camp edges). No Godot was run for this spec (watchdog RED: the operator is gaming); the page picture referenced is
the existing still `E:/FightCamp/tmp/s381/gameplan/playbook_one_page.png`.

Operator decisions this spec obeys: ONE page, no tabs ("all these are the same scene wtf"). Ink cards of the Fight Camp
modal. Pictures over text, one line each, no flavour text. Stamina per card, no action points. The opponent reads
repeated or long combos: visible, capped, counted only when THAT item fires. Each fighter carries the plan his own way
(traits per playthrough). The go-to combination (PLANCOMBO1) stays. No holo panels in live rounds.

Approved additions (all five are in this spec, with numbers): (1) MIX on a line, (2) SCORE/CLOCK WHEN chips,
(3) circling / pivot at LONG and MID, (4) BODY JAB and FEINT as setup moves that can open a combo, (5) HEAD/BODY share
per round. Kept: round phases, footwork chains ("1-2 -> step out"), the read meter.

Words used below: ITEM = one thing in the plan the fighter must do (a line cell, a mix option, a combo slot). PHASE = one
of the plan's three columns (Early / Middle / Late). FIRE = the item is thrown in an exchange (6 exchanges of 30 s a
round, `Exchanges.EXCHANGES`).

---

## 1. The page (calm)

One page at 1920x1080, three columns, no tab strip (`Data.gd` playbook tabs -> `[]`). The v1 layout stays: LEFT moves
(350 px), CENTRE opponent strip + stitch bar + plan table (scrolls), RIGHT player + "how he carries it" (410 px, fixed).
v2 changes how the centre reads: the S381 mockup put 4-6 numbers in every plan cell; v2 shows a coloured bar and ONE word
per cell, and every number moves to hover.

### 1.1 Cell grammar (used everywhere in the plan table)

A cell is 64 px high. Top: a bar filled to the projected effect (green = wins, grey = even, red = loses). Under it a 4 px
read strip (green under 0.4, amber up to her trigger, red past it). One word in the bar. Nothing else.

| word | when | hover shows |
|---|---|---|
| `wins` | projected exchange odds >= 0.55 | odds %, edge in power points, fires a round, gas a round |
| `even` | 0.45-0.55 | same |
| `loses` | < 0.45 | same + the fit word ("walks into it") |
| `READ` | her read on the item >= her trigger in that phase | read %, uses until read, "she counters it (-7)" |
| `rare` | projected fires < 1.0 a round | "she only puts you there about 0.6 times a round" |
| `drill` | the item's mastery < 30 (plays at 0.8) | mastery, weeks to 30 at this week's pads |
| `tired` | his tank cannot throw it whole that phase | finish length, energy at mid-round |
| `off` | the line has no cell in that phase | - |

Priority when two apply: READ > drill > tired > rare > wins/even/loses. A coloured left edge on the row marks the row
group (tells amber, combos gold, lines blue).

### 1.2 Centre, top to bottom

1. OPPONENT STRIP (96 px): ink face card | style word | ONE edge bar (whole plan vs her) with one word (`ahead` /
   `even` / `behind`) | `has your tapes` chip at rating 55+ | Real plans | Test it (N left) | Map. Hover on the bar:
   the number and the one thing that moved it most.
2. STITCH BAR (200 px): ink cards in click order (punches red ink, feet/defence/setups blue ink), the join word between
   cards (good / rough / clumsy), each card's range chip, and three tiles that each show ONE word + a pip bar:
   COSTS (gas pips), WINS (`wins`/`even`/`loses`), READ (`slow` / `normal` / `fast`). Numbers on hover. Book chips
   underneath.
3. ROUND HEADERS (one per phase column): phase name (`R1-2`), pace chip per round in the phase (push / steady / save),
   two thin tank bars at the bell (his, hers), the HEAD/BODY bar (section 3.8) with one word (`head` / `mixed` / `body`).
4. PLAN TABLE, three row groups:
   - HER TELLS (amber): ink tell picture | the tell in 4-6 words | answer slot | one word `answered` / `waiting`.
   - COMBOS (gold): mini ink cards of the chain | WHEN chip (optional) | per phase: a 0-3 pip stepper + the cell |
     Drill it. Slot 1 carries the go-to star.
   - LINES (blue): place picture | WHEN chips (game and/or score/clock) | per phase: the move card or MIX card + the cell.
   Header line of the table: `holds 6 · plan 7` per phase (red when over, hover lists the half-followed rows).
5. FOOTER: `Copy last plan` | `Copy my plan vs this style` | `Clear`.

### 1.3 The MIX card (in a line cell)

Two or three small ink cards stacked like a hand, each with its share as a pip row (10 % a pip). Click opens a 3-slider
picker (steps of 10, each 20-60, sum 100). One word on the cell as usual. Hover: per option odds, read, weeks of pad time.

### 1.4 The WHEN chips (pictures, one word)

Game chips (exist): presses / boxes / counters / loads up / tiring / hurt / you're tired / you're hurt.
New score/clock chips: scorecard picture `ahead`, scorecard picture `behind`, clock picture `last 30`, bell picture
`R4+` (any N from 2 to the bout's rounds). A line takes at most one game chip and one score/clock chip.

### 1.5 Left and right columns

LEFT: v1 rows (ink pose, name, mastery bar with ticks at 30 and 85, gas pips, [+]). New rows: `Jab` (single) under LONG,
`Body jab` and `Feint` under LONG (blue ink, SETUP tag), `Circle off` under LONG and `Pivot` under MID and CLINCH (blue).
A setup or circling row under 30 shows the `drill` word on its bar and `Drill it` sets it as the week's learning move.
RIGHT: v1 player + CarryStrip, unchanged. No holo panel anywhere on this page or in live rounds.

---

## 2. What the plan is (data)

```
f["plan"] = {
  "v": 2,
  "lines":  [{"at": "mid", "when": "press", "cond": "", "cells": [cell_E, cell_M, cell_L]}],
              # cell = null | {"move": id} | {"mix": [[id, 50], [id, 30], [id, 20]]}
  "combos": [{"id": "1-1" | "own:3", "when": "", "cond": "", "uses": [2, 1, 1], "go_to": true}],
  "pace":   ["steady", "steady", ...],      # one per round (PlanFile.pace_for keeps reading it)
  "body":   [0.2, 0.2, 0.2],                # head/body share per phase
}
```

- `PlanWhen.arrows_for(plan, n, rounds)` flattens the phase of round n into the arrows the ring already reads
  (`{move, when, cond, mix}`), so `PlanBoard.pick` / `PlanFight.choose` keep their shape. `LiveRound.open` sets
  `f.bout.arrows` from it at every round open (today: only at n == 1, `LiveRound.gd:61`).
- Phase of a round: `phase(n, rounds) = min(2, floor(3 x (n - 1) / rounds))`. 3 rounds: R1 | R2 | R3. 4: R1-2 | R3 | R4.
  6: R1-2 | R3-4 | R5-6. 8: R1-3 | R4-6 | R7-8. 12: R1-4 | R5-8 | R9-12.
- MIGRATION (SaveGame): each old arrow becomes a line with the same move in all three cells; `plan_combo` becomes
  combos[0] with `go_to` and uses [2, 2, 2]; `round_pace` becomes `pace`; body [0.2, 0.2, 0.2]. `f["arrows"]` stays as a
  derived mirror (= phase 0 arrows) until every reader moves (FilmEdge, PlanLines.strength, PlanTest.run).
- A save whose old plan already uses `feint` seeds the new Feint setup mastery at 30 so no old plan gets weaker.

---

## 3. Rules, with numbers

### 3.1 Phases

- Every line row has one cell per phase; a cell may be empty (`off`). The same row may hold a different move per phase
  (`MID when presses`: Pivot | Slip 2-3 | Pivot).
- LIMITS COUNT PER PHASE: lines active in a phase <= `PlanBoard.arrow_limit(coach)` (4 new coach .. 9 top coach); this is
  how a real coach fits a long plan (the corner gives 1-2 points a minute, the fighter keeps the phase's plan, REALPLANS
  s1). Combo slots for the whole plan = 1 + floor(arrow_limit / 3) (v1: 2 / 3 / 4).
- HOLDS (section 3.11) also counts per phase.
- The corner's one change a round (`PlanFight.corner_change`) edits the current phase's cell and every later cell of
  the same row that held the same move.

### 3.2 WHEN chips: game + score/clock

Condition ids and what makes them true in an exchange (ctx built in `PlanExchange` from `LiveRound` state):

| id | true when | source |
|---|---|---|
| (game) press / range / counter / loadup / tiring / hurt / she_tired / she_hurt | `Exchanges.situation(...)` this exchange | exists |
| `ahead` | closed rounds won > closed rounds lost (round 1: never) | match rounds in `m` |
| `behind` | closed rounds won < closed rounds lost | same |
| `last30` | exchange index i == 5 (the round's last 30 s) | `Exchanges.EXCHANGES - 1` |
| `rN+` | round n >= N | n |

PICK ORDER on a card (`PlanBoard.pick` gains `cond` and a ctx; old two-argument calls keep today's result):
1. a line whose game chip AND score/clock chip both hold;
2. a line whose game chip OR score/clock chip holds (game first on a tie);
3. a due COMBO use whose chain starts on this card (section 3.7);
4. the card's any-time line;
5. his instinct (`PlanFight.choose` today: the first doable move out of the card).

VALIDATION (`PlanBoard.validate` per phase): one cell per (at, when, cond); a forced move cannot be planned; a move must
start on the line's card (a mix: every option).

Real basis: score/clock is the most needed gap in REALPLANS s5 (8 of 23 plans: Leonard, Taylor-Ochigava, Lopez, the
wrestling finals). Effect in the sim: none on its own; it chooses WHICH item fires.

### 3.3 MIX on a line

- A cell may hold 2-3 options with shares in steps of 10, each 20-60, sum 100. All options start on the line's card.
- WHEN IT FIRES: one roll on the plan's own dice (`PlanExchange` rng stream "mix") picks the option by share. The rest
  of the exchange is the picked option exactly as a single line.
- VALUE (projection and `PlanLines.strength`): sum of share x `PlanFight.value(option, sit, rate(option))` minus the
  card mean. A mix is never better on average than its best option: the payoff is the read.
- READ: each option has its OWN read meter and fills only when that option fires (section 3.10). A 50/30/20 mix fires
  each option at half, 0.3 and 0.2 of the line's rate, so each meter fills 2x / 3.3x / 5x slower than a single line.
- SAME LOOK: options and plan items that open with the same LOOK (jab look: jab, 1-1, 1-2, 1-1-2, body jab, feint; cross
  look; hook look; step look) make her guess. Her counter's land chance on an item is multiplied by
  `look_share = item's projected fires / all items' projected fires with that look in the phase`. This replaces v1's
  "same look -0.5 tells" rule. It is how "change the jab so he can't time the 1-2" pays.
- HEAD SPACE: a mix counts 1 + 0.25 per extra option toward HOLDS (2 options 1.25, 3 options 1.5).
- PAD TIME: a mixed line on the week's drill list splits its pad minutes by share (section 5a).
- Example vs Maria Ortega (eye 74, trigger 0.80): single `1-1` line firing 2 a round reads 0.37 a round; as `1-1 50 /
  jab 30 / body jab 20` the 1-1 meter fills 0.19 a round and her land chance on it is x0.5 by look share.

### 3.4 Circling and pivots (new StrikeMap rows)

| id | name | kind | from | to | fits (best / ok / wrong) |
|---|---|---|---|---|---|
| `circle` | Circle off | step | long | long | best: press, she_tired / ok: loadup, counter, she_hurt / wrong: tiring, hurt |
| `pivot_out@mid` | Pivot and turn | step | mid | long | inherits `pivot_out` (press best, loadup ok, she_tired ok, she_hurt best) |
| `pivot_out@clinch` | Turn him onto the ropes | step | clinch | opp_ropes | inherits `pivot_out` |

- `pivot_out@clinch` is the "hold and turn him" of the acceptance plan (REALPLANS gap 2, clinch as a weapon, only the
  turn; leaning and shoving stay out). It sits under approved item (3) as a pivot in the clinch.
- Gas: 1 pip (0.12 of the tank) a throw; 2 pips when her game is press or loadup (v1 rule for moving under fire).
- Mastery: one learnable setup `Pivot` (section 3.5) rates `circle`, `pivot_out@mid` and `pivot_out@clinch`; under 30
  they play at `PlanBoard.UNDRILLED` 0.8. `pivot_out` off the ropes stays free (survival; balance unchanged).
- `PlanFight.STEP_BEAT` gains circle -> "slip" (lateral), pivots -> "slip".

### 3.5 Setups: single jab, body jab, feint

New StrikeMap rows (kind `setup`, a single action that may stand alone on a line or OPEN a stitched chain):

| id | name | from | to | fits (best / ok / wrong) | mastery |
|---|---|---|---|---|---|
| `jab` | Jab | long | long | best: counter / ok: press, range / wrong: - | the Jab punch (`f.moves`) |
| `body_jab` | Body jab | long | long | best: range / ok: counter, press / wrong: loadup | setup `Body jab` |
| `feint@long` | Feint | long | long | best: counter / ok: range, loadup / wrong: tiring, hurt | setup `Feint` |

- Setup masteries live in `f["setups"]` = {"Body jab", "Feint", "Pivot"}, NOT in `f["moves"]`: `BoutRules.weapons`
  counts every key of `f["moves"]`, so adding them there would inflate `weapons_edge` (test pins this).
- Start values for a recruit: Body jab 0.4 x technique, Feint 0.3 x fight_iq, Pivot 0.5 x footwork (typical 22 / 18 /
  30). A brand-new fighter can start at 0. Learning: the week's `learning` slot (`Sim.drill_week`, LEARN_MINUTES 420 on
  pads): 0 -> 30 in 2 weeks with a coach rated 50, 3 without; from 22 it takes 1 week.
- In a chain (`ComboFlow.MOVES`): `body_jab` {hand lead, level body, kind punch, loads rear} (a real punch: gas 2 pips
  first, level change with a head punch scores `BONUS_LEVEL_CHANGE` 10); `feint` {kind setup, loads rear}: gas 1 pip,
  `BONUS_SETUP_FIRST` +6 when it opens (same as step-in first), `-0.5` tells (rhythm breaker). `OwnCombos.PUNCH_OF` adds
  `body_jab -> "Body jab"`; a feint is not a punch, so "feint, 1-2" is a 2-punch own combo.
- Fit of a chain that OPENS with a setup: the core punches' fit, raised one step (wrong -> none -> ok -> best) vs
  counter (feint) or range (body jab). Real basis: PlanFight's own comment ("counter: feint, single jabs"), REALPLANS
  gap 6 (jab variants: Inoue, Lopez, Ali, Mayweather).

### 3.6 Footwork chains

Kept from v1: a stitched chain mixes punches and steps ("1-2 -> step out" = [jab, cross, step_back]). Its plan row:
`from` = the card its first move needs (jab/feint/body jab/cross -> long, hook/uppercut/slip -> mid, step_in -> outside),
`to` = the range track's last stop. Fit: the chain's punch core matched to the nearest book id (`PlanFight.fit`), raised
one step when the exit step is itself `best` vs the situation (1-2 then step out vs a presser: none -> ok). Exit score
`ComboFlow.BONUS_EXIT` 10 already exists.

### 3.7 Combos: slots, uses per round, WHEN

- Slots: 1 + floor(arrow_limit / 3). Slot 1 = the go-to star (PLANCOMBO1, `OwnCombos.named`, NAMED_SHARE 0.40 stays).
- Uses: 0-3 per round, set per phase; all combos together <= 4 of a round's 6 exchanges. ONE USE = the chain thrown
  twice in that exchange (v1 THROWS_PER_USE 2; 4 uses x 2 = 8 = `Combos.uses` cap).
- A combo may carry a WHEN chip (game and/or score/clock): its uses then count only in exchanges where the chip holds
  ("if he's slowing, let 1-2-3b go").
- DUE: a use fires on the first exchanges of the round whose card is the chain's start card and whose WHEN holds, until
  the round's uses are spent (pick order step 3). Visits above the round's real visits to that card show `rare`.

### 3.8 HEAD / BODY share per phase

- A bar per phase in the round header, 0-60 % body in steps of 10, default 20 (`Exchanges.BODY_SHARE` 0.2).
- IN THE RING: `LiveRound.exchange` uses it for `share_a` (our body shots) unless a shout-bar aim overrides that exchange
  (`PaceAim.body_share`, unchanged).
- TANK: each body shot she takes costs her `Exchanges.BODY_COST` 1.2 energy for the rest of the fight. At ~3.5 landed a
  30 s exchange (21 a round, even bout), 20 % body = 4.2 body shots = -5.0 of her tank a round; 40 % = 8.4 = -10.1. So
  40 / 40 in R1-2 puts a presser under `OPP_TIRED` 45 about a round earlier, and `Exchanges.next_mode` sends her
  into `tiring` (75 % chance an exchange) sooner.
- BODY MAP: body shots land on her ribs (`BodyMap.RIB_HIT` 1.5 a shot vs `HEAD_HIT` 0.55); the post-fight body view and
  her fade both follow the slider.
- COST: each +10 % over 20 costs -0.5 power points an exchange (getting inside to dig; same scale as `PaceAim.AIM_COST`
  1.5 for a 0.5 body aim). No cost when her game is `tiring` (`PaceAim.BODY_ON_TIRED_EDGE` logic).
- HER GUARD follows your aim one round late: guard g starts 0.2; after each round g = 0.5 g + 0.5 x that round's share.
  When you go UP after the body (share < g), each exchange gets +clamp(6 x (g - share), 0, 2) ("dig the body and the head
  opens"). Example: 40 / 40 then 10: g = 0.35 at R3 -> +1.5 an exchange in R3. Going down after head work gives no
  bonus (the body shots and her tank are the payoff).
- BALANCE GATES (stage 4): no schedule beats flat 20/20/20 by more than +0.04 win share vs an even opponent; 40/40/10
  beats flat by >= +0.02 vs a `fades_late` presser; 60/60/60 loses to flat vs an out-boxer.

### 3.9 Stamina per card (no AP)

Kept from v1 (`ComboFlow.energy`, pips = tenths of a tank point, exact on hover): first punch 2 pips (0.23), each later
punch 3 (0.32), step / slip / roll / pivot / circle 1 (0.12; 2 under press or loadup), feint 1, hop in 2, body jab = a
punch. Examples: 1-1 = 5, 1-2-3 = 8, 1-2-3-2 = 11, "1-2, step out" = 6, "feint, 1-2" = 6.
NEW, mastery sets the cost: x1.10 RAW (< 30), x1.00 USABLE, x0.95 SHARP (60-84), x0.90 SIGNATURE (85+), on top of
`SkillAwards.economy_ids` (graded moves). Round gas = `PlanGas.round_spend(...)` = `Combos.round_spend` with the plan's
real chains x their uses; an empty plan returns today's number exactly (test). `BoutNight.gd:291` and the page's tank bars
call the same function. Measured v1 bells at conditioning 50, steady: 68 / 46 / 29.

### 3.10 The read meter per item (TheRead mirrored onto our plan)

Kept from v1, with these v2 changes marked NEW:
- Her eye = rating + jitter -8..+8 (seeded). `looks_needed = TheRead.looks_needed(eye, film=false)`: 16 at 40, 11.1 at
  60, 7.7 at 74, 5.0 at 85+ (Milazzo 2016).
- Tells per fire: 1.0 + 0.5 per move after the first, +1.0 rear power opener, -0.5 per slip/roll/step/feint (max -1.0);
  a plan line counts 1.0 per punch, 0.75 per step/tie-up/pivot.
- NEW disguise from fight_iq (operator: "fight_iq hides patterns"): x clamp(1.2 - 0.004 x fight_iq, 0.85, 1.10)
  (iq 60: x0.96; iq 85: x0.86).
- NEW mastery hides it too: x1.0 RAW/USABLE, x0.9 SHARP, x0.8 SIGNATURE. Floor 0.75 tells.
- NEW CAP: one fire adds at most 0.25 read, so nothing is read in under 4 fires (Undisputed's "too fast reads as
  cheating" backlash; FOR_PLAYBOOK "avoid" 3).
- COUNTED ONLY WHEN THAT ITEM FIRES (a mix option, a line cell, a combo use). Off-plan throws count on the item they
  match. Every read drops 0.10 at each bell.
- Trigger by her main game: counter 0.55, range 0.70, press 0.80, loadup 0.85. She counters when the item fires and her
  read from BEFORE this fire is at or past the trigger (she must have seen it already), at most once a round per item; lands with read x (0.5 + 0.5 x rating/100) x look_share (NEW, 3.3). Landed: -7 (`TheRead.EDGE_LANDED`),
  the chain's tail is cancelled (not whole, no `LONG_EXTRA`). Missed: +5. Two landed = SOLVED: x0.4 for the bout unless
  the corner swaps it.
- Tape: rated 55+ opponents start each item at +0.10 per recent fight (of his last 3) where it fired 3+ times, max 0.30;
  rematch = max(tape, 0.5 x last read) (`OppFile.remember` keeps `their_read`).
- Worked numbers vs eye 74 (looks 7.7), fight_iq 60: 1-1 1.44 tells -> 0.19 a use; "1-2, step out" 1.44 -> 0.19;
  slip 2-3 1.44 -> 0.19; 1-2-3b 1.92 -> 0.25 (at the cap); single jab 0.96 -> 0.12. The go-to 1-1 at 2/1/1 uses over 6
  rounds, no tape: bells 0.27 / 0.55 / 0.64 / 0.72 / READ in R5 (0.91). The same 1-1 at SIGNATURE with iq 75 (1.08 tells,
  0.14 a use): 0.18 / 0.36 / 0.40 / 0.44 / 0.48 / 0.52, never read. Drilling to signature is the long-term answer.

### 3.11 How each fighter carries it (traits per playthrough)

Kept from v1 (HOLDS, STICKS, UNDER FIRE, WHERE HE GOES, TIRED FAVOURITE, habit tells, reveal over time, seeded rng
`c.seed x 7919`). v2 changes:
- HOLDS = clamp(4 + round((fight_iq - 40) / 12), 4, 8), counted PER PHASE. Item weights: a line cell 1, a mix 1 + 0.25
  per extra option, a combo slot 1, an item at SIGNATURE 0.5 (drilled to habit), a line that equals his instinct on
  that card 0 (he does it anyway). Items past HOLDS (bottom rows) are followed at STICKS x 0.6 and show `half` on hover.
- STICKS = clamp((0.60 + 0.003 x discipline + 0.002 x coachability) x trust, 0.5, 0.97). Under fire x0.5 (x0.4 at
  temper >= 70). A score/clock line still obeys STICKS: "if you're ahead, box" can be dropped by a brawler when hurt.

---

## 4. What each rule changes in the sim

| rule | function (file) | change |
|---|---|---|
| phases | `LiveRound.open` (state/LiveRound.gd:61) | set `f.bout.arrows = PlanWhen.arrows_for(plan, n, rounds)` every round, keep corner changes |
| pick order, score/clock | `PlanBoard.pick` (rules/PlanBoard.gd), `PlanFight.choose` | new optional args `cond`, `ctx`; old calls unchanged |
| mix | `PlanExchange.pick_option` (NEW state/PlanExchange.gd) | rolls the option before `PlanFight.choose` |
| item worth | `PlanFight.edge` / `PlanFight.value` | value x (1 - 0.6 x read) for the fired item; `rate()` covers setups, pivots, own chains, mix options (0.8 under 30) |
| circling, pivots, setups | `StrikeMap.MOVES` rows + `PlanFight.ANSWERS` (rules/StrikeMap.gd, PlanFight.gd) | 5 new rows (3.4, 3.5); ANSWERS lists gain `circle`, `jab`, `body_jab`, `feint` |
| chains | `ComboFlow.MOVES`, `OwnCombos.row`, NEW `PlanChains.row` | body_jab punch, feint setup; a chain's from/to/fit |
| the exchange | `LiveRound.exchange` (state/LiveRound.gd:168) | the plan block (lines 242-255) moves to `PlanExchange.run(...)`: pick, mix roll, carry roll, their read, counter, solved, gas; returns `d` delta + record |
| their read | NEW rules/PlanRead.gd, mirrors `TheRead` | uses `TheRead.looks_needed`, `land_chance`, `punish` semantics on OUR items |
| her adaptation | `Exchanges.next_mode` (rules/Exchanges.gd:182) | NEW READ_BAIT: while one of our items is READ and not SOLVED, every game whose `PlanFight.GAME_CARD` is that item's start card gets +0.2 weight (she invites it to counter it); body work keeps reaching `tiring` through her energy |
| head/body | `LiveRound.exchange` `share_a` (line 281), NEW rules/PlanTarget.gd | share per phase, cost -0.5 / +10 %, guard bonus |
| gas | NEW rules/PlanGas.gd, `BoutNight.gd:291` | `round_spend` with planned chains x uses, mastery cost tiers |
| tally | `PlanFight.tally`, `PlanRecord.summary` | per item: `[won, used, read_landed]`; mix options keyed `line:at:when:cond#id` |
| corner | `PlanFight.corner_change`, `BoutNight.gd:180` | edits the phase cell (3.1); a READ item offers "Swap in: <drilled spare>" |

---

## 5. TRAINING WIRING (every link both ways)

The EA core (operator S354): AM sessions sum to a goal + intensity; PM = the combo planner; the fight plan. The Playbook
is the third mechanic and must feed and be fed by the other two. Numbers below use a coach rated 50, technique 50,
fight_iq 60 (cap 72) unless stated; all gains are `MoveMastery.gain` (pads 2.1 / h x coach (1 + 0.4 x skill/100) x room
(1 - m/cap)).

### 5a. Plan -> the week's pad sessions (PM) and back

| link | plan -> training | training -> plan |
|---|---|---|
| drill list | NEW `PlanDrill.week_list(f)` builds the week's pad list from the plan: (1) plan items under 30 (they play at 0.8), (2) the go-to under 85, (3) mixed-line options by share; at most 3 items | the Playbook row shows `drilling` on those items; the Training tab's `ComboPlanner` (ui/ComboPlanner.gd) shows the same list and its "Drill this week" edits it (one list, two views) |
| pad minutes | `Sim.drill_combos` (state/Sim.gd:322) loops the list instead of one `combo_learning` id; minutes = `COMBO_MINUTES` 240 x `TrainingPlan.pads_factor` (0-2) x pad nights / 6 (`WeekPhase.pads`: 6, taper 3, film week 5), split equally, a mix by its shares | mastery rises -> the cell loses `drill` at 30 (rate 0.8 -> 1.0), SHARP at 60 (read x0.9, gas x0.95), SIGNATURE at 85 (read x0.8, gas x0.9, half a head slot) |
| one item = today | a list of one item at 240 min reproduces today's `drill_combos` exactly (pinned by test) | - |
| weeks to usable (30) | 2-move combo 4 weeks, 3-move 6, 4-move 8; film week 5 instead of 4; taper-only (3 nights) 8 | the cell's hover: "drill: 4 weeks at this week's pads" |
| MIX costs pad time | 1-1 50 / 1-1-2 30 / feint 20 on 240 min: 1-1 8 weeks, 1-1-2 19 weeks, feint 10 weeks to 30 | the mix card warns `drill` on any option under 30: mix what is drilled |
| setups and circling | NEW `Data.SETUPS` = Body jab, Feint, Pivot learn in the `learning` slot (`Sim.drill_week`, LEARN_MINUTES 420): 0 -> 30 in 2 weeks (3 without a coach), 22 -> 30 in 1 | a setup under 30 shows `drill`; the left row's `Drill it` sets `f.learning` to it; the plan default sets it when a planned setup is under 30 |
| decay | an item not drilled loses 0.75 a week, never below 30 once usable (`MoveMastery.decay_week`) | an old plan stays playable |
| AM -> plan | the morning sessions (WeekPlan days, `CampForecast.run` forecast) move the stats the plan reads: conditioning -> bells (cond 30: 66 / 41 / 22, 50: 68 / 46 / 29, 70: 71 / 51 / 36); speed -> finish length (`RoundStyle.combo_cap`: 1 + (speed >= 58) + (speed >= 66)); technique + fight_iq -> mastery cap (40 + 0.4 tech + 0.2 iq); fight_iq -> HOLDS and disguise | the plan's GAS and FINISHES tiles read the FORECAST stats on fight night, so raising AM intensity shows on the plan the same day |
| AM fatigue -> PM | NEW: pad efficiency in `MoveMastery.gain` = 1.0 under week fatigue 60, falling to 0.8 at 80 (tired pads are sloppy) | the week view's evening cell shows `sloppy` over 60 |

### 5b. Camp <-> plan

| link | numbers and function |
|---|---|
| camp pad nights default to the plan | `Bouts.start_camp` (and each camp Monday) sets the drill list from `PlanDrill.week_list` unless the player set one; the Camp modal (ui/modals/Camp.gd, branch claude/camp2) shows the go-to + mixed lines as ink cards on the pad-night row |
| protocol sets pad volume | Light 3 / Standard 4 / Hard 5 club nights (camp2 PROTOCOLS `nights`); `BoutRules.camp_evening` drill share 0 / 0.05 / 0.09 stays on the camp stat; plan minutes scale with pad nights / 6 |
| not drilled | a line or combo under 30 shows `drill` and plays at `PlanBoard.UNDRILLED` 0.8 (`PlanFight.rate`, now also for setups, pivots, chains, mix options) |
| sparring nights = plan tests | Build 1, Peak 2, taper 0 (`WeekPhase.PHASES` spar). NEW `PlanSpar.night(f)`: one simulated 3-round spar of the CURRENT plan vs the partner (Partner card matching her stance/style = her style at the fighter's rating; club mates = Boxer-puncher at rating - 5). It records `[won, used, read_landed]` per item into `f.spar_rec` (grey chips on the rows), reveals one `?` trait (PlanCarry), and gives each thrown item ring-sparring practice (`ring_sparring` 1.5 / h x 30 min split over items: about +0.9 each). Spar reads do NOT carry into the bout (a different reader). |
| film | camp2 `FilmEdge.answered` / `PlanLines.answers`: each found tell answered by a plan line or drilled combo = +0.4, max +1.2 (`BoutRules.film_edge`); film takes one Build pad night (`WeekPhase.film_night`: pads 6 -> 5, so plan minutes x5/6 that week). The HER TELLS group is the same rows. |
| focus card thresholds | the camp focus card's threshold line names the plan item it unlocks: speed 66 -> "1-2-3b finishes whole", power 60 -> body call strong, conditioning -> R3 bell |

### 5c. Mastery and attributes set each card's cost, lands-whole odds and read speed

| tier (mastery) | play rate | gas x | lands whole (worth -> `ComboOdds.win_odds`) | read x |
|---|---|---|---|---|
| RAW < 30 | 0.8 (`UNDRILLED`) | 1.10 | worth 2.4 -> 0.536 | 1.0 |
| USABLE 30-59 | 1.0 | 1.00 | 3.0 -> 0.544 (flows: 5.0 -> 0.573) | 1.0 |
| SHARP 60-84 | 1.0 | 0.95 | NEW SHARP_EDGE +1: 4.0 -> 0.559 (flows 6.0 -> 0.587) | 0.9 |
| SIGNATURE 85+ | 1.0 | 0.90 | 10 (cap) -> 0.640; long signature 5.5 -> 0.580 | 0.8 |

Attributes: fight_iq -> HOLDS (4-8) and disguise (x0.86-1.10 tells); technique + fight_iq -> mastery cap; speed ->
finish length; conditioning -> round spend (`Combos.spend_factor` 1.2 -> 0.8); discipline + coachability -> STICKS;
heart / confidence / work_rate -> under-fire break; footwork -> Pivot start value.
Functions: `OwnCombos.worth` / `lands_whole` (+SHARP_EDGE), `PlanRead.tells` (iq + tier), `PlanGas.card_cost` (tier),
`PlanCarry.holds` (signature half slot).

### 5d. After the fight: PlanRecord suggests next week's drills

- `PlanRecord.summary` adds `read_landed` per item; `PlanRecord.rates` / `verdict` keep MIN_USED 6, WORKS 0.55, FAILS 0.35.
- NEW `PlanDrill.suggest(f, results)` -> at most 3 suggestions, pre-filled into next week's drill list (the player
  confirms on the Playbook or the Training tab):
  1. an item SOLVED (2 counters landed) or READ in 2+ rounds -> "drill a spare": the best-fit item on the same card not
     in the plan, or a mix option to add;
  2. `fails` -> the best answer on that card vs her game (`PlanLines.options` top row);
  3. `works` and under 85 -> keep drilling it toward signature (slower read, half a head slot);
  4. fired 0 times in a bout -> "rare: drop it" (no drill).
- Tape on us: `OppFile.remember` keeps her reads; the next 55+ opponent starts from our last 3 fights, so the
  suggestions prefer fresh items when our go-to carries 0.20-0.30 tape read.
- The coach's post-fight note names one suggestion in one line; the Film card shows which answered tells fired.

---

## 6. Build stages (each file < 500 lines; tests per stage; run every dependent test after a data change)

Merge first: `claude/camp2` (FilmEdge, PlanLines.answers/tell_sit, halved edges) - stages 5 and 8 build on it.

| stage | files (budget) | tests |
|---|---|---|
| 1 DATA | StrikeMap.gd (+5 rows, ~135), PlanFight.gd ANSWERS (+~10, ~255), ComboFlow.gd MOVES (body_jab, feint, hop_in; ~240), Data.gd SETUPS + start shares (~250), SaveGame.gd migration v2 (+~60) | strike_map: rows, routes still reach every card; plan_fight: fits of new ids; combo_flow: body jab level change +10, feint opener +6; save_migration_v2: old arrows -> lines x3, plan_combo -> combos[0] uses [2,2,2], feint seeds 30; weapons_edge unchanged with setups present. Then ALL dependent tests (plan_*, combo_*, the_read, habit_fix, playtest_s375, tieup_plan, plan_templates). |
| 2 PLAN SHAPE | NEW PlanWhen.gd (phases, conds, arrows_for, validate per phase; ~220), PlanMix.gd (~140), PlanChains.gd (~150), PlanTarget.gd (~120); PlanBoard.pick/validate (+cond; ~200) | plan_when: phase table for 3/4/6/8/12 rounds, pick order 1-5, per-phase limit, old two-arg pick unchanged; plan_mix: shares validation, roll frequencies within 0.03 over 2000 rolls, value = weighted sum; plan_chains: from/to/fit incl. exit upgrade; plan_target: guard series, cost, no tiring cost |
| 3 RULES | NEW PlanRead.gd (~260), PlanCarry.gd (~220), PlanCombos.gd (~180), PlanGas.gd (~150) | plan_read: worked numbers of 3.10 (0.19 / use, cap 0.25, look_share, bell drop, solved), signature 1-1 never read in 6; plan_carry: HOLDS per phase incl. mix/signature/instinct weights; plan_combos: uses cap 4, due order, WHEN on combos; plan_gas: empty plan == `Combos.round_spend` exactly, tier factors |
| 4 RING | NEW state/PlanExchange.gd (~300) lifted out of LiveRound.exchange (LiveRound 467 -> ~430); LiveRound.open per-round arrows; BoutNight.gd:291 PlanGas, :180 corner per phase; Exchanges.next_mode READ_BAIT (+~12) | plan_bout + NEW plan_balance (400 bouts a case): even win share 0.60 +/- 0.08; repeat-one-combo loses to a 3-item mix vs an 85 counter-puncher and wins vs a 40; best plan size between 3 and HOLDS; head/body gates of 3.8; projected reads within 0.10 of the sims; READ_BAIT raises countered fires, not win share by more than -0.03 |
| 5 TRAINING | NEW PlanDrill.gd (week_list, minutes, suggest; ~220), PlanSpar.gd (~160); Sim.drill_combos loop + drill_week setups (Sim.gd ~ +40, file stays < 500), MoveMastery.gain efficiency from fatigue; ComboPlanner.gd reads the list; Camp.gd pad-night cards (camp2); PlanRecord.summary read_landed | plan_drill: single item at 240 == today's drill_combos; mix split minutes; weeks-to-30 table of 5a; taper/film scaling; setups via learning slot 2 weeks; suggest() cases 1-4; plan_spar: records, reveal, +0.9 practice, no carry into the bout; training_plan / week_plan / combo_plan stay green |
| 6 PAGE SHELL | Playbook.gd (picker + 3 columns), NEW MoveColumn.gd (~300), CarryStrip.gd (~150); Data.gd tabs [] | route['tab'] tests updated (move_book, combo_builder, game_plan, plan_screen, playtest_s375, bjj_mat); move_player_probe green; .exe built and played on his Samsung |
| 7 CENTRE | NEW StitchBar.gd (~400), OppStrip.gd (~250), PlanTable.gd (~480; split PlanCell.gd ~200 if it grows); delete GamePlan.gd (550, over the cap), trim ComboBuilder.gd | plan_table_ui: every cell word of 1.1 from fixtures, mix picker, WHEN chips, phase cells, head/body bar, holds header; UI probe: every old tab function reachable; ACCEPTANCE TEST (section 7) |
| 8 FILM ON THE PAGE | HER TELLS rows from FilmEdge.rows (camp2) | film_page: answered count matches FilmEdge.summary |
| 9 PLAYER | BoxMap segments per card incl. circle, pivot, body jab, feint (agent seats animate, Claude integrates) | eyes gate on every chain (burst + crops, gap/noses/wrists/feet/boots, men bare-chested) |
| 10 ANA | v1 stage 7; WHEN `ahead` / `behind` / `last30` apply to her match (points, clock); mix / setups / head-body do not | bjj_mat, mat_edge |

Left out on purpose until stage 4's balance run is green: leaning/shoving in the clinch, counter from long (REALPLANS
gap 7), split loadup by distance (gap 3), a feint's own edge beyond its tells, the opponent pull-out event.

---

## 7. ACCEPTANCE TEST - the real 6-round coach plan, entered click by click, nothing lost

Source: the coach's notebook plan in the S381 real-plan research (pro orthodox boxer vs a pressure fighter, 6 rounds).
Today's format loses 8 things (research "LOST IN TRANSLATION": round phases, the 1-2 THEN step out chain, change the
jab, circling at long/mid, score/clock, body jab / feint setup, head/body share, any cost for repeating). This test enters
it on the v2 page and asserts every sentence lands in a plan element.

Fixture: male boxer, orthodox, coach rated 54+ (arrow_limit 6), opponent `Pressure fighter` rated 72, 6 rounds ->
phases R1-2 | R3-4 | R5-6. File: NEW `tests/plan_realplan_test.gd`; it drives the same functions the page calls
(`PlanWhen.set_cell`, `PlanMix.set`, `PlanCombos.set_uses`, ...) and, in stage 7, the page itself through the UI probe.

### 7.1 Clicks

| # | click | result in `f.plan` |
|---|---|---|
| 1 | fighter chip, opponent strip shows "Pressure fighter, 6 rounds" | phase headers R1-2 / R3-4 / R5-6 |
| 2 | LINES `+` -> OUTSIDE picture -> any time -> R1-2 cell -> `Double jab, cross` | L1 outside / - / - : [1-1-2, off, off] |
| 3 | LINES `+` -> LONG -> any time -> all phases -> MIX -> Jab / Body jab / Feint -> sliders 40 / 30 / 30 | L2 long: mix [[jab,40],[body_jab,30],[feint@long,30]] x3 |
| 4 | LINES `+` -> LONG -> WHEN `presses` -> R1-2 -> `Circle off` | L3 long/press: [circle, off, off] |
| 5 | COMBOS slot 1 (star) -> book chip `1-1` -> steppers 2 / 1 / 1 | C1 1-1 go_to, uses [2,1,1] |
| 6 | STITCH: Jab, Cross, Step back -> join words good/good -> Save to book ("1-2, step out") -> Into the plan -> steppers 2 / 1 / 0 | C2 own:N [jab, cross, step_back], uses [2,1,0] |
| 7 | LINES `+` -> MID -> WHEN `presses` -> R1-2 `Pivot and turn`, R3-4 `Slip, cross, check hook`, R5-6 `Pivot and turn` | L4 mid/press: [pivot_out@mid, slip 2-3, pivot_out@mid] |
| 8 | LINES `+` -> ON THE ROPES -> any time -> all phases -> `Pivot off the ropes` (cell shows it equals his instinct: weight 0) | L5 own_ropes: [pivot_out x3] |
| 9 | LINES `+` -> MID -> WHEN `loads up` -> R3-4 -> `Slip, cross, check hook` | L6 mid/loadup: [off, slip 2-3, off] |
| 10 | LINES `+` -> INSIDE -> any time -> R3-4 -> `Tie up` | L7 inside: [off, tie_up, off] |
| 11 | LINES `+` -> CLINCH -> any time -> R3-4 -> `Turn him onto the ropes` | L8 clinch: [off, pivot_out@clinch, off] |
| 12 | COMBOS slot 3 -> book chip `1-2-3b` -> WHEN `tiring` -> steppers 0 / 0 / 2 | C3 1-2-3b when tiring, uses [0,0,2] |
| 13 | LINES `+` -> LONG -> score chip `ahead` -> R5-6 -> MIX Jab / Circle off 60 / 40 | L9 long/cond ahead: [off, off, mix [[jab,60],[circle,40]]] |
| 14 | LINES `+` -> MID -> clock chip `last 30` -> R5-6 -> `Pivot and turn` | L10 mid/cond last30: [off, off, pivot_out@mid] |
| 15 | round headers: pace R1-R4 steady, R5 push, R6 steady; head/body left at 20 / 20 / 20 | pace [steady x4, push, steady]; body [0.2,0.2,0.2] |

### 7.2 Every sentence and the element that holds it

| sentence (coach's words) | plan element | v2 feature used |
|---|---|---|
| R1-2 "Take the centre" | L1 OUTSIDE R1-2: Double jab, cross (jab back to the middle) | phases |
| R1-2 "jab" | L2 LONG any time: the jab mix | mix |
| R1-2 "and turn him" | L3 LONG when he presses R1-2: Circle off | circling at long |
| R1-2 "double jab" | C1 go-to 1-1, 2 uses a round in R1-2 | combos, uses, go-to star |
| R1-2 "1-2 and step out" | C2 own chain [jab, cross, step_back], 2 uses a round in R1-2 | footwork chain |
| R1-2 "never back up straight" | L4 MID when he presses R1-2: Pivot and turn (no step-back line exists; the starter plan's "step back" at mid is replaced) | pivot at mid |
| R1-2 "turn off the ropes" | L5 ON THE ROPES: Pivot off the ropes, all rounds | existing row, instinct weight 0 |
| R3-4 "Make him pay coming in" | L4 MID when he presses R3-4: Slip, cross, check hook | phase cell change |
| R3-4 "when he loads the right, slip and come back 2-3" | L6 MID when he loads up R3-4: Slip, cross, check hook | phases |
| R3-4 "hold" (inside) | L7 INSIDE R3-4: Tie up | phases |
| R3-4 "and turn him inside" | L8 CLINCH R3-4: Turn him onto the ropes | pivot in the clinch |
| R5-6 "If he's slowing, stand and let 1-2-3b go" | C3 1-2-3b WHEN tiring, 2 uses a round in R5-6; pace R5 push | WHEN on a combo, pace |
| R5-6 "if you're ahead, box" | L9 LONG WHEN ahead R5-6: mix Jab 60 / Circle off 40 | score chip, mix with a step |
| R5-6 "and stay off the ropes the last 30 s" | L10 MID WHEN last 30 R5-6: Pivot and turn (+ L4 R5-6 pivot when he presses, + L5) | clock chip |
| Throughout "Change the jab" | L2 mix runs in all three phases | mix |
| Throughout "(single, double, to the body, feint it)" | single = L2 Jab 40; double = C1 1-1; to the body = L2 Body jab 30; feint it = L2 Feint 30 | setups, mix, combos |
| Throughout "so he can't time the 1-2" | SAME LOOK: L2's three options, C1 and C2 all open with the jab look, so her counter on C2 (the 1-2) lands x look_share (R1-2: about 2 of 6 jab-look fires = x0.33) | read meter + look share |

Nothing is lost: 17 of 17 parts land in an element. Repetition now has a cost (the read meter on each item), which was
the eighth loss.

### 7.3 Limits the page must show (asserted, not errors)

- Lines per phase vs arrow_limit 6: R1-2 = L1, L2, L3, L4, L5 = 5; R3-4 = L2, L4, L5, L6, L7, L8 = 6; R5-6 = L2, L4, L5,
  L9, L10 = 5. All fit a coach rated 54+. A new coach (4 lines, 2 combo slots) is refused at step 8 (5th R1-2 line),
  step 10 (5th R3-4 line) and step 12 (3rd combo slot); each refusal names the phase ("R3-4: this coach holds 4") and the
  test asserts those three refusals with a 4-line coach.
- Combo slots: 3 used; arrow_limit 6 -> 1 + 2 = 3 slots. Uses: R1-2 4 of 6, R3-4 2, R5-6 3 (C1 1 + C3 2): all <= 4.
- HOLDS per phase (weights 3.11): R1-2 = L1 1 + L2 1.5 + L3 1 + L4 1 + L5 0 + C1 1 + C2 1 = 6.5; R3-4 = 1.5 + 1 + 0 + 1 +
  1 + 1 + C1 1 + C2 1 = 7.5; R5-6 = 1.5 + 1 + 0 + 1.25 + 1 + C1 1 + C3 1 = 6.75. A fight_iq 64 fighter (HOLDS 6) shows
  `holds 6 · plan 6.5 / 7.5 / 6.75` and the bottom rows of each phase read `half` on hover; at fight_iq 88 (HOLDS 8)
  nothing is half-followed; drilling 1-1 to signature saves 0.5 in every phase.
- Reads (eye 74, trigger 0.80, no tape): C1 1-1 reads `READ` in R5 (0.91, section 3.10); the corner card offers the swap.
  C2 at 2/1/0 bells 0.27 / 0.55 / 0.64 / 0.72 / 0.62 / 0.52: it touches 0.82 after its last R4 throw but never fires
  again, so it is never countered. L2's options each stay under 0.4 (mix). The test asserts the page's cell
  words equal `PlanRead.projected` and that 400 simulated bouts land within 0.10 of it.
- Frequency: words `rare` where the projection says < 1 fire a round (likely L1 and L9: a presser rarely leaves the fight
  at OUTSIDE, and `ahead` needs won rounds). The test asserts the word, not a number.

### 7.4 Pass conditions

1. All 15 clicks succeed in order through the page functions; `PlanWhen.validate` ok for every phase.
2. `f.plan` equals the expected JSON in the test (lines L1-L10, combos C1-C3, pace, body).
3. `PlanWhen.arrows_for(plan, n, 6)` for n = 1..6 gives each round the arrows of 7.2 (spot check: R4 has slip 2-3 at
   mid/press; R6 has the `ahead` mix and the `last30` pivot).
4. A seeded 6-round bout fires at least once: the mix (each option), C1, C2, L4 in two different phases, and the
   `last30` line in R5 or R6 (seed chosen in the test, recorded in it).
5. A save -> load round trip keeps the plan byte-equal.

---

## 8. Open items (Claude decides, listed for the record)

- The `pivot_out@clinch` row goes slightly past approved item (3); it is the "turn him inside" of the acceptance plan
  and inherits pivot_out's fits. Kept unless stage 4's balance run says otherwise.
- The SHARP_EDGE +1, the gas tiers and the fatigue-to-pad efficiency are design values, tuned in stage 4/5 with
  BalanceHarness, then fixed.
- The mix's head-space weight (0.25 per extra option) and the instinct weight 0 are estimates; stage 4's "best plan size"
  test checks them.
- Ana's mat gas stays out until it has its own measured model (v1).
