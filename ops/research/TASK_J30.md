# TASK J30 — JOHN — HOW TO WRITE A MOVE SCRIPT FOR A TWO-FIGHTER COMBAT SPORTS ANIMATION

**Research only.** No engine, no code. Deliver `research/J30_MOVE_SCRIPT_METHOD.md` and mail RESEARCH READY.
Every substantive claim tagged **DOCUMENTED** (with a URL you opened) / **INFERENCE** / **NOT FOUND**.
Operator, 2026-09-14: *"Do research how to write proper scripts for combat sports 3d animation"*.

---

## THE SITUATION

A boxing (then MMA, kickboxing, judo) management game with a real-time 3D fight. A simulation engine decides every
action - who throws what, where it lands, how hard, whether it lands, was blocked or slipped - and the 3D room shows it
with bought motion-capture clips (one pack for strikes, another for reactions), retargeted onto our fighters, joined at
runtime, then corrected part by part (foot IK, arm IK to the target, a step that closes distance). The operator watched
the result and said, verbatim: *"it looks like each part of body have each own sped"*, *"There is no cohesion between
animations and reactions"*, *"Their distance is off their action looks like robot made in 90s"*, and asked *"Have you
written a proper script o. How to execute the moves?"* - we have not. We will write one next, boxing first (jab, cross,
lead hook, rear hook, uppercut, body shot; the other man's head hit, body hit, block, slip), and drive the animation from
it so both bodies and every body part run on ONE clock. We will measure the timing from real footage ourselves.

**Already on record (go past it):** fighting-game frame data fields (startup / active / recovery); EA Sports UFC GDC 2015
Animation Bootcamp as a move-list source; how clips can be joined; spacing between two bodies. None of it is a method for
writing down how a move is EXECUTED by both fighters.

## WHAT TO FIND

1. **How productions script combat for animation and motion capture** - EA UFC / Fight Night, Undisputed (Steel City
   Interactive), Creed, For Honor, Sifu, Mortal Kombat, Tekken, Street Fighter, WWE, and film/TV fight previs: the move
   document, the mocap shot list and coverage matrix (strike x reaction x distance x direction), paired two-performer
   captures, what the fight choreographer or stunt coordinator writes, naming, and how transitions are planned.
2. **How fight choreography and martial arts movement are NOTATED** - stunt/fight choreography notation, beat sheets,
   Labanotation or other movement notation used for martial arts or boxing, coaching breakdowns of a punch into phases.
3. **How animation craft times one strike and one reaction** - key poses (anticipation, strike, contact, follow-through,
   recovery), timing and spacing charts, overlapping action / successive breaking of joints, the kinetic chain
   (feet -> hips -> trunk -> shoulder -> arm) and the receiver's chain (head -> neck -> trunk -> feet) as animators use it.
4. **How two-character interactions are authored** - in engines (Unreal Contextual Animation, Motion Warping for synced
   attacks, Pose Search interactions, Unity equivalents: what a paired attack/reaction asset carries - alignment,
   distance, contact frame, roles, warp windows) AND in animation tools (Blender, Maya / MotionBuilder, Cascadeur: both
   rigs in one scene on one timeline, how mocap is cleaned and an exchange is timed to its contact frame, how the pair is
   exported). We have Blender 5.2 (scriptable, free) and Cascadeur on the PC; say what each is used for in production.

## WHAT TO DELIVER

`J30_MOVE_SCRIPT_METHOD.md`, 250 lines at most:
- **## DECISIONS** first: the method in ten lines - what a move script for two fighters must contain.
- **## SOURCES**: a table (URL | who | year | what it says | grade).
- **## THE TEMPLATE**: a field-by-field template for ONE exchange (a technique and its reaction): identity; distance
  before / at contact / after; the shared clock; the thrower's phases with each body part's onset and peak (in frames at
  30 and 60 fps, as blanks to be measured); the receiver's response by outcome (landed head, landed body, blocked,
  slipped, missed) with each body part's onset; contact point; the guard hand's job; footwork of both men; how the
  exchange enters from and exits to stance or the next exchange. Mark which fields a source gives and which are ours.
- **## A FILLED EXAMPLE**: the jab to the head landing, filled from sources where they exist and `TO MEASURE` where they
  do not - never an invented number.
- **## HOW TO MEASURE IT FROM VIDEO**: what the productions or coaches say is visible on footage, and at what frame rate.

## RULES

No invented numbers. No marketing copy passed off as method. Every URL opened. Download nothing.
