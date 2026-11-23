# PICS2D2 - the full 2D picture set for boxing, wired as a second view (S540)

Kind: build (pictures + a view). Model: claude-opus-5-5 (Code Mode tab). Commit only your paths (`git commit -- <files>`).
Godot only through godot_slot (`--who PICS2D2`); windowed renders ONLY on the hidden desktop (`python tools/hidden_desktop.py run ...`
or `ops\Tools\godot_hidden.ps1`), never on the owner's monitors; one windowed render at a time. Open stills with the file tool.

## The owner's answer
PICS2D1 (`docs/PICS2D1_RESULT.md`, stills in ops/previews/s539_pics2d/) -> board Q-S294-310 "2D picture round beside the 3D: keep it
as a second view (1.5-2 days for boxing), or drop it?" -> **"Keep, build the full set"**.

## Do (PICS2D1_RESULT.md "What a full set would take")
1. All punch families per corner from clip_db: jab, cross, lead hook, rear hook, body hook (aimed at the BODY), uppercut x landed /
   blocked (the defender's guard catch) / missed; plus guard, clinch, a knockdown in 3 frames, referee step-in, corner sit. Both
   corners rendered, no mirroring. About 40-50 pairs. Fix the repeats PICS2D1 showed (a body hook drawn as a head hook).
2. Landed glove ON the target (PICS2D1: 0.18-0.32 m beside the head) - set by the pair placer, not by changing the 3D takes
   (FIGHTPLAYER2 method line: no new correction layer in scripts/fight3d).
3. Wire it as a view of the settled exchanges (a TextureRect player as pics2d_round's pics mode), a toggle beside the 3D on the
   fight screen, shipped ON (GameSwitches.GAME_ON); one golden-path step that opens it; a contact sheet of one real round in
   ops/previews/s540_pics2d/.
4. Stills: open every picture yourself; list any that read wrong. Put the contact sheet on the board
   (`python ops/Tools/review_add.py --stage S540 ...`).

## Prior research
PICS2D1_RESULT.md, FIGHTBIZ1_COMPARE.md (their 2D view: ~60 paired pictures + tweens, a pose pair pops in over 0.24 s).

## What would a human do?
Read each picture at a glance: who threw what, did it land. Same two boxers, same look, every exchange.

## Prefab check
Our own 3D renders (no outside art).

## VISUAL GATE
A picture is done only when opened and checked by eye: both boxers head to feet in frame, the glove on the target for a landed
punch and short of it for a miss, the right punch family. Red first: the PICS2D1 body-hook still is the known wrong picture.
The owner closes it on the contact sheet.

## Contract
OWNS: tools/pics2d*.gd, scripts/ui/FightPictures.gd, assets/ui/fight_pictures/, tests/fight_pictures_test.gd
RED_TEST: tests/fight_pictures_test.gd
REGRESSION: tests/golden_path_test.gd
VISUAL: ops/previews/s540_pics2d/contact_sheet.png opened and checked
