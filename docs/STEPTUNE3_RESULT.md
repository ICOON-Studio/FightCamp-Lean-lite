# STEPTUNE3 result - sizing the steps' levers on the phase-1 fight

S530, Qwen on the PC (branch `qwen/steptune3`). Brief: `ops/research/TASK_STEPTUNE3.md`.
Starting board: `docs/TREEVALUE5_RESULT.md` (0/10 inside the gate). Scope: `ops/research/STEPS_SCOPE_S528.md` phase 4.
Prior method finding: `docs/STEPTUNE2_RESULT.md` (the per-fire invariant, the OPEN blind spot).

## Headline

*(filled in at the end of the round)*

## 1. What this round could move, and what it could not

Phase 1 (S528) wired two levers that STEPTUNE2 found inert, and phase 3 changed the gate's own reference:

- `StepWire.open_edge` passes a step's opening through the next STEP line to the punch after it, and the probe
  (`_keep_dest_punch`) keeps one planned PUNCH on the swept step's destination card. OPEN is now spendable in principle.
- `StepWire.levers(.., fit)` lets a wrong-fit step's `wrong_extra_damage` (default `WRONG_COST` 0.2) more of her punches
  land. This is the first **style-selective** lever in TABLE: it only bites where `PlanFight.fit` says "wrong", so it can
  lower one style's cell without lowering the others. STEPTUNE2's invariant assumed a style-uniform package; this breaks it.
- Phase 3 aligned `StepValue.TARGET`'s wrong styles with `PlanFight.ANSWERS`, and **removed the wrong style from four steps**
  (feint, tie_up, roll_out, push_off: no style punishes them in the fight).

Which styles each step's wrong cost can bite (`PlanFight.ANSWERS`, the situations that list the step `wrong`):

| step | wrong in | the styles that play those games most |
|---|---|---|
| step_in | press, she_hurt | Pressure fighter (press .55), Volume puncher (press .45) |
| step_out | range, tiring, hurt, hurt_danger | Out-boxer (range .60), Boxer-puncher (range .35) |
| step_back | range, tiring, hurt, hurt_danger | Out-boxer, Boxer-puncher |
| cut_off | press, she_tired | Pressure fighter, Volume puncher |
| herd | press, she_tired, hurt_danger | Pressure fighter, Volume puncher |
| feint | tiring, hurt, hurt_danger | any style, when she is tired/hurt |
| tie_up | tiring, hurt, hurt_danger | any style, when she is tired/hurt |
| pivot_out | **nowhere** | the cost is inert for it |
| roll_out | **nowhere** | the cost is inert for it |
| push_off | **nowhere** | the cost is inert for it |

## 2. BLOCKER (outside OWNS): the probe cannot score four of the ten steps

`tools/treevalue_cells.gd:78` reads `cells[wrong]` with `wrong = StepValue.wrong_style(step)`. Since phase 3 that returns
`""` for feint, tie_up, roll_out and push_off. Measured on this worktree (a scratch call of `Cells.legs` with synthetic
cells, run headless through the slot queue):

```
SCRATCH legs herd -> { "best": "Volume puncher", "wrong": "Pressure fighter", ... }
SCRIPT ERROR: Invalid access to property or key of type 'String' on a base object of type 'Dictionary'.
   at: legs (res://tools/treevalue_cells.gd:78)
SCRATCH legs feint -> {  }
SCRIPT ERROR: Invalid access to property or key 'pass' on a base object of type 'Dictionary'.
   at: _initialize (res://tests/step_levers_test.gd:30)
```

`legs` returns an empty Dictionary, the caller's next `lg["pass"]` errors too, and **the calling function aborts**. In
`tools/treevalue_probe.gd` that caller is `_initialize`, so the summary dies before `quit()`: the six CELL lines print,
then no `TREEVALUE2 done pass=` line and the process runs until its own timeout ends it.

Two consequences, both design changes rather than numbers:

1. The gate's wrong leg (`wrong < 0`) has no style to read for those four steps. As written it can never pass them.
2. `tools/treevalue_cells.gd` needs a `wrong == ""` branch (score the two legs that exist, or skip the step) before any
   future round can size them. Neither file is in this brief's OWNS, so neither is touched here.

