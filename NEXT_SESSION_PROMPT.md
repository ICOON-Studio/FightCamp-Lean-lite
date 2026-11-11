# S433 handover: the core loop reviewed by critics, six maps at 7+, the integration map decides the build (written 2026-11-11, end of S432)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start` (~14 s, ~160 lines since S432),
then `python ops/Tools/where_we_are.py roll S433` and redraw the Miro map (recipe: ops/Tools/where_we_are_svg.py docstring).

## USAGE FIRST
`get_usage` before anything. Late S432: weekly all models ~40 %, Fable 68 % (resets Thu 2026-11-12 16:00), extra usage
EUR 37.92 of 40. Measured in S432: Opus 5.5 workflows are cheap against the all-models bucket (about 12 critic/design
workflows, ~15M agent tokens, moved it ~35 % -> ~40 %); Fable workflows burn Fable fast (S431: 24 % -> 60 % in an hour).
His question "opus 5.5/high/ultracode or fable 5.2 medium?": answered Opus high + ultracode until the reset; after it, Fable
medium for hard single-thread work, workflows still checked against usage.

## HIS WORDS IN S432 (all acted on)
- "make other active sessions to report here" -> done; HUMANFIGHT1 and S431 reported (nothing unpushed).
- "check if you can trim the session start" -> done, 33466aa0 (~50 s -> ~14 s).
- Q-184 "i want v3 reviewed by critics . see if we can deepen and stregthnen and add if required any new mechanics , before we
  start building we need to decide if we done with the mechancis for this version" -> map v3 critics 7/6 -> v4 7/7 -> v4.1.
- "i want a bit more rpg elements with coach and fighters" / "yes add the rpg layer after the review" -> RPG layer, passed.
- "is there a hype mechanic for the fighter ? if not can you add a deep one" + "maybe do a research ... how hype builds around
  a fight and a fighter , what role the coach can play" -> research + hype map, passed.
- "how deep are the training mechanics ? have critics rated them ?" -> never rated before; 5/5 as built; training map.
- "do the same for the most important aspects of the game that affect the loop like building the fighter and the coach,
  playbook , training and how these 2 impact fight , need reviewed them all and properly strenghen and add mechanics"
  -> playbook and from-build-to-fight tracks, then the INTEGRATION pass.
- Q-185 board answer "this looks nice i do not understand theoptions you are giving me though" -> read as painting 1 for both
  pages (explained in chat). Decided: the two pages are built AFTER the integration map says what each page shows (once).
- "show me the integration results when ready and prepare handoff".

## 0. THE DESIGN STATE (all in ops/research, all critics' reviews and 10/10 drawings in docs/mockups/s432/critics)
| Map | File | As built | Final |
|---|---|---|---|
| Club week | CLUBWEEK_MAP_V41_S432.md (+ VERDICT.md: mechanics complete for the week) | - | v3 7/6 -> v4 7/7, v4.1 = the judge's 10 changes |
| RPG layer (coach + fighters) | RPG_LAYER_MAP_S432.md | - | 6/6.5 -> 6.5/7 -> 7/7 |
| Hype | HYPE_MAP_S432.md (research HYPE_RESEARCH_S432.md, notes in hype_notes/) | none existed | 7/7 |
| Playbook | PLAYBOOK_MAP_S432.md | 6/5 | 7/7 |
| From build to fight | FIGHT_LINK_MAP_S432.md | 5.5/6 | 7/6.5 -> 7/7 |
| Training | TRAINING_MAP_S432.md (v5) | 5/5 | 7/6 -> 7/6.5 -> 6.5/6.5 -> 6.5/7: NOT passed, v6 next |
INTEGRATION: CORE_LOOP_MAP_S432.md - see section 0b (filled at the end of S432 when it lands).

## 0b. INTEGRATION RESULT (ops/research/CORE_LOOP_MAP_S432.md, picture docs/mockups/s432/core_loop.png)
- MECHANICS COMPLETE: five tracks closed (club week, RPG layer, hype, playbook, build to fight: two fresh 7s each, with the
  integration decisions written in). TRAINING is the one short track (v5: 6.5 and 7). FIRST WORK OF S433: training v6 with
  exactly the five changes in CORE_LOOP section 4 (Hard buys real fitness, at least 1.6x Normal; fresher than tiredness 50
  counts; Stamina a smooth number, not a cliff at 64; the professional's camp = blocks of the same load control, no second
  free Hard button (BoutRules.PROTOCOLS); a career arc: ceilings move after named events, build direction on Training), two
  fresh critics, 7+ rule. Only the Training tab and its modules wait on it.
