# S440 handover (written 2026-11-12 about 08:30, end of S439)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S440`
and redraw Miro. Read ops/research/S439_DIGEST.md first, then ops/research/DAMAGESHOW_AUDIT_S439.md.

## USAGE FIRST
`get_usage`. S439 at 07:50: all models 67 %, Fable 86 % (reset Thu 2026-11-12 16:00 local), extra usage EUR 37.92 of 40.
S439 used one Explore agent (0.2 M tokens) and no workflow. Keep `model: 'opus'` on every workflow agent.

## HIS WORDS
- On the board, Q-S294-191: "Use Auto until it resets" (Cursor). Nothing in this session's chat (it was started from the
  lead session; this file was written by the DAMAGESHOW side session: the lead session may add its own section below).
  Still standing from S438: "Stop, show damage".

## 1. WAITING ON HIM
- THE RESULT PAGE STILLS (review board, "Result page shows the marks of the fight", and sent to him): docs/playtest/S439/
  result_staged.png (heavy damage set by hand so every mark shows), result_staged_closeup.png, result_real.png (the
  bout as boxed: nothing sore, clean bodies). His OK or his marks decide step 2. Do NOT start the 3D face before it.
- ANSWERED: Q-S294-191 "Use Auto until it resets": the lead S439 session put the Cursor seat on its Auto model and
  launched PAGES2B (the Fighters page re-run, ops/research/TASK_PAGES2B.md) and MATLINES1 at Goose (issue 225). Those
  two runs are the lead session's: read `start` (COLLECT NOW / runs in flight) for where they stand.
- The sound board: 26 voice lines, all unheard (docs/audio/board/sound_board.html; never print that file, it holds the
  audio as text). A line plays in the game only after he keeps it.
- The new build: Builds/FightCamp.exe (S439), docs/WHAT_TO_TRY.txt current. Not played by him.
- Two things only he can say, ask them with the stills when he answers:
  a) most amateur bouts leave nothing sore (5 of 12 lost bouts had a sore place), so the marks show in under half the
     bouts. Fine as it is, or should light marks show earlier (a display line, not a rule)?
  b) the portrait afterwards: no place lasts past the bout today. How long should a mark stay on her portrait
     (for example until the next bout, or a number of days)? Display only.

## 2. DAMAGESHOW1, WHERE IT STANDS (his "Stop, show damage", Q-S294-192: NO new damage or recovery decisions)
- DONE S439: the audit; the result page (ResultMarks.gd, BodyCallouts.pin, the truthful DAMAGE tile, BoutMarks.gd so a
  skipped or unwatched bout keeps its marks). It joins RESULTLOOK1 (his C295): the rest of that redraw (why each round
  was lost before any breakdown; the towel line and bare numbers go) is still open and needs critics, then him.
- NEXT, step 2, after his look: THE FACE DURING THE FIGHT in 3D. Where it attaches (audit, last section):
  `FighterFace._scars()` already puts decals on a BoneAttachment3D on the Head bone at brow, cheek and nose spots
  (SCAR_AT); the eye shader `assets/shaders/mh_eye.gdshader` has `lid` (0 open, 1 shut). Feed them from BodyLive.map at
  each contact: a cut = a decal at the brow of that eye or on the nose; a swollen eye = lid up by the same strength
  FaceMarks uses ((55 - v) / 55 + 0.35); a closed eye = lid 1; a red nose = a soft red decal. Stepped by the band's
  word. A still on the broadcast camera AND the close-up (`tools/fight3d_play.gd` on the hidden desktop), opened by you,
  then his OK. Ludo paints a concept only if the look is new; this one reuses the scars' look.
- Then step 3, the portraits (needs answer b above).
- NOT FIXED, measure first: the injury roll reads eyes, nose and ribs from the map only for a bout watched to the end
  (`Injuries.after_bout` runs before `AfterFight.book` rebuilds the map). Feeding every bout the full map is right but
  moves the injury rates of S434 / S438: run rib_injury_test and the injury rates with BoutMarks first, then decide.

