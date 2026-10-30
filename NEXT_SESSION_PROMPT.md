# S317 - next session (written S316, 2026-10-30)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.

Where it stands: update 19 exported (Lean d807465): one guard at every range, gloves along the forearm, steps flow
instead of restarting, heads clear each other, clinch overhook. Digest: Game Godot/research/S316_DIGEST.md.

1. Board: Q-S294-24..30 (Q-S294-29 = the body map + round data plan, S316_BODY_MAP_PLAN.md; Q-S294-30 = update 19).
2. SMOOTHNESS FIRST (operator: "nowhere near that smooth"): `tools/smooth_probe.gd` (plain + control arms noguard
   noreach nosnap noglove nojoin nofeet). Now (Lean S316 ramp commit): 168 clip changes/min, 1475 kinks/min. Ruled out:
   the procedural layers (-10 % all off) and the recovery speed-up (ramped S316: 1511 -> 1475, hook clips unchanged).
   The hook / body-shot "kinks" are probably the clips' own fast hands (a hook's hand tops 2 cm/frame legitimately):
   FIRST give the probe a raw baseline (play each clip alone on one body, same metric) and count only kinks ABOVE the
   raw clip at the same clip time. Then go after what is left (joins into punches, idle restarts 42 x 0.20 s).
3. Ring entry THROUGH THE ROPES (operator S316: "the first animation is about entering the ring through the ropes"):
   Game Godot/assets/anim/mixamo_s215/mh/entry_entering_ring.res (7.3 s = Mixamo "Entry", 219 frames, she bends and
   ducks between the ropes) - copy into Lean, play it at the start of FightIntro from outside the ropes on her corner,
   pure (no layers), then the walk to the centre. (entry_entering_from_ring_corner.res, 3.3 s, is the walk from the
   corner.) Mixamo has no clinch.
4. On his yes to Q-S294-29: BodyMap rules (test first), live figure, corner jobs, round data.

Traps: notes only in Lean docs/WHAT_TO_TRY.txt; exe smoke ends rc 124 (pass = 0 ERROR lines); Lean branch is `main`;
every new absolute-time beat key is shifted in ExchangeBeats.build; read shown poses via tools/pose_tap.gd.