## 3. The window arithmetic on TREEVALUE5's board (before any number changed)

A uniform per-fire lever package `dL` (deny / drain / own tank / a spent open) moves every cell by `F_style x dL`.
The gate asks best in 1.5..5, wrong < 0, others 0..1, so each leg is an interval on `dL`; the window is their intersection.
Computed from TREEVALUE5's win counts and fires/bout (not its rounded deltas):

| step | best | wrong | dL window | verdict |
|---|---|---|---|---|
| step_in | Out-boxer | Pressure fighter | [+0.792, -0.213] | EMPTY |
| step_out | Slugger | Out-boxer | [+0.797, -1.125] | EMPTY |
| step_back | Pressure fighter | Out-boxer | [+0.941, -1.023] | EMPTY |
| pivot_out | Pressure fighter | Out-boxer | [+0.106, -0.135] | EMPTY |
| cut_off | Out-boxer | Pressure fighter | [+2.393, +0.909] | EMPTY |
| herd | Volume puncher | Pressure fighter | [+6.538, +1.667] | EMPTY |
| feint | Counter-puncher | none | [-0.356, -0.256] | open for best+others only (2 legs max) |
| tie_up | Slugger | none | [-0.244, -1.023] | EMPTY |
| roll_out | Slugger | none | [+1.452, +0.082] | EMPTY |
| push_off | Pressure fighter | none | [+1.807, +1.957] | open for best+others only (2 legs max) |

