# TASK STOPWORD1 - the Ask card's stoppage word: measure the risk, then the pure rule (probe + rule, no screen)

Status: OPEN (S513, Claude main line). Discipline: boxing. Model: qwen3-coder (or any seat that runs Godot).
Source: Ask for a bout (built S512). Map ops/research/ASKFIGHT_MAP_S441.md lines 82-83: the card says the stoppage chance
IN WORDS ONLY - "unlikely / possible / a real risk" - never a number the player can sort by. The card already has the
slot (scripts/rules/AskBout.gd `card(..., stop_words)`, key "stoppage") but scripts/state/AskFlow.gd line 93 passes ""
because no chance figure exists. Claude wires the word into AskFlow after this lands.

## Contract
OWNS: tools/stop_word_probe.gd, docs/STOPWORD1_RESULT.md, scripts/rules/StopWord.gd, tests/stop_word_test.gd
RED_TEST: tests/stop_word_test.gd -> STOP_WORD PASS
REGRESSION: ask_bout_test, ask_wire_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py stoppage ask card`. Read AskBout.gd (card, answers: the opponent rows carry a
rating), AskFlow.gd (answers -> card), tools/ask_probe2.gd (the real-bout loop: Bouts.fight_step to the end; its seed
4421 population), Bouts.stopped / BoutNight.stopped (how a stoppage is read off the bout). ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
A coach looks at the other boxer's level and record and says "he won't stop you", "he could", or "he can really hurt you".
So: fight many real bouts at each level gap and count how often OUR boxer is stopped.

## Prefab check
None needed: the bout sim is ours and the chance has to come from it (a public KO-rate table would not match our sim).

## The job
1. tools/stop_word_probe.gd (SceneTree, headless): the TEST CLUB's three boxers (scripts/state/TestClub.gd), each against
   real amateur opponents of the same sex and class (Data.OPPONENTS etc., as ask_probe2 picks them) whose rating sits at
   a gap of -15, -10, -5, 0, +5, +10, +15 from the boxer's fight rating (opponent minus ours; nearest available). 60
   bouts per gap per boxer through the game's real bout (Bouts.fight_step to the end, ask_probe2's loop), distinct
   opponents where the pool allows, seeds off 4421. Count: our boxer stopped, the opponent stopped, decisions.
2. docs/STOPWORD1_RESULT.md: the table (gap -> our stopped %, their stopped %, n), the population named, and the bands.
3. scripts/rules/StopWord.gd (pure, no preloads): `static func word(gap: float) -> String` returning "unlikely",
   "possible" or "a real risk", plus `const` band edges in rating points read off the table with these chance edges:
   unlikely = our boxer stopped under 8 % of bouts, possible = 8-20 %, a real risk = over 20 %. If no gap reaches a band,
   say so in the result and keep the band's edge beyond the measured range. A one-line `## why` comment names the table.
4. tests/stop_word_test.gd: word() at each measured gap matches the table's band; it never gets SAFER as the gap grows
   (monotone); it only ever returns the three words. Last line `STOP_WORD PASS` (or FAIL n).
Last printed line of the probe: `STOPWORD1 done`.

## Rules for this seat
Godot only through godot_slot, headless, `--audio-driver Dummy`, `--fixed-fps 60`, `--log-file E:/FightCamp/tmp/<run>.log`.
No screens opened. Nothing outside OWNS; never touch scripts/fight3d/. No two identical fighters in a measurement.

## The one trap
The pool of a weight class is small (4-11 fighters): at big gaps the "nearest" opponent may be far from the asked gap.
Record the REAL gap of every bout and bucket by it, not by the gap you asked for.
