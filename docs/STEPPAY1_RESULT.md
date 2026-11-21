# STEPPAY1 RESULT (S533) - what each place in the ring is worth today (phase 1 of STEPS_PAYOFF_SCOPE_S533, no game change)

Probe: `tools/place_value_probe.gd` (headless, nothing under scripts/ changed). Run:
`godot --headless --audio-driver Dummy --path . --script res://tools/place_value_probe.gd` (Godot 4.7.2, about 95 s on the box).
Base: main `107c2aea`.

**RESULT: tools/place_value_probe.gd -> PLACE_VALUE done control=ok determinism=ok**

## The answer in one line
No place is an edge. Over 400 exchanges x 3 seed sets per cell, every forced place lies within **-3.0..+3.2 points** of the
control arm for every style, about the size of one cell's own noise (one seed set's 400 exchanges swing 4..10 points; the 95%
band on 1,200 exchanges is about +-2.8). Having the opponent on the ropes (opp_ropes, -2.6..-0.8) or trapped in the corner
(corner, -2.9..-1.2) scores **the same as being on the ropes yourself** (own_ropes, -2.8..-0.2). Long range is the only place
that reads above the control for every style (+1.1..+3.1), and that comes from the plan's lines there, not from the place.

## How the place was forced (and what could not be)
- LiveRound.exchange reads the card at `scripts/state/LiveRound.gd` L235-237 (`lv["at"]`, "" -> `PlanFight.GAME_CARD[sit]`). The
  probe sets `LiveRound.live(m)["at"]` before each exchange and fights it with `BoutNight.fight_step(c, f, m, "shout:")` (the shout
  bar's say-nothing); the next round opens with `BoutNight._open(c, f, m, BoutRules.auto_corner(stats))` under the same stop checks
  as `BoutNight._box_out` (TowelWire.coach_pull, CrackWire.bell). Nothing of the round is reimplemented; RingDuel.settle runs as is.
- **Exchange 0 of each round cannot be forced without a game change**: `BoutNight._open` (L174-203) calls `LiveRound.open`, which
  builds `m["live"]` fresh (LiveRound.gd L110, no "at"), and then fights the first exchange itself (`_shout`, BoutNight.gd L203).
  There is no moment between the two to set the card. Those exchanges are the game's own and are never counted (in any arm).
- Each counted exchange of a forced arm recorded `rec["at"]` == its place (control 3: `off_at=0` on all 48 cells).

## Population (two different fighters, never identical)
Your boxer: TREEVALUE1's 60 generated boxers (`tools/treevalue_probe.gd` `_make_fighter`, seeds 7100..7159: own stats, style word,
stance), the TREEVALUE plan (`TV.PLAN`), moves / steps / combos at 45, amateur 3x3, no coach. Opponent: one shipped boxer per style
(`TV.STYLE_OPP`: Maria Ortega, Jade Cooper, Holly Price, Priya Nair, Erin Doyle, Dana Whitfield) at the TREEVALUE3 calibrated rating
(docs/TREEVALUE3_RESULT.txt: the base plan wins about half its bouts). Cell = the first 400 counted exchanges of bouts in seed order,
for seed sets 0, 10000, 20000 (1,200 a cell).

## Controls
| control | what it shows | result |
|---|---|---|
| CONTROL arm == the game | the probe's driver with `at` left alone vs `Bouts.fight_step(c, f, m, "sim")` on the same seeds, exchange for exchange (won, landed both ways, card), 6 styles | 0 of 400 differ in every style; the game's own share 43.0..45.5 |
| a green control can read worse | the same comparator fed a broken arm (corner forced, Pressure fighter) | 126 of 400 exchanges differ in result or landed - it reads the break |
| the place really took | every counted exchange of a forced arm fought on its place | off_at = 0 on all 48 cells |
| determinism | opp_ropes vs Out-boxer, 400 exchanges, twice in one run; and the whole run twice in two processes | 0 differ; every CELL line identical |

## Table 1 - exchange win share for your boxer by the place the exchange starts at (mean of 3 seed sets, seed spread in brackets)
The opponent's share is 100 minus this (no draws in an exchange). The CONTROL row is the game's own mix of places.

