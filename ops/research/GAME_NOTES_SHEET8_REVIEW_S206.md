# "Game Notes" sheet, tab Sheet8 - Claude's review (S206, 2026-10-11)

Source: the operator's Google Sheet "Game Notes" (gid 211115209 = Sheet8), saved verbatim as GAME_NOTES_SHEET8_S206.tsv.
Operator S206: "check this".

## What it is
A complete multi-agent build plan for a game called "Fightcamp / CAGE": a CLAUDE.md, four agent roles (architect, builder,
validator, content), eight subsystem prompts (fighter data model, stress and afflictions, gym scene, cage fight scene,
management, UI/broadcast, audio, asset generation), a director prompt and a file tree.
Its pitch: an MMA gym manager = "MMA Promoter" management + "Darkest Dungeon" training (stress, afflictions, quirks,
perma-death) + "Tekken 8" fights; training watched in 3D, never a menu click.

## Where it collides with what is built and settled
1. ENGINE: Unreal Engine 5 (C++/Blueprint). FightCamp is 40 days into Godot 4.7.2 (680 tests, certified moves, the gym, the
   career loop). Switching engines = throwing that away; that is a scope decision only the operator can make (CLAUDE.md s2),
   and nothing in the sheet is evidence that Godot blocks the game.
2. MMA FIRST vs BOXING FIRST: the agreed release (roadmap objective, D27) ships a boxing demo, MMA as the first update.
3. "NOT Football Manager, NOT a spreadsheet": our settled genre line (Ludo facts sheet item 8) is "PC deep management sim, FM /
   Motorsport Manager class". The sheet's "training is WATCHED in 3D, never a menu click" matches our gym floor direction
   (GYM3D1/GYM4 - the 3D club is HOME); its anti-FM line does not match our deep profile/scouting/finance screens.
4. The fight model: HP 100, damage = striking x 0.5 - chin x 0.3, decision by total damage. Ours is a far deeper simulation
   (exchange-resolved, 9 readout stats, 54-node technique tree, real judging) - the sheet's model would be a step back.

## What is worth taking (none of it needs UE5)
- STRESS + AFFLICTIONS (Darkest Dungeon): a fighter's stress rises with sparring/hard days and can flip into a lasting state
  (paranoid, hopeless, zealous, tenacious...) that changes training and fight behaviour. We have morale and the composure
  states (composed / pressured / rattled / panicked) but nothing that persists like an affliction. A real design addition ->
  Ludo first (D39), then the operator's OK.
- STRESS VISIBLE ON THE BODY: breathing, movement quality, slower animation - this is exactly ANIMFATIGUE1 (running now on
  Codex) and the r38 composure field on the intent bus (merged today).
- BROADCAST CAMERA auto-cut on big hits (wide / over-shoulder / close-up): our fight camera is `broadcast` + follow; an
  auto-cut on damage > threshold is a small, cheap feature for "the fight is watchable".
- CONTENT RULES: every fighter has distinct quirks; flavour text banned if generic ("He's tough" banned, "took a knee to the
  temple in round 2 and kept walking" allowed) - a good bar for our news/story lines.
- universal-modder `um win drive` (automated playtest: launch, screenshot, drive input) - a prefab to evaluate against our
  own walk tools (playable_loop_test, record_room); fal.ai asset generation - we already have it (`/generate` skill).

## Claude's recommendation
Keep Godot and the agreed release. Take the four ideas above into the existing roadmap: stress/afflictions as a Ludo design
question (then a board approval), broadcast auto-cut and the content-tone rule as small tasks, um win drive as a prefab check.
The engine/MMA-first/anti-FM parts of the sheet are NOT adopted unless the operator rules otherwise on the board.

## Operator ruling (board Q-S205-2): "keep Godot, take the 4 ideas (recommended)" - what happened to each (S206)
1. Stress + afflictions -> Ludo design question (queued for the next Ludo round, after the profile spec).
2. Broadcast camera auto-cut -> TASK_BROADCASTCUT1A (pure cut rules, OpenCode, issue #121); wiring behind a switch later.
3. Content tone rule -> topics/ui_screens.md Settled ("flavour text is specific, never generic").
4. `um win drive` prefab check (github.com/rehan-remade/universal-modder, MIT, Python 3.10+, PowerShell/C# WinDrive): it drives
   real mouse/keyboard input on the desktop ("asks before driving your mouse and keyboard") - that collides with the operator's
   "nothing opens on my screens" rule, and our own walk (playable_loop_test + record_room on the hidden desktop, godot_hidden.ps1)
   already plays the game headless. NOT adopted; revisit only if we need input-level playtests of the exported .exe.
