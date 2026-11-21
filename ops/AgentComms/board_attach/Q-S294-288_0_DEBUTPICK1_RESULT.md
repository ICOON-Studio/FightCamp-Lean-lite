# DEBUTPICK1 RESULT - the promoter picks the debut opponent to fit each boxer

S533, Fable side console. Owner, Q-S294-286: **"Pick to each boxer"**. Rule: `scripts/rules/DebutPick.gd`. Test:
`tests/debut_pick_test.gd`. Probe: `tools/turn_gap_probe.gd -- pick=1`. Follows `docs/TURNPRO6_RESULT.md` (section 8, item 1).

## 1. What changed, in one paragraph
Each promoter used to book every boxer a debutant at one fixed gap under the boxer's own rating (Bow Lane 3.0, Harrow &
Finch 6.0), and the same debut then won anywhere from 40.3 to 90.3 in 100 depending on who the boxer was. Now each
promoter has a TARGET win chance and finds the debutant that gives THIS boxer that chance: the safer house (Harrow &
Finch) aims at 75 in 100, the bigger gate (Bow Lane) at 60 in 100. A matchmaker misjudges, so the target moves up to 4
points either way, fixed by the boxer, the house and the day (same seed, same pick). The search runs through the read
the offer card already shows (`DebutRead.card` -> `BoutRead.round_edges`): no second model of the fight.

## 2. The numbers
| House | Aim | Misjudgement | Kept from TURNPRO6? |
|---|---|---|---|
| Bow Lane (ticket house, the bigger gate) | 60 in 100 | up to 4 either way | yes (its measured mean was 60.1) |
| Harrow & Finch (guarantee house, the safer start) | 75 in 100 | up to 4 either way | yes (74.9) - see section 4 on its played mean |

The gap can be anything from 6 rating points OVER the boxer to 14 UNDER, in steps of 0.1 (`GAP_MIN`, `GAP_MAX`). The pick
is 8 reads (halving the range) plus the nearer of the two neighbours. It is made once, when the promoter calls
(`ProOfferWire.make`), and travels in the offer: `opp_gap` (what `Roster.turn_pro` books and what the two asks move by
0.5), `opp_target`, `opp_picked`, `opp_day`. A save keeps it (the offer and the booked bout are saved as they are).

## 3. The measurement
Population (printed by the probe): the six people the game can sign, two sets of training picks (A: Jab and move / Pad
rounds / Hill sprints; B: Body work / Defence drills / Film study), each played from signing to the first pro offer by a
bot that takes every legal bout. Tess arrives the same on both sets (counted once): 11 different boxers.

| Boxer | Style, stance, class | At the offer | Strength (no camp) |
|---|---|---|---|
| Lucy Jackson | Out-boxer, orthodox, wlw | day 174, 7-2 | 65.9 |
| Kira Mensah | Out-boxer, orthodox, wfw | day 265, 7-1 | 67.1 |
| Samira Khan | Slugger, orthodox, www | day 398, 7-8 | 69.9 |
| Tess Reilly | Pressure fighter, southpaw, wmw | day 41, 7-4 | 59.4 |
| Danny Osei | Boxer-puncher, orthodox, mlw | day 167, 7-1 | 63.7 |
| Josh Harper | Pressure fighter, southpaw, mww | day 111, 7-2 | 60.4 |
| Lucy Jackson (picks B) | Out-boxer, orthodox, wlw | day 153, 7-1 | 64.7 |
| Kira Mensah (picks B) | Out-boxer, orthodox, wfw | day 251, 7-1 | 67.0 |
| Samira Khan (picks B) | Slugger, orthodox, www | day 328, 7-6 | 67.4 |
| Danny Osei (picks B) | Boxer-puncher, orthodox, mlw | day 202, 7-2 | 65.0 |
| Josh Harper (picks B) | Pressure fighter, southpaw, mww | day 118, 7-2 | 60.0 |