| place | Pressure | Slugger | Out-boxer | Counter | Volume | Boxer-puncher | mean of 6 | vs CONTROL |
|---|---|---|---|---|---|---|---|---|
| outside | 45.1 (42.5..49.0) | 45.6 (41.8..51.0) | 46.3 (44.0..51.0) | 46.8 (44.5..50.8) | 44.8 (43.2..47.8) | 46.6 (43.0..52.0) | 45.9 | -0.3 |
| long | 48.1 (45.2..53.0) | 48.3 (43.8..52.8) | 49.2 (46.8..53.5) | 49.2 (47.5..52.8) | 47.2 (45.0..50.0) | 49.5 (46.5..54.8) | 48.6 | +2.4 |
| mid | 48.4 (44.5..54.2) | 50.0 (46.8..55.2) | 43.3 (40.5..47.5) | 46.1 (44.5..48.2) | 46.1 (43.2..48.5) | 46.8 (43.5..52.0) | 46.8 | +0.6 |
| inside | 44.1 (40.5..48.2) | 46.3 (43.2..51.2) | 45.1 (42.8..49.5) | 45.6 (42.8..49.2) | 43.4 (39.8..47.0) | 45.2 (42.0..51.0) | 44.9 | -1.2 |
| clinch | 42.4 (38.8..47.0) | 44.2 (41.5..49.0) | 45.0 (41.5..50.0) | 45.2 (42.5..48.5) | 42.8 (41.0..46.0) | 45.6 (42.5..51.0) | 44.2 | -2.0 |
| own_ropes | 44.3 (41.5..49.8) | 44.4 (40.8..50.2) | 44.6 (42.0..49.2) | 44.8 (41.5..48.5) | 44.3 (42.2..47.5) | 45.0 (41.8..51.0) | 44.6 | -1.6 |
| opp_ropes | 43.6 (41.5..47.5) | 44.8 (40.5..50.8) | 45.1 (42.8..49.8) | 45.0 (42.5..48.2) | 43.7 (42.2..46.2) | 45.2 (41.8..51.0) | 44.6 | -1.6 |
| corner | 43.8 (41.5..47.5) | 44.7 (40.2..50.8) | 44.9 (42.5..49.8) | 44.7 (42.2..48.0) | 43.2 (41.5..46.2) | 45.2 (41.8..51.0) | 44.4 | -1.8 |
| CONTROL | 45.2 (42.5..50.2) | 47.2 (45.0..51.2) | 46.2 (43.2..50.8) | 47.6 (45.5..51.2) | 44.5 (42.2..47.8) | 46.4 (43.2..52.0) | 46.2 | - |

Both corners: your own_ropes (44.3..45.0) is the opponent's opp_ropes, and your opp_ropes (43.6..45.2) is the opponent's own_ropes.
The trapped side and the side doing the trapping score the same, whichever corner it is.

## What fired there, landed both ways, and the opponent's range game
"*" = the arrow was thrown but not as a planned line (the card's instinct move, or the FireLevel roll / StepWire.holds took the
plan away). Lines are shown for the Pressure fighter cells; the CELL lines in the probe output have all 54.

