# TASK COACHDEEP1 - coaches as people (Football Manager depth): design map from the code + the first probe (S539)

Model: claude-opus-5-5 (Code Mode tab). Discipline: boxing (demo). Map + greybox probe only: nothing under scripts/ changes.

## Why (owner, S539, verbatim)
- "why not make proper coaches like fottball manager and use them more to tighten and improve the core loop ?"
- "make him more deep , what he know how he mix with fighters and different personalities , his playbook , needs proper
  attributes and personality"
- Earlier the same session: "can the 'their corner' be hyperlinked to their coach so you can quickly see what his coach is good
  at and get some clues ?" (the pro weigh-in miss pop-up, scripts/ui/modals/WeighIn.gd, "THEIR CORNER ANSWERS").
Bar (owner S534): probe the lever FIRST, then two fresh critics at 8+ DEPTH and 8+ PLAY, then build. FREE HAND: remove, add,
interconnect.

## What failed before (read first)
docs/COACHHIRE1_RESULT.md (S538): a second coach as a stat multiplier + a wage was never a choice (one boxer, the wage only
closes the gym sooner); CoachMarket + CoachFit were removed. Its "Limits": a coach matters when coaching TIME is short (3-4
boxers sharing evenings) - DEPTH_SCOPE_S534 change 3, "the coach's hands as the club's currency". Also COACHFITPROBE2/3,
DESIGN_COACHFIT1_* , ops/research/topics/staff_coaches.md (settled lines).

## The coach, as the owner asks (design these, each wired to something the game already has, or cut)
1. ATTRIBUTES (Football Manager style, 1-20 or 1-100, few and readable): pads/technique, conditioning, tactics (game plans),
   cutman/corner, weight management, scouting/film, motivation, teaching young boxers. Each one names the rule it changes today
   (file:line): e.g. tactics -> the plan grade / corner calls (PlanLines, Exchanges); weight -> the weigh-in miss chance
   (WeighMiss.gd, built S539); cutman -> GuardState recovery between rounds; film -> OppFile depth; motivation -> morale.
2. WHAT HE KNOWS: the arts and moves he can teach well (a move he does not know is slower to drill: MoveMastery / PadWeek),
   the styles he reads best.
3. HIS PLAYBOOK: his own preferred plan lines and drills - a coach brings a way of fighting (e.g. "counter off the jab",
   "pressure to the body"); a boxer whose style fits it learns faster, one who does not resists.
4. PERSONALITY + HOW HE MIXES: coach personality (temper, discipline, patience, ambition, loyalty) against the boxer's
   personality (FighterProfile) -> chemistry: learning speed, morale, loyalty; a clash costs something visible. The coach-boxer
   bond grows with time together.
5. TIME: limited hours; the weekly plan assigns coaches to boxers (the core-loop choice COACHHIRE1 says is missing).
6. THE OTHER CORNER: opponents' coaches on the same model (a card behind "their corner"): their ratings drive their weigh-in
   answer, how fast they read repeated combos (REPEATBITE: docs/REPEATBITE1_RESULT.md - the read could depend on WHO you face),
   their round-2 adjustment. Every line on that card must be something the player can act on (C443 only actionable info).
7. CAREERS (later phase, sketch only): reputation, poaching, a retired boxer becoming a coach.
Reference reads (our own words): Football Manager's staff model; MMA Empire's camps (ops/research/MMAEMPIRE1_COMPARE.md s1:
gym-mates lift training; retired fighters as coaches); MMA Fighter: Road to Champion (Steam 5481980: retired fighter returns as
a mentor; mental stats).

## Do
1. ops/research/DESIGN_COACHDEEP1.md from the code (every CODE claim with file:line read today): the coach model above, the
   table of every menu it appears on and what each is wired to, a phase plan (your coaches -> other corner -> careers), a cut list.
2. Greybox probe tools/coachdeep1.gd (+ rules copy) of the CORE lever only: a 4-boxer TEST CLUB (three boxers in different
   classes + one BJJ, owner S428/S487), 1 or 2 coaches with different attributes/playbook/personality, assignments week by week,
   104 weeks, paired arms, a bout's dice on the fight day. Bars written in the result BEFORE the run, not loosened: (a) no single
   assignment rule is best in more than 6 of 10 cells; (b) chemistry moves an outcome by a line ($1,000, 3 reputation, 0.5 of a
   win less loss, or 5 morale) in at least half the cells; (c) the right coach for a boxer differs by boxer in at least half the
   cells; (d) best beats laziest (same coach for everyone) by a line in at least half; (e) effects larger than 2 standard errors.
3. docs/COACHDEEP1_RESULT.md. PASS -> ops/research/CRITIC_COACHDEEP1_BRIEF.md (CRITIC_PACK + CRITIC_ACCESS first, never a score;
   DEPTH / PLAY / GENERAL /10; reads the code and the probe; the list to 10 + a drawn 10/10 page via tools/render_mockup.py) and
   queue kalli and dola. FAIL -> what to change, stop.

## Prior research
`python ops/Tools/prior_research.py coach personality chemistry playbook staff`; the files named above.

## What would a human do?
A gym owner hires the coach whose way of boxing suits his kids, and keeps the hothead trainer away from the sensitive one.

## Prefab check
None (our own rules).

## Contract
OWNS: ops/research/DESIGN_COACHDEEP1.md, tools/coachdeep1.gd, tools/coachdeep1_rules.gd, docs/COACHDEEP1_RESULT.md,
ops/research/CRITIC_COACHDEEP1_BRIEF.md
RED_TEST: tools/coachdeep1.gd (a probe)
REGRESSION: none (no game file changes)
VISUAL: no

## Rules
Work in main. Godot ONLY via `python ops/Tools/godot_slot.py run --who coachdeep1 -- <godot> --headless --audio-driver Dummy
--path . --script res://tools/coachdeep1.gd -- ...`, one run at a time; long output to E:/FightCamp/tmp/coachdeep1/, wait on its
done line. Read ops/research/GDSCRIPT_TRAPS.md. No script over 500 lines. Commit only your paths, push. When done run
`python ops/Tools/idle_guard.py ok COACHDEEP1-done`, report in two lines, stop.
