# TASK GRAPPLEMAP1 - GrappleMap as the card game's BJJ position graph and 2D view (S540)

Seat: ARENA (card game = free seats, owner S539). New Arena chat on the lite mirror, branch main. Node only, never Godot. Own
folder: proto/grapplemap/ - do NOT touch proto/cardgame/ (CARDFIX6B is fixing it in parallel).

## Why
Owner S540 sent https://eel.is/GrappleMap/index.html ("the eel.is link could be used for the 2d display maybe").
GrappleMap (https://github.com/Eelis/GrappleMap) is a directed graph of two-person grappling positions (vertices = a pose of both
figures, with name, tags, references, joint coordinates) and transitions (edges = keyframes of joint coordinates), in one text
file GrappleMap.txt. LICENSE, verbatim: "All authors involved in the creation of the contents of this package have agreed to
release their respective contributions into the Public Domain." No attribution required. Other links he sent
(jiujitsu-sekai.com, 223wrestling.com flowcharts) state no license: reference only, copy nothing from them.

## Do
1. Fetch GrappleMap.txt from the GitHub repo in your sandbox. Write `proto/grapplemap/parse.mjs`: positions and transitions with
   names, tags, joint coordinates per frame; print counts (positions, transitions, tags). Commit a SMALL extract only, not the
   whole file: `proto/grapplemap/bjj_slice.json` = the positions and transitions that map to the card game's BJJ cards
   (proto/cardgame/cards.mjs: list each BJJ card and its GrappleMap position/transition id, or "no match").
2. `proto/grapplemap/render2d.mjs`: project one position or transition (both figures, red and blue, side view, orthographic) to
   an SVG, 512x512, joints as round-capped limbs; a transition as N frames (SVG per frame, or one SMIL/CSS-animated SVG). Render
   every matched card's picture to `proto/grapplemap/out/*.svg` and a contact sheet HTML `proto/grapplemap/out/index.html`.
3. A node test (`proto/grapplemap/grapplemap.test.mjs`): the parser reads the file's own counts, every slice entry exists, every
   SVG has two figures inside the frame.
4. `proto/grapplemap/README.md`: the license line verbatim, the source commit, what was taken, and the count of BJJ cards with a
   GrappleMap picture. Plain words.

## Prior research
docs/PICS2D1_RESULT.md (our boxing 2D picture test, Fight Business style: paired pictures + tweens);
CARDGAME_PLAN_S539.md; DESIGN_CARDGAME_SCOPE.md round 6 (BJJ picked).

## What would a human do?
Use the free, open position map so every BJJ card has a correct picture of the two bodies, instead of drawing them by hand.

## Prefab check
GrappleMap itself (public domain).

## Contract
OWNS: proto/grapplemap/
RED_TEST: proto/grapplemap/grapplemap.test.mjs (node --test)
REGRESSION: none (standalone)
VISUAL: proto/grapplemap/out/index.html - Claude renders and checks it
