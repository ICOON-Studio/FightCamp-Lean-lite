# S368 - Gemini 4 Argon on the operator's BJJ grapple walk (2026-11-02)

Operator: "the clip shows that bjj is good enough to use it the game as it is (ask gemini to rate this)".
Clip: ops/previews/S368/grapple_walk.mp4 (his recording of the no-gi move browser, 35 s, 1920x1080). Prompt:
research/GEMINI_BJJ_PROMPT_S368.txt (BJJ black-belt eye, per technique READS/UNCLEAR/WRONG). Argon, 24 fps: 66,273 tokens
in, 2,187 out, $0.1544. Full answer: ops/previews/S368/grapple_walk.gemini_argon.md.

Verdict 5/10 as a shipping match view (7.5 as a move-graph tool). 8 of 10 techniques READ (Posture Up, To Arm Lock,
Escape to triangle, Foot Over Foot Pass Finish, Hip Escape, Bottom Angles Out, Top Breaks Posture); UNCLEAR: "Sweep"
(an upa with no arm trap), the stand-up triangle escape (legs float), To Foot Over Foot (hidden by the top player's back).
Its three biggest problems, CHECKED by Claude:
1. ~1.2 s pause between every move - TRUE: frame-difference motion drops to idle breathing (~0.25-0.35 vs ~1.5 moving)
   for ~1 s after every move (3.0-4.0, 7.0-8.0, 11.0-12.0, 14.0-15.0, 21.0-22.0, 29.5-30.5 s).
2. No weight, uniform floaty pace; clipping - TRUE at 5.2-5.6 s (Red's thigh into Blue's hip in the mount roll);
   10.4-10.9 s Red's shin over Blue's head reads as through it (partly hidden); 0:24 knees into thigh: occluded.
3. Raw developer strings - TRUE: a move named "Escape https://www.youtube.com/watch?v=... Dean Lister Shows Triangle
   Defense With Keenan Cornelius" (15.0 s); small low-contrast panel; the top player's back hides guard work 20-34 s.
Its one change: no pauses between chained moves + speed curves per move (explosive sweeps/escapes/bites, heavy settles).
Claude's rating as the watched belt-match view: 6/10 now, ~7.5 after the cheap fixes (pauses, pace, names, panel).
