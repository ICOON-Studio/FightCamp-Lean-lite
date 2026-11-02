# C18 DIGEST — the wider game survey

Research only. No `.gd`, `.tscn`, save or test touched. Deliverables:
`C18_GAME_SURVEY.md` (this digest's source) and this file.

## The one finding

**Pound for Pound — our nearest commercial neighbour — ships its fight as a
text broadcast with a playback transport and no player input at all.** Played
first-hand to a finish: two portraits, a round clock, one highlighted
play-by-play line over two faded ones, a momentum bar, and a control bar of
step-back / play-pause / `SPEED · NORMAL` / `SIM TO END`. Nothing else. It is
also a **promoter** game, not a coach game, by its own welcome text.

## Recommendation

**A broadcast the corner can talk into.** The model resolves (`advance_exchange()`
stays authoritative, a seeded `begin_fight()` still finishes headless); the
scene presents; the operator controls pace with playback verbs; and the ONE
live surface is a small, priced hand of corner calls that the fighter may
refuse (K19's HEARD / HALF-HEARD / WAVED OFF). Ship `QUICK SIM` beside it.

Rejected, with reasons in the survey: **Punch Club 2's live tactical fight**
(costs a coordinate system, a save migration and a much wider test matrix — and
a coach who moves the fighter is not a coach) and **KungFuCard's card duel as
the fight itself** (a second live economy competing with the preparation layer,
and it cannot carry three rounds of fatigue and damage). Cards belong in
preparation.

## C17's three gates — framed, not answered

| Gate | Falls | Not settled by the survey |
|---|---|---|
| Q1 cadence | Atomic exchange; presentation is a cancellable queue | whether 1.4 s per 14 fight-seconds reads as continuous or as a slideshow |
| Q2 speed/pause | Speed and pause are presentation-only | whether the 8 s window freezes the sim clock — **nobody surveyed ships both a real-time fight and a stopping input window** |
| Q3 spatial | No authoritative spatial state in v1 | P4P has a cheap middle the gate does not name: a position/phase enum plus a control-time accumulator, no coordinates |

## First-hand evidence grades

| Game | Grade | Reached |
|---|---|---|
| Pound for Pound (demo) | PLAYED | world setup → booking → fight week → watched a bout to a submission finish |
| KungFuCard | PLAYED | one duel round committed and resolved |
| 足球经理：自走棋 Demo | PLAYED | coach quiz → live match with a coach hand, `CP 12/12` pool and Pitch Missions |
| Punch Club 2 (demo) | PLAYED (partial) | iso city map; the fight is story-gated and was not reached |
| The King is Watching | PLAYED | Week 36 save; the king's gaze as the production input |
| Punch Club 2 fight model | CODE | `REQUIRED_TICKS_IN_ROUND`, `PAUSE_BETWEEN_TICKS`, `DISTANCE_BETWEEN_FIGHTERS`, per-move damage fields |
| P4P fight model | CODE | `SimulateAsync` + `GetPlaybackData` / `PlaybackSpeed` / `RenderFeed`; `positionControllerId` |
| KungFuCard model | CODE | `SetBattleCard`, `BattleGroupDamageRule`, `CoolDownCard`, 破招 / 绝招 layers |
| Master of Command · FM2020 · Your Football Life · Corner King | INSTALLED, NOT RUN | — |

Part 1 of the survey (Codex) is entirely second-hand and labelled as such.

## Take, named

From P4P: the contested-week calendar carrying rivals' cards; graded booking
with the reasons as chips; venue fill projected against the card actually
booked; the missed-weight decision with four named consequences; the post-fight
statistics panel; the playback transport. From the auto-chess football demo:
one visible in-match pool, a small hand, and **missions that pay for using it
on a timer**. From The King is Watching: attention as the production input.

## Blockers

None. The three operator gates remain deferred by the operator's own decision;
this survey frames them and stops there.

## Screenshots

Not committed. The reads were taken from other studios' running games; the
standing rule keeps ripped or captured third-party art in the session
scratchpad.
