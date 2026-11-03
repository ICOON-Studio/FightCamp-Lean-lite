# BJJ references for the BJJ-to-9/10 loop (S371) - for Ziva (the fixer), Gemini 4 Argon (the judge) and any seat on the mat

Operator S371: "ziva needs access to https://eel.is/GrappleMap/index.html https://grappleflows.com/main", "also gemini might
need that". This file is what both sites give us, so a seat without a browser (or without the operator's login) has it.

## 1. GrappleMap (Eelis) - https://eel.is/GrappleMap/index.html
- A database of no-gi grappling POSITIONS (two stick figures, a name, tags) and TRANSITIONS (animated moves between them):
  a big directed graph. No gi techniques in it.
- WE ALREADY SHIP ITS DATA: scripts/grapple/GrappleMapDB.gd reads it (since S335: the ground-move browser, GrapplePose,
  GrappleGraph, GrappleContact, GrappleGrip, GrappleTiming). tools/grapplemap_graph.py builds the graph.
- Source + data: https://github.com/Eelis/GrappleMap/ ; GrappleMap.txt (2.55 MB):
  https://raw.githubusercontent.com/Eelis/GrappleMap/refs/heads/master/GrappleMap.txt . Entry = a name line (literal \n
  breaks), `tags:` (snake_case; top_/bottom_ prefixes mark the player, e.g. side_control top_kneeling bottom_supine crossface),
  optional `ref:` (the instructional source), then the joint-coordinate lines.
- Tools on the site (JavaScript/WebGL, Chrome): search by tags, composer, explorer (http://eel.is/GrappleMap/explorer/),
  editor (http://eel.is/GrappleMap/editor/).
- LICENSE: PUBLIC DOMAIN (code and data). The cited instructionals are separate works.
- LIMITS (its own FAQ): timing is NOT captured; fixed-interval keyframes (joints change direction at most ~5 times a second);
  grip fights barely modelled; no clothing; hand-edited, not motion capture. So GrappleMap is right for WHICH position
  follows which and WHERE the limbs are; it is NOT a reference for speed, weight or timing - take those from real footage.

## 2. Grapple Flows - https://grappleflows.com/main (the operator's account; login needed, read in his Chrome S371)
- A BJJ flowchart app: flows of nodes (Action / Position / Submission / Reaction) joined by labelled arrows; templates
  (Closed Guard Game, Half Guard Game, Guard Passing, Back Attack, Leg Lock, Takedown, Mount Attack, Knee Cut, Front
  Headlock); flows can be built from voice or a video.
- The operator's flow "Match Breakdown: Mount Sweep To Foot Over Foot Pass" (https://grappleflows.com/flows/6ae70c23001a4e0c1aeb,
  6 nodes, times from the source clip) - A MATCH SEQUENCE OUR BELT MATCH SHOULD BE ABLE TO PLAY AND THE JUDGE CAN CHECK:
  1. 0:00 Top postures in mount - from mount the top fighter posts the hands and postures up (Action; grip: posts the hands).
     -> "bottom fighter bridges and sweeps"
  2. 0:00 Bridge sweep to closed guard - the bottom fighter bridges, sweeps, ends in closed guard at a distance (Position).
     -> "from closed guard she attacks"
  3. 0:09 Arm lock attempt - from closed guard, controls the arm and goes for the arm lock (Submission).
     -> "opponent escapes the arm lock"
  4. 0:09 Switch to triangle - the opponent escapes the arm lock, so the attacker switches to the triangle (Submission).
     -> "defender escapes the triangle by standing"
  5. 0:17 Defender stands up - escapes the triangle by standing: standing against an open guard (Reaction).
     -> "to pass the open guard"
  6. 0:17 Foot over foot pass - the top fighter steps a foot over the leg and starts the pass (Position; leg path).
  About 20 s of real time for six positions: ~3-4 s a transition.
- "Escape & Survival" (https://grappleflows.com/flows/6ae6cab000303c489760) is the template only (Under side control:
  frames, shrimp, recover guard or turn to knees; Under mount: protect the neck, upa or elbow-knee to half guard; Back
  defence: hand-fight, clear a hook, slide to the floor; Turtle: defend the back, rebuild guard or stand).

## How each seat uses this
- ZIVA (fixer): match the belt match's positions to GrappleMap names/tags (already in GrappleMapDB) and the operator's
  six-node sequence above; timing and weight from real footage, never from GrappleMap.
- GEMINI 4 ARGON (judge, ops/Tools/gemini_judge.py --kind fight): judge a BJJ film against real no-gi BJJ: positions
  recognisable by name, legal transitions in a sensible order (the six-node sequence above is one real one), contact
  (no limbs through bodies), weight on the right points, believable speed (~3-4 s a transition).
