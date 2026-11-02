# BRIEF - the training loop as a "day lap" in one 3D gym (opinions wanted, S171)

You are a senior game designer. No repo access is needed. Answer in plain words, max 700 words, with a ranked list.

## Context
FightCamp is a combat-sports gym-management game (boxing demo first, MMA later), real-time 3D fights, Godot engine. The player runs a gym,
signs a fighter, trains him, scouts opponents, books fights, watches them and coaches the corner. Problem: the weeks between fights feel
repetitive - pick a focus, press advance.

## The idea on the table (the operator's)
- ONE 3D gym is the only scene (zoom into rooms: bag lane, cage, ring, strength, recovery, film room, office).
- A training DAY is a LAP, like the preparation lap in Motorsport Manager: the fighter physically walks station to station through
  6 slots (about 2 h each) per a schedule the player set; the lap plays at 1x/4x/skip and pauses only on exceptions (a flinch, a swollen hand,
  a coach argument) where the player can push, pull him off or extend a station.
- Each station in use shows YOUR fighter's progress against the OPPONENT's projected progress (grey "?" until scouted; scouting - watching film,
  hiring a scout - narrows it to a band).
- Tasks last 1 slot, several days (sparring cycle, scouting report, weight cut), or can be doubled in one slot at a quality penalty.
- Pressure builds toward the fight date: free slots shrink (recovery, weigh-in), the room's light and noise change, a countdown is on the board.
- UI must be light: numbers written on objects in the room or hanging over people; almost no menus.

## Questions
1. What breaks first about this idea (pacing, balance, player fatigue, production cost)? Name the top 3 failure modes.
2. How does Motorsport Manager (and Football Manager, Out of the Park, Game Dev Tycoon, Two Point Hospital, Hades-style hub games) keep
   the in-between time engaging, concretely: what are the decisions per minute, and what interrupts the player?
3. What is the right number of meaningful decisions per camp week, and what should be automatic?
4. Propose 5 specific, cheap "exception events" for a training lap that create a decision and a story (each: trigger, choice, consequence).
5. How should "progress against the opponent" be shown so it creates tension without becoming a spreadsheet? Sketch it.
6. What would you CUT from the idea to ship a first playable in 3 weeks?

## Prior research
D69_FIRST_HOUR_FRESH_EYES.md (one-more-turn pull, overlapping timers), J54_MENU_ARCHITECTURE_SURVEY.md (menu survey); no study yet on the day-lap idea.

## What would a human do?
A real coach looks at the gym floor, sees who is where, and walks over when something looks wrong.

## Prefab check
Motorsport Manager prep lap, Two Point Hospital staff routing, MMA Manager 2 gym - say what each does and what to copy or avoid.

Rules: nothing opens on a screen; reply as text only; no file attachments.
