# TASK U35 — CURSOR — WHAT RingStagePanel LETS THE PLAYER DO TO A LIVE FIGHT

Model: Composer (Cursor's own pool — the Other Models pool is empty until
Oct 7), medium effort. Launched `-p --force --trust`.
Assigned by Claude, 2026-09-10. Owner: cursor.

## READ ONLY. YOU EDIT NO `.gd` FILE IN THIS TASK.

Your single deliverable is one research file. If you find a bug, **write it
down, do not fix it.**

## Why this exists

R96 measured the real-time engine and found the wiring job is a **beat
adapter**, not an engine swap. Claude is building that adapter now and switching
`FightNightScreen` onto it for boxing, MMA, kickboxing and muay thai.

`RingStagePanel` is the harder half, and R96 said explicitly it should be
**scoped separately rather than discovered mid-build.** It carries
`react_to_combo(_fight_state, side, "instinct")` at `RingStagePanel.gd:1200` —
a **player-intervention verb the real-time core has no equivalent for.** The
20 Hz engine has no combo window, no pause point and nothing that asks the
player a question.

Before anyone writes a line of that, we need to know exactly how big the surface
is. That is this task.

## Owned files

- `research/U35_INTERVENTION_SURFACE.md` — **NEW, yours, the only file you
  create.**

## The files to read (and their real sizes)

- `Godot/scripts/RingStagePanel.gd` — **1,414 lines.** Small enough to read
  whole if you want it, but the anchors below will save you most of it.
- `Godot/scripts/FightNightScreen.gd` — **848 lines.** It is the host: it owns
  the timer, calls `_view.present_event(event)` and opens the corner dock.
- `Godot/scripts/FightSimulation.gd` — **3,270 lines. NEVER open it whole.** Read
  only `sed -n` windows around the anchors named below.
- `Godot/scripts/FightRealtime.gd` — **2,086 lines.** Same rule; the verbs are
  `begin` at `:325`, `advance_tick` at `:550`, `result` at `:648`.

Anchors:

| what | where |
|---|---|
| the intervention verb | `RingStagePanel.gd:1200` (`react_to_combo`) |
| the view's event entry | `RingStagePanel.gd:429` (`present_event`) |
| the host's tick loop | `FightNightScreen.gd:405-415` |
| the host opens the dock | `FightNightScreen.gd` `_show_command_bar` |
| the pause question | `FightSimulation.is_decision_point` |
| the combo the player answers | `FightSimulation.gd:1852` (`combo_incoming`) |
| between-rounds window | `FightSimulation.gd:2830` (`between_rounds`) |
| the chain the player calls | `FightSimulation.gd:2004-2018` (`chain_refused`) |

## What the file must answer

Answer each with `file:line` evidence. A claim with no anchor is not a finding.

1. **The full verb list.** Every method on `RingStagePanel` and every method on
   `FightNightScreen` that lets a player *change* a fight in progress, as
   opposed to watch one. Name each, give its signature, say who calls it and
   what it does to `_fight_state`.
2. **Every pause point.** What makes the fight stop and ask the player
   something? `is_decision_point` is one. Are there others? For each: what
   opens it, what closes it, what happens if the player answers nothing.
3. **What each intervention actually costs the fight.** Does `react_to_combo`
   change a roll, a stat, a state flag, or only the display? Follow it into
   `FightSimulation` and say what it writes.
4. **Which of these the 20 Hz engine can express today, and which it cannot.**
   Three buckets: *has an equivalent*, *could have one cheaply*, *has nothing
   and would need new engine surface*. This bucketing is the point of the task.
5. **The coached-sides contract.** `_coached_sides` gates whether a corner
   window opens at all (lab coaches both, a player's bout coaches theirs, a
   spectator watch never pauses). Say exactly how it is set in each of the three
   entry paths and what a real-time fight would have to preserve.
6. **The display-only surface.** Which parts of `RingStagePanel` only *read*
   the fight — the body regions, the strip, the broadcast readout, the callout
   line, the rails. For each, name the event keys it reads. Claude needs this
   list to know what the adapter must emit; it is the most immediately useful
   section of your file.
7. **Your own recommendation, one paragraph.** Given all of the above: is the
   intervention surface a *port*, a *rebuild*, or a *thing we should cut*? You
   have read more of this panel than anyone. Say what you actually think.

## The refusals

- **Do not design the replacement.** No new verb names, no state machine, no
  proposed API. This is a survey of what exists.
- **Do not fix anything.** A bug you find is a finding with an anchor.
- **Do not read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any
  digest.** This file is self-contained.

## THE GATE — tier: RESEARCH, NO `.gd` TOUCHED, NO GATE AT ALL

Not the parse gate, not a test, and **never** the suite. `git status -s` before
you stage is the whole check.

## Deliver

1. `git rev-parse --abbrev-ref HEAD` — **you left this checkout on
   `cursor/u34-judo-board-caller` yesterday and six commits went to a branch
   while `git push origin master` answered "Everything up-to-date".** Land U35
   on **master**.
2. `git add -- research/U35_INTERVENTION_SURFACE.md`, commit, push.
3. One line: `python Tools/agent_comms.py send --from cursor --to claude --subject U35-done --body "<commit> <verb count> <which bucket react_to_combo landed in> <your port/rebuild/cut call>"`.
4. Do **not** edit `HANDOFF.md`.

## The one trap specific to U35

`RingStagePanel` is `FightNightScreen`'s **child view**, not a second
independent caller — R96's phrasing ("the second caller") is about which file
names `FightSimulation`, and both do. Get the ownership right in your file: the
host owns the loop and the state, the panel presents and asks. A survey that
gets that backwards will send the next build task in the wrong direction.
