# S419 handover (written 2026-11-10, S419 main session)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S420` and redraw the map.
Older handovers (S396 to S417): ops/research/HANDOVERS_S349_S417.md, grep by keyword. S418's is in git (219c37ef).
READ THE PULL'S OUTPUT: a file list after a session-start pull is the alarm. `start` printed only 5 of his 7 board marks: read ops/AgentComms/media_comments.json for `seen_by_claude: false` as well.

## FIRST: his answers on the board
- Q-S294-166: Training tab, approach B painted by Ludo. He said in chat "the B approach seems good , what do you think"; Claude agreed (B, plus approach A's peak-tiredness number on each evening option). On "Yes": brief Cursor from docs/mockups/s419/training_b.html (layout, real words) and training_b_painted_ludo.png (look); the emoji become KitIcon icons; type floor 20 px, at most 70 words (ops/research/TRAINING_TAB_BRIEF_S419.md). The current Training week page stays untouched until then.
- Q-S294-164 (pick of A/B/C) is answered by the above: mark it. Q-S294-165: At a glance panel, A ring diagram or B card (docs/mockups/s419/glance.png); build his pick in DarkOverview._glance, tooltips from the designer's list in the S419 digest.
- Q-S294-163 still open: may the map redraw delete its own spare cards.

## Late in S419: a run of his notes while playing (all in the second export unless said)
- "these humans look too big compared to everything else in the gym": GymFloorPeople FIG_FAR 0.12 / FIG_NEAR 0.16 (was 0.15 / 0.20); a cardio spot is on the belt (GymFloorSpots.ON_BELT). Still sent, no answer yet.
- "the guide says open people ... it has to be highlighted on the gym": GuideLines.place(c) names the step's gym place; that pin is ringed by the guide's light and turns red (GymHub.needs). NOT looked at on a still for the coach step.
- "the white in the picture doesn blend": the guide's bubble is slate with chalk words; the small tags (UI.chip) are see-through dark. The roster card feet and the "Scouted for you" strip are still cream: LOOKSLATE7, moved ahead of World on Cursor.
- "the slots are hidden when you try to upgrade": the Equip bar sits at the bottom of the picture. NOT looked at on a still.
- "explain what to do about the weight ?": the guide's fight-week line now says "<name> makes weight Friday, fights Saturday" or "<name> is over the limit. Set the diet to Cut." and rings the Fighters place when over.
- "how many tale of tape screens ... i saw at least 2" and "the offer screen can be uses also as a tale of the tape screen": there are four plus the offer. TAPEVERSUS1 (Cursor, RUNNING): one TapeRows rule, fight night drawn as the versus picture.
- "LUCY JACKSON AHEAD ... wtf is that": the round bar now reads "LUCY IS WINNING THIS ROUND" / "THIS ROUND: EVEN".
- Hologram "head 4 / liver 1 ... do we only have 2 hit points": tags now read "4 hits to the head". The honest answer: the fight tracks SIX places (head, two eyes, nose, left ribs, right ribs) and the hologram groups them into three. No jaw, temple, solar plexus or stomach. A design question for him, not asked on the board yet.
- "the fighters are sliding a lot in the fight": FIGHTSLIDE1 (Qwen, RUNNING, measure only): metres slid per round, by cause.
- "the people screen look very poorly ... populated with 10 coaches": docs/mockups/s419/people_a.png (coverage board) and people_b.png (staff wall), Q-S294-167.
- Training B: three critics in. ops/research/TRAINING_B_DECISION_S419.md section 3 is the decision. NEXT: one consolidated drawing of it, Ludo's paint, his yes, the Cursor brief. Q-S294-166 was asked on the earlier drawing.
- BLOCKMEET2 (PR 154) and LOOKSLATE5 (PR 153) have LANDED and are NOT collected.

## Built S419, exported, HE HAS NOT PLAYED IT
- LOOKSLATE2, 3, 4 (Cursor, PRs 150 to 152) merged: Club People, Fight camp, the bout offer, New game, the interview on slate. Fixed at collect: the bout offer's corner notes (VersusPanel._tag), the camp's small titles (Camp.gd KICKER) and the dial needles (GaugeRow.Dial._ink) were dark on dark.
- Overview: "Wants the fight: keeps it long, steady pace" is "In the ring: Stays at range, steady pace" (Attrs.wants_words).
- BLOCKMEET1 (Qwen, PR 148) merged: probe re-run here, CTRL_LANDED 0.001 to 0.021 m. Fight path: 11 of 12 blocked rows not between, glove 0.11 to 0.19 m under the face, the block starts at 0.8 of the contact time.
- ANIMREBUILD1 (agy, PR 77) taken as docs/ANIM_REBUILD_DESIGN.md with a note on its stale parts (steps 1, 2, the clip counts).
- seat_dispatch MAX_PC_AGENTS 2 -> 3 (his word). Ludo CLI 0.2.6, skill `ludo` installed (free offline toolbox).

## Running
- QWEN BLOCKMEET2 (the animation item): the block set 0.25 s early, the blocked head punch carried onto the blocking glove. Collect: read every comparison in tests/block_meet_test.gd, re-run it, then film a blocked jab (tools/head_aim_film.gd) and a fight.
- AGY LEGTREMBLE1: his "the legs treble ... in a lot of clips" on the board's animation page. Ruler controls first (a smooth sine reads 0, a 10 Hz wobble reads about 20), three-arm census, fix where it lives. Claude's quick census: 45 of 153 clips shake with no fight layers on (E:/FightCamp/tmp/s419_tremble). After the merge re-render the board films (153 date from 11-02) and look.
- CURSOR LOOKSLATE5 (Money); 6 (World) and 7 (roster strip, review cards, Overview buttons) launch by themselves.
- The animation page shows 1 of 169 clips because of its own rule (his OK or 9/10). He read that as "only 1 animation": consider showing all with their state.

## Seen, not fixed
- Luke Reid's portrait on Club People reads near black (mh_boxer_07 on a black ground, 160 x 210): a lighter ground behind portraits there, or a proper coach portrait.
- A bare "roster places" icon at the right end of the staff strip, no number beside it.
- The bout offer's left corner note sits over the boxer's boot.
- PR 140 REARHAND5B not judged (see Traps). PR 105 MENUPLAYBOOK1 still open.
- Main CI: no finished run since e4a7b6f3 (red). Read the run on the wrap-up push; head_aim_test stays off the list until its join check reads speed.
- The 19_round1 walk-in through the ropes; WeekCards.gd 552 and MovePlayer.gd 664 lines; John's chat seat refused; ZIVA down.
- THE MAP: stale cards as described in S418's handover (git 219c37ef) until Q-S294-163 is answered.

## Waiting on him
Q-166, Q-165, Q-163 | play the S419 build | keep or cut Test day and dues bands | "yes, ARCHIVED" | about 700 MB of old Builds folders.

## STILL OPEN from older handovers (details: grep ops/research/HANDOVERS_S349_S417.md)
- Nested cards put a frame inside a frame (Fights offers, Find a fighter): judge on his reaction.
- PRESENT1 leftovers that need a layout, so a mockup and his yes first: a Coach's suggestion on game plan lines, a weekly checklist, the Money split.
- GYMKIND1: +10% at most gives +0.5 to +1.2 points in three years: too small. kit_gain_on stays false; redesign before asking him.
- R28: eye damage critical 2% after round 3 of 3, 86% after round 5 of 6: fix on real rounds first. R25, R37, R55, R58 not started (the old TASK_R25/28/37/55/58.md are unrelated briefs: new names).
- Animation backlog: 47 boxing clips scored under 6 (CLIPRESCORE1); pro_right_hook's low hand is in every right hook we bought.
- Members fill three to a place: he may want the floor's tier idea in the places rule.
- Held worktrees: LEAN_FIGHTERMODEL4G (1 unpushed), LEAN_GYM3D2 (1 dirty), LEAN_MONEYOD2 (3 dirty). All three are superseded work; look, then retire.

## Traps
- tools/head_aim_film.gd with move=rear_hook printed no CONTACT line (S419): check MoveTip.info's name for the rear hook before filming PR 140.
- seat_dispatch `films <task>` only films when the brief has a FILM: line or a tools/ probe as RED_TEST.
- agent_comms `ask --attach` needs absolute paths; `--attach` repeats per file.
- Each push to main cancels the last CI run: push once, at the end.
- A `cd` outside the repo in the Bash tool moves the session folder: absolute paths.
- Long shell heredocs fail, and a heredoc doubles backslashes: write scripts to the scratchpad and run them.
- Every Godot command goes through `python ops/Tools/godot_slot.py run --who claude -- ...`; the hidden-desktop pair runs from the PowerShell tool. PowerShell swallows the job's stdout there: have the tool write files, do not rely on printed lines.
- Hidden-desktop stills were full 1920x1080 this session. `--resolution 960x720` is ignored there: the window is 1920x1080 and a smaller control sits top left.
- Never `git diff --stat` without a path here: 150 lines of line-ending warnings. roadmap.json is CRLF in the working copy, indent 1, not ASCII-escaped, one trailing newline.
- A test's tail is Godot's leak warnings: grep the output for the verdict line and for SCRIPT ERROR.
- BodyCallouts.gd's `UI` is TV.gd, not UI.gd: no WoodKit calls there.
- seat_dispatch worktrees start from origin/main: push the brief and anything it names before launching.

E: 44 GB free (over the 85% rule).
SETTINGS: this session ran on Claude Fable 5 (weekly all-models use was at 82% on 11-10, resets 11-12) | critics sonnet | Cursor Grok 4.7 High until 12-07.
