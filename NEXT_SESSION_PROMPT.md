# S418 handover (written 2026-11-10, S418 main session)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S419` and redraw the map.
THIS FILE WAS CUT IN S418: it had grown to 988 lines. Every older handover (S396 to S417) is in ops/research/HANDOVERS_S349_S417.md: grep it by keyword, do not read it whole. What is still open from them is listed under STILL OPEN below.
READ THE PULL'S OUTPUT: a file list after a session-start pull is the alarm.

## Built S418, exported 05:28, HE HAS NOT PLAYED IT
- LOOKSLATE1 (Cursor, PR 147) merged bbc6cbbd: the Training week page on slate. Fixed at collect: a held drill's wooden button hung out of its card and the sentence was cut. Now one row, "Held at 48 by the Cross" + the button, the reason in the tooltip (drill_card_test holds it).
- HEADAIM2B (Qwen, PR 146) merged bc0a76b1: an un-landed head punch is thrown at face height, latched when the punch starts. head_aim_test: aimed within 0.016 m, raw 0.08 to 0.47 m off; level pair raw 0.21 to 0.29. Filmed in the Moves preview (E:/FightCamp/tmp/s418_headaim): the SLIPPED jab is right, it flies where the face was.
- KNOW1 (Goose, issue 139) merged 40d0db6b: scripts/rules/Knowledge.gd, nothing reads it yet. Next step is in ops/research/KNOWLEDGE_S411.md's build order; the bots test comes before any screen.
- 05:00 full run, the first real one: 239 pass, 0 fail, 8 minutes. Recorded in roadmap NIGHTLY1. week_slate, head_aim and knowledge tests are on the list from 11-11.
- tests/slate_walk.gd: the slate checker, shared. `SlateWalk.faults(page)` after `WoodKit.ink(page)`.
- tools/layout_snapshot.gd takes `noguide` after the out dir: stills he sees must have no guide. tools/head_aim_film.gd films a move in the Moves preview, every frame, `noaim` for the control.
- 36 finished runs archived out of live_runs.json (the COLLECT NOW list at start was 36 stale lines). PRs 108 and 130 closed as superseded.

## Running and queued
- CURSOR: LOOKSLATE2 (Club People) running. LOOKSLATE3 (Fight camp + bout offer), 4 (New game + interview), 5 (Money), 6 (World) are in dispatch_queue.json and launch by themselves every 30 min. Collect each: read the diff, run its slate test and regression, render with `layout_snapshot.gd -- <dir> noguide` on the hidden desktop, OPEN the page.
  Cursor inverted a check to pass in LOOKSLATE1 (`>= 1080` for "fits the screen"): read every edge check in the new slate tests.
- QWEN (the animation item): BLOCKMEET1, measure only. The Moves preview's BLOCKED jab ends at the partner's chin, under the raised blocking glove (E:/FightCamp/tmp/s418_headaim/jab2.jpg; same with and without the aim). Believe the table only if CTRL_LANDED reads to_face under 0.05 and every row prints a gap of 0.80 to 1.10. Then decide BLOCKMEET2: raise the block to meet the punch, or aim the blocked punch at the blocking glove. Film it, judge, then him.

## Next for Claude, in order
1. Collect what landed (above).
2. LOOKSLATE7 is briefed and queued on Cursor after 6: the Fighters page's cream "Scouted for you" strip and the roster cards' paper feet (RosterCards.PAPER: his S410 pick, so show him a still before and after), the week review's white pad cards (FlipCard.gd), DarkOverview's flat red and dark buttons.
3. PR 140 REARHAND5B: film both right hooks on its branch, judge, do not loosen bars.
4. Playbook game plan (cream rows) and combination builder (cream cards), Fight night: a Ludo painted concept in the slate look first, his yes, then re-brief MENUPLAYBOOK2B and MENUFIGHT1B (held in dispatch_queue.json; base cursor/menuplaybook1, PR 105 stays open until it lands).
5. The critic's corner as a game screen: NOT built. Body map with where the hits landed, numbers, choices proposed from what happened; Ludo concept first; score the look first with hard fails. His marks: ops/Feedback/2026-11-09-05.
6. PR 77 ANIMREBUILD1 (agy design draft, docs/ANIM_REBUILD_DESIGN.md): unread since 11-07. Read it, take or close.

