# S438 digest (2026-11-12, 00:50 to about 04:00)

## What happened
- START: no open board questions. The PC was RED on memory until about 02:03 (his game, about 5 GB), so the first hour
  was work without Godot. Usage at start: all models 61 %, Fable 81 %; at 03:10 all models 65 %.
- MIRO "Where we are" rolled to S438; his "Yes, delete them" on the six old S437 cards: deleted (12 widgets).
- BUILD: the S437 build that was never exported went out at 02:03; a second export at about 02:55 carries the ribs
  and the voices. Both smoke-ran 40 s on the hidden desktop with no error line. Not played.
- RIBS1 (Cursor's run stopped on its usage limit, one commit, checks never ran): reviewed by a workflow reader, fixed
  by a workflow fixer, checked by a fresh reader, finished by Claude, merged b01f204d. Both rib sides take damage, 60 %
  on the DEFENDER's liver side (PaceAim's rule), RIB_HIT 3.1 (3.0 to 3.2 read the same), the ring matches the settled
  body count where free single punches allow. The clinch rib digs were removed (the game never fed a clinch beat to
  BodyMap). The count match took head damage away (body shots used to be shown as face punches), so S318's "loser
  hurt" fell to 37 %: FACE_HIT 1.1 -> 1.15 and HEAD_HIT 0.55 -> 0.575 re-measured (real path 45 %, unit list 82 %;
  1.2 / 0.6 read 58 % and 92 %, over the unit bar). Body plan: target rib hurt in 65.5 %, at or under 35 in 15 %;
  default bout 0 %. OPEN: 846 of 1800 rounds settle more body shots than free singles (worst gap 4).
  docs/RIBS1_RESULT.md has every table.
- VOICEWIRE1 (PR 218): review found 15 defects (the in-round shout not wired though the note said so, the result
  announced on every redraw, a generator that could pay twice and wrote made-up loudness). Fixed in a worktree by a
  workflow fixer, checked by a fresh reader, merged 5ad6a0a9. Claude left the woman coach's 8 shouts out (nothing
  plays them) and made the tool find ludo.cmd on Windows (the first run found no tool and spent nothing). 26 lines
  made: 26 credits, 1083.51 -> 1057.51. All unheard; the sound board (docs/audio/board) was sent and the reel posted.
- QWEN IN THE CLOUD (Goose issues 219, 220): PUNCHFORM1 (the pure maths of a punch's form) and ROSTERROW1 (the data
  behind a Fighters page row). Neither opened a PR; both read from the branch and fixed at collect (0dff9792):
  PunchForm's hang ran short at the clip's ends and the other glove was read only to contact; RosterRow's five bars
  were five old single stats (Claude's brief named the wrong module): now the painted groups from Attrs, the ring =
  Attrs.weighted, best_of filled, stance shown.
- CLIPS: the other seven side films read on 66 ms sheets (all seven faulty; rows in clip_verdicts.json). Session start
  now prints "CLIPS verified N of M" (1 of 76). CLIPFIX1 could not start (Cursor out of usage) -> CLIPFIX2 on Qwen
  (PR 222, NOT merged: a useful table - the jabs hang 0.21 to 0.28 s against 0.14 for the good one - but hip turn read
  170 degrees, back-to-guard -1 on a good control, two bars fitted a hundredth from a control, no fix) -> CLIPFIX3
  (PR 223): the ruler's four faults and the three jabs retimed into assets/anim/baked/fixed. Claude filmed the three
  from the side: plain jab and jab C hold full reach about 0.17 s now, no jump seen. Two blind reviewers were reading
  it at wrap-up (workflow wf_8e4ad0f2-75b).
- DAMAGE DESIGN: split in two maps with every number from a script (ops/research/DAMAGE_FIGHT_MAP_S438.md,
  DAMAGE_AFTER_MAP_S438.md, tools/damage_*_numbers.py). Two rounds each with fresh critics: after the fight 5.5 / 5
  then 6 / 6 (clarity 5 / 5); the fight 4.5 / 4 then 5.5 / 5.5 (clarity 5 / 6). The common finding: case by case every
  decision is a LOOKUP on one visible thing; the "no option best over 70 %" asserts hid it. Round 3 launched
  (wf_f9efba2a-fc8) with the lead's direction: regret asserts per bout length, the opponent read by signs with
  confidence dots, the minute re-aim as the decision, a range call, three priced ONE CHANGE options, prices shown as
  win chance, four care answers that are four jobs, the weapon as GUESS or KNOWN, one Monday board with standing
  orders, "a minute, played" and "a Monday, played". Critics' pictures: docs/mockups/s438/damage/.
- CURSOR IS OUT OF USAGE ("You're out of usage. Switch to Auto, or ask your admin"): CLIPFIX1 and PAGES2 died in 10 s.
  Q-S294-191 on the board (Auto until it resets / wait / he raises it). Briefs ready: TASK_PAGES2.md (the Fighters
  page as painted, building on RosterRow).

## Traps
- A cloud Goose run can end "success" with a pushed branch and NO PR: read the branch.
- The rtk hook turned `| cut -c1-N` at the end of some commands into files named cut_-c1-N.log in the repo root.
- hidden_desktop.py needs the exe's full Windows path (a relative Builds/FightCamp.exe = CreateProcess failed).
- tools/voice_make.py and any Python tool calling `ludo`: on Windows it is ludo.cmd (shutil.which).
- clip_orbit frames are 1920x1009 jpgs: crop 960:810:420:180 for a figure sheet; drawtext crashes this ffmpeg.
- A workflow's journal can look finished while agents still run: TaskStop is not needed, wait for the notice.
- "No option best in more than N %" is a blind assert: print the winner case by case, or assert regret.

## Open
- PR 223 CLIPFIX3: the two reviewers' verdicts, then collect or round again; jab B's film unread.
- Damage round 3 scores (wf_f9efba2a-fc8 journal). 7+ from both on a map = that map to the board with its pictures.
- Cursor (Q-191): PAGES2 waits.
- PR 211 CALLSPREAD1 still held behind the foundation's third round (not started).
- The 846 short rounds (body count against free singles): a design call for the damage build, not a defect fix.
