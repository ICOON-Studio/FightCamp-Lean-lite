# TASK Q216 - The engine's red tests outside boxing: judo ippon, the Muay Thai adapter, MMA bands, the hang

Owner: **Qwen** (identity `qwen`, CLI `--yolo`). Model: qwen3-coder (fixed at assignment; do not self-escalate).
Assigned S122 (Claude), 2026-09-29. Milestone: these are DEFECTS, fixed now under the operator's 2026-09-27 rule
("when you notice something you have to act on it"), even though the active milestone is the boxer.

## Why
Red in the nightly suite (AgentComms/nightly/latest.txt, 2026-09-28 at 6d2a4201) and on master:
- `fight_scoring_test` - "a clean uchi-mata carries enough magnitude to be an ippon (19 >= 22)", "judo: a perfectly
  executed uchi-mata is IPPON and ends the bout at once", "a finished result stamps its own scoring style". Red every
  night since at least 2026-09-26.
- `grapple_adapter_test` - "seeded MT witness seed 93003 must not land a throw after Q166 re-pin"; "MT adapter moved
  striking for a round 1 expected=24.21 actual=37.51" (rounds 2, 3 too). New 2026-09-28.
- `fight_back_bands_contract_test` - "two strikers (grapple gap) sub-finish share 33.3% not in 12-32%". New 2026-09-28.
- `fight_plan_ai_corner_test` - "the better coach's plan won less often, pooled". New 2026-09-28.
- `fight_footwork_economy_test` - "mma ON m/min >= 12 (got 9.3)". New 2026-09-28.
- `fight_metres_test` - HANGS (timeout). Red since at least 2026-09-26.
- `fighter_reachability_contract_test` - "f01_m_box_welter neck 0.15 has no usable approach". Red since 2026-09-26.

## What would a human do?
A gameplay/systems engineer triages each red as TEST-IS-STALE or GAME-IS-WRONG before touching code: read the test
header (it names the rule, the source study and the population), run it alone, and find the commit that turned it
red (`git log -- <files it touches>`, and bisect with the test as the probe when unsure). A stale test is restated to
the current design in the test, quoting the change. A real regression is fixed at its cause with a control arm
(same seed, number before and after). A hang is debugged by finding the loop that never exits (print the tick / the
state in the loop), never by raising the timeout. Bands are never widened to pass.

## Prior research (primary studies - read the relevant section)
- Judo scoring: `research/U69_IPPON_LINE.md` (the ippon line when the catalogue moved),
  `U74_JUDO_THROWS_OVERSCORE.md`, `U190_DIGEST.md`, `J27_FREQUENCIES_AND_THROW_DEFENCE.md`,
  `COMPETITION_RULESET_RESEARCH.md`.
- Muay Thai adapter: `research/Q24_MUAY_THAI_ADAPTER.md`, `Q166_DIGEST.md` (the re-pin the test names).
- MMA bands / ground: `research/G34_GRAPPLING_CONTRACT.md`; the back-bands test header names its sources.
- `research/S122_DIGEST.md` - TONIGHT'S ENGINE CHANGES (read first): footwork is a `footwork` event, never an
  `action`; boxing_output retuned (JAB_USAGE_MULT 2.6, CONTACT_LADDER 0.58, new FOOTWORK_MULT 0.25);
  AthleteDevelopment.migrate_athlete now seeds the S33 grapple trio; carry_progress contract restated for the S117
  tier 1-2 floor. A seeded number may have moved because of these - say so if it did.
- All research is open: root `RESEARCH_INDEX.md`.

## Prefab check
None: these are our own engine's tests and data.

## Build (in this order; push the branch after each test goes green)
1. `fight_metres_test` hang first (a hang can hide other failures): find the loop, fix it.
2. `fight_scoring_test` (judo ippon), 3. `grapple_adapter_test`, 4. `fight_back_bands_contract_test`,
5. `fight_plan_ai_corner_test`, 6. `fight_footwork_economy_test`, 7. `fighter_reachability_contract_test`.
For each: decision (stale test / real regression), the commit that caused it, the fix, before/after.

## Gate
- Each test passes, or the digest says exactly why it cannot yet. Ceiling, not an exact count.
- Boxing is NOT to move: `boxing_output_test.gd`, `footwork_not_a_blow_test.gd`, `judge_panel_test.gd` still pass,
  and if you touch FightRealtime.gd run `tools/u195_engine_census.gd -- bouts=20 ruleset=boxing switch=feint` and
  show the all_on row unchanged (S122: KO+TKO 45.0%, acc 31.5% at 120 bouts).
- NEVER TEST IDENTICAL FIGHTERS; a fighter must be legal for his ruleset.

## Tests (tier: script edited)
Parse gate first: `python Godot/tools/check_scripts.py <touched .gd>`. One test:
`"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tests/<name>.gd`
Subset when done: `python Godot/tools/run_tests.py --only fight_scoring,grapple_adapter,fight_back_bands,fight_plan_ai,fight_footwork_economy,fight_metres,fighter_reachability,boxing_output,footwork_not_a_blow,judge_panel --jobs 2`.
NO full suite.

## Owned files
The seven tests above; `Godot/scripts/FightRealtime.gd` (7,403 lines - NEVER open whole; `grep -n` then
`sed -n 'A,Bp'`), `FightMoves.gd` (1,720 lines - same), `GrappleResolve.gd`, `JudgePanel.gd`, `RoundScoring.gd`, the MT
adapter script the test loads, `Godot/assets/data/technique_catalog.json` (data fixes only, cite the source).
NOT `FightWorldLiveScreen.gd` / `FightStagePlayer.gd` (Cursor's U196 holds them).

## Deliver
Branch `qwen/q216-engine-reds` in your own worktree (`git worktree add ../FightCamp-Q216 -b qwen/q216-engine-reds origin/master`).
Commit per fix, push, write `research/Q216_DIGEST.md` (one section per test), send one line:
`python Tools/agent_comms.py send --from qwen --to claude --task Q216 "<summary>"`. Do NOT edit HANDOFF.md.

**The trap:** a census or seeded test that reads different tonight may be reading the S122 footwork change, not your
edit - run the test on `origin/master` BEFORE your change and cite both numbers.
