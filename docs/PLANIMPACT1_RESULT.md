# PLANIMPACT1 result - can the written fight plan be made to matter? (S548)

Task: `ops/research/TASK_PLANIMPACT1.md`. Rules written before any run: `ops/research/DESIGN_PLANIMPACT1.md` (commit f6ea4ea).
Probe only: nothing under scripts/ or tests/ changed. Tools: `tools/planimpact1_probe.gd`, `tools/planimpact1_rules.gd`,
`tools/planimpact1_sum.py` (commit 2280f6b). Raw runs: `E:/FightCamp/tmp/planimpact1/`.

## For the owner (wins in 100)

1. **No lever passes every bar.** The written plan stays small: the best plan beats the coach's plan by about 2 (lever 1),
   4.5 to 6 (lever 2) and 1 (lever 3). The task's bar is 6 or more in most fighters.
2. **Lever 2 comes closest ("the boxer carries out a corner command better when the plan drilled it").** The plan then adds
   6.5 to 7.4 over no plan with a live corner (today +1.4 to +2.0), and the live corner stays worth 15 to 20 over the
   file coach. It fails because a careless plan also gets the bonus, and because one plan suits every opponent.
3. **The combo counter is not the plan's main tax.** With it fully off the style plan gains only 1.5. What taxes the plan most
   is that the corner's commands ignore what the boxer drilled. Lever 2 is the one rule that moved the plan's worth.
4. Lever 1 (two answers for one moment) and lever 3 (round one belongs to the plan) are dead: +0.0 and -3.4 / -0.7.

**Decision:** lever 2 is the one to design further, with one narrower rule (below, "next"). It goes to a second probe
(PLANIMPACT2), not to the game. Until then nothing is built.

## METHOD followed
- MECHANICS NEED 8, PROBE FIRST: only levers measured on a greybox; no rule landed.
- CONTROL FIRST: with every lever off the probe reproduced PLANWORTH1's arms A, B58, C on Lucy Jackson and Danny Osei
  **5400 of 5400 bouts identical**, and CORNERBASE1's `full_L3` (reader_nr and skill58, Lucy and Samira, presser, 3 rounds)
  **280 of 280 identical** (`ctl.jsonl`). So PLANWORTH1's A, B58, C, D, E strings are reused bout for bout.
- DEPTH STAYS IN THE CORNER: bar 2 measured for every lever.
- NO BALANCING NUMBER: each lever at the strength written in the design plus one half-strength arm. Nothing tuned.
- NOT IDENTICAL FIGHTERS: PLANWORTH1's ten TELLPLAY1 types at week 4 (Lucy Jackson, Kira Mensah, Samira Khan, Tess Reilly,
  Danny Osei, Josh Harper, Nell Ward, Reece Doyle, Bayo Adams, Kai Turner; six styles, each with stats in `ctl.log`),
  and CORNERBASE1's five women (Lucy, Samira, Tess, Cara Bello raw week 0, Jade Yates all-round week 80).
- One narrowing, taken once as the design said: the one-rep trial raised 80.7% of the reader's commands under C (> 80%), so the
  NARROWED mapping (the line must be thrown from the card the moment is fought on) replaced the wide one before the full run
  (`trial_cb.jsonl` -> `trial_cb_narrow.jsonl`). Full runs: `narrow=1`.

## What the code does today (read first; details in the design page)
- Lever 1: `PlanBoard.validate` refuses two lines on one place, so a moment has one planned answer and she never alternates.
- Lever 2: the live commands (`tools/cornercmd2_rules.gd`) are carried out at her own grade; the plan plays no part.
- Lever 3: the live corner already coaches five of round one's six exchanges.

## The rules (as written before the run)
1. **Variety beats the counter.** A place may hold two lines; she throws the one the opponent has counted fewer times.
   Half: alternates on every second firing. V = C re-chosen by one greedy step on separate dice (60 cells; 38 changed).
2. **The plan is what she drilled.** A live command whose moment the plan answers (a `best` line thrown from that moment's
   card) is carried out one grade higher (Poor -> OK -> Good). Half: the multiplier half way.
3. **Round one belongs to the plan.** The reader says nothing in round 1; his first command is set at the round-1 corner.
   Half: silent for the first three exchanges.

