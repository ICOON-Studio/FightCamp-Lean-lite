# TASK AMATEURPROBE1 - QWEN (qwen3-coder) - amateur bouts at 1 to 2 weeks' notice with no camp: what changes. Measure only

Status: OPEN (S429, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: the operator's S428 scope change: "make it so amateur fights do not require fight camp and can happen within a week"
(ops/research/SCOPE_FOUR_FIGHTERS_S428.md; design ops/research/AMATEURWEEK1_MAP_S429.md). Before any rule changes, measure
what a short lead and no camp do to the game as it is. This task changes NO game file.

## Contract
OWNS: tools/amateur_probe.gd, docs/AMATEURPROBE1_RESULT.md
RED_TEST: tools/amateur_probe.gd -> AMATEURPROBE1 careers=<n> (measure only)
REGRESSION: golden_path_test
VISUAL: no

## The job
1. Start from tools/money_four_probe.gd (on main, S429): it plays 52-week careers through the real game (Main.act) with
   the sensible player and four fighters signed on day 1 (Lucy, Kira, Samira, Tess). Copy what you need into your own file;
   do not edit it. Keep its population rule: 10 careers a cell, the same seeds in every cell, stats jittered by seed.
   Stipends fixed as its FOUR_ONE cell (the best one on the stipend, three on day jobs). Fewer than 10 careers a cell = VOID.
2. Find in the code, and SAY in the result file with file and line: where an amateur offer's fight day is set
   (scripts/state/Bouts.gd uses AmateurBooking.fight_day and lead_weeks: 2 to 4 weeks today), how the sensible player sets a
   camp (the `main.act(...)` call and its arguments; BoutRules.PROTOCOLS 0 = None, 1 Light, 2 Standard, 3 Hard), and what a
   camp gives on fight night (BoutRules: `edge`, `focus`; PeakCamp: the peak bonus).
3. Cells:
   (a) TODAY: lead 2 to 4 weeks, camps as the sensible player sets them (the control arm);
   (b) TODAY_NOCAMP: lead 2 to 4 weeks, never start a camp;
   (c) SHORT_CAMP: lead 1 to 2 weeks, camps as the sensible player sets them;
   (d) SHORT_NOCAMP: lead 1 to 2 weeks, never start a camp (the design under test).
   The short lead: the game's constants cannot be changed from a probe, so right after an offer is accepted set that
   fighter's `bout["day"]` to `c.day + 7 * n` with n = 1 or 2 from the career's seed and the offer id (keep it a Saturday if
   the game's own fight_day lands on Saturdays: say what you did). If anything else stores the fight day (the offer, a
   calendar row, the weigh-in), move it too, and say every place you touched. If the game cannot run a bout moved this way
   (weigh-in, tape days), say exactly what breaks and print that cell as VOID: do not fake it.
4. Print one line per career and cell:
   `AMATEUR cell=<id> career=<i> bouts=<n> wins=<n> losses=<n> stoppage_losses=<n> injuries=<n> missed_weight=<n>
   mean_tiredness_at_bell=<x> mean_days_offer_to_bell=<x> ticket_income=<$> cash_w52=<$> closed=<0|1>`
   and at the end `AMATEURPROBE1 careers=<n> (measure only)`.
5. docs/AMATEURPROBE1_RESULT.md, plain words: the population; one table of the four cells (medians: bouts a year for the
   club and per fighter, win share, stoppage losses, injuries, missed weights, tiredness at the bell, days from offer to
   bell, ticket income, cash at week 52, clubs closed). Then six sentences:
   - how many bouts a year does each fighter box at the short lead, against today? (the design aims at 8 to 10)
   - what does dropping the camp cost in win share, at today's lead and at the short lead?
   - does the short lead raise injuries, missed weights or tiredness at the bell?
   - does the ticket money grow enough to change the club's year (cash at week 52 against the control)?
   - what does the sensible player do in the weeks between bouts now that they are shorter, and does anything starve?
   - what could you not measure?
   Bend no threshold. Check your own sums: every count times its price must equal the money you print, or say why not.

## Prior research
docs/MONEYFOUR1_RESULT.md and tools/money_four_probe.gd (the harness and the four-fighter numbers: about 46 bouts a year for
four, about $12,600 in tickets), docs/HANDSPROBE1_RESULT.md (camps are 3.9 weeks on average today),
ops/research/AMATEURWEEK1_MAP_S429.md, ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
A real club coach takes a bout at a week's notice with a boxer who is already in training: no camp, just the weight, a look
at the opponent and fresh legs. He knows what that costs him against a rested, prepared opponent, and takes the bout anyway
because bouts are how amateurs learn.

## Prefab check
tools/money_four_probe.gd and tools/career_harness.gd exist. No asset or library applies.

Every Godot job through the queue: `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver
Dummy --path . --script res://tools/amateur_probe.gd` (the plain win64 exe, never the console one; headless only). Parse
first with `--check-only` through the same queue.
RESULT lines for the PR body: `RESULT: tools/amateur_probe.gd -> AMATEURPROBE1 careers=<n> (measure only)`.
