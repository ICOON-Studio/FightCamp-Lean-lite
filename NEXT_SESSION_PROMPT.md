# S323 - next session (written S322, 2026-10-31)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.

Where it stands: update 25 exported (built from 1685692, 38/38 tests); main is de915d0 (BodyRates wired, next build).
"The body is the track" (operator Q-S294-38 "Build it") part 1 is in: BodyLoad (per-part Burn rules), BodyBurn (the 3D:
each shoulder drops its own glove, legs shorten steps, arms lose snap; `-- noburn` control), BodyRates (stats + style set
each part's rate). Cutman/second work by themselves (Q-S294-36). Digest: Game Godot/research/S322_DIGEST.md.

1. Board: Q-S294-39 (update 24 close punches), Q-S294-40 (what the round/result pages need), his verdict on update 25.
2. The body view (plan step 3, Game Godot/research/BODY_TRACK_PLAN_S321.md): both bodies on the fight screen, every part
   outlined and coloured by BodyLoad.band (BodyBurn.load), hurt outlines from BodyMap (BodyLive.map). Stand-in look: the
   glass body (tools/preview_body_track.gd) - no muscle model bought ("Not yet"). Pure layout/colour mapping -> Qwen brief;
   the view itself is yours. Then Pace (Push/Steady/Save; BodyLoad already takes ctx.pace) and Aim.
3. The referee stands between their heads ON SCREEN (update 25 exe still) - measure his screen position, not the ground.
4. Two inside punches still end 0.15-0.20 m to the side (tools/hit_gap_probe.gd "far" lines; it now prints timing too).

Tools: tools/burn_probe.gd (Burn per round + shown glove height, round 3 late; `noburn` arm), tools/ref_probe.gd (referee
vs the boxers' line), tools/hit_gap_probe.gd. All on the hidden desktop (tools/hidden_desktop.py run --log=...).
Traps: AnimationPlayer.play() on the playing clip continues it (FightStage._start now stops it first); the board's Test
runs skip rounds - anything "at the bell" must also run in FightView.skip_round; probe numbers jitter run to run
(measure master and the change, twice, before calling a regression); tune feel numbers on the GAME's beats (burn_probe),
the test builder throws fewer lead-hand punches.
