# S505 handover (written 2026-11-16 at the end of S504)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Roadmap `now.next_action` has the full detail.
Digest: `ops/research/S504_DIGEST.md`.

## Where the fight stands
- Fight motion week (deal: 5+ from BOTH blind critics or 3D leaves the first release). r10 (S503): coach 5, animator
  4.5. No new blind round in S504.
- S504 built (hit reactions, both critics' item 1): the hit-stop holds only the hitter (`-- holdboth`), the hit man's
  punch waits 0.20 s after his snap (`-- nosnapwait`), reaction clips start 0.067 s before their peak, and a hit
  reaction has its own quicker join (HitImpact.REACT_JOIN, `-- slowreactjoin`). Furthest point median 5 -> 3 frames,
  reactions later than 4 frames 25 -> 3 (s504base -> s504d). Cost: head jumps over 12 cm 89 -> 96 (see digest table
  for the final REACT_JOIN setting).

## NEXT (in order)
1. Head jumps (critics: 8 cm a frame). Split on s504f (90 over 12 cm in 180 s): 54 are in the PUNCHER's own clips
   (31 inside a punch clip, 12 at a change into one, 11 on its contact frame - the worst a pro_body_shot lunging 27 cm
   a frame with its hips 11 cm, jabs 24-27 cm at a clip change), ~25 in reactions (11 inside body-shot reactions), the
   rest dodges/idle. So the cap belongs on the punch first (PunchPace speed x the clip's own lunge; PopCap), then the
   reactions. Ruler: fight_motion_rulers "head jumps" + "worst head
   jumps" list on `human_fight_film secs=180 seed=7` (log only; ~4 min a run on the hidden desktop).
2. Cross step back still ~9 cm (target 15-25). Traced in S504: the place (bx.pos) does move back the full 15 cm and
   RingPlace's range keeper does not pull it in; the SHOWN hips are RingFeet.shown = lerp(place, the feet rig's step
   centre, rig.w) plus HitStep.lean capped at LEAN_MAX_M 0.08 - the feet's step pair has not caught up inside 12
   frames. Try: lean cap 0.12-0.15 for a cross/body, or the rig's chase started on the blow at HitStep.speed().
   hit_step_test pins cross < body and 1.4 m/s.
3. Stand-offs: STANDOFF1 found the "stand-offs" are NOT gloves pressed (one 0.3 s press in 180 s; 619 frames inside
   1.0 m) - they are standing close doing nothing. Measure idle time inside 1.0 m (both in guard/idle, no punch) and
   make the inside phase act: punch, tie up or step out.
4. Hand home within 4 frames of contact: collect Qwen PUNCHEND2 (home from her guard + from the contact frame) and use
   its contact_home_p50 as the ruler; arm left out median is 6 frames.
5. Film r11 (`--write-movie`, 1920x1080, sheets as in S503), rulers, two NEW blind critics (briefs in
   E:/FightCamp/tmp/fightweek/r10blind, sed the folder).

## Waiting on the operator
- Q-265: Scorecard tab mockup (docs/mockups/s504/scorecard/scorecard.png). His yes -> build the tab on ResultPage
  (TABS gains "scorecard"; ScoreSheet.build(from_rounds(...)); hover = the round's reason).

## Seats
- Qwen PUNCHEND2: launched ~22:05, wt LEAN_PUNCHEND2. Collect by its contract.
- Ziva COACHNECK2: never started (no branch, no change in ZIVA_LEAN). Re-send the brief to Ziva.
- Kalli SQ202/SQ203, John SQ204 still in the seat queue (guard damage v2 waits on SQ204).

## Debt
uppercut_tail_test red before and after S504 (not in the nightly list). block_absorb, hit_carry, join_return,
punch_speed, punch_weight red since S496-S501.

## PC
TRAP: every Bash call starts with `cd /e/FightCamp/Lean`; never `cd` into a worktree in a plain call (S504 did it twice:
use a subshell `( cd <wt> && ... )`).