| place | landed by yours / theirs a exchange (range over 6 styles) | planned line fired | top lines (\* = not fired as planned) | opponent in its range game | range move on the opponent's mirror card (StrikeMap) |
|---|---|---|---|---|---|
| outside | 3.08-3.31 / 3.27-3.38 | 16%-25% | step_in\* 749, 1-1-2\* 156, 1-1-2 147, feint\* 63 (vs Pressure) | 6%-36% | outside:none |
| long | 3.14-3.38 / 3.15-3.23 | 18%-31% | 1-1\* 665, step_out\* 222, step_out 212, 2-3 31 (vs Pressure) | 6%-35% | long:step_out |
| mid | 3.17-3.45 / 2.93-3.39 | 46%-48% | step_back\* 478, step_back 430, slip 2-3\* 71, 1-6-3\* 71 (vs Pressure) | 6%-37% | mid:step_back |
| inside | 2.98-3.21 / 3.71-4.05 | 47%-48% | tie_up\* 544, tie_up 500, roll_out\* 81, roll_out 75 (vs Pressure) | 6%-36% | inside:none |
| clinch | 2.95-3.15 / 3.79-4.20 | 2%-13% | push_off\* 1039, push_off 161 (vs Pressure) | 6%-36% | clinch:none |
| own_ropes | 3.06-3.23 / 3.35-3.45 | 48%-49% | pivot_out\* 619, pivot_out 581 (vs Pressure) | 6%-36% | opp_ropes:none |
| opp_ropes | 3.03-3.25 / 3.38-3.46 | 1%-3% | 1-2\* 1165, herd 20, herd\* 15 (vs Pressure) | 6%-36% | own_ropes:pivot_out |
| corner | 3.03-3.24 / 3.38-3.46 | 0%-0% | 3b-3\* 1200 (vs Pressure) | 6%-36% | own_ropes:pivot_out |
| CONTROL | 3.10-3.33 / 3.30-3.49 | 35%-40% | pivot_out 163, pivot_out\* 162, 1-1\* 124, tie_up\* 122 (vs Pressure) | 6%-36% | - |


- **The opponent has no move list in the live round.** Its range game is the mode "range" picked by `Exchanges.next_mode`
  (RingDuel.settle, RingDuel.gd L385-386), which takes no card; the only thing that cuts it is `lv["ring_cut"]` from a planned
  cut_off (RingDuel.step_bias L69-76). Measured: the opponent fought in its range game the same share at every place (Pressure 6%,
  Out-boxer 35..37%), including opp_ropes and corner. The map lists pivot_out on the trapped side's card (own_ropes, StrikeMap.gd
  L40), but nothing takes it away from or gives it to the opponent: a trapped opponent keeps every range exchange it had.
- At opp_ropes / corner almost nothing fires as planned (0..3%): the TREEVALUE plan's only line there is herd (when "hurt"), so the
  boxer throws the card's first move (1-2@opp_ropes / 3b-3@corner) as instinct, worth 0 plan points (Table 2, LineGrade.edge).
- Inside and clinch the opponent lands more (3.7..4.2 against 3.4): the tie-up there rolls ClinchRest's dice (LiveRound.gd L267-271),
  whose shots go to the opponent's landed (L321-323).

## Table 2 - every rule that reads the place (from the code at 107c2aea)
Inside the exchange the card is the local `at` (LiveRound.gd L237). These are ALL its reads; the duel ladder `lv["place"]` (an int:
long / pocket / inside, RingDuel.step L111-117, Duels) is a different thing and does not read the card.

