# TASK PROFILE2E_FIX (S209) - review round 2 of cursor/profile2e (f7dec1d3)

Model: Cursor (local), same worktree E:/FightCamp/wt/PROFILE2E, branch cursor/profile2e. First `git merge origin/master`.
Claude opened every still in previews/profile2e/. Fix these, re-shoot, push. Brief: TASK_PROFILE2E.md still applies.

1. THE INJURED STILL IS NOT INJURED: `2_tab3_medical_bio_injured.jpg` is byte-for-byte the unhurt screen (CLEARED TO SPAR, no pins,
   grey body). Give the stills tool a real injured boxer the game's own way (an injury record + region wear through the GameState API
   the injury list reads - find it, never write fake keys) and show: regions coloured by wear, injury pins, the injury rows (region,
   severity, weeks out), diagnosis text that matches, and the stress meter at a non-zero value from his real stress dict.
2. FACE CLOSE-UP shows a FULL-BODY NON-METAHUMAN woman (old Tripo/MPFB body) - forbidden (operator S207: "i do not want to see mbfb model
   anywhere again"; MetaHuman only). It must be a HEAD close-up (portrait framing: crown to collarbone fills the box) of the athlete's
   MetaHuman. Pick the body with `FightWorldStage.model_for_skin(mesh, "", athlete, "", true)` (MHNATIVE1 is extending it to the women
   MetaHumans mh_boxer_* - until that lands a woman may get no MetaHuman: then show the honest empty state "NO SCAN" in the box,
   never an old body). Camera: aim at the head bone, ~50 mm portrait lens, soft key + rim light.
3. BODY DIAGRAM: today grey blocks. Draw the 6 wear regions as shaped regions (head, torso, arms, hands, legs, feet - use the regions the
   wear data has) coloured green->yellow->orange->red by wear, outline + subtle fill; FRONT/REAR must switch what is drawn.
4. CONTRADICTION: "3.8 kg to lose ... past the safe line" + "CLEARED TO SPAR" + weight cut "NOT INDICATED". The diagnosis line and the
   weight-cut card must read the same weight status: if the cut is past the safe line, the diagnosis says so and RECONFIGURE WEIGHT CUT
   is enabled (it calls set_weight_cut_plan); "NOT INDICATED" only when no cut is active.
5. EMPTY SPACE: PERFORMANCE & CAMP is three mostly empty columns. Follow reply2 4.1 for what fills them from real reads: the
   camp timeline (week 8 -> fight night) empty state as a drawn track with "no bout booked" marker, the week's planned sessions per
   day from his real program (rest days honestly labelled), techniques-in-training list or the tree's next 3 learnable moves with
   their prerequisites (TechniqueTree). Same for MEDICAL's right column: the treatment cards fill the height (bigger cards with
   cost/days/effect rows), not three small boxes at the top.
6. Re-shoot all stills to docs/previews/profile2e/ (injured + unhurt must differ), run the profile tests, update PROFILE2E_DIGEST.md
   with a "round 2" section. Same rules: watchdog before Godot runs, hidden windows only, no image viewers, never master.