Each boxer signs each house's deal through `Roster.turn_pro` and is played by the game's own days to the morning of fight
night. Then two arms on that one fight-night boxer, the SAME 300 nights each (PlanTest's scratch dice, day 50000 + k x 7):
- **picked** - the opponent at the gap `DebutPick` found at the offer (what the game now books);
- **fixed (control arm)** - the opponent at the house's old one gap. It cannot share the pick's faults, and it reads the
  old wide spread through the same instrument: this measurement can read worse.
The scratch bout on the real day's dice gave the booked bout's result in 22 of 22 checks. 13,200 bouts.

**Bow Lane (bigger gate, debut 4 weeks out) - aim 60 in 100**

| Boxer | Target (aim and misjudgement) | Gap picked | Offer shows | Played: win / draw / loss | Win less target | Control: fixed gap 3.0 won |
|---|---|---|---|---|---|---|
| Lucy Jackson | 59.1 | -2.1 | 59.1 | 55.3 / 23.7 / 21.0 | -3.8 | 81.7 |
| Kira Mensah | 61.9 | +3.0 | 61.7 | 59.3 / 18.7 / 22.0 | -2.6 | 59.3 |
| Samira Khan | 63.2 | +2.2 | 63.0 | 56.7 / 21.7 / 21.7 | -6.5 | 61.3 |
| Tess Reilly | 60.3 | +8.9 | 60.3 | 69.3 / 16.3 / 14.3 | +9.0 | 40.3 |
| Danny Osei | 60.8 | +1.4 | 60.7 | 64.3 / 19.3 / 16.3 | +3.5 | 75.0 |
| Josh Harper | 57.3 | +3.8 | 57.5 | 52.3 / 20.3 / 27.3 | -5.0 | 47.0 |
| Lucy Jackson (picks B) | 58.5 | +0.5 | 58.6 | 53.7 / 24.7 / 21.7 | -4.8 | 67.0 |
| Kira Mensah (picks B) | 58.2 | +4.5 | 58.3 | 53.7 / 17.0 / 29.3 | -4.5 | 46.0 |
| Samira Khan (picks B) | 58.4 | +6.4 | 58.5 | 60.3 / 20.3 / 19.3 | +1.9 | 42.0 |
| Danny Osei (picks B) | 60.6 | +4.2 | 60.5 | 64.0 / 17.3 / 18.7 | +3.4 | 56.0 |
| Josh Harper (picks B) | 56.1 | +3.0 | 56.0 | 57.0 / 19.7 / 23.3 | +0.9 | 57.0 |

**Harrow & Finch (safer house, debut 6 weeks out) - aim 75 in 100**

| Boxer | Target (aim and misjudgement) | Gap picked | Offer shows | Played: win / draw / loss | Win less target | Control: fixed gap 6.0 won |
|---|---|---|---|---|---|---|
| Lucy Jackson | 76.0 | +2.0 | 75.9 | 77.7 / 15.0 / 7.3 | +1.7 | 90.3 |
| Kira Mensah | 77.1 | +6.3 | 77.1 | 76.7 / 13.3 / 10.0 | -0.4 | 74.0 |
| Samira Khan | 74.0 | +4.5 | 73.8 | 73.7 / 14.3 / 12.0 | -0.3 | 81.3 |
| Tess Reilly | 71.4 | +11.1 | 71.3 | 84.0 / 12.0 / 4.0 | +12.6 | 60.0 |
| Danny Osei | 75.7 | +4.8 | 75.6 | 81.7 / 13.3 / 5.0 | +6.0 | 84.0 |
| Josh Harper | 76.5 | +8.0 | 76.3 | 75.7 / 16.3 / 8.0 | -0.8 | 67.0 |
| Lucy Jackson (picks B) | 75.4 | +4.3 | 75.5 | 72.0 / 18.3 / 9.7 | -3.4 | 80.3 |
| Kira Mensah (picks B) | 73.4 | +7.5 | 73.2 | 74.0 / 16.0 / 10.0 | +0.6 | 65.7 |
| Samira Khan (picks B) | 77.2 | +10.2 | 77.1 | 84.3 / 10.7 / 5.0 | +7.1 | 59.3 |
| Danny Osei (picks B) | 73.8 | +7.0 | 73.9 | 78.3 / 16.0 / 5.7 | +4.5 | 73.7 |
| Josh Harper (picks B) | 77.0 | +7.2 | 76.9 | 85.3 / 10.0 / 4.7 | +8.3 | 80.0 |

| House | Arm | Mean win | Lowest .. highest boxer | Spread |
|---|---|---|---|---|
| Bow Lane | fixed gap 3.0 (control) | 57.5 | 40.3 .. 81.7 | 41.4 |
| Bow Lane | **picked** | **58.7** | **52.3 .. 69.3** | **17.0** |
| Harrow & Finch | fixed gap 6.0 (control) | 74.1 | 59.3 .. 90.3 | 31.0 |
| Harrow & Finch | **picked** | **78.5** | **72 .. 85.3** | **13.3** |

**The band.** The played win share of each boxer sits from -6.5 to +9.0 points of that boxer's target at Bow Lane and
from -3.4 to +12.6 at Harrow & Finch: **7 under to 13 over**, 18 of 22 cells within 7. (300 bouts measure a share
to about 3 points either way.) The spread across boxers fell from 41 points to 17 (Bow Lane) and from 31 to 13
(Harrow & Finch). The gaps picked run from -2.1 to +8.9 (Bow Lane) and +2 to +11.1 (Harrow & Finch): a strong,
finished boxer is tested by a debutant rated ABOVE the boxer, a newcomer still growing gets one far below. The offer card
shows the target to within 0.2 point in every cell (a 0.1 step of gap is about half a point of chance).

## 4. What the measurement says about the aims
- Bow Lane lands on its aim: played mean 58.7 for an aim of 60. Kept.
- Harrow & Finch plays 3.5 points ABOVE its aim (mean 78.5, four boxers over 80). The cause is known and is
  not the pick: the offer's read is made on the boxer as today, 6 weeks before the bout, and the camp's training is still to
  come (TURNPRO6 section 5: the offer reads low, most for a boxer still growing fast - Tess +12.6, Samira on picks B +7.1,
  Josh on picks B +8.3 here). I kept the aim at 75, so the card shows what the promoter aimed at; lowering the aim to 72
  would centre the played share but the card would then promise less than the house means. The clean fix is in the read
  (count the training to come), which TURNPRO6 left open. Say if either should be done.
- The low side is small: no boxer played more than 6.5 under the target.

### Why the offer reads a newcomer low (traced, `tools/debut_read_gap_probe.gd`)
TURNPRO6 put it down to "the camp's training" in general. Traced on Tess Reilly (called on day 41, Bow Lane, gap 7.2: the
offer reads 57.4, the offer's own rule on the fight-night boxer 65.5, the booked bout 68.2). The offer was re-read with
one thing at a time taken from the boxer as on fight night:

| Taken from fight night | The offer's read moves | What changed in 4 weeks |
|---|---|---|
| The attributes | +8.4 points | Stamina 62.9 -> 65.3 (the camp's focus was conditioning; the tank is what loses these bouts), Recovery +0.7 |
| The moves | +4.9 | Lead hook 32.6 -> 59.8: a new weapon learnt in camp |
| The combinations | +2.9 | the 1-2 from 10.9 to 31.8, a third one started |
| The six stats | -1.7 | +0.5 on the mean: NOT the cause (every boxer gains about this much) |

So it is three things a camp builds fast in a boxer six weeks into the gym - the tank, a new punch, a combination - and
none of them is the six-stat mean a simple forecast would move. Counting them at the call means playing the camp ahead
on a copy of the career (the camp's focus is the player's choice), which is a design decision and a cost on the offer
screen, not a constant. Not built.

## 5. A fault found and fixed on the way
The debutant's name came from the day the screen was READ, and the name decides the debutant's shape (the bout's
attributes are drawn from it). So the offer could show one opponent on Monday and another on Tuesday, and
`Roster.turn_pro` booked a third on the signing day: Tess read 57 in 100 at the call and 52 the next morning, same gap.
A picked offer now carries `opp_day`; the read and the booking both use it. Old offers (no `opp_day`) behave as before.

Also fixed, seen on the real screen: the two-house offer was 1,119 px tall on a 1,080 screen before this task (the Win
chance row of TURNPRO6 pushed it over), so the Stay amateur button was cut off. The new sentence sits in the Debut row
("Debut, 4 weeks out - Picked to test your boxer"), the rating moved beside the win chance, the column spacing is 5 px:
1,047 px, everything on screen (still: `tools/debut_pick_still.gd`).

## 6. Where it shows (wired)
| Screen | What it shows | Wired to |
|---|---|---|
| Pro offer (`scripts/ui/modals/ProOffer.gd`), each house's column | "Debut, N weeks out: Picked to give your boxer a winnable first night" / "Picked to test your boxer" | `DebutPick.line` |
| Same row, on hover | "The promoter picked this debutant to fit your boxer. Aimed at about 75 wins in 100, give or take. Spend the ask to change it." (25 words) | `DebutPick.tip`, `Tip.explain` |
| Win chance row | "about 74%, a draw 14% (rated 9.0 under)" | `DebutRead.card`, `DebutRead.words` |
| The asks (Softer opponent, Better split) | move the picked gap by 0.5, as before | `ProCall` (unchanged) |
| The booked bout (bout page, fight week, fight night) | the picked debutant | `Roster.turn_pro` -> `DebutOpp.make` with the offer's `opp_gap` and `opp_day` |

No names in text, no pronouns (no_pronoun_test, words_on_screens_test, tooltip_standard_test pass).

## 7. Files
- `scripts/rules/DebutPick.gd` (new, 99 lines): aims, the seeded target, the search, the words.
- `scripts/state/ProOfferWire.gd`: `make` picks for each house that calls. `scripts/rules/DebutRead.gd`,
  `scripts/state/Roster.gd`: the debutant of the offer's day (one line each).
- `scripts/ui/modals/ProOffer.gd`: the Debut row, its hover card, the fit.
- `tools/turn_gap_probe.gd`: `pick=1` (the two arms). `tools/debut_pick_still.gd` (new): the real screen.
  `tools/debut_read_gap_probe.gd` (new): what moves the read between the call and fight night.
- `tests/debut_pick_test.gd` (new, 32 checks; cannot load on main - DebutPick does not exist). In `tools/run_tests.sh`.

## 8. Tests (each through the Godot queue, one at a time)
PASS: debut_pick_test (DEBUT_PICK failures=0), pro_call_test, pro_offer_wire_test, pro_contract_test, pro_debut_test,
pro_lean_test, pro_week_lines_test, pro_read_test, loyal_pro_share_test, test_jump_test, save_load_test (86 checks),
no_pronoun_test, plain_words_test, words_on_screens_test, file_limits_test, tooltip_standard_test, golden_path_test
(GOLDEN_PATH failures=0).

FAILS, NOT FROM THIS TASK: debut_read_test, 1 of 38 - "Lucy gap -2: the booked bout's read 0.618 within 0.05 of the played
share 0.553". The same line fails with the pick switched off (checked: one run with `ProOfferWire.make` put back). The
fight-night read now sits 6 points high for Lucy against a stronger opponent; it passed when TURNPRO6 landed, so a fight
change since moved it (the fight files have commits and uncommitted edits from the P4PBUILD1 and STEPPAY2 sessions). It is
in this page's own numbers too (Lucy, Bow Lane, picked: fight-night read 61.3, played 55.3). For the main session.

## 9. Left open
1. The offer reads low for a boxer still growing fast, so the safer house plays about 3.5 points over its aim (section 4:
   the cause is the stamina, the new punch and the combination a camp builds, not the six stats). A fix means playing the
   camp ahead on a copy of the career when the promoter calls.
2. The asks still move the gap by 0.5 (about 2.4 points of chance); their prices were set against the old curve.
3. debut_read_test's Lucy bound (section 8).

Measured on the working tree of 2026-11-21 (main at 3d9a0da51 plus this task; other sessions' uncommitted fight edits
were in the tree and are part of what was played).

Reproduce: `python ops/Tools/godot_slot.py run --who debutpick -- <godot.exe> --headless --audio-driver Dummy --fixed-fps 60
--path . --script res://tools/turn_gap_probe.gd -- pick=1 nights=300 out=<file.jsonl>` (about 11 minutes).