- 30+ conflicts settled with one decision each (section 2): loyalty the only bond; THE TANK = energy at the first bell (LEGS
  stays Speed/Footwork/Flexibility, as on the approved pages); CARDIO the group, Stamina the ability; one Tank scale; fight-week
  shape = the load (Easy / Sharpen / Normal); one pace control (Hype's Entertain/Safe cut); one scoring rule; one towel; ...
- Code holes found (all foundation fixes, section 5 step 0): tank 0 on every no-camp bout; our punches start at 0; stop_mult
  only on side b and puncher_chance never reads it; FighterGoal's trust_delta read by nothing; energy reads the old Cardio
  average; Knowledge.range_of called by nothing; rest drains Stamina; ceilings never reach the gain; hours ignore effort.
- BUILD ORDER (section 5): STEP 0 twelve foundation fixes F1-F12 (each with its seat), STEP 1 the probes on the played bout
  (cloud; LEVERS1 with THE TARGET first; cut under 1.5 in 100), STEP 2 the rule modules by group, STEP 3 the screens (the
  Fighters page and the Profile to painting 1 FIRST - their exact contents are section 3), STEP 4 one golden-path season test.
  Steps 0-2 can start now.
- Three questions put on the board (none blocks): Q-186 the pro keeps the day job to the top 10?; Q-187 feather and middle
  pro tables?; Q-188 Ana's mat plan this version or next?

## 1. ALSO LANDED IN S432 (main, pushed)
- HUMANFIGHT1 collected; THE STEPPING ROUTE IS THE DEFAULT (his Q-183; captured takes opt-in `-- rokoko`). PRs 163, 168 closed.
- TRAININGB2 (Training tab readable, Start week back on screen), AIMWIRE1 (rib calls reach the fight, liver side first),
  CAMLINE2 round 1 (camera never long behind a boxer; round 2 WIP on claude/camline2 with two debug scripts: never collect
  them), DUESSUMS2 (0 of 972: a full small club ignores reputation; DUESSUMS3 with a waiting list running on Qwen).
- Ludo painted the matched look (docs/mockups/s432/ludo; painting 1 is the pick). Exported Builds/ at 13:14 (exe smoke clean).

## 2. RUNNING
- HUMANFIGHT2 on Cursor (ops/research/TASK_HUMANFIGHT2.md: pops, reach per punch, one-frame contact, posture; ruler first).
  The round after it (HUMANFIGHT3): taller stance (knee 125 -> 145-160 deg), rear-heel pivot, the knee jerks.
- DUESSUMS3 and CORNERFACE1 on Qwen. SQ41 John (how big fight games animate).

## 3. NEXT, IN ORDER
1. Training v6 (the five changes) + two fresh critics. Workflow on Opus is fine (cheap against all-models).
2. STEP 0 foundation fixes: brief F1 REST1, F2a CEIL14, F6 STANDDOWN1, F10 KNOWN0 to Qwen; Claude takes F3 CARDIO1, F5 NOCAMP1+TANK1,
   F7 PUNCHSTART1, F8 STOPMULT1, F12 CORNER17 (each red on main first, one file per task, 500-line rule).
3. STEP 3 screens 1 and 2 to Cursor (Fighters page, then Profile, painting 1, contents = CORE_LOOP section 3) after KNOWN0.
4. Put the build order on the board (roadmap plan.next) and the Miro P0 map; collect HUMANFIGHT2, DUESSUMS3, CORNERFACE1.

## Traps (S432)
- Export: Godot crashed on exit AFTER writing; smoke-run the exe by its full path through godot_slot.
- A Godot command in a shell heredoc is blocked by rule_guard: write the runner with the Write tool.
- `agent_comms.py ask --attach` wants an absolute path. There is no `answer` command: edit questions.json.
- Seats drop the brief's own red checks (DUESSUMS2) or skip a measurement (AIMWIRE1): read the brief's checks against the test.
- A workflow call in the same message as another call can be refused by the auto-mode check: send it alone.
- Miro: 14 leftover slots under the P0 frame; deleting needs his yes (not asked again yet).
- `cd` in a Bash call moves the working directory: start each command with `cd /e/FightCamp/Lean`.

SETTINGS: S432 ran on Opus 5.5 (high, ultracode on). Next: Opus 5.5 high until Thursday 16:00, then Fable 5.2 medium; Fast off.
