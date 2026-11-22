# TASK CARDREF2 - reference games, new scope: many martial arts in one card game (S537)

Model: claude-fable-5-2 (Agent SDK, API credit). RESEARCH ONLY.
OWNER S537: the card game takes BJJ, wrestling, judo, karate, MMA, sambo (and boxing) - "this might give enough depth and fun
and replayability, however i would like to see animations if possible" -> "so the research on the other games can get a
different scope now". Read ops/research/OWNER_CARDGAME_INTERVIEW_S537.md and CARDREF1_REFERENCE_GAMES.md first (do not
redo CARDREF1).

## The rule for reference games (owner, global CLAUDE.md)
Read-only inspection of INSTALLED files; findings in OUR words and numbers; nothing of theirs copied; no game launched; no
runtime hooking of online games. Encrypted packs stay closed.

## The questions
1. **Styles that feel different.** How do multi-style fight games make a striker, a wrestler, a judoka, a BJJ player and a
   karateka play differently - their own cards, ranges (distance: kicking / punching / clinch / ground), positions (standing,
   clinch, top, bottom, back), and win conditions (KO, submission, throw for points, decision)? Who beats whom, and how is a
   style-vs-style matchup kept 40-60% and not a lock?
2. **Positions as the board.** How do grappling games turn position into the game state (a position ladder, transitions,
   escapes, a submission chain) without slow sums - fast and punchy (the owner's taste)?
3. **Replayability.** How do they make the 20th fight differ from the 1st: style drafting, cross-training, hybrid decks,
   opponents' styles, rulesets (boxing / MMA / BJJ / judo / karate points).
3b. **Action points per limb (owner's idea).** Which games split the action economy by body part or slot (limbs, stances,
   hands), how many points, what happens when a limb is hurt, and whether it stays fast. What it would give each style.
4. **Animation in card games.** How do card/tactics fight games show the move when a card resolves (a short clip, a sprite
   loop, a pose card, a camera cut), at what length, and what it costs to make. What OUR repo already has to feed it:
   list the clips/animations for BJJ, wrestling, judo/throws, kicks, MMA in assets/ and E:\FightCamp\packs (names, counts,
   licences per ops/research/CLIP_LICENCE_LIST_S392.md), and the grappling/MMA rules or data already in scripts/ and the old
   archive notes in ops/research (grep BJJ, wrestl, judo, sambo, karate, takedown, submission).

## Sources
Installed (E:\SteamLibrary\steamapps\common and C:\Program Files (x86)\Steam\steamapps\common): Mixed Martial Cards Demo,
MMA Arena, KungFuCard, Elite MMA Manager Demo, Blood & Canvas Bareknuckle Boxing Demo, Gladiator Command, Dominus Gladiatus,
Might & Magic Fates TCG - check which exist. Public sources (web) for other multi-style fight card/tactics games and for the
real sports' rules (IBJJF points, judo ippon/waza-ari, karate WKF points, sambo, wrestling) - our words only.

## Deliverable
`ops/research/CARDREF2_MARTIAL_ARTS.md`: per question, what the games do (per game) and the real sports' scoring in numbers;
then "the six styles in our card game" - per style a one-paragraph proposal (its cards, range, position play, how it wins,
its counter), a style-vs-style table with the intended edge, and "what we can animate now from what we own" (a list). Then 6-10
probes for CARDSCOPE4, none run.

## Rules
No edits outside that one file. Commit by pathspec with 'Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>', pull
--no-rebase --no-edit, push. Report in two lines and stop.
