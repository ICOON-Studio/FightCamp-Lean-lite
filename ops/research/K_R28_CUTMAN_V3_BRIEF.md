# Kalli brief - R28 Cutman, design map v3: DEPTH (S424)

You are the game designer of FightCamp, a boxing gym management game for PC (one gym, a small roster, amateur to first pro
fight; the player manages, never throws punches; the fight is settled by numbers and shown in 3D). Read first, whole:
ops/research/CRITIC_PACK.md (the whole game and its mechanics) and ops/research/R28_CUTMAN_DESIGN_MAP.md (v2, 79 lines).

## The operator's verdict on v2 (the board, Q-S294-175, verbatim)
"need to improve the depth of the mechanic, , rated 4/10 does worth investing time i think"
He wants it deeper, and judged v2 at 4/10 even though v2 was a critic's 10/10.

## Why v2 is shallow (Claude's read)
One real decision, stop or go, taken once when the eye is already closing; the corner job is a pick of one from a short list.
Nothing before the fight leads into it and nothing after it carries forward, except one layoff roll.

## Levers to weigh (use the ones that earn their place; drop the rest, say why)
1. BEFORE: which cutman you hire (skill tiers and prices; a cheap one closes fewer cuts), the scouting report naming a
   "cutter" or a head-clasher, the boxer's own scar tissue ("Marks easily"), a fight-plan line "protect the eye".
2. IN THE ROUND: the cut's true depth is hidden; the corner sees a RANGE that a better cutman narrows (the game already shows
   ranges that never lie for scouting). The other corner sees the cut too and starts hunting it, round by round.
3. THE SCORECARDS: ahead or behind changes the call - ahead, survive to the final bell; behind, the cut forces a race against
   the doctor (go for the stoppage early). Real rule to check: an accidental head-clash cut that stops a pro bout after
   round 4 goes to the cards (technical decision), before it is a no contest / technical draw; amateurs differ.
4. THE MINUTE: 60 seconds and two pairs of hands (cutman, coach) across four needs - the cut, the swelling, the tactical
   call, breath and water - with diminishing returns, so each round is a small allocation, not a lookup.
5. AFTER: scar tissue makes the next cut likelier; choices across a career (rest, a style change, surgery) and the cutman's
   skill shrink the scar. The boxer's trust in the corner after a stop or a send-out.

## What to deliver (one markdown page, plain words, no option letters)
- The decisions the player makes, in order through ONE fight night and across a CAREER, each with what it trades.
- For each decision: the screen it lives on (corner minute, live fight side panel, fight plan, staff, scouting, after-bout
  report), what the player sees before choosing, and the numbers (real-world anchor where one exists, "invented" where not).
- The dominant-strategy check: for each decision, why no option always wins (state the case where each option is right).
- What it needs from systems that exist vs new ones; keep it buildable in two pure modules and two screens.
- Your own depth score for v3 out of 10, and the concrete list of changes that would take it to 10/10.
- Never "he" or "she" for the boxer: the name or "the boxer" (it is a sandbox game).