| place(s) | rule that reads it | file + function + line | what it changes |
|---|---|---|---|
| all 8 | which planned line fires | PlanFight.gd `choose` L101-110 -> PlanBoard.gd `pick` L74-86 (arrow's StrikeMap `from` must equal `at`); called LiveRound.gd `exchange` L238 | the arrow; with no arrow for the card the first StrikeMap.outs(at) move the boxer can do is thrown unplanned |
| all 8 | the card's mean | PlanFight.gd `card_mean` L131-138 (mean value of StrikeMap.outs(at) vs the game); LiveRound.gd L243 | subtracted from the planned line's value (LineGrade.gd `edge` L88). **Unplanned: 0** (LineGrade.gd L84-85) - the card's mean drops out |
| mid | style multiplier | StyleName.gd `plan_mult` L96-100; LiveRound.gd L252 | `1.0 + effect("mid_edge")`: no style row has that lever any more (StyleName.gd L12-17), so it is 1.0 for everyone (comment L95) |
| clinch | the tie-up and its dice | ClinchRest.gd `tied` L27-28 (`at == "clinch"`); LiveRound.gd L267-271 | a clinch roll: its edge off the exchange, its shots on the opponent's landed (L321-330) |
| own_ropes, opp_ropes | guard wear on the ropes | LiveRound.gd L350 -> GuardState.gd `after` L93, ctx L101 / L103 -> GuardWear.gd `wear` L135-136 (WEAR_ROPES 0.12, L29 ESTIMATE) | the boxer on the ropes' guard wears 12% faster; what gets through is damage (LiveRound.gd L351-355) for the knockdown roll - not the exchange odds. **corner is not read here** |
| own_ropes, opp_ropes | the ropes count sets the next card | StepWire.gd `after` L34-42 (StepEffect.on_ropes, ROPES_AT 3, StepEffect.gd L19 / L332) | writes `lv["at"]` for the next exchange (three in a round, Q-S294-231) |
| every card (write) | where the next exchange starts | RingDuel.gd `settle` L360 -> PlanFight.gd `where_next` L150-155 (won: the arrow's `to`; lost to press / loadup: own_ropes, LOST_CARD L26; else GAME_CARD L23-24) | the next card only |
| every card (round's first exchange) | the game's card | LiveRound.gd L235-236, PlanFight.GAME_CARD L23-24 (hurt -> opp_ropes, she_hurt -> own_ropes, tiring / she_tired -> inside) | sets `at` when it is "" |
| after the bout | words and pictures only | PlanFight.gd `fought_cards` L220-228, `arrow_line` L237; LineSwap.gd L65 / L125; RingMap.gd `place` L44-70 (top-down ring); FightFlow.gd L16-22; MoveWords.gd L10-17 | none on the result |

**What this means for phase 2.** The exchange odds read the place only through the planned line (and the clinch's tie-up). An
unplanned exchange at opp_ropes and at corner plays the same as one anywhere else; Table 1 shows it (opp_ropes and corner agree to
0.5 in every style). No code takes a range move away from a trapped boxer, no code gives the boxer doing the trapping more, and
`corner` is read by nothing but the plan pick and the words. So phase 2's "THE PLACE PAYS" needs a new read in the exchange odds;
there is nothing today to resize. Its size can start from this table: the place gives -3.0..+3.2 today, so a phase-2 edge must be
measured as a shift against these rows, with this probe's CONTROL row as the floor.

## Steps and the cards they start from (StrikeMap.gd L18-49)
| step | from -> to | ropes count (StepEffect TABLE) |
|---|---|---|
| step_in | outside -> long (L19) | - |
| feint | outside -> outside (L21) | - |
| step_out | long -> outside (L28) | - |
| cut_off | long -> opp_ropes (L29) | opp_ropes +1 (StepEffect.gd L145-154) |
| step_back | mid -> long (L33) | - |
| tie_up | inside -> clinch (L35; @own_ropes L41) | - |
| roll_out | inside -> mid (L36) | - |
| push_off | clinch -> mid (L39) | - |
| pivot_out | own_ropes -> mid (L40) | - |
| herd | opp_ropes -> corner (L45) | opp_ropes +1 (StepEffect.gd L165-174) |
Every step costs the exchange it is planned in: it is the exchange's arrow (LiveRound.gd L238-239), so no punch line fires that
exchange; its value is `PlanFight.EDGE[fit]` minus the card's mean (PlanFight.gd L19, LineGrade.gd L88).

## Seen, not fixed (files this task does not own)
- `tools/treevalue_cells.gd` `run_bout` (L45-46) calls `Bouts.fight_step(... "start")` and then `"sim"`. "sim" runs the start branch
  again (BoutNight.gd L69-76), so round 1 is opened twice: the first open's exchange is thrown away while `f["bout"]` keeps what it
  wrote (guard, plan_tally, form). The TREEVALUE numbers were measured on that path; this probe compares against "sim" alone.
- `StyleName.plan_mult` (L96-100) still adds `mid_edge` / `counter_edge`, levers no style has since S486: dead code, always 1.0.

## Limits
- The forced arm holds the card for the whole round (after its first exchange), so `where_next` never moves the fight: this is the
  value of an exchange that starts there, not of a stay that lasts.
- One plan (TREEVALUE's). The planned share at a place depends on the plan having a line there; a plan with a line on opp_ropes or
  corner would change those rows through the plan pick - which is the point: the place itself adds nothing.