## Seen this session, not fixed
- 19_round1 still (E:/FightCamp/tmp/s418_screens): the first frame of round 1 shows the red boxer bent back through the ropes, alone in shot. It is the walk-in; the map has it as "Red's leg past the rope: refine". Film the first five seconds before anyone outside sees a fight.
- The Training week with a fight booked runs to y 1355 (1363 on the cream page): the camp chart pushes it past the first screen. A layout matter for the Training re-brief.
- WeekCards.gd is 552 lines and MovePlayer.gd 664: over the 500 rule, allowed by file_limits_test's list. Split when either is next touched.
- John's chat seat: gbot answers "A Sandbox session is not permitted on this endpoint" since 11-06. SQ29 (crossover) and SQ30 (knowing a fighter) wait. His account: tell him, do not chase.
- ZIVA still down: two seats ran Godot all session, so the start line's own condition (no other Godot job) was not met.

- THE MAP, redrawn S418 (4 created, 32 updated, ledger learned before and after, 139 ids). Stale cards left on it because nothing may be deleted until he answers Q-S294-163: DONE this session shows "Cage under repair, red floor less" and "REARHAND4: no better right hook" under the live cards; NOW shows "FIGHTERMODEL4E (Cursor)" and an empty "-" card. Two cards outside the ledger sit exactly on top of live NEXT cards with the same text (3458764689809187235 "Money: warm shell, small text", 3458764689809187237 "Playbook + Home round 2", each with a checkbox): `trim` will never remove those, delete them by id on his yes. The ledger also holds 8 old-format keys (wwa_card_...) whose ids are not on the board: that is why TRIM says 16 and only 8 are real.

## Waiting on him
Play the S418 build | Q-S294-163 may the map redraw delete its own spare cards | keep or cut Test day and dues bands | "yes, ARCHIVED" (finish moving, delete) | Builds holds about 700 MB of old folders he asked to remove.

## STILL OPEN from older handovers (details: grep ops/research/HANDOVERS_S349_S417.md)
- Nested cards put a frame inside a frame (Fights offers, Find a fighter): judge on his reaction.
- PRESENT1 leftovers that need a layout, so a mockup and his yes first: a Coach's suggestion on game plan lines, a weekly checklist, the Money split.
- GYMKIND1: +10% at most gives +0.5 to +1.2 points in three years: too small. kit_gain_on stays false; redesign before asking him.
- R28: eye damage critical 2% after round 3 of 3, 86% after round 5 of 6: fix on real rounds first. R25, R37, R55, R58 not started (the old TASK_R25/28/37/55/58.md are unrelated briefs: new names).
- Animation backlog: 47 boxing clips scored under 6 (CLIPRESCORE1); pro_right_hook's low hand is in every right hook we bought.
- Members fill three to a place: he may want the floor's tier idea in the places rule.
- Held worktrees: LEAN_FIGHTERMODEL4G (1 unpushed), LEAN_GYM3D2 (1 dirty), LEAN_MONEYOD2 (3 dirty). All three are superseded work; look, then retire.

## Traps
- A `cd` outside the repo in the Bash tool moves the session folder: absolute paths.
- Long shell heredocs fail, and a heredoc doubles backslashes: write scripts to the scratchpad and run them.
- Every Godot command goes through `python ops/Tools/godot_slot.py run --who claude -- ...`; the hidden-desktop pair runs from the PowerShell tool. PowerShell swallows the job's stdout there: have the tool write files, do not rely on printed lines.
- Hidden-desktop stills were full 1920x1080 this session. `--resolution 960x720` is ignored there: the window is 1920x1080 and a smaller control sits top left.
- Never `git diff --stat` without a path here: 150 lines of line-ending warnings. roadmap.json is CRLF in the working copy, indent 1, not ASCII-escaped, one trailing newline.
- A test's tail is Godot's leak warnings: grep the output for the verdict line and for SCRIPT ERROR.
- BodyCallouts.gd's `UI` is TV.gd, not UI.gd: no WoodKit calls there.
- seat_dispatch worktrees start from origin/main: push the brief and anything it names before launching.

E: 46 GB free (over the 85% rule).
SETTINGS: this session ran on Claude Fable 5 | critics sonnet | Cursor Grok 4.7 High until 12-07.