## Lever 1 - full run (10 types x 6 styles x 5 files x 30 paired dice = 9000 bouts an arm; `l1_a`, `l1_b`)

Countered share of plan exchanges: C 9.7% (trial), V 5.1%, V-half 5.6%, counter off 0%. V never reached 0: not the
counter-off arm in disguise.

| Type | A | B58 | C | V | V-half | C counter off | V counter off | D | E |
|---|---|---|---|---|---|---|---|---|---|
| Lucy Jackson | 51.6 | 53.3 | 55.9 | 56.4 | 56.4 | 60.4 | 60.4 | 52.4 | 50.9 |
| Kira Mensah | 43.9 | 44.4 | 44.7 | 44.9 | 45.0 | 47.6 | 47.6 | 44.9 | 42.8 |
| Samira Khan | 33.0 | 33.7 | 36.2 | 36.0 | 36.3 | 36.9 | 36.9 | 36.4 | 37.8 |
| Tess Reilly | 33.3 | 34.0 | 35.9 | 36.0 | 36.0 | 36.4 | 36.6 | 35.1 | 35.9 |
| Danny Osei | 45.9 | 48.0 | 50.1 | 49.6 | 49.8 | 50.7 | 50.8 | 46.2 | 44.1 |
| Josh Harper | 35.4 | 36.4 | 40.4 | 39.9 | 39.9 | 41.2 | 41.2 | 39.6 | 39.8 |
| Nell Ward | 49.2 | 50.8 | 52.1 | 52.2 | 52.2 | 53.3 | 53.2 | 51.2 | 45.1 |
| Reece Doyle | 43.8 | 45.0 | 45.0 | 46.1 | 45.8 | 47.0 | 46.9 | 44.8 | 44.2 |
| Bayo Adams | 38.8 | 39.0 | 44.0 | 43.9 | 44.0 | 44.3 | 44.3 | 43.7 | 44.3 |
| Kai Turner | 34.6 | 36.2 | 33.9 | 33.7 | 33.9 | 35.1 | 35.1 | 35.6 | 34.2 |
| **ALL** | 40.9 | 42.1 | 43.8 | 43.9 | 43.9 | 45.3 | 45.3 | 43.0 | 41.9 |

