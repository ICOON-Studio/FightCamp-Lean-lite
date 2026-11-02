# TASK M35 - MARIA - WHERE EVERY PICTURE CAME FROM, AND WHAT REPLACES THE ONES WE CANNOT SHIP (art direction)
Model: Maria Art Director. Owner: maria. Assigned S79, 2026-09-25. Art/research only - no .gd/.tscn, no commits.

## Why
Your M34 flagged it: "the repo AI portraits and gym/office art have no recorded generator/terms - they need clean
replacements before shipping", and "never ship a picture whose source isn't recorded". The operator will pick one of
your four directions (A brass, B poster, C arena, D six a.m.); whichever he picks, the portraits and scene art have to
be clean. This task makes that list and the replacement spec, so S80's art spend is aimed.

## What would a human do?
An art director at a small studio keeps an asset ledger: every image, where it came from, who made it, under which
licence, and whether it can ship. Before a pitch build they clear the ledger - anything unknown is replaced, not
argued about. They then write one prompt/brief sheet so every replacement matches the chosen look.

## Do
1. Ledger: every image under `Godot/assets/` that a player can see (portraits, gym/office/city art, key art, icons,
   textures on menus). Columns: path, what it is, where it came from if known (git log of the file, a README, a
   generator note), licence, SHIP / REPLACE / UNKNOWN. Count each class.
2. For REPLACE and UNKNOWN: a replacement brief per image family (fighter portraits, coaches, gym interiors, office,
   city backdrops, title key art), written so it works for ANY of A-D with a one-line per-direction delta. Include
   the generator settings you would use (Higgsfield gpt_image is what we have: 0.25 credits an image) and how many
   images each family needs.
3. The five images that matter most for the first 10 minutes of play (title, HOME, fighter card, weigh-in, fight
   night) - ranked, with why.

## Deliverable
`M35_ART_PROVENANCE_AND_REPLACEMENTS.md` + `CLAUDE_LAND_NOTE_M35.md`. Mark every guessed source UNKNOWN - never fill a
source you did not see.
