# S320 digest - Lean update 23 (2026-10-31)

Working commit: Lean 9a55d90 (pushed). 37/37 Lean tests. Update 23 exported; the exe loads the body portraits (probe run on
the exe). Board: Q-S294-35 (update 23), Q-S294-34 (in-round plan), review page S320 (film + round page + result).

## Operator input this session (verbatim)
- Q-S294-31 answer: "upload a short videoto judge" -> tools/judge_film.gd (intro + N s of round 1 at 1x, movie writer).
- C145 markup: "each of these needs to be on each fighters side"; C146: "we have real andropoid,use it".
- "try 2 godot if you want at the same time to see how heat is going" -> ran two Godot jobs all session: GREEN/AMBER,
  CPU 42-60 %, 67-74 C, peak under 75 C.
- "the ropes look wierd" (ring entry still); "the footing and moving of the fighters looks very bad, why the clips we have
  are so much smoother than what i see in the fight"; "some hits seem to register even when opponent is way to far";
  "the fix ooption how it becomes avaibale , does it actually works ?"; "need more features for player to do/select
  during the round"; "key stats shown during the fight would be nice" (typed garbled, read as key stats);
  "these needs much better visuals for the player to understand what happenned" (round + result pages);
  "you change the menu concept , try more modern panels etc if you want".

## What changed (evidence)
1. FEET. smooth_probe (same fight, 1.8 min, both arms run): clip changes 167 -> 97/min; 154/min of the old changes were
   advance/retreat/strafe - the old game's WALKING strides (1.7 m/s) played at 0.19-1.15x for 0.2-0.9 s and cut. Footwork
   glide (`Footwork.glide`, `-- stepclips` = control arm): no step clip, the guard plays on (median 2.1 s, was 0.2 s), the
   body moves with a 0.07 s speed ramp, FootPlant steps the feet. Our kinks 494 -> 401/min.
   Considered and measured out: the Ailive footwork take (9.3 s, operator "not bad" S273) as a continuous base - stance
   0.53-0.84 m vs the Pro guard's 0.47, hips 3-12 cm lower, arms down for its first 2 s and last 2 s: every join into a
   Pro punch would drop and split. The Punch Pro pack has no step clips at all.
2. HITS FROM TOO FAR. tools/hit_gap_probe.gd (glove front to the landing point at each landed contact, 150 s):
   before p50 0.21 / p90 0.63 / max 0.98 m, 66 % over 0.15 m (jabs and body hooks landed from a 1.6 m gap).
   PunchRange.gd: the clip's touch gap (gap_m - short_m from clip_contact.json) vs today's gap -> lunge up to 0.26 m, a
   step in for the rest (max 3 m/s, an opponent's step away stops); no hit reaction when the punch clip was cut off before
   contact (3 of 35); aim at the head AS SHOWN (GloveClear.shown_head). After: max at range 0.49 -> 0.36 m (pocket),
   p90 0.36. STILL OPEN: inside (gap ~0.5 m) jabs/hooks stop 0.13-0.22 m SHORT of the face with PunchReach weight 1.0.
   Exempting the striking hand from GloveClear (kept in) changed nothing - next suspects ElbowClear or the ShortPunch skip.
3. BODY MAP. tools/bake_body_portraits.gd bakes each MetaHuman boxer's front portrait per corner (head to knee) and the six
   places' ellipses (json, bones/mesh projected); BodyFigure.set_portrait draws it. Each boxer's panel sits at her own screen
   edge (red left, blue right) with live punch stats (thrown/landed, jabs, power, body - counted at the beats). TRAP: a png
   rewritten by a tool needs `godot --headless --import` again, and export_presets include_filter must list the json.
4. ROUND + RESULT AS PICTURES (RoundGraphics.gd): exchange strip (winner colour, SHOUT/SET-UP marks), versus bars between the
   two body maps, energy bars, round chips, corner card as tiles; result = three judges' round-by-round cards (judge 3 flips
   the majority's closest round, matching BoutRules.scorecards), "what decided it" tiles, money tiles. A skipped round's
   WORKED/HURT now come from its exchanges (it read "nothing clean" next to 24 landed); a 3-3 round says why it was won.
5. HABIT FIX. It works: offered only for a habit that cost her (the coach saw it); a fix lowers that habit's cost by her
   uptake; habit_fix_test: an even fight 0.60 -> 0.65 with the fix. New: the next corner card says what the fix did.
6. ROPES. 10 straight pieces a side bent into V's when parted: drawn as Catmull-Rom curves (x4 pieces), parting radius 0.9
   -> 1.5 m, a rope fades whole when any piece blocks the view and by a distance ramp otherwise (per-piece fading left
   floating stubs).

## In-round plan (Q-S294-34, docs/IN_ROUND_PLAN.md) - waiting on him
Build now: 1 live punch stats (BUILT, his own ask), 2 aim the shout on the opponent's body map, 3 Push/Steady/Save pace.
Next: the towel (G44's first pick). Later: mark a habit for the gym.

## Defects seen, not yet fixed (next session)
- Inside punches land ~0.15-0.22 m short (above).
- The referee drifts between the boxers in rest spells (S320 film, round 1 ~1:10).

## HANDOFF
Next action: roadmap now.next_action (S321). Runs in flight: none. Agents: none launched this session (the operator's
asks were live-fix work on the PC; Qwen seat idle - give it the body-map shout target's pure rule once Q-S294-34 is
answered).
