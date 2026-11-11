# S437 handover (written 2026-11-11 night, end of S436)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S437`
and redraw Miro. Read ops/research/S436_DIGEST.md, then ops/research/ANIM_AUDIT_S435.md sections A and G.
If the S434 session is still open, its workflows may still run: check file times before touching the weight map or the
foundation (folder: C:\Users\user\.claude\projects\E--FightCamp-Lean\cc06cf94-1b7f-4ff3-ac8d-fa7ac72dd524\subagents\workflows).

## USAGE FIRST
`get_usage`. S436 at 21:47: all models 55 %, Fable 72 % (reset Thu 2026-11-12 16:00), extra usage EUR 37.92 of 40.
No paid critic round without his word.

## HIS WORDS (S436)
- On the intro's old dark tape card: "thats terrible i asked to be switched with the one that was shown when
  negotiating a contract"; then "yes use this one for taleof tape", "of course adjust without the contract offer
  options and refine it a little bit", "animations on tale of tape cannot be identical at the same time for both
  fighters please", "add a bit mor stats here , like record , from where , reach etc". ALL BUILT (see the digest).
- Then on the tape card: "remove the panel and makeittransparent and do it similar to ufcs presentations". BUILT
  (dbf7c119): no slate or frame, see-through bands, red / blue edges. He has not answered on that still yet.
- On the glove-touch two-shot: "this pose is wrong ,not normal". Rebuilt: one glove out, the other arm down, upright.
- He has NOT yet answered on the new stills (review board S436: the tape with eight rows, the touch, the name calls).
  Read the board comments first.

## 1. WAITING ON HIM
- His look at the S436 stills / the build (docs/WHAT_TO_TRY.txt top entry).
- Miro "P0 Where we are": three old "Added in S435" cards (widget ids in the S436 svg's data-deleted rows) need his yes
  to delete; until then `where_we_are.py svg` prints TRIM and the redraw is sent WITHOUT the data-deleted lines.

## 2. SEATS
- Collected S436: GYMLIFE2 (PR 215). Closed: PR 213, PR 214 (the intro is Claude's now, on main).
- PR 211 CALLSPREAD1: still NOT collectable as is (a wrong call costs less); after the foundation lands, with a fix
  that keeps exchanges_test "wrong calls lose clearly more".
- Cursor is idle and has NO brief: RANKSHOWUI (the Why card and the fighter page; the result page already shows the
  rank tile), PAGES2, ROPEENTRY2, BJJLOOK1 all lack ops/research/TASK_<id>.md. Write RANKSHOWUI first.
- Qwen: DUESSUMS3C queued; VOICEWIRE1 has no brief.

## 3. ANIMATION (every session): D0 is Claude's own work
Done: BEAT_TALLY; SKIP / VOID fail; S436 step 1: tests/ruler_stand.gd, head_aim 12 of 12 green, block_meet 27 of 27
with one real red (A_B rear hook 3.3 cm into the blocking glove).
NEXT, in order: (2) restore short_m (tools/punch_reach.gd write=1) and take ops/research/CLIP_CONTACT_REMEASURED_S435.json
with tools/hit_gap_probe.gd before / after; (3) human_feet on the default route; (4) a layer-order test; (5)
tests/fight_bout_test.gd, the frozen real-bout ruler (`seed=` does not change the bout: use the `women` bout or a seed
that reaches the round script); (6) the corner-face scene and ruler. THEN the seat tasks CONTACT1 (its bar is now the
block_meet red), POPS1, REACH1, KNEE1. New rulers that stand two boxers use tests/ruler_stand.gd.
Intro leftovers: celebration windows picked by eye per clip; men's opponents without height / reach on file.

## 4. THEN (board plan.next)
The S434 workflows' results (training v2 clarity round, the weight map's clarity round, the foundation by diff when each
skeptic reads "ready"), TURNPRO1 design, WRESTLE0, RESULTLOOK1, VOICEWIRE1 brief, KNOWN0 wiring.

## Traps (S436)
- `cd` into a seat worktree moves the session there: use `git -C`. Write edit scripts with the Write tool.
- Never edit game files under a running export; stop it first. godot_slot can wait minutes behind a seat: not a hang.
- The 3D fight has no stage headless EXCEPT the pure stage tests (head_aim, block_meet build FightStage headless fine);
  the real game's intro and bout need hidden_desktop with --log and the exe's full path.
- A seat's green tests do not mean the camera shows the right boxer: read stills of the real game before a collect.

SETTINGS: S436 ran on Fable 5.2. Next: Opus 5.5 high (ruler code, collects); Fast off.
