# TASK K58 — KALLI — HOW COMBAT GAMES SCRIPT A MOVE BEFORE THEY ANIMATE IT

Owner: Kalli (research, no shell). Stage: S4a. Deliver as ONE markdown answer. Operator, 2026-09-14: "Do research how to
write proper scripts for combat sports 3d animation".

## Why this exists

Our 3D boxers play bought motion-capture clips, and every body part is then corrected by a separate system on its own
timer. The operator's verdict, verbatim: "it looks like each part of body have each own sped", "There is no cohesion
between animations and reactions", "Their distance is off their action looks like robot made in 90s". We have NO written
script for how a move executes. Before we write one (jab, cross, hooks, uppercut, body shot, and the other man's head
hit, body hit, block and slip), we need to know how professional combat and fighting games write theirs.

## Already on record - do not repeat, go past it

We already have: fighting-game frame data fields (startup / active / recovery, from Dustloop and SuperCombo) and EA
Sports UFC's GDC 2015 Animation Bootcamp talk (Harrower & Dowsett) as a MOVE LIST source; how clips join; spacing
between two bodies. None of it says how a studio writes down HOW A MOVE IS EXECUTED by both fighters before animating it.

## What to find (sources you could open, with links)

1. **Talks and articles from studios that shipped combat sports or fighting games** - EA UFC and Fight Night, Undisputed,
   Creed, Thrill of the Fight, For Honor, Sifu, Absolver, Street Fighter, Tekken, Mortal Kombat, Punch-Out, Def Jam, WWE:
   GDC talks (including Animation Bootcamp), Game Developer / Gamasutra articles, 80.lv and similar animator interviews,
   studio blogs. For each: what their MOVE DOCUMENT or SPEC contained (fields, examples), how attacker and defender were
   planned together, how distance and contact were specified, how transitions and reactions were organised.
2. **Motion-capture shoot scripts and shot lists for fighting**: how a session is planned - move lists, coverage matrices
   (each strike x each reaction x each distance/direction), naming, paired captures of two performers, what a stunt
   coordinator or fight choreographer writes down.
3. **Templates animators use for one attack**: key poses (anticipation, strike, contact, follow-through, recovery), timing
   charts, frame data (startup / active / recovery frames), spacing, "the order body parts move" (overlapping action,
   successive breaking of joints, the kinetic chain feet-hips-shoulders-arm).
4. **Two-character (paired / synced) attack-and-reaction authoring** in engines - e.g. Unreal Contextual Animation,
   Motion Warping for synced attacks, Unity equivalents - what information such an asset requires - AND in animation
   tools: how an animator builds an attack and its reaction TOGETHER in Blender, Maya / MotionBuilder or Cascadeur (both
   rigs in one scene, one timeline, contact frame, distance), cleans up motion capture there, and exports the pair.

## Format

Start the answer with the line `Collect as: K58_COMBAT_MOVE_SCRIPTS.md`. Then a markdown file whose first line is a `# `
title, then: a table of sources (URL | studio / author | year | what it says a move script contains), the FIELDS a proper
move script has (merged from the sources, each field naming its source), and the five sources most worth reading in
full, best first. Only list sources you opened; mark anything you could not open as NOT OPENED; no guesses.
