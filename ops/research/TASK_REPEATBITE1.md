# TASK REPEATBITE1 - make repeated combos bite: greybox probe of three variants, then build the winner (S539)

Model: claude-opus-5-5 (Code Mode tab, owner's subscription). Discipline: boxing (demo). Board row DEPTH1 / plan chart.

## Why
Owner Q-S294-306, asked "Repeated-combo penalty fires 3 times in 600 bouts. Make repeats cost more?": "Yes, make it bite"; in
chat: "yes, make repeated combos matter more". His original ask (Q-301): "maybe add a penalty if some combos are repeated too
often the have a bigger chance to be read by the opponent for a counter punch".
Today: scripts/rules/PlanRead.gd ADJUST 0.7 after FREE_USES 2 a round, on the edge only (S396), now SHOWN (PLANREADSHOW1,
983016e51: LiveRound read_adj, ExchangeBeats/FightNight line, ResultTabs, PlanChart chip). It fires ~3 in 600 bouts: a bout has
~18 throws, a round 6 exchanges, and a 30% edge trim is invisible. REPEATREAD1 (docs/REPEATREAD1_RESULT.md, S538) tried a window
rule and FAILED: SPAM lost only -0.9 overall, -2.8 vs the counter-puncher (bars 5 and 2).

## Do
1. Read PlanRead.gd, LiveRound.gd around the ADJUST call and the read_adj record, docs/REPEATREAD1_RESULT.md and its probe
   (tools/repeatread*), docs/PLANREADSHOW1_RESULT.md. Reuse REPEATREAD1's population (60 boxers x 6 opponent styles x 3 nights)
   and its SPAM / WEAPON / SPREAD plans; a bout's dice are the fight day's.
2. Probe three variants (rules copy in tools/, the game untouched), each with the count of reads a bout and the win change:
   A. THE COUNTER: once a move is read (it has been thrown N times in the bout - try N 2 and 3 - counting every throw, plan
      line or instinct), each further throw of it has a chance to be COUNTERED: the opponent lands a clean shot instead
      (damage + the exchange lost), counter-puncher x1.75, a fighter with high ring IQ reads one throw sooner.
   B. THE MEMORY: A, and the read carries across rounds (it fades by one between rounds, the corner's "change it up" call
      clears it).
   C. THE FILM: B, and an opponent whose camp filmed your boxer starts the fight with the boxer's most-thrown move of the last
      bout already half-read (wires into the existing film/OppFile path if it is cheap; else drop C).
   Bars, written in the result BEFORE the run, not loosened: (a) SPAM loses 5+ in 100 against the counter-puncher and 2+
   overall; (b) with the rule ON a plan with a main weapon still beats the even spread against at least two styles; (c) every
   effect larger than 2 standard errors; (d) the read FIRES - a live "they have your X now" line - in 25 to 60 bouts of 100
   for SPAM and under 15 for SPREAD; (e) no variant makes one plan shape the answer against all six styles.
3. Pick the smallest variant that passes (FREE HAND, owner S534: cut, add, interconnect) and BUILD it ON (GameSwitches.GAME_ON,
   read with GameSwitches.on()): the rule in PlanRead.gd, the counter in the exchange settle, the record through PLANREADSHOW1's
   read_adj path; the live line and the result Plan tab line already exist - make them say the counter ("countered: they
   timed your one-two"). Red test first: tests/repeat_bite_test.gd (SPAM vs a counter-puncher gets countered; a varied plan
   does not). Keep tests/plan_read_shown_test.gd, plan_read_test, result_tabs_test, plan_chart_test, golden_path_test green.
   If NO variant passes: write that, build nothing, report.
4. docs/REPEATBITE1_RESULT.md: the three variants' tables, bars, the pick and why, what the player sees.

## Prior research
docs/REPEATREAD1_RESULT.md, docs/PLANREADSHOW1_RESULT.md; `python ops/Tools/prior_research.py counter read repeat combo`;
memory feedback_probe_population_and_dice_s533, feedback_long_probe_output_to_file_s533.

## What would a human do?
A coach watching his fighter throw the same one-two for the third time shouts "he's waiting for it!" - and the next one gets
countered. The fix is to mix it up, and good opponents punish the fighter who doesn't.

## Prefab check
None (our own rule).

## Contract
OWNS: scripts/rules/PlanRead.gd, scripts/state/LiveRound.gd (the read and the counter only), scripts/rules/PlanReadShow.gd,
tools/repeatbite1.gd, tools/repeatbite1_rules.gd, tests/repeat_bite_test.gd, docs/REPEATBITE1_RESULT.md
RED_TEST: tests/repeat_bite_test.gd
REGRESSION: tests/plan_read_shown_test.gd, tests/plan_read_test.gd, tests/result_tabs_test.gd, tests/plan_chart_test.gd, tests/golden_path_test.gd
VISUAL: no (the screens exist; text only)

## Rules
Work in main. Godot ONLY via `python ops/Tools/godot_slot.py run --who repeatbite1 -- <godot> --headless --audio-driver Dummy
--path . --script ...`, one run at a time (other probes are running); long output to a file under E:/FightCamp/tmp/repeatbite1/,
wait on its done line. Read ops/research/GDSCRIPT_TRAPS.md. No script over 500 lines. Commit only your paths (`git add -- <new>`
then `git commit -m ... -- <paths>`), push. When done run `python ops/Tools/idle_guard.py ok REPEATBITE1-done`, report in two
lines, stop.
