# KNOWMISREAD1 result - let the player be wrong about people (DEPTH_SCOPE_S534 change 4)

Status: TEST LANDED, RULE ALREADY BUILT, PROBE BELOW THE BOUND ON TWO OF THREE SEED SETS. Discipline: boxing. S534, 2026-11-21.

## What was found
1. The shared misread was ALREADY in the game. `scripts/rules/Knowledge.gd` has carried `SHARED_MISREAD := 0.5` in
   `_offset` since S527 (commit 039578f8d, "KNOWBOTS6 passes at rho 0.5 -> Knowledge shared misread"). DEPTH_AUDIT_S534
   row 19 quotes the older numbers (0.83 off, under 8%) from KNOWBOTS4 and 5, measured before that build. So step 2 of the
   brief needed no code: Knowledge.gd is unchanged by this task.
2. New test `tests/know_misread_test.gd` (11 checks, public calls only: shown, range_of, all_seen, KnowReads.apply).
   Population: 400 fresh prospects, seeds 61000.., each with different true attributes.
   - built rule: `KNOW_MISREAD failures=0 (11 checks)`; mean |shown rating - true| = 1.63; 142 of 400 misread by 2+ points.
   - red arm (a scratch copy of Knowledge with SHARED_MISREAD 0.0, the tree before S527): 3 failures - mean 0.81,
     22 of 400 misread by 2+, body and skills lean the same way 51% (a coin).
   It also holds: the truth is inside every range; the miss never passes 0.6 of the mean half-width; same seed, same
   misread; a fully seen boxer and a known group show the truth; a closer look, a test day, a trial and a hard spar
   cut the mean misread by 40%+ and never flip its direction. (The game has no "film" read on prospects; the reads
   tested are the four KnowReads has.)
3. KNOWBOTS6's probe re-run on the BUILT rule (same worlds, same two signers, 60 worlds a set, 4 signings a world;
   the probe's own lever at 0, so the shown rating is exactly what the game shows). Mean |shown - true| = 1.771,
   the same as KNOWBOTS6's 0.5 arm, so the rule measured is the rule KNOWBOTS6 sized.

| Seed set | Top-10 boxers, blind signer | Knows the truth | Worth | Bout wins worth | Flops (blind / knows) | Cash worth |
|---|---|---|---|---|---|---|
| 7000 | 91 | 95 | +4.4% | +0.9% | 28 / 11 | +4.2% |
| 8000 | 87 | 95 | +9.2% | -0.8% | 32 / 14 | +3.1% |
| 9000 | 89 | 96 | +7.9% | +4.8% | 30 / 16 | +4.1% |

KNOWBOTS6 (S527) read +8.7 / +9.8 / +14.4% on the same sets. Today: +4.4 / +9.2 / +7.9% (mean +7.2%).

## Verdict
The brief's bound (knowing the truth worth 9 to 14%) is NOT met on today's tree: one set of three is inside it.
The misread itself is as sized (1.77 points, a blind signer flops twice as often: 90 against 41), but it buys fewer
top-10 boxers than it did two days ago.

Why the number moved (read, not measured): Knowledge, the world files, Matchmaking, AttrGen and the probe have no
commit since 039578f8d. The fight rules under Matchmaking.fight do (S531-S533: steps, place edge, plan "want", fatigue,
turn-pro gap curve), and LineGrade.gd carries another session's uncommitted edits. Bouts resolve differently, so the
same picks rank differently.

The ruler is also coarse: a set's result is a difference of 4 to 8 boxers in about 90. One set cannot tell 5% from 10%.

## What this means for row 19 (whom to sign)
- "Wrong about people" is real and tested, and it shows where it should: the existing ranges, no new screen.
- It is not yet proven worth 9%+. Not closed; it should not go to critics as "fixed" on this evidence.

## Next (not done here - outside this task's files)
1. A sharper ruler before any number changes: the same probe with the per-world difference kept (blind and knowing
   signer on the same world), 180+ worlds, so the result carries its own spread. About 35 minutes of PC time.
2. On that ruler, the share at 0.5 against 0.8 (KNOWBOTS6 ran 0.8 and 1.0; mean misread 2.72 and 3.37). If 0.8 clears
   9% with room, changing it is one constant in Knowledge.gd and two bounds in the tests.
3. The audit's other half of change 4 - the same shared misread on the opponent's file, which is what would make the
   $250 scout pay (row 36) - is not built and was not in this brief.

## Tests run (all through godot_slot)
know_misread_test 0 failures (11); knowledge_test 0 (17); know_reads_test 0 (15); know_wire_test 0;
knowledge_keep_test 0 (13); knowledge_shared_test 0 (4); golden_path_test: GOLDEN_PATH failures=0
