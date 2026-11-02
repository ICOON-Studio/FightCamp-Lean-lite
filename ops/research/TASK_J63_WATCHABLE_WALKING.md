# TASK J63 - Research: how management/sim games make a character walking between stations WATCHABLE (research only, no code)

You are John, a research agent. You have no shell and no repo. Everything you need is on this page. Reply in this chat with ONE document.

## Context (read once)
FightCamp is a boxing / MMA gym-management game (Godot). The player's training week is being rebuilt as ONE big 3D gym hall. The
player clicks a station (heavy bag, pads, treadmill, ring, pit box); the boxer WALKS there along the aisles at about 1.4 m/s, prepares
(gloves off, wraps), then trains; a day is 600 minutes of game time and the walk costs real game minutes. A camera shows the whole hall
from above-and-behind (home view) and zooms in on a station. We now play a real walk-cycle animation while he walks (before, he glided).

## Question
For shipped games where a small character walks between work points (staff or athletes), what makes the walking READABLE and
PLEASANT TO WATCH instead of dead time? Concretely:
1. Camera: follow vs fixed overview vs cut; zoom level while walking; what happens when the walk is long.
2. Time: do games speed up / skip walks? Fast-forward controls, "queue the next order while he walks", walk cost shown on the route.
3. Cues: path line, destination highlight, floating label, footstep/cloth sound, arrival beat (a short pause before the work starts).
4. Animation: walk-cycle quality cues players notice (foot sliding, arm swing, head bob, turning on the spot, start/stop transitions).

## Precedents to cover (6-10, real titles only; say "not verified" when you are unsure)
Two Point Hospital / Two Point Campus, Prison Architect, Football Manager (training ground), Fight Night / Undisputed career modes,
Game Dev Tycoon, Rimworld (work walking), Planet Coaster staff, Punch-Out!! (training montage), Rocky-style training montages in games.

## Output (max ~120 lines, markdown)
- A table: game | what the player sees while the character walks | what they can DO meanwhile | source (store page, dev talk, video title).
- Then "WHAT A HUMAN WOULD DO": five concrete rules for our hall, each one sentence, ordered by value.
- Then one "DO NOT": the most common mistake you found.
Sources must be links or exact titles. No invented quotes. Do not browse our repo. Do not write code.

## Prior research
Checked with the repo's prior-research tool: research/topics/camera_broadcast.md and gym_rooms_art.md exist (broadcast camera and rooms), but no
study of walking between stations. This is new.

## Prefab check
Not applicable (research only).
