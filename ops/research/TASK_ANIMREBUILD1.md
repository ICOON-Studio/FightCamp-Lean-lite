# TASK ANIMREBUILD1 - AGY (Argon High) - design draft: fight animation rebuilt around a clip library + one picker
Kind: research
Status: OPEN (S399, Claude main). Discipline: boxing (BJJ only as "must not block it later").

## Contract
OWNS: docs/ANIM_REBUILD_DESIGN.md (a document only)
RED_TEST: tests/plain_words_test.gd -> PLAIN_WORDS failures=0 (no game file changes; this stays green)
REGRESSION: plain_words
VISUAL: no

## Why
Every S397/S398 animation round lost or tied on film (FIGHTWALK1-3, HITSELL2-4, INSIDE2-4, SOUTHPAW1): the fixes are not the
problem, the system is. Too many layers write the same bones each frame (FootPlant, BoxerFootworkRig, KneeTrack, CornerIK,
HitSnap, ElbowClear, FloorClear, BodyLive, ExchangeBeats, Clinch ...), so a fix in one is undone or hidden by the next
(HitSnap tuned on a bare body never reached the screen; films ~95% identical). The anim chain proposed a REBUILD: a library of
real captured clips (paired where two boxers touch), ONE picker that chooses the clip for the moment, physics only for impact,
and far fewer layers.

## Read first (all in this repo)
- ops/research/ANIM_HANDOVER_S397.md (what was tried, what lost, rules learned)
- ops/research/FIGHTWALK2_FILMS_S397.md (film fault checklist)
- ops/research/TASK_SOUTHPAW2.md "Why round 1 was not kept"
- scripts/fight3d/*.gd - list every node/script that writes bone poses or the root, in the order they run per frame
- scripts/FightClipRokoko.gd, scripts/fight3d/FightClips.gd, BeatClips.gd (what clips exist and how they are chosen today)
- the fight model's output the animation must show: scripts/rules/Exchanges.gd, LiveRound.gd (what events per exchange)

## Write docs/ANIM_REBUILD_DESIGN.md (under 400 lines), with these sections
1. TODAY: a table of every pose writer (file, bones it writes, when, what it exists to fix). Mark which ones fight each other.
2. TARGET: the clip library (what one entry holds: clip, start/end stance, range in m, hand, target, paired partner clip, tags),
   the picker (inputs = the model's event + both boxers' current pose/range; output = clip pair + blend time; how it avoids
   repeats), impact (where physics or additive hit reactions apply and where they must NOT), and the few layers that survive
   (root placement, foot lock, look-at - justify each one kept).
3. CLIP GAP LIST: per model event (jab, cross, hook, uppercut, body shots, slip, roll, block, clinch entry/break, hurt, knockdown,
   corner), which clip we have (Rokoko / ActionForge / Ailive footwork) and which we need, with paired captures called out.
   Sources allowed: Rokoko, ActionForge, Ailive footwork/duck, Ludo animate. No Meshy. Bodies stay MetaHuman.
4. MIGRATION in steps of ONE change each, every step judged on a 2-min film against main (blind critic), each with: the files it
   owns, a headless test that FAILS on main first, and the fault it removes. Step 1 must be small and visible.
5. RISKS: what gets worse first, and how BJJ (ground, scrambles) fits the same picker later without blocking boxing now.

## Rules
Do not change any game file - this is a document only. No invented numbers: every "today" fact cites file:line. Say "unknown"
where you cannot read it. Plain words, short sentences.

## Result lines (end of the doc)
RESULT: writers today <n>, fighting pairs <n>
RESULT: library entries needed <n>, have <n>, paired captures needed <n>
RESULT: migration steps <n>; step 1 = <one line>
