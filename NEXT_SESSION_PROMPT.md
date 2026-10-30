# S318 - next session (written S317, 2026-10-30)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.

Where it stands: update 20 exported (Lean ef45185): ringside shot director + new light (RingCamera/RingSet), motion blur
(addons/, MIT), ring entry through the ropes (FightIntro + RingRopes.part), the clinch from a two-person Cascadeur clip
(tools/pair_bake.gd -> baked clinch_att/vic, Clinch.gd), guard ease 0.3 s. Digest: Game Godot/research/S317_DIGEST.md.

1. Board: Q-S294-31 (update 20).
2. Collect Qwen BODYMAP1 (E:\FightCamp\wt\LEAN_BODYMAP1, qwen/bodymap1 86ae8d3): it claims test 5 (loser hurt 40-90 %)
   is impossible; its reason contradicts itself - check RoundScript's landed counts per side, then fix and merge.
3. Clinch: the victim half's hand rises over the top (Game docs/previews/s317/clinch_paired_ring.jpg, 14 s); gloves on the
   grip (operator C143). Re-bake with tools/pair_bake.gd (stills in its out dir), then tools/clinch_still.gd.
4. Smoothness: tools/smooth_probe.gd (raw baseline) - ours 557/min, ~330 at clip changes; pro_idle plays 0.17 s 41x/min.
5. Body map figure / corner jobs / round data on BodyMap.

Traps: the probe must stop logging before its raw pass (fixed); a bake retarget needs each half in its own facing and the
clip's real pelvis gap (0.83 x hip height); motion blur needs the plugin classes imported (`--import` once after a clone).
