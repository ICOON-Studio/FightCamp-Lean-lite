# TASK KNOWBOTS1 - prove the reads are worth paying for before Knowledge is wired (bots, no screen)

Status: OPEN (S461, Claude main). Discipline: boxing. Model: Antigravity (agy), high.
Mechanic: PROGRESSIVE KNOWLEDGE (approved Q-S294-139; design ops/research/KNOWLEDGE_S411.md - READ IT WHOLE, especially "First,
prove it" and the build order). Step 1 is built: scripts/rules/Knowledge.gd (fresh / all_seen / width / expose / range_of / stale)
with its truth-inside test. This is STEP 2, the bots test: "stop here if it fails". Nothing is wired (INTEGRATION_S459.md row 10).

## What is measured
tools/knowbots_probe.gd: 60 seeded worlds (scripts/world/WorldSim.gd, as tests/world_years_test.gd and tests/matchmaking_bots_test.gd
drive it), each run for 4 years. In each world the player's club signs from prospects (scripts/rules/Recruit.gd makes them) and
trains them on the game's own rules. Three bots, same seeds, same prospects:
- BLIND: signs by the SHOWN centre only (Knowledge.range_of with a fresh knowledge dict and the prospect's hype), never pays a read.
- READER: pays reads where they narrow a choice: Scout a prospect ($250 G, one group sharpened, Knowledge.expose), a Trial (four
  weeks' stipend, G), Test day on its own boxers; signs on the range it then sees. Charge every read's cost to the club's money.
- BAD SIGNER (control arm that cannot share the bug): signs the lowest shown centre. It must do clearly worse than BLIND, or the
  harness cannot tell a good signing from a bad one.
The bout always reads the TRUTH (the design's rule): Knowledge changes only what the bot sees, never a fight.

## Pass line (the design's)
READER's boxers reach the world top 10 at least 5 more times per 60 worlds than BLIND's, AFTER what it paid for reads (report
money too). Report: top-10 appearances, titles, money spent on reads, signings that flopped (truth far under the shown centre),
per bot. If READER misses the bar, say so plainly: the design changes ("the reads are decoration"), not the bar.

## Contract
OWNS: tools/knowbots_probe.gd, docs/KNOWBOTS1_RESULT.md
RED_TEST: tools/knowbots_probe.gd -> KNOWBOTS1 done (a probe; docs/KNOWBOTS1_RESULT.md is the deliverable)
REGRESSION: knowledge_test, world_years_test
VISUAL: no
NOT YOURS: every file in scripts/ and tests/ (read-only). Constants marked G in Knowledge.gd are the design's guesses: report what
they would need to be, never edit them.
(knowbots_probe.gd under 500 lines; a second file tools/knowbots_bots.gd if needed. FIRST a pilot of 4 worlds and print the projected
wall time; if 60 worlds pass 90 minutes, cut and say so. Runs only through `python ops/Tools/godot_slot.py run --who knowbots --
<godot> --headless --audio-driver Dummy --path . --script res://tools/knowbots_probe.gd`. PR body: `RESULT: tools/knowbots_probe.gd
-> reader_minus_blind=<n> per 60 worlds pass=<yes|no>`.)

## Prior research
KNOWLEDGE_S411.md; TASK_KNOW1.md (the module contract); tests/knowledge_test.gd; tests/world_years_test.gd and
tests/matchmaking_bots_test.gd (how a world is run and read).

## What would a human do?
A club coach who trials a lad for a month before signing him, and spars him hard before booking a step up, keeps fewer flops.
Measure whether the game rewards that before showing ranges on every screen.

## Prefab check
None: the probe reuses the game's world, recruits and Knowledge.gd.

## The one trap
Never let Knowledge change a fight or a training gain: the truth drives everything; the bots differ ONLY in what they see and pay.
