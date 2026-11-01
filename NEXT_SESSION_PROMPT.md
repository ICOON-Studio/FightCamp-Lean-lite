# S349 - next session (written S348, 2026-11-01)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S348 shipped update 49: the PLAYBOOK menu page (her move map + the move player on her own body, Replay, Slow motion; Moves and
Plans tabs), the holo is HER (own skin/hair/face, kit neutral) with HEAD / LIVER / RIBS close-ups and hover tooltips (what
landed where), the referee and the lens keep off each other, the flow view in the menu colours. Digest:
Game\Godot\research\S348_DIGEST.md. OPERATOR RULE S338: agents do animations, Claude does mechanics + UI.
Hidden desktop: Godot `--log-file <path>`; push scripted mouse with `root.push_input(ev, true)` (viewport coords).

1. Board: Q-S294-72 (training screen mockup, docs/playtest/S348/training/training_mockup.png) + comments on the S348 stills.
2. Collect in flight: GROUND3 (Qwen, wt LEAN_GROUND3 - files written, not committed at S348's end; the reconcile marked it
   stale while it ran), SMOOTH3 (Goose, Lean issue 18 - the join audit's three fixes; quote its smooth_probe lines),
   PADWORK1 r3 (Goose #13 5633c78) + CLINCH2 (Goose #14 31ccc38) on the GPU with the visual gate.
3. Combos tab on ComboFlow (collected S348, scripts/rules/ComboFlow.gd): his "Build a smart combination" layout - numbered
   rows (move, one-line cue, a still of her throwing it, the target on the ghost), the key-lesson strip from ComboFlow
   notes, Save to her book, the player plays the chain. ComboFlow round 2: "move your head after punching" (a chain ending
   on a defence or step scores).
4. On his yes to Q-S294-72: the training screen (8 numbered cards round her, leader lines to the parts they train, muscle
   chips per card in BodyTrack colours, "Pad rounds" opens a round-by-round plan: each round a named combo with numbered
   move pictures + three focus points).
5. C197 corner card refine under the new lens; the Playbook map in the martial-arts-tree look (glowing paths, picture cards).