Paired differences over all (+-2 SE): V-B58 **+1.8 +-0.5**; C-B58 +1.7 +-0.5; V-C **+0.0 +-0.2**; V-half-C +0.1 +-0.2;
counter off-C +1.5 +-0.3; E-B58 -0.2 +-0.6; D-B58 +0.9 +-0.4. Per type V-B58 ranges -2.6 (Kai Turner) to +4.9 (Bayo Adams).
V-C per opponent style: Pressure -0.1, Counter +0.1, Volume +0.2, Boxer-puncher -0.5, Out-boxer +0.3, Slugger +0.2
(every one inside its 2 SE).
Cross play (bar 3; each style's V plan against each style, 2 files x 30 dice a cell): no plan best in more than 3 of 6 for
4 of 10 types (Tess Reilly: the Slugger plan best in all 6).

## Levers 2 and 3 - full run (CORNERBASE1 harness: 5 boxers x 10 cells x 40 paired dice = 2000 bouts an arm a length)

Wins in 100, all five boxers (`cb_L3a/b`, `cb_L6a-d`; `sum_cb_L3.md`, `sum_cb_L6.md`):

| Arm (corner : plan : lever) | 3 rounds | 6 rounds |
|---|---|---|
| file : none | 65.8 | 64.5 |
| file : coach | 66.3 | 65.4 |
| file : C | 66.8 | 64.8 |
| file : K (corner plan) | 67.2 | 66.0 |
| file : E (careless) | 66.8 | 65.4 |
| reader : none | 75.1 | 77.2 |
| reader : coach | 76.2 | 77.8 |
| reader : C | 77.1 | 78.6 |
| reader : K | 77.2 | 78.4 |
| reader : E | 76.2 | 77.8 |
| reader : coach, **L2** | 77.2 | 78.6 |
| reader : C, **L2** | 81.6 | 84.6 |
| reader : C, L2 half | 79.6 | 82.0 |
| reader : K, **L2** | 81.8 | 85.2 |
| reader : E, **L2** | 79.3 | 83.7 |
| reader : D (K's first line), **L2** | 78.1 | 79.2 |
| reader : none, **L3** | 72.2 | 76.7 |
| reader : coach, **L3** | 72.7 | 77.6 |
| reader : C, **L3** | 73.8 | 78.0 |
| reader : C, L3 half | 74.4 | 77.5 |
| reader : V, L1+L2 (pair) | 81.9 | 85.3 |
| reader : K, L2+L3 (pair) | 77.2 | 83.5 |

Share of the reader's commands raised by L2: C 69% / 75%, K 90% / 89%, coach's plan 42% / 36%, careless 28% / 49%,
one line 50% / 40%.

Key paired differences (+-2 SE), 3 rounds / 6 rounds:
- L2 best plan - coach's plan (both with L2): C **+4.5 +-1.1 / +6.0 +-1.3**; K +4.7 / +6.6.
  Per boxer, max(C, K) - coach: 3 rounds Lucy +6.2, Samira +15.0, Tess +2.8, Cara +1.0, Jade +3.2 (2 of 5 at 6+);
  6 rounds Lucy +10.0, Samira +14.2, Tess +3.5, Cara +6.0, Jade +0.5 (3 of 5 at 6+).
- L2 reader - file coach, same plan: C **+14.8 +-1.8 / +19.8 +-1.9**; K +14.6 / +19.1 (today, coach's plan: +10.0 / +12.4).
- L2 careless - coach: **+2.1 +-1.3 / +5.1 +-1.3**. L2 one line - coach: +0.9 / +0.7.
- L2 on - off, plan C: +4.5 / +6.0; half strength +2.5 / +3.5 (the slope is there).
- L2, K - C: +0.2 / +0.5 (no trade). K's cross play (each style's K against six style cells): every boxer's K plan is the
  SAME set of lines for all six styles (only the order changes, which the board ignores), so one plan is best in 6 of 6
  for every boxer. Checked in `cbx_L3.jsonl` "fought": not a wiring fault, the corner plan is style-blind.
- L3 on - off, plan C: **-3.4 +-1.3 / -0.7 +-1.0**. L3 C - coach: +1.1 / +0.4. L3 reader - file, plan C: +6.9 / +13.1.
- Pair L2+L3, K: -4.7 / -1.6 against L2 alone (L3 takes away what L2 adds in round 1).

## The seven bars

| Bar | Lever 1 variety | Lever 2 drilled corner | Lever 3 round one | L1+L2 pair |
|---|---|---|---|---|
| 1 plan pays (best - coach >= 6, 6 of 10 types / 3 of 5 boxers) | **FAIL** 0 of 10 (+1.8 over all) | **FAIL** at 3 rounds (2 of 5, +4.5); pass at 6 rounds (3 of 5, +6.0; Cara exactly +6.0 +-3.0) | **FAIL** (+1.1 / +0.4) | as L2 (2 of 5 / 3 of 5) |
| 2 corner still pays (reader - file >= 6) | pass (lever does not touch the corner; reader - file on C +10.3 / +13.8 from the table, V within 0.2 of C) | pass (+14.8 / +19.8) | pass, barely at 3 rounds (+6.9 / +13.1) | pass (+14.7 / +20.0) |
| 3 not one plan (no plan best in > 3 of 6, 6 of 10 / 3 of 5) | **FAIL** (4 of 10) | **FAIL** (K is one plan for every style: 0 of 5) | not run (bar 1 failed wide) | not run |
| 4 careless costs (E - coach <= -3) | **FAIL** (-0.2) | **FAIL** (+2.1 / +5.1: the careless plan GAINS) | not run | not run |
| 5 no trap (one line never > 2 under coach) | pass (+0.9; no type under beyond 2 SE) | pass (+0.9 / +0.7) | not run | not run |
| 6 choice is a trade (V better in 2+ styles and C better in 2+) | pass on sign only (V ahead in 4 styles, C in 2), every gap inside its 2 SE: no real trade | reported only: K - C +0.2 / +0.5 | - | - |
| 7 the card can say it | see below | see below | see below | - |
| **Verdict** | FAIL | FAIL (closest) | FAIL | FAIL |

**Bar 7 (not built).** `tests/plan_read_fit_test.gd` plays `BoutNight.play_out` with no live corner and plans with no twins,
so none of the three levers would turn it red, and none of them would show on the card without new read lines:
- Lever 2 would need `BoutRead._round_edges` (l.313) to read the reader corner's raised grade, and `PlanReadFit.chain`
  (l.49) to credit a prepared command. Neither function knows corner commands today. The card cannot say "this plan
  sharpens Go to the body" until both do, and the fit test would need a reader-corner arm to go red on a wrong read.
- Lever 1 would need `PlanReadFit.countered` (l.63) to take the two lines' counts apart.
- Lever 3: `BoutRead._call` (l.215) and its round-1 call would only need the corner's silence in round 1.

## Combined arm
No lever passed alone. Two pairs were run for information: L1+L2 is lever 2 again (V adds +0.3 / +0.7 to C, inside noise);
L2+L3 is worse than L2 alone (-4.7 / -1.6).

## The lever to design next, and where it would show
Lever 2, with ONE narrower rule (a rule with a boxing reason, not a tuned number): **a command is prepared only by a line that
answers that moment on the card where THIS opponent's style fights it** (`CoachPlan.cards(style)`, the same game cards the
careless plan avoids). Reason: a camp drills for the opponent you are going to meet, not for every fight. On paper this
addresses both failures: a careless plan would prepare nothing (bar 4), and the corner plan would change with the style (bar 3).
It is a new rule, so it needs a new probe (PLANIMPACT2: the same harness and bars, with the rule written down first). It is
not built here.

| Menu | What it would show | Wired to |
|---|---|---|
| Plan board | under each line, the corner commands it prepares against this opponent ("drilled: Go to the body") | PlanImpact prepared() on the plan + opponent style |
| Bout card | "Corner sharper: 3 of 8 commands drilled" next to the read | BoutRead round edges with the raised grades |
| Corner bar (live) | a drilled command's grade shown one step up (OK -> Good), marked drilled | the reader grades st["gr"] after sharpen |
| Result page | "Drilled commands won N of M exchanges" | the bout's exchanges with a prepared command |

## Owner's "cut it or keep it"
If PLANIMPACT2 fails too, the plan screen's worth is what was measured here: today the best written plan adds about 2 over
the coach's plan; the ring rule that taxes it most is that **a corner command is carried out the same whether or not camp
drilled it** (connecting them moved the plan from +0.9 to +4.5 / +6.0 over the coach's plan). The combo counter costs the
plan only 1.5.

## Honest limits
- Lever 2's bar 1 at 6 rounds rests on Cara at exactly +6.0 +-3.0, so the pass is borderline.
- K and the five boxers' C plans for Cara and Jade come from the read greedy (`cpick`), not PLANWORTH1's frozen plans.
- The K cross play ran at 3 rounds only, on six style cells (presser, mover, counter, loader, fader, slow).
- Lever 1's bar 2 comes from the lever-off table: lever 1 does not touch the corner, and V's plans sit within 0.2 of C.
- Lever 3's bars 3 to 5 were not run: bar 1 missed by about 5 points at both lengths (+1.1 / +0.4 against 6).
- The earlier worker of this task was cut off by a PC restart. Its completed runs were reused (control, cpick, the trials,
  V picks for types 0-5 and type 6 styles 0-4); nothing complete was re-run.

## Reproduce
```
python ops/Tools/godot_slot.py run --who PLANIMPACT1 -- <godot.exe> --headless --audio-driver Dummy --path . \
  --script res://tools/planimpact1_probe.gd -- stage=<ctl|cpick|vpick|pw|x|cb> out=E:/FightCamp/tmp/planimpact1/<name>.jsonl ...
  vpick: n=20 types=<i>        (V plans; merge rows "vplan" into plans.json as V|ti|si)
  pw:    arms=V,Vh,Coff,Voff n=30 k0=0 nf=5 types=0,1,2,3,4 (then 5..9)
  x:     n=30 nfx=2
  cb:    narrow=1 n=40 lens=3|6 cells=<ids> arms=<corner:plan:L2:L3:L1,...>   (cross: arms=reader:K@0:1:0:0,...,K@5)
python tools/planimpact1_sum.py ctl|l1|x <jsonl...>;  python tools/planimpact1_sum.py cb <a/b,c/d pairs> <jsonl...>
```
(`sum.py cb` needs the pairs argument first: it takes a first argument with "/" as the pairs, and a path has one.)
