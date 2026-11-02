# TASK Q184 - QWEN - KICKBOXING FINISHES 7% AGAINST GLORY'S 33%: FIND THE MECHANISM AND FIX IT
Owner: qwen. Assigned S82, 2026-09-26. Model: qwen3-coder, medium, `--yolo`.
Branch: `qwen/q184-kb-finishes` (worktree `%TEMP%\FightCamp-Q164`, reset onto origin/master).

## Why
Q183's census (`research/Q183_DIGEST.md`, 90 bouts per condition, 3 matchups x 30 seeds) reads kickboxing finish
rate **6.7%** (OFF and ON alike). G108 (`research/G108_FINISH_RATES.md` section 3) sourced Glory 2024-25:
**n=201, strike stoppages 67 = 33.3%** (HW 46%, FTW 16%), 3x3 rounds, 3 knockdowns in a round = TKO. Boxing in the
same census finishes 35.6% and MMA 40%, so the stoppage machinery works; something kickboxing-specific starves it.
This is an ENGINE defect, not a band problem.

## What would a human do?
A combat-sports analyst asks where Glory's finishes COME FROM before touching a dial: knockdowns per bout, how many
knockdowns end in a stoppage, the 3-knockdown rule, body/liver kicks and leg-kick accumulation stoppages, and which
weight classes carry them. Then they compare the same counts in our bouts and find the first stage of the funnel where
kickboxing falls off while boxing does not. Tune the stage that is wrong, never the last number.

## The work
1. Funnel census, boxing vs kickboxing, same 3 matchups x 30 seeds (your q183 tool is the base; copy it to
   `Godot/tools/q184_kb_finish_funnel.gd`): per bout - significant strikes landed, damage to head / torso / legs,
   shocks, knockdowns, share of knockdowns that end the bout, standing TKOs, 3-knockdown TKOs, leg-damage stoppages,
   decisions. Label every rate with its divisor.
2. Name the first funnel stage where KB diverges from boxing, with numbers. Suspects (check, do not assume): the
   ruleset's knockdown rule wiring (`FightRealtime.gd:292` THREE_KNOCKDOWN_COUNT - does KB read it?), the standing TKO
   (`FightRealtime.gd:295-335`, `FightStoppageRead.gd`), whether kick damage reaches the shock/knockdown path at all,
   and whether the KB ruleset's round length/count differs.
3. Fix the mechanism at that stage (ruleset-scoped; boxing and MMA finish rates must not move by more than their 95%
   CI). Re-run the funnel: KB finish rate should land in 25-45% for a mixed-weight population. That is a CEILING gate:
   if it lands lower but moved toward the band, say so and push.
4. If the gap is a MISSING mechanism (e.g. no leg-kick stoppage exists), implement the smallest sourced version and name
   the source; if unsourced, write JUDGEMENT in a code comment.

## Owned files
`Godot/tools/q184_kb_finish_funnel.gd`, `research/Q184_DIGEST.md`, and the stoppage/knockdown code you change in
`Godot/scripts/FightRealtime.gd` (5,828 lines - NEVER open it whole; `sed -n 'A,Bp'` windows around :270-:340 stoppage
constants, :1500-:1530 standing TKO, :1685-:1830 result/stoppage) or `Godot/scripts/FightStoppageRead.gd` (small, read
whole). A test for the fix: extend `Godot/tests/fight_realtime_test.gd` or add `Godot/tests/fight_kb_finish_test.gd`
(bound the value, not a monotone direction). Cursor works on MMA leg share in the same file in parallel (U178) - stay in
the stoppage/knockdown code.

## Fixtures
NEVER identical fighters, and every fighter legal for the ruleset: kickboxers who can all kick, differentiated by style
and attributes (outside kicker vs pressure puncher). Name the population in the tool's output.

## Tier
Parse gate on every touched .gd (`python Godot/tools/check_scripts.py <files>`), then the focused test, then
`python Godot/tools/run_tests.py --only fight_realtime,fight_scoring,fight_stage,fight_footwork --jobs 2`. NO full suite
(it runs nightly). At most one Godot run of yours at a time. Commit after each step - an honest partial beats an
uncommitted whole.

## Research
All research is open: root `RESEARCH_INDEX.md` lists every study; J20 and G108 are the anchors. Do NOT read
HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md.

## Done
Commit on your branch, push, then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q184 --body "<stage that diverged + KB finish before->after + boxing/MMA unchanged?>"`.
Do not edit HANDOFF.md.

## The trap
Raising a global damage or stoppage constant would lift KB and also push boxing (35.6%) and MMA past their anchors. The
fix is where KB differs from boxing, and the census must show the other two did not move.
