# TASK C228 - angles of attack + guard coverage (engine, Codex, long run)
Model: gpt-6-luna, medium (operator rule 2026-09-25: luna for engine, astra only for 3D animation). Owner: Codex. Branch: codex/c228-angles-guard.

## Why
Operator 2026-09-30 brief (FM-style boxing engine), point 4 is the one the engine does not have:
"If a fighter utilizes footwork to step outside the opponent's front foot (creating a T-angle), the opponent's
defensive success probability drops ... The engine calculates the defensive guard as geometric hit-boxes (e.g., High
Guard covers the head but opens vector paths to the liver and ribs)."
Today: `FightDefenceModel.gd` (490 lines) decides read -> family -> height -> timing -> evade with NO angle input, and
guard is only a block HEIGHT (`choose_block_height` line 159, `height_covers` line 176). Facing exists
(`FightBearing.gd`, fighter key "bearing"), positions are fixed-point `pos_x`/`pos_y` (`FightRealtime.gd:1760`),
stance ORTHODOX/SOUTHPAW (`FightStance.gd:37-38`, `Stance.of`).

## Prior research (read first, in this order)
- `python Tools/prior_research.py angle guard outside foot coverage` and read `research/topics/footwork.md` (136
  lines, the Open + Engine sections).
- `research/Q71_BOXING_EVASION.md` (guard kinds, `FightMoves.gd:918 guard_from_node`).
- `research/G99*` (CompuBox bands: thrown 45-56/rd, connect %, jab share 40-44%) - the census bands below.
- Sources you add must be labelled DOCUMENTED / SECONDARY / PROXY / NO STUDY with the citation, like G152's digest
  (`research/G152_JUDGES_DIGEST.md` table is the model).

## What would a human do?
A combat-sim designer: (1) compute ONE number per exchange - the attacker's angle off the defender's centre line,
taken from positions, bearing and both stances (outside the lead foot vs inside, orthodox vs southpaw); (2) feed it
into the existing perceive/evade/block chain as a modifier with a sourced or labelled magnitude, never a new chain;
(3) turn the guard into coverage per target zone (head / body-lead side / body-rear side) with a guard KIND per
fighter state (high guard, long guard, shell, low hands when tired) so a high guard trades body exposure for head
cover; (4) census before/after on legal, different boxers; (5) leave every existing band green.

## Prefab check
None: our own engine. No new dependencies. (Name any library you consider and why it was refused.)

## Owned files
- NEW `Godot/scripts/FightAngles.gd` - pure static, zero preloads: `attack_angle_deg(att_pos, att_bearing, def_pos,
  def_bearing, att_stance, def_stance) -> float`, `outside_lead_foot(...) -> bool`, `angle_defence_mult(angle_deg) ->
  float` (1.0 at 0 deg).
- NEW `Godot/scripts/FightGuardCoverage.gd` - pure static: guard kinds, `coverage(kind, zone) -> float 0..1`,
  `kind_for(fighter_state, stamina, plan) -> String`.
- `Godot/scripts/FightDefenceModel.gd` - ONLY add optional trailing parameters with neutral defaults to
  `resolve_at_contact` (line 241) and use them; every existing caller byte-identical when they are absent.
- `Godot/scripts/FightRealtime.gd` (7460 lines, NEVER read whole: `sed -n 4740,4800p` is the contact window; the call
  is at line 4767; `DEMO_SWITCHES` line 1080; option parsing near line 1125) - pass the new inputs ONLY when switch
  `angle_guard` is ON; add `"angle_guard": true` to DEMO_SWITCHES only after phase 4 passes.
- NEW tests `Godot/tests/fight_angles_test.gd`, `Godot/tests/fight_guard_coverage_test.gd`; NEW census
  `Godot/tools/c228_angle_census.gd`.
- NOT yours: FightClipBinding.gd, tools/c223_*.gd, FightStagePlayer.gd, GameState.gd, UIKit.gd (Qwen and Claude own them).

## Phases (commit + push after EACH phase; never stop at "written")
1. FightAngles.gd + its test: angles from constructed positions (straight on = 0; outside the lead foot of an orthodox
   man = the side the test names; southpaw mirror). Mutant: flip the stance sign -> the test must fail.
2. Wire the angle into `resolve_at_contact` behind `angle_guard`: defence (read + evade + block) scaled by
   `angle_defence_mult`. OFF = byte-identical (hash test like `boxing_output_test.gd:42` T1).
3. FightGuardCoverage.gd + test + wire: high guard covers head, leaves body zones partly open; tired -> hands drop.
   Body-shot share and landed% must move the right way in the census.
4. Census `c228_angle_census.gd`: 40 seeded BOXING bouts x 3 rounds, OFF vs ON same seeds, the population = three legal,
   DIFFERENT boxing matchups with boxing plans (copy `Godot/tools/c226_stamina_census.gd` lines 86-100: out-boxer /
   pressure / counter; boxing ruleset from combat_rulesets.json). Print: thrown/man/rd, connect %, jab share, body-shot
   share, share of exchanges from outside the lead foot, landed% inside vs outside, finish rate. Pass: ON connect and
   jab share inside G99 bands (as `boxing_output_test.gd` checks them), landed% outside > inside, finish rate inside
   the bands `fight_pace_anchor_test` and `boxing_output_test` hold. Never loosen a band.
5. Footwork that SEEKS the angle: a pressure / high-IQ fighter's circle intent prefers stepping to the outside of the
   lead foot (FightIntent / FightFootwork hook, behind the same switch), census again: outside-foot share rises with
   ring IQ, not for everyone equally.
6. Digest `research/C228_DIGEST.md`: sources table, before/after census, every constant labelled
   AUTHORED/DERIVED/SOURCED, what is still open.

## Tests (tier: a script edited)
Parse gate first: `python Godot/tools/check_scripts.py <touched .gd>` (a parse error hangs a headless test).
Focused: `python Godot/tools/run_tests.py --jobs 2 --only fight_angles,fight_guard_coverage,fight_defence_model,fight_bearing,boxing_output,fight_pace_anchor,fight_realtime`
fight_realtime_test takes >10 min on a slow box: if the runner times it out, run it alone
(`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_realtime_test.gd`) and report both.
Watchdog before every heavy run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`.

## The one trap
Two fighters in a test or census are NEVER identical (stats, plan, reach differ) and are LEGAL for boxing: no mma_*
plans in a boxing ruleset (C226b made exactly that mistake). The exit code alone is not a pass - read for SCRIPT ERROR
and the FAIL lines.
