# TASK MATCHBOTS2 - scouting must buy something again now that pros can be stopped (S547)

Kind: probe (find the cause on the bots' own bouts; then ONE change, in the bot's taste or in the bars, with the
reason written). Model: claude-opus-5-5. Discipline: boxing (demo path). Seat: Claude worker in a console tab.
Estimate: 3 hours (the test takes about 11 minutes a run; run it alone).

## Why
`tests/matchmaking_bots_test.gd` has been red in the 05:00 run since S535 DMGCLASS2 (68067e0ba) took the amateur
four-count limit out of pro world bouts (`WorldBout` passes `rounds >= PRO_FROM` to `Knockdowns.round_counts`). The
rule is right: pros get stopped more. Two bars fail: "smart's median place beats hard's by >= 1" (+0.5: smart 13.0,
hard 13.5) and "scouting is worth it: fewer stoppage losses than blind" (+0.14: smart 0.91 stopped, blind 0.77).
Read plainly: THE BOT THAT SCOUTS IS STOPPED MORE OFTEN THAN THE ONE THAT DOES NOT. If that is also true for a player,
scouting an opponent - a thing the game sells him - does not protect his boxer. That is a mechanic question, not a
test number.

## METHOD (quote in your first message)
A WORKER'S NUMBERS CAN BE RIGHT AND ITS WHY WRONG: open the code lines first; prove the cause with an arm that cannot
share it. MECHANICS NEED 8, PROBE FIRST. The ring is the truth: nothing in `WorldBout`, `Knockdowns` or the fight
changes here. NEVER a bar moved to go green: a margin changes only with the measured reason written beside it.

## What the code says today (read before any run)
- `tests/matchmaking_bots_test.gd` (the four bots; `SMART_AT` 0.55; `SCOUTED_RISK` 2.5: "once it has the tape it treats
  a scouted opponent as this many rating points easier" - the scouting bot takes HARDER fights; nothing in its taste
  prices being stopped), `scripts/rules/Matchmaking.gd`, `scripts/world/WorldBout.gd`, `scripts/rules/Knockdowns.gd`.
- What scouting shows the PLAYER about an opponent's punch and his own boxer's chin: `scripts/rules/Knowledge.gd`,
  `KnowReads.gd`, the bout offer page's read (`scripts/ui/OfferSides.gd` "THE COACH'S READ", RISK line). The bot may
  use only what the player's screen shows after the same looks.
- `ops/research/TASK_NIGHTREDS1.md` (the earlier measurement brief, never run), docs/STRUCTURE_DESIGN_S395.md 5.3a.

## The steps
0. CONTROL: the test as it is, at HEAD and with `rounds >= PRO_FROM` forced false in a COPY of the bout call inside a
   probe (`tools/matchbots2_probe.gd`, the test's bots copied by preload, not pasted): the four bots' median place,
   stopped, top-10, money, both ways. It must show the two bars pass with the four-count limit and fail without it.
   If not, the cause is elsewhere: say where (bisect as NIGHTREDS1 describes) and stop.
1. WHY THE SCOUT IS STOPPED MORE: per bout of the smart and the blind bot - the opponent's place, his power and stop
   rate, our boxer's durability, the read the bot had, the result. Table: stoppage losses by the opponent's power third,
   smart v blind. Name the cause in one sentence (expected: the tape makes the bot braver against everyone, punchers too).
2. ONE CHANGE, decided by step 1, written before the run:
   (a) if scouting shows the player the opponent's punch (it should: say which screen line), the smart bot prices it -
       a scouted puncher against a low chin is read HARDER, not easier - and the bars are re-read unchanged; or
   (b) if the player's screen does NOT show it, that is the finding: write what line the read needs (a design note for
       the coordinator, no UI built here) and give the bot only what the screen has.
   Then, only if the bars still fail with the cause removed: re-set a margin, with the two-way table that justifies it.
3. GREEN: `matchmaking_bots_test` passes, run twice (it is seeded: two runs print the same lines).

## Not allowed
No change under scripts/ (if the read needs a line, write it down). No edit of another test. One Godot process at a
time through `python ops/Tools/godot_slot.py run --who MATCHBOTS2 -- <command>`; watchdog before each job; long runs
write to a file.

## Feedback loops
The bot's taste feeds which fights it takes, those feed its rating and place, the place feeds which offers come: the
test already runs that loop for 24 months and is capped by the table's size. One-rep trial: 10 careers a bot, both
arms of step 0, before the 120-career runs; stop if smart and blind print identical lines (scouting not wired).

## Prior research
`python ops/Tools/prior_research.py matchmaking bots scouting stoppage`; docs/STRUCTURE_DESIGN_S395.md 5.3a;
`ops/research/TASK_NIGHTREDS1.md`; `docs/DMGCLASS2_RESULT.md` if present.

## What would a human do?
A matchmaker who watched tape and still got his man knocked out more often would ask what the tape told him about the
other man's punch - and whether he looked.

## Prefab check
None to take: the bots and the world sim are ours.

## Contract
OWNS: tests/matchmaking_bots_test.gd, tools/matchbots2_probe.gd, docs/MATCHBOTS2_RESULT.md
RED_TEST: tests/matchmaking_bots_test.gd
REGRESSION: tests/matchmaking_bots_test.gd (run twice; no other test reads the bots)
VISUAL: none

## Result
`docs/MATCHBOTS2_RESULT.md`: the control's two-way table, the cause in one sentence with its table, the change and
why, the bars before and after, whether the PLAYER's screen shows what the bot now uses (the line, or the gap), and
`RESULT: tests/matchmaking_bots_test.gd -> <exact pass line>`. Commit only your own paths with a pathspec; do not
push; do not ask questions: decide, and write what you decided.
