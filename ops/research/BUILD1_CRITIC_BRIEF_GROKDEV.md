# BUILD1 critic brief (Grok Dev) - FRESH, CODE-CHECKED critic: score a DESIGN for Puncher's chance (S570)

Repo: ICOON-Studio/FightCamp-Lean, branch main (pull first; commit 4ecd137 or later). Read only - push NOTHING, open no PR.
Read in this order:
1. ops/research/CRITIC_PACK.md and ops/research/CRITIC_ACCESS.md (the whole game; facts only).
2. ops/research/DESIGN_BUILD1.md (the design you score).
3. The code it claims things about: proto/twohands/order.html (the rules, everything above "// ---- the page"),
   proto/twohands/tools/rules.mjs, proto/twohands/tools/balance.mjs, and the probe
   ops/research/s558_balance/build1_probe.mjs with its output ops/research/s558_balance/results/build1_v1.txt and _v2.txt.
CHECK THE PAGE AGAINST THE CODE: every number the design quotes from the probe, every patch the probe makes (does it do
what the page says? does it change something the page does not say?), the claim that the look-ahead table is an
approximation for unequal builds, and the claim "a deck that is part of another is beaten by it". Run the probe yourself
(Node 20+, from the repo root), e.g.
  node ops/research/s558_balance/build1_probe.mjs a=out:50:50:50 b=pres:50:50:50 n=24 seed=7
  node ops/research/s558_balance/build1_probe.mjs a=pres2:50:50:50 b=gen2:50:50:50 n=24 seed=7 def=2
on YOUR OWN seeds, and try at least one exploit of your own (a build or pool split the page did not try). List every
contradiction between page and code you find.

## What to score (bar: 8+ on DEPTH and 8+ on PLAY or the mechanic does not stay; be blunt, a kind score is useless)
1. DEPTH (1-10): are there real, lasting decisions - in camp (which cards on which part, which pool to train) and in the
   bout (which part to protect, which card to spend)? Does the probe show the choices matter, or is one choice always right?
2. PLAY / fun (1-10): would a player enjoy building a fighter this way and fighting with that body? Is the "hand is the
   body, his punches take your cards away" idea fun or a chore?
3. GENERAL (1-10): clear, consistent with the game's rules and words, buildable from what exists, nothing useless.
4. SPEED (1-10): seconds and clicks a beat in the bout, and in the camp screen; does it feel quick?
5. THE FIRST FIVE MINUTES (1-10): how far does a new player get without help?
Also: which options a screen would be MISSING, which are useless, and what each changes (the game's critic rule).

## What you must return
- A score table (the five lines above, each with one line of why).
- **To reach 10/10** for EACH score: the concrete changes, most important first, each specific enough to build
  (numbers where you can). A score without this list is not finished.
- **Your 10/10, drawn**: ONE self-contained HTML page, 1920x1080, inline CSS only (no external files, no scripts needed),
  showing the camp screen where the player builds the body (parts, slots, pools) and a strip of the bout hand grouped by
  body part, the way YOU would make it to earn 10/10. Put it between the lines `<!-- PAGE START -->` and `<!-- PAGE END -->`.
  Plain words on screen; names only in headers; nothing drawn on top of the fighters.
- Plain words. The game is called Puncher's chance (never any other name).

Reply in this chat with the whole result (scores, the contradictions found with file:line, your runs with their exact
command lines and numbers, To reach 10/10, the HTML page).
