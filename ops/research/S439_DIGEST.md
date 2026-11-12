# S439 digest, the DAMAGESHOW side session (2026-11-12, about 07:45 to 08:30)

The lead S439 session ran beside this one in the same checkout (MATLINES1 at Goose, Cursor on Auto with PAGES2B after his
answer on Q-S294-191 "Use Auto until it resets"): its own notes are its commits and its handover section.

## What happened
- START: PC GREEN. Usage: all models 67 %, Fable 86 % (reset 2026-11-12 16:00), extra usage EUR 37.92 of 40. No answer
  yet on Q-S294-191 (Cursor), the sound board or the review board (0 unseen comments). Miro "Where we are" rolled to S439.
- DAMAGESHOW1 STEP 0, THE AUDIT (his "Stop, show damage", Q-S294-192): ops/research/DAMAGESHOW_AUDIT_S439.md. One Explore
  agent read the code; the table lists every screen, what BodyMap has there and what is drawn. The findings that matter:
  the body map lives only for the bout and only for rounds WATCHED in the 3D ring; face marks are drawn on one card
  (the corner card's HEAD close-up); no 3D face and no portrait shows anything; a sore place never outlasts the bout.
- DAMAGESHOW1 STEP 1, THE RESULT PAGE (commits 2f158e27 and the one after):
  - `scripts/fight3d/BoutMarks.gd`: the bout's map from its settled rounds on the ring's own path (ExchangeBeats, same
    seeds). `AfterFight.book` uses it whenever the ring did not ring a bell for every round (`body_bells`, counted in
    BodyLive.bell). Before: Skip bout after round 1 left the map at round 1, so a stoppage loss read "Nothing lasting";
    an unwatched bout had no map and no figures at all.
  - `Aftermath.damage`: every sore place worst first, every cut, the band decides (55 is sore, 35 badly hurt), no map
    never says "Nothing lasting". Right ribs are named "Liver", as the close-ups name them.
  - `scripts/ui/ResultMarks.gd` + `BodyCallouts.pin`: each boxer's figure on the result page keeps the close-ups of its
    sore or cut places out, on a hooked line, with "LEFT EYE 31 - badly hurt, cut"; her face card is 92 px with the
    FaceMarks (lines scale with the card, the nose is soft-edged now, the face is not washed in the band colour).
  - Tests: tests/bout_marks_test.gd (12 unwatched bouts: a map every time, the tile counts what the map has),
    tests/result_marks_test.gd, tests/fight_stats_test.gd (new tile cases). Also run green: face_marks, callout_pop,
    holo_live, body_figure, fight_flow, rank_show_ui, corner_stats, ko_continues, body_map.
  - Stills: tools/damage_result_still.gd (the real flow: round 1 watched, then Skip bout). docs/playtest/S439/:
    result_real.png (78 punches taken, nothing under 55: two clean bodies, "Nothing lasting"), result_staged.png (a
    heavier map set by hand, the tile rebuilt by the game's rule), a 3x close-up. On the review board, sent to him.
- BUILD: exported at 08:09 after the change; the exe smoke-ran 40 s on the hidden desktop with no error line. Not played.

## Findings for later
- A typical three-round amateur bout leaves nothing sore (head near 60, sore starts at 55): in 12 lost bouts 5 had a
  sore place. So the new marks show in under half the bouts. Not changed: no new rules.
- The injury roll reads eyes, nose and ribs only when the bout was watched to the end (audit defect 5). Left as is, on
  purpose: feeding every bout the full map moves the injury rates measured in S434 / S438. Measure, then decide.
- "The portrait afterwards" (step 3) has nothing to read: no place lasts past the bout. It needs his word on how long a
  mark stays visible (display only).

## Traps
- The session's shell `cd` into a worktree or tmp folder moves the harness's working directory: start every command
  with `cd /e/FightCamp/Lean &&`.
- A seat worktree's `git status` lists every file outside its sparse set as `D`: E:/FightCamp/wt/LEAN_CLIPFIX4 looked
  like a retired husk and was alive. Read `git log` and `ls` there first.
- hidden_desktop.py does not pass Godot's prints back: a still tool's lines are only seen in a headless dry run.
- A Godot job from the shell must go through `python ops/Tools/godot_slot.py run --who claude -- <command>`.
- Never print a file that may hold base64 audio (docs/audio/board/sound_board.html): grep it with `-c` or `-l` only.
- The mismatch offer cannot be accepted with `accept` alone in a still tool (the flow ran on to week 20).

## Open
- His look at the result page stills, then step 2 (the 3D face in the fight).
- The sound board (26 voices), the review board. (Q-S294-191 was answered: Cursor on Auto.)
- The clip ruler: The lead S439 session ran the in-house fixer already: commit 1f7e9a49 in the worktree E:/FightCamp/wt/LEAN_CLIPFIX4 (branch qwen/clipfix4, one commit ahead of origin, NOT pushed at 08:15): one hang number, the brief's bars, jab C retimed 0.265 -> 0.140, jab and jab B STOP (their stale fixed takes deleted), punch_form_test red on 3 FINDINGs and jab_retime_test red on 2 FINDINGs, both left for the lead's call (docs/CLIPFIX4_RESULT.md there). The worktree is alive (its `D` status lines are the sparse checkout, not a retire). Open: the five FINDINGs, a fresh reader, the side films, the merge, closing PRs 222 to 224.
