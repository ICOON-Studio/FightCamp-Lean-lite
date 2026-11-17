# S507 handover (written 2026-11-17, end of S506)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Roadmap `now.next_action` has the detail.
Digest: `ops/research/S506_DIGEST.md`.

## Where the fight stands
- Blind r11 (S505): coach 5, animator 5.0. Their #1 and #2 are now BUILT but NOT FILMED (the owner played ArcheAge
  Chronicles all S506 - no renders, no heavy E: writes while he plays):
  - FREEHAND: GuardTuck holds the non-punching glove at its guard point by the chin while a punch clip plays
    (FREE_W 0.9, body shot 0.5; a beat's after fact right_low/left_low lets it drop). `-- nofreehand` = control.
  - HEADEASE: HitSnap's snap/give ease home (smoothstep, 0.30 / 0.40 s) instead of an exponential spring.
    `-- oldsettle` = control. BlockCatch keeps the old spring (`envelope(t, true)`).
- The BEFORE numbers (s505b, tools/free_hand_probe.gd, FREEHAND1 collected): off_share 0.78, free_p50 24.1 cm,
  free_p90 38.9, guard_free_p50 16.8.

## FILMED at the end of S506 (owner: "go ahead film it now", while he played)
- s506a (both on): FreeHand off_share 0.78 -> 0.30; HeadEase back frames 4 -> 13 (no snaps); hit reactions bigger
  (jab 14.4, cross 16.7 cm). COST: head jumps 77 -> 91 (punch frames 40 -> 50, hits 34 -> 38). Ease 0.24 / 0.27 tried
  (s506b/c): back to 4 frames - 0.30/0.40 kept. Both-off film = s505b to the frame (the fight is deterministic).
- So item 0 below is DONE; the new first item is HEADJUMP1 against s506a.

## NEXT (in order)
0. On an idle PC: 180 s film seed 7 (`tools/human_fight_film.gd`, hidden desktop; no `--write-movie` for the log alone)
   -> free_hand_probe vs s505b, head_ease_probe (collect HEADEASE1 first) vs s505b. Adopt if the numbers move the
   right way and the red fight tests keep their FAIL sets.
1. Hook fling (critics' item 3): hit_frame THROUGH 0.24-0.36 m on pro_left_hook_ft / _hurt_ft / right_hook_hard is the
   stepping body leaving the fixed aim at FULL reach weight (traced with prints) - not the release. Check it on the
   film first; if it shows, re-aim from the body (the carry relative to the shoulder), do not cap the release (tried,
   no effect, not kept).
2. Film r12 + two NEW blind critics, aim 6 from both.
3. Merge Ziva PR 341 (COACHNECK2) once the owner OKs the still pair on /review (CornerIK under 500 lines).

## Seats
- HEADEASE1 collected (tools/head_ease_probe.gd). Qwen HOOKPAST1 running (branch qwen/hookpast1): the fling ruler.
- Films: pass `--log=<dir>/godot.log` to hidden_desktop or there is no godot.log for trunk_tap_report.

## Traps seen this session
- block_meet runs at its header's FIXED_FPS 30: at 60 it reads 14 failures (3 is its baseline).
- My A/B script stripped numbers from FAIL labels: compare ROW values too, not only labels.
- `cd` into a tmp/worktree folder in a Bash call moves the session folder (happened twice): use absolute paths.

## Waiting on the owner
- PR 341 look (coach neck before/after on /review).
- Unity + Unity Hub (~27 GB on C:) look unused - his call.

## Debt
uppercut_tail, block_absorb, hit_carry, join_return, punch_speed, punch_weight, block_catch, hit_frame, punch_range,
block_meet (3), guard_knee (1) red; none new in S506 (A/B per change).
