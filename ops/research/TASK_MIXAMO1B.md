# TASK MIXAMO1B (S216) - the Mixamo reactions, knockdowns and get-ups play in the live fight (MetaHuman boxers, behind a switch)

Model: Codex gpt-6.1-sol, reasoning HIGH (animation + the 6.5k-line fight file); Cursor if no Codex seat is free.
STARTS ONLY WHEN: (1) MIXAMO1A is merged (bakes `Godot/assets/anim/mixamo_s215/mh/*.res` + `Godot/assets/data/mixamo_s215_catalogue.json`),
(2) MIXAMO1C is merged (`Godot/scripts/HitReactionPick.gd`), (3) the operator approved the Ludo round 48 verdict on the board
(`research/LUDO_ROUND48_VERDICT_S216.md`: the catalogue tags + power bands that Claude applies to the catalogue before launch).
Worktree on E: seeded with `Tools\seed_godot_cache.ps1 -Worktree <wt>`; branch `codex/mixamo1b` from master.

## What
A new GameSwitch `mixamo_reactions` (ON in `GameSwitches.GAME_ON`, OFF in plain headless tests = the control arm). When it is ON and the
fighter is a MetaHuman body (`metahuman_bodies`), the fight plays the Mixamo bakes for `react_head`, `react_body`, `knockdown` and `getup`:
- graft every catalogue row with gate PASS and keep = true into `_variants` for its role (rows carry target/side/power/fall tags);
- `_play_single_role` picks the take with `HitReactionPick.pick(event, rows, recent, seed, bands)` - event built from the landed punch
  (type, attacker stance, landed power 0..1, knockdown, blocked); the seed from the bout seed + beat index (a seeded bout looks the same twice);
- a knockdown queues `HitReactionPick.getup_for(knockdown_id, ...)` instead of the single `getup` role (the existing 0.10 s
  BLEND_INTO_GETUP_S join stays); a KO row (fall with no get-up per the verdict) queues nothing;
- one-shots stay whole (`reactions_play_whole`); root travel of a reaction is room travel (it must not slide the pair apart > the
  existing `body_spacing` limits).
With the switch OFF every role and every chosen take is byte-identical to master.

## The verdict's rules (LUDO_ROUND48_VERDICT_S216.md - binding)
- Tags come from `Godot/assets/data/mixamo_s215_ludo_tags.json` (keep, category, target, side, power, fall, kd_kind, getup_from) joined to the
  1A catalogue by file; a row plays only if keep = true AND its 1A gate is PASS.
- Bands passed to HitReactionPick: `{"medium": 0.45, "big": 0.80}`. A LIGHT hit plays NO Mixamo clip: today's additive flinch stays
  (`human_hit_additive`, `human_flinch`). Only medium and big hits swap in a Mixamo react_head / react_body.
- OPERATOR OVERRIDE S216 ("do what ludo suggests"): the 9 block clips are IN. Blocked hits pick a block row by punch height and side (Ludo table);
  a blocked punch with power > 0.65 also plays block_react. The native MetaHuman guard is the idle default.
- Corner rest (category corner_rest, #115) plays in the corner between rounds.
- Liver shot: a two-stage reaction (freeze 0.35-0.70 s, then crumple into a body reaction or the liver knockdown). Needs the engine liver event; if none exists, add that event as a hook only (no damage number changes).
- Knockdown: the engine decides it and the count; pick the fall by kd_kind (flash / heavy / ko from the engine's knockdown data where it
  exists, else heavy), the get-up by `getup_from`; ko rows queue no get-up; after a get-up play the hurt_idle row until the count resumes.
- Blend in/out (s): medium 0.06/0.20, big 0.08/0.32, block_react 0.05/0.15, knockdown -> getup 0.10 (existing), getup -> idle 0.28.
- Medium/big reactions in place (strip their horizontal hips travel); falls keep their travel.
- The animation changes NO engine number (no stamina, guard or knockdown effects). Ludo mechanics numbers are NOT in scope.

## Owned files
- `Godot/scripts/FightStagePlayer.gd` (6,499 lines - never read whole). Windows: `sed -n 290,330p` (RECEIVER_SWAY_ROLES, the `_variants`
  doc), `sed -n 1460,1560p` (role grafting, ROLE_GETUP), `sed -n 1575,1700p` (BLEND_INTO_GETUP_S, play_role, _play_single_role),
  `sed -n 1755,1775p` (the knockdown -> getup queue). Find where `play_role("react_` is called with the landed punch to get its power.
- `Godot/scripts/GameSwitches.gd` (52 lines): add `"mixamo_reactions": true`.
- NEW `Godot/tests/mixamo_reactions_wire_test.gd`.
Read-only: `FightReactionSide.gd` (45), `FightClipBinding.gd` (3,162 - grep only), the two new modules.

## Acceptance
- New test, two DIFFERENT MetaHuman fighters (stats, stance and body differ - never identical fighters): switch OFF -> the same take
  names as master over a 3-round seeded bout (control arm); switch ON -> react_head takes come from the Mixamo bakes, a big landed hook plays
  a big row from the punching hand's side, a knockdown is followed by the getup whose fall matches, the same seed twice gives the same takes.
  It must go RED on the shipped tree (no switch) - record the FAIL lines in the digest.
- `python Godot/tools/run_tests.py --jobs 2 --only fight_reaction,certified,game_switches,switch_gate,technique,body_spacing` green.
- STILLS ON THE GAME'S CAMERA (CLAUDE.md s2, no exceptions): `record_room ... as_game` (broadcast camera + follow), saved ONLY through
  `Godot/tools/still_framing.gd` `save_if_framed` (both men head to feet in frame; never a mat/tight/low shot) into
  `E:/FightCamp/tmp/mixamo1b/`: guard, light head hit, big head hit, body hit, knockdown mid-fall, on the canvas, get-up mid, back in guard.
  Plus a 6-frame strip of one big head hit and one knockdown->getup. Open every still yourself and describe what you see in the digest.
- Windowed Godot only via `Tools\godot_hidden.ps1`; nothing opens on the operator's screens (file tools only for images).

## Prior research
`topics/hit_reactions.md` (reactions play whole U159, direction Q104, sided C177), `topics/knockdowns_stoppage.md`, `LUDO_ROUND16_S193.md` s3,
`LUDO_ANIMATION_S192.md` (blend/interruption times), `LUDO_ROUND48_VERDICT_S216.md` (when it exists).

## What would a human do?
A gameplay animator hooks the reaction set to the combat events, with variety rules, then watches a full round on the real camera before
calling it done.

## Prefab check
The clips are the prefab (Mixamo, licensed, Ludo round 47). The selector is MIXAMO1C. Nothing else to buy.

## The one trap
FightStagePlayer.gd is shared with TECHSTAGE1 and the queued SPLITFIGHT1: keep the diff small and local, rebase on master right before
the PR, and never take whole files.
