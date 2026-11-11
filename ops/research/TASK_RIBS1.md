# TASK RIBS1 - CURSOR (Grok 4.7 High) - the ribs take damage normally (the defect, before the redesign)

Status: OPEN (S437, Claude main). Discipline: boxing. Model: grok-4.7-high.
Source: the operator S437: "i want the ribs to take normally the damage" (and S434: "do ribs get hurt, if not when will
it be fixed ?"). Four readers of the code and two critics found why the ribs look untouched (S437 review; the deeper
redesign is ops/research/DAMAGE_MAP_S437.md and is NOT this task). This task fixes the defect in today's rules only.
You cannot see pictures: work from the numbers and print the tables asked for.

## Contract
OWNS: scripts/rules/BodyMap.gd, scripts/fight3d/ExchangeBeats.gd, tests/body_map_test.gd, tests/rib_damage_test.gd, docs/RIBS1_RESULT.md
RED_TEST: tests/rib_damage_test.gd -> RIB_DAMAGE failures=0
REGRESSION: body_map_test, body_tip_test, body_figure_test, body_report_test, injuries_test, fight_stats_test, file_limits_test, no_pronoun_test
VISUAL: no
NOT YOURS: scripts/rules/Exchanges.gd, PaceAim.gd, InjuryRoll.gd, Injuries.gd, every screen (read them; do not edit).

## The three faults (verified in code; re-read each line before you change it)
1. ONE SIDE ONLY. BodyMap._punch_hits (lines 40-68): `body_hook` always lands on `opp_side + "_ribs"` (an orthodox
   attacker always hits right_ribs, a southpaw left_ribs). Between two orthodox boxers the left ribs can never be hit.
   The fight rules already split body shots 60 / 40 (PaceAim LIVER_SHARE 0.6: 60 % to the side the attacker's lead hook
   reaches, the liver side by stance).
2. TOO SMALL TO EVER MATTER. RIB_HIT 1.5 (x2 big) against a hurt line at 55: about 30 landed body hooks on one side.
   A rib ends a normal bout at 80-92 while the fight rules already call the ribs hurt after 4 body shots there.
3. BODY SHOTS VANISH IN THE RING. scripts/fight3d/ExchangeBeats.gd: `_body` (lines 247-264) turns single landed
   punches into body_hook until the ring matches the fight rules' body count, but `_show_game` (137-151, 180-195) runs
   AFTER it and swaps the opponent's singles to jab / cross / lead_hook, body hooks included; and `_habits` runs BEFORE
   `_body`, which can turn a "digs to the body when hurt" hook back. The ring then shows, and BodyMap counts, fewer
   body shots than the fight rules settled.

## The job
1. tests/rib_damage_test.gd FIRST, red on main. It must go through the real path (the round's settled exchanges ->
   ExchangeBeats -> BodyMap.add_beats), not a hand-made beat list alone. Find how tests/body_map_test.gd,
   tests/fight_stats_test.gd or tools/ build a round's beats from a settled round, and reuse that. Over 200 seeds of a
   3-round amateur bout, two orthodox boxers, print and assert:
   a. BOTH rib sides take damage: across the seeds, each side's mean loss is above 0, and the liver side takes between
      50 % and 70 % of all rib damage.
   b. COUNT MATCH: for every round, the number of landed body_hook beats BodyMap receives equals the body shots the
      fight rules settled for that round, within 1 (print the worst mismatch; on main it is larger).
   c. DEFAULT GAME (body share 0.2): the more-hit rib ends the bout between 62 and 82 on average (bounded, never an
      exact value), under 55 in at most 15 % of bouts.
   d. BODY PLAN (the "Go to the body" call, share 0.5, all three rounds): the target's more-hit rib is at or under 55 by
      the final bell in at least 60 % of bouts, and at or under 35 in at most 20 %.
   e. A CONTROL that cannot share the bug: a head-only arm (share 0.08) leaves both ribs above 85 on average.
   f. The S318 bars still hold on the same seeds (BodyMap.gd line 11 comment: loser's worst place hurt in 40-90 % of
      bouts, doctor band at most 8 %, winner fine at least 50 %). Print each.
   Print one table line per arm: `RIB_ARM <name> liver_mean= other_mean= hurt_pct= critical_pct= shots_mean=`, then
   `RIB_DAMAGE failures=<n>`.
2. BodyMap.gd: the body hook's side comes from the beat. If the beat carries `"side"` ("left" / "right") use it;
   otherwise pick by the same hash the function already uses: liver side (the side the attacker's lead hook reaches)
   60 in 100, the other 40 (read the 0.6 from one constant `LIVER_SHARE := 0.6` with a comment pointing at PaceAim's;
   do not preload PaceAim: BodyMap stays a pure module with zero preloads). RIB_HIT: start at 3.0 and tune it, ONE
   number, until 1c and 1d hold together; if no single value holds both, say so in the result file with the two tables
   and stop: do not add a second multiplier to make the bars pass. Record the tried values and their tables.
3. ExchangeBeats.gd: after `_show_game` and `_habits` have run, the landed body_hook count of each side must equal the
   fight rules' body count for that exchange whenever enough single landed punches exist (re-run the matching as the
   LAST step, or make `_show_game` skip body_hook; choose the smaller change and say which). Never change who lands or
   how many punches land: only which landed single is a body hook.
4. tests/body_map_test.gd: update only the asserts the new side rule and RIB_HIT change, and say in a comment why each
   moved. Do not delete an assert.
5. docs/RIBS1_RESULT.md: the three faults as measured on main (the red table), the final tables, the RIB_HIT values
   tried, what you did NOT fix (words-only and skipped bouts still carry no body map: that is the redesign's job).

## Traps
- ops/research/GDSCRIPT_TRAPS.md first (Variant `:=`, `%%`).
- Never test identical fighters: the two boxers differ in stats, techniques and plan; print the population in the
  table header.
- A bar that only your own new function can pass is not a bar (S420): 1b must count what BodyMap really receives.
- The injury roll reads the ribs at 35 or under (InjuryRoll RIB_HURT_LINE): with ribs that fall, rib injuries will
  become more common. Print, for the default and the body-plan arm, the share of bouts ending with a rib at or under
  35, so Claude can re-check the injury rate at collect. Do not edit InjuryRoll.

## Prior research
ops/research/S316_BODY_MAP_PLAN.md, ops/research/TASK_RIBHURT1.md, ops/research/G132_LIVE_DAMAGE_AND_THE_CORNER.md
(real corner: body work saps output over rounds), ops/research/HUD_REVIEW_S392.md line 9.

## What would a human do?
A body attack is the slow investment of a fight: by the third round of a body plan the ribs should be visibly sore on
the picture, on either side, and a fighter who was hit to the head only should show clean ribs.

## Prefab check
No asset or library applies.

Every Godot job through the queue: `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless
--audio-driver Dummy --path . --script res://tests/rib_damage_test.gd` (the plain win64 exe, never the console one).
Parse first: `--check-only` on each touched file. Under 500 lines a script.
RESULT lines for the PR body: `RESULT: tests/rib_damage_test.gd -> RIB_DAMAGE failures=0`.
