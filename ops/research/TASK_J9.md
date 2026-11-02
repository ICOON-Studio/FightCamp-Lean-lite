# TASK J9 — THE CORNER: WHO IS LICENSED TO BE THERE, AND WHAT THEY DO (John)

**Status: COMPLETE 2026-09-07 - the brief was delivered by Codex as C31,
not by John. SUPERSEDED here; nothing landed under J9.**
John's Grok Build balance ran out mid-pass (402) and NOTHING landed in
`research/`. The brief moved to `research/TASK_C31.md`, which
keeps the Q-series numbering. **John does not run this on a top-up** - if the
balance returns, ask Claude for a new task rather than resuming here.

Research only. Follows J8 (`e26823d` cycle),
and cites J1–J8 without reopening them.

Model: top tier, effort high, Fast off. One delivery.

## Why this exists

J8 **N7** ruled that **coach quality is the strongest combat-gym demand
*kind* in the retrieved record — and still UNKNOWN as a number.** It ranked
coach above gym reputation and above athlete fame, which is the opposite of
where the operator's instinct had it. That ruling closed the membership
question and opened a bigger one it had no room for: **the game has coaches
and has never asked what a coach is.**

What is live: `get_world_coaches()` (`GameState.gd:583`), `_sign_world_coach()`
(`:3541`), `get_coach_capacity()` (`:3609`), `get_coach_rating_average()`
(`:3616`), `assign_coach()` / `clear_coach()` / `release_coach()` (`:12453`,
`:12471`, `:12498`), `_corner_coach_id()` (`:10151`), plus `CoachRapport.gd`,
`PlanCoach.gd` and `StaffHubPanel.gd`. A coach is a rating, a wage and an
assignment.

What is absent: any notion that a corner is a **licensed** position, that a
cutman is a different job from a head coach, that the number of seconds
allowed in the corner is a **published rule** in every commission that
regulates the sport, or that what a second may legally do between rounds is
written down. R35–R38 built a fight the corner can talk to; nobody has checked
what the corner actually is.

Unlike J8, **this one is likely to find real citations.** Cornerman and
second licensing, the count of seconds permitted, and what a corner may do
between rounds are published by athletic commissions and by the ABC's unified
rules. That makes this the first study since J1 with a real chance of moving a
game rule from *invented* to *evidenced*.

## What to research

Four areas, decisions numbered **Q1–Qn** so nothing collides with J3 D1–D16,
J4 E1–E34, J5 G1–G34, J6 A1–A18, J7 P1–P16 or J8 N1–N22.

1. **The licence.** Is a second / cornerman / cutman a licensed role, by whom,
   and what does the licence require? Where it is published, cite it. Where a
   body is silent, say UNKNOWN.
2. **The corner as a published rule.** How many seconds are permitted, who may
   be in the cage or ring and when, what a second may and may not do between
   rounds, what stopping the fight from the corner is and who may do it. This
   is the area most likely to be evidenced; treat it as the pack's spine.
3. **The staff a combat gym really has**, as *kinds* — head coach, discipline
   coaches, strength and conditioning, cutman, manager (J4 already ruled the
   manager's desk; **do not reopen E1–E3**). What is a job title and what is
   the same person wearing a second hat. Against this, say plainly whether
   the game's single `coach_rating` is an honest compression or a flattening.
4. **What a corner is paid**, under the same UNKNOWN policy J5 and J6 ran:
   a percentage of a purse that is not in a statute, a commission form, an
   organization's published page or a named industry table is **UNKNOWN and is
   not to be authored.** J6 A4/A6/A10 already refused a trainer and cutman
   percentage on the settlement — this area may confirm that refusal or find
   the citation that lifts it, and either answer is a result.

Ends with the decisions page up front (one recommendation, one line why) and a
**priority ruling**: what, if anything, this pack says should be built next,
and where it ranks against what is already queued.

## Out of scope

- No `.gd`, no `.tscn`, no `Godot/assets/data/`, no `HANDOFF.md` edits.
  **Claude writes your HANDOFF block.**
- **Do not reopen** J4 E1–E3 (the manager's desk), J5 G1–G18 (the gym's
  ledger), J6 A15–A18, J7 P1–P16, J8 N1–N22, R40, R43's payee, or R44's flat
  membership count.
- **No invented number.** No coach wage table, no corner percentage, no
  coach→member coefficient, no rapport formula. J8 N7 is the standing warning:
  the *kind* being real is not permission to author the magnitude.
- No real coach's, cutman's, official's or commission officer's name as data
  (J5 G34). A body is a kind of source, never a catalog row.
- No UI design, no screen proposal, no second career mode.
- This is not a review of `CoachRapport.gd` or `PlanCoach.gd` and must not
  recommend rewriting either for want of a citation — same rule J7 ran under
  for R42.

## Done

Push your deliverable only:
`research/J9_THE_CORNER.md` plus your land note. Message Claude when it
lands; Claude writes the HANDOFF block and marks the task done.

## Owned files

<!-- J9 was SUPERSEDED before John started it: its own header says the brief was delivered by Codex as C31, and `research/J9_THE_CORNER.md` was never written. The scripts J9 names are anchors it was told to read, not files it owns. -->

```
research/C31_THE_CORNER.md
```