The binding pairs are the ones STEPTUNE2 named: a style that fires MORE than the best style and is capped at +1
(step_in's Counter-puncher 1.79 vs 1.01, pivot_out's Slugger 3.39 vs 2.83, roll_out's Pressure 2.44 vs 1.24), or a style
that fires the SAME and sits below the best (step_back's Slugger 2.15 = Pressure 2.15, cut_off's Volume 1.17 ~ Out-boxer 1.11).
Only a style-selective lever can break those locks - which is what phase 1's wrong cost was supposed to be.

## 3b. Why phase 1's wrong cost is mostly inert: a step fires on the card that grades it RIGHT

`StepWire.levers` applies `wrong_extra_damage` only when `PlanFight.fit(arrow, psit) == "wrong"`. But a planned step fires
on its OWN card (`StrikeMap.from`, `PlanBoard.pick`), and that card is `GAME_CARD[sit]` / `LOST_CARD[sit]` of the situation
the fight is already in. So the situation a step fires in is usually the one `ANSWERS` grades it best or ok:

| step | its card | the situations that put the fight there | ANSWERS fit there | can the wrong cost bite? |
|---|---|---|---|---|
| step_in | outside | counter | ok | almost never |
| feint | outside | counter | best | almost never |
| step_out | long | range | **wrong** | **YES - its own card is its wrong answer** |
| cut_off | long | range | best | almost never |
| step_back | mid | press, loadup | best, best | almost never |
| pivot_out | own_ropes | press/loadup loss, she_hurt | best, ok, best | never (in no `wrong` list) |
| tie_up | inside | tiring, she_tired | **wrong**, best | **YES at tiring** |
| roll_out | inside | tiring, she_tired | none, ok | never (in no `wrong` list) |
| push_off | clinch | tie_up's destination | mode-dependent | never (in no `wrong` list) |
| herd | opp_ropes | hurt | best (**wrong** at hurt_danger) | only vs a hits-back-hurt opponent |

Measured below (run 2): step_in's cost at 5x the default moves its cells by 1-3 wins in 1,200. The lever is real but it
is aimed at the wrong place - a step is punished for the situation it is standing in, and it is almost never standing in
the situation that punishes it. **Design change, not a number:** grade the wrong cost on the situation the step walks
INTO (its destination card's game), or let `open_on` / `deny_on` select the situation, so a step can be wrong where it is used.

## 3c. The punch-count levers act AFTER the exchange is scored (the round's central finding)

`LiveRound.exchange` runs in this order:

```
d += StepWire.open_edge(lv, arrow, planned)     # line 272 - BEFORE the duel is settled
var s := Exchanges.settle(d, roll_a, roll_b)    # line 275 - won + margin fixed here
var lev := StepWire.levers(lv, s, arrow, ...)   # line 277 - edits s["landed"][1] only
```

`levers` cuts her landed punches (DENY) and adds the wrong-fit extra (WRONG_COST), but `s["won"]` and `s["margin"]` are
already decided. `Exchanges.round_of` takes the round from `won_n`, then from the margin sum; `BoutRules.cards_of` reads
only `rounds[].won`. **The landed counts never reach the scorecards.** After `levers` they feed only:

- `Exchanges.body_shots` / `Adaptation.body_shots` (line 307) -> body units -> next exchanges' energy,
- `GuardState.after(f, s["landed"], ...)` -> guard wear -> `m["damage"]` -> knockdowns and stoppages.

So DENY and `wrong_extra_damage` can only change a bout through energy, damage and a stoppage - a weak channel in an
amateur 3x3 decided on the cards, with opponents calibrated to ~50%. Runs 2 and 3 measure exactly that: **five times the
default wrong cost moves a cell by 0-3 wins in 1,200**, even on step_out, whose own card is the situation that grades it wrong.

OPEN is the only TABLE lever that acts before `settle`, and run 1 measures it at dL ~0.2-1.1 per unit open. Together these
are the two reasons the map's sizes (0.1-0.6) cannot reach a 1.5-5-in-100 gate: the lever that moves the margin is small
and spends once, and the levers that punish do not move the margin at all.

**Design change, not a number:** let DENY and the wrong cost reach `d` before `settle` (a share of her landed punches as a
margin penalty, the way `open_edge` is a margin bonus), or let the landed counts score the close rounds. Until then no
`deny` / `wrong_extra_damage` size can be read against this gate.

## 4. Per step: old -> new numbers, cells before and after

Cells are win difference in 100 over 1,200 bouts a cell per arm (400 x 3 seed sets), Sharp 60, OK grade, calibrated
opponents. "before" = TREEVALUE5's win counts on the shipped table; every run below reproduced its calibration
(52.89 / 55.95 / 54.24 / 53.29 / 53.02 / 52.64) and its determinism control (203 wins, 861 fires) exactly, so the
two boards are the same measurement.

### cut_off - open 0.0 -> 0.33, MEASURED, reverted (run 1)

The one step far from target whose open STEPTUNE2 said this plan can spend (its destination `opp_ropes` keeps
`3b-3@opp_ropes`, and a loss to `range` lands on the kept `2-3` / `1-2-3b` at long). Sized to 0.33, the middle of
STEPTUNE2's predicted best+wrong window.

| style | before [with/without] | open 0.33 [with/without] | fires/bout | dL bought |
|---|---|---|---|---|
| Pressure fighter (wrong) | -1.92 [582/605] | -1.83 [583/605] | 0.89 | +0.09 |
| Slugger | -0.83 [578/588] | -0.83 [578/588] | 0.96 | 0.00 |
| Out-boxer (best) | -0.25 [624/627] | **0.00 [627/627]** | 1.11 | +0.23 |
| Counter-puncher | +0.08 [640/639] | +0.25 [642/639] | 0.99 | +0.17 |
| Volume puncher | -2.75 [587/620] | -2.33 [592/620] | 1.17 | +0.36 |
| Boxer-puncher | -1.00 [589/601] | -0.67 [593/601] | 1.09 | +0.31 |

Legs before: wrong (1). Legs after: wrong (1). `TREEVALUE2 done pass=0/10`.

**What it buys: k_open = dL / open = 0.0 to 1.08 wins in 100 per fire per unit open (mean ~0.58).** That is the number
STEPTUNE2 could not measure (its open was unspendable) and it is ~10x smaller than the ~5 its window arithmetic assumed.
The best cell needs dL +1.58 to reach +1.5, i.e. **open ~2.3**; the others leg needs Volume >= 0, dL +2.35, i.e. **open ~3.4**.
At open 2.3 the next punch would carry +33 power points - twice a best call's whole edge (`Exchanges.EDGE.best` 17).
Not a defensible size for cutting the ring, and no leg is gained at 0.33, so the row goes back to **open 0.0**.

cut_off's window is EMPTY on the phase-1 code: it needs a design change, not a number.

### step_in - wrong_extra_damage 0.2 -> 1.0, MEASURED, reverted (run 2)

The first measurement of phase 1's new cost lever, at 5x the default. step_in's wrong style is now Pressure fighter
(phase 3), and `press.wrong` does list step_in - so this is the lever the scope wired for exactly this cell.

| style | before [with/without] | cost 1.0 [with/without] | fires/bout | wins moved |
|---|---|---|---|---|
| Pressure fighter (wrong) | +0.08 [557/556] | +0.00 [556/556] | 0.47 | -1 |
| Slugger | -0.08 [539/540] | -0.17 [538/540] | 0.40 | -1 |
| Out-boxer (best) | +0.67 [560/552] | +0.75 [561/552] | 1.01 | +1 |
| Counter-puncher | +0.50 [591/585] | +0.25 [588/585] | 1.77 | -3 |
| Volume puncher | +0.25 [571/568] | +0.25 [571/568] | 0.40 | 0 |
| Boxer-puncher | +0.67 [561/553] | +0.67 [561/553] | 0.73 | 0 |

Legs before: 0. Legs after: 0 (the wrong cell reached exactly 0.00, not below it). `TREEVALUE2 done pass=0/10`.

**What it buys: nothing a gate can read.** Five times the cost moves a cell by at most 3 wins in 1,200, and it does not
move the wrong style most. Section 3b is the reason: step_in fires from `outside`, the counter card, where `ANSWERS`
grades it `ok` - the press situation that punishes it puts the fight at `mid`, where step_in cannot fire at all.
The row goes back to **wrong_extra_damage 0.2** (the map's value, and the same as `StepWire.WRONG_COST`).

step_in's window is EMPTY: its best cell needs dL +0.79 while its Counter-puncher cell (fires 1.77, nearly twice the
best style's 1.01) caps dL at +0.28. No TABLE number reaches both.

### step_out - wrong_extra_damage 0.0 -> 1.0, MEASURED, reverted (run 3)

The one step whose own card IS its wrong answer: step_out fires from `long`, `GAME_CARD[range]`, and `range.wrong` lists
step_out. Its wrong style is now Out-boxer (phase 3), the style that plays range .60 of its games. If the new cost lever
can lower a wrong cell anywhere, it is here.

| style | before [with/without] | cost 1.0 [with/without] | fires/bout | wins moved |
|---|---|---|---|---|
| Pressure fighter | +0.83 [562/552] | +0.83 [562/552] | 1.37 | 0 |
| Slugger (best) | +0.42 [556/551] | +0.50 [557/551] | 1.38 | +1 |
| Out-boxer (wrong) | +1.75 [590/569] | **+1.50 [587/569]** | 1.60 | -3 |
| Counter-puncher | +0.83 [614/604] | +0.75 [613/604] | 1.35 | -1 |
| Volume puncher | +0.33 [583/579] | +0.25 [582/579] | 1.67 | -1 |
| Boxer-puncher | +1.67 [578/558] | +1.75 [579/558] | 1.52 | +1 |

Legs before: 0. Legs after: 0. `TREEVALUE2 done pass=0/10`.

**What it buys: -0.25 on the wrong cell at 5x the default cost.** The cell needs -1.75 more to go negative, i.e. a cost
around 7 - seven times her landed punches added as extra damage on a wrong-fit exchange. Not a defensible price for a
lateral step, and it would still leave the best cell (Slugger +0.50) a full point below the band. Section 3c is the reason
the lever is so weak: the extra punches land after the exchange is scored. The row goes back to **wrong_extra_damage 0.0**
(the default `WRONG_COST` 0.2 applies).

step_out's window is EMPTY, and its best style is its WEAKEST cell (Slugger +0.42 against a +2.5 target) - the
TARGET / ANSWERS mismatch STEPTUNE2 s2 named, still there after phase 3 aligned the wrong styles only.