## 3. THE CLIP RULER, IN-HOUSE (the lead S439 session's work; the side session did not touch it)
- The lead S439 session ran the in-house fixer already: commit 1f7e9a49 in the worktree E:/FightCamp/wt/LEAN_CLIPFIX4 (branch qwen/clipfix4, one commit ahead of origin, NOT pushed at 08:15): one hang number, the brief's bars, jab C retimed 0.265 -> 0.140, jab and jab B STOP (their stale fixed takes deleted), punch_form_test red on 3 FINDINGs and jab_retime_test red on 2 FINDINGs, both left for the lead's call (docs/CLIPFIX4_RESULT.md there). The worktree is alive (its `D` status lines are the sparse checkout, not a retire).
  NEXT there: read the five FINDINGs and decide each; a fresh reader on the commit; the side films; merge by diff;
  close PRs 222, 223, 224. If the lead session's own handover section says more, it wins.
- Spec: ops/research/CLIPFIX4_REVIEW_S438.md (12 + 9 defects). What is right already: the measures (the real shoulder
  joint, guard from frame 0, hip turn 29 to 76, reach) and the retime touches nothing but time. NOT honest: the hang
  bar was raised 0.15 -> 0.20 and the faulty jab B whitelisted; the "fixed" jabs still hang 0.262 / 0.171 / 0.239 s
  (target 0.14; jab B's file is the round-3 one); the retime test's contact target is a typed z = 1.5 (the gap is
  0.899); the per-clip labels claim catches that pass; the result note calls unfixed defects fixed.
- The calls, already made: no fourth seat round. One Opus fixer in the worktree with the two review files as the spec;
  bars exactly the brief's; the good jab A reading 0.167 against 0.15 is REPORTED as a finding (show it beside a real
  jab's hold time from ops/research/topics/striking.md), never fixed by moving the bar in the test; one hang number
  (the ruler's) for tool, test and retime; retime to that number or say plainly it cannot hold with contact kept; then a
  fresh reader; then the side films:
  `python ops/Tools/godot_slot.py run --who claude -- python tools/hidden_desktop.py run --timeout=300 <godot.exe full
  Windows path> --path . --windowed --resolution 960x540 --audio-driver Dummy --script res://tools/clip_orbit.gd --
  out=<dir> ids=pro_left_jab,pro_left_jab_b,pro_left_jab_c side once`, sheet: `ffmpeg -start_number 6 -i
  <dir>/<id>/f%04d.jpg -vf "crop=960:810:420:180,scale=320:270,tile=6x5" -frames:v 1 -update 1 out.png`.
  Then close PRs 222, 223, 224.

## 4. ANIMATION (every session)
Item: the clip ruler above (owner Claude). Seats: Cursor runs PAGES2B on Auto, Goose runs MATLINES1 (the lead session's). After it: the
crosses (A and B short, C drops the lead glove), the lead hook (straight arm) and hook v2 (drops to the hip), the lead
uppercut (finishes above the head), the two body shots (bowed lunge), each on the honest ruler, each filmed from the
side. Then D0 step 3 (human_feet on the default route), a layer-order test, tests/fight_bout_test.gd, the corner-face
scene; then CONTACT1, POPS1, REACH1, KNEE1.

## 5. THEN
The foundation branch's third round (ops/research/FOUNDATION_S434_RESULT.md: CARDIO1, NOCAMP1), then PR 211
CALLSPREAD1. TURNPRO1, WRESTLE0, the rest of RESULTLOOK1. The dues design call. ROPEENTRY2 and BJJLOOK1 have no brief.
PAGES2B and MATLINES1: collect by diff when they land (blind review first: every seat delivery of S438 was wrong somewhere).

## Traps (S439)
- A seat worktree's `git status` shows every file outside its sparse set as `D`: that is not a retired husk. Read
  `git log` and `ls` there before calling it dead (S439 wrote it off wrongly for half an hour).
- Start every shell command with `cd /e/FightCamp/Lean &&`: a `cd` elsewhere moves the session's working folder.
- A Godot job from the shell goes through `python ops/Tools/godot_slot.py run --who claude -- <command>` (the guard
  blocks a bare Godot call). hidden_desktop.py wants the exe's full Windows path and does not pass Godot's prints back:
  dry-run a still tool headless first to read its lines.
- Never print docs/audio/board/sound_board.html (base64 audio: tens of thousands of tokens).
- The Miro redraw: push only the cards that changed (a partial SVG is safe), not the whole frame (20 KB out, 20 KB back).
- The idle guard blocks a turn that only waits: `python ops/Tools/idle_guard.py ok "<what runs and notifies>"`.

SETTINGS: S439 ran on Fable 5.2. Next: Opus 5.5 high (the clip ruler's fixer and reader by workflow on Opus); Fast off.
