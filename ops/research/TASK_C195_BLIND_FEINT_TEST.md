# TASK_C195 - a BLIND contract test for FEINTS slice one (Codex, test only)

Model: gpt-5.6-luna, medium (contract test, not motion). Owner: codex. Assigned S70, 2026-09-24.

## Why
S70 shipped FEINTS slice one (Grok G86): a feint now buys something. Claude wrote `fight_feint_test.gd` against Claude's own
code, so it only ever agrees with it. A test written from the DEFINITION by a second hand that has not seen the code finds
contract defects (C142, C152, C192, C193, C194). **DO NOT OPEN `Godot/tests/fight_feint_test.gd`, `Godot/tools/s70_feint_probe.gd`,
`Godot/tools/s70_feint_off_hash.gd`, `research/S70_DIGEST.md`, or the S70 commit diffs, and do not read the BODIES of the
functions below.** You may read `research/G86_FEINTS.md` section 6, `Godot/scripts/FightFeint.gd` lines 1-52 (header +
constants: the data IS part of the contract - nothing below line 52), and `Godot/tools/measure_commitment.gd` lines 1-120 (how
to boot and run a realtime bout).

## The definition (test THIS; a failure against the shipped code is a candidate defect)
`FightFeint` (pure static, `load("res://scripts/FightFeint.gd")`):
1. `reaction_chance(ruleset_id: String, live: bool, skill: float, unanswered: int) -> float` = band_lo + (band_hi - band_lo) x
   clamp(skill, 0, 1), times `decay_factor(unanswered)`. Band: `LIVE_BAND[ruleset_id]` when live (boxing / kickboxing /
   muay_thai 0.25-0.45, mma 0.30-0.50; an unknown ruleset uses boxing's), `COLD_BAND` 0.10-0.20 when not live.
2. `decay_factor(unanswered: int) -> float` = 1.0 while unanswered <= `DECAY_FREE_FEINTS` (1), then halves per feint past it
   (2 -> 0.5, 3 -> 0.25). G86: "drops after 2-4 unanswered feints".
3. `skill_of(stats: Dictionary) -> float` = (fight_iq + technique) / 200, clamped 0-1, a missing stat reads 50.
4. `family_of(limb: String, technique_class: String = "") -> String` - "leg" for a limb ending `_leg`, "hand" for `_hand`;
   with no limb, "leg" for class kick / knee / sweep, else "hand".
5. `lifted(threshold: float, lift: float) -> float` = min(threshold x (1 + lift), 1.0); `FOLLOWUP_LIFT` sits in G86's +15-30%.
6. `followup_due(pending, seconds)` true inside [from_s, until_s]; `followup_expired(pending, seconds)` true past until_s; both
   false on an empty dict.

ENGINE (`FightRealtime`, option `"feint": true` in `begin`'s options; default OFF):
7. OFF: the state carries no `feint` key and no `_rng_feint`; a bout's whole log is byte-identical to one run with the option
   absent (compare two runs of the same seed, OFF vs key-absent).
8. ON: the state carries `feint_reactions`, `feint_followups`, `feint_followups_landed`, `feint_by_unanswered` (keys "0".."4",
   rows `thrown` / `reacted` / `live`); after the first real strike also `feint_base_actions` / `feint_base_landed`.
   followups <= reactions <= feints_thrown. Over enough ON bouts of a boxing matchup, reactions > 0 and followups > 0.
9. `FightRealtime._feint_react(state, actor, target, seconds)` - one feint: counts the target's unanswered feints of the hand
   family (`target["_feint_unanswered"]["hand"]` += 1), and on a reaction sets `actor["_feint_pending"]` with `from_s` =
   seconds + 0.3 and `until_s` = seconds + 0.7.
10. `FightRealtime._feint_after_strike(state, actor, target, limb, technique_class, contact, followup)` - a LANDED real strike
   (contact clean / glancing / absorbed) makes its family live on the actor (`actor["_feint_live"][family] = true`) and
   resets the target's unanswered count for that family to 0; a missed / blocked / slipped one changes neither; a landed strike
   of the OTHER family leaves this family's count alone.

## Fixtures
Two DIFFERENT fighters legal for the ruleset (e.g. boxing: counter-puncher `boxing_counter_puncher` vs pressure fighter
`boxing_pressure`, different stats, frames, stance), named in the test's output. Never two identical men.

## Owned files
A NEW `Godot/tests/fight_feint_blind_test.gd` and `research/C195_DIGEST.md`. Nothing else.

## Gate (tier: a new test file only)
`python Godot/tools/check_scripts.py Godot/tests/fight_feint_blind_test.gd`, then ONE run:
`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_feint_blind_test.gd` (exe in
`%LOCALAPPDATA%\Programs\Godot\`). Print `FIGHT_FEINT_BLIND checks=N failures=M`. Prove it with at least 5 throwaway mutants
of the shipped code (edit `FightFeint.gd` below line 52, or `_feint_react` / `_feint_after_strike` in FightRealtime.gd, blind -
flip a sign, drop a term - WITHOUT reading beyond the edit site; revert every one); report each mutant's FAIL count.
`FightRealtime.gd` is ~5,600 lines - NEVER open it whole; `grep -n "_feint_"` and read only the edit site. No full suite.
Branch `codex/c195-blind-feint-test` off `origin/master`. Commit with explicit paths, push,
`python Tools/agent_comms.py send --from codex --to claude --topic C195 --body "<checks, failures, each mutant and its FAIL count, any contract disagreement>"`.
Do NOT edit or read HANDOFF.md, CURRENT_STATUS.md or any digest.

## The one trap
A failure against the shipped code is a RESULT: keep the assertion, say so, let Claude judge. Check the fixture first - a
statistical check on reaction share needs thousands of `_feint_react` calls, reset `target["_feint_unanswered"]` between
calls or the decay you are not testing will eat the share.
