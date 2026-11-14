# S470 handover (written 2026-11-14 at the end of S469; S468's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S470`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context; wrap-up from ~395k (S469 wrapped at ~375k). At most TWO helpers at once.
- Never idle while a test or agent runs: run_in_background and do the next item (the Stop hook blocks an idle turn).
- Godot jobs (tests, films, export) go through `python ops/Tools/godot_slot.py run --who s470 -- <cmd>`.
- A job on the hidden desktop prints NOTHING unless `tools/hidden_desktop.py run --log=<file>` is given.
- Never `cd` into an agent worktree in the main shell; read it by absolute path.
- Bash heredocs with apostrophes break under the command hook: write files with the Write tool.

## HIS WORDS THIS SESSION (quote them)
- "make amber for disk at 20gb left red at 10gb" -> done (pc_watchdog E: gate in GB; C: keeps 15 / 6 GB).
- "what do you think of these ideas for structuring fight plan ? also this : <Submission Saga on Steam>" with seven
  generated pictures: an if-then flowchart plan (a main line of steps, IF diamonds on the opponent's reaction, a Plan B
  reset), one plan per opponent type with presets + Simulate, a live fight screen where the triggered branch lights up
  with a commentary line, the same for BJJ, a weekly camp schedule, a profile + equipment page.
  MY ANSWER (given in chat; his decision is OPEN - ask again if he has not answered): take the flowchart as the LOOK of
  the plan we already have (PlanBoard: a card = a step, an arrow with `when` = a diamond; triggers = the opponent habits
  film study found, not single punches, because the fight is settled per 30-second exchange), cap 3-4 steps + 3 if-thens
  + one Plan B, and light the branch up in the fight when it fires. Not taken from the pictures: live sliders (his own
  S442 rule is two bars), % gear buffs (his Q-212 rule), names in commentary lines (his S448 rule), the 2D radar.
  Before any menu work the plan must matter more (S468: a plan change is worth 9 -> 11 of 40 bouts) - his S459 rule.
  Roadmap row PLANFLOW1. If he says yes: design map -> design loop (two critics 6+/6+) -> his board.
- Submission Saga (Steam 4690760, solo dev, EUR 6.99, released 2026-09-17, 38 reviews all positive): a one-fighter
  pixel RPG, simultaneous turns scored by real BJJ points, 19 positions, 90+ moves, 8 stats, 5 belts, a submission
  timing gauge. Useful for our BJJ fighter: the size of the position map and points-per-position scoring. Not a rival
  (no gym management). If he installs it, read its numbers with REA (his rule) before designing our BJJ match.

- LATER THE SAME SESSION: "go with your recommendation" -> PLANFLOW1 is ON. Kalli's map v1 is queued (SQ117,
  ops/research/DESIGN_PLANFLOW1_V1_WRITE_KALLI.md); then design_loop.py critic with two fresh critics (6+/6+), then his board.
  He then pasted a list of deepening ideas ("What do you thinkof these ?"): my verdict is in that brief (TAKE state,
  clock and score triggers, bait / conditioning, plan size from Knowledge, composure greying the plan out, 2 corner shouts
  a round, one change between rounds; CHANGE feints to habits and signature chains to named-not-buffed; LEAVE OUT
  hybrids and a countdown). He has not answered the verdict yet: quote his answer when it comes and fold it into the brief.
- "thats 13/24 wtf ?" (memory): the full account was 5.3 GB Claude, 4.7 GB Chrome, 2.3 GB compression, about 5 GB in
  ~410 small programs, about 6.3 GB Windows itself (paged pool 10 GB reserved, 4.6 GB in RAM after 2.3 days up - high;
  not traced to a driver). Always give the whole account, never the top few.
- GUARDKNEE3 (Qwen) launched after LIVERPROBE1 landed.

- MEMORY TRACE (his "doi t"): `powershell -File ops/Tools/pool_tags.ps1` lists Windows kernel memory by owner tag (read-only).
  Result: tag Toke = 2,051,822 live security tokens = 4.26 GB, with their parts (SeAt 0.75, SeTd 0.25, SeTl 0.25, SeDt 0.2,
  ReTa 0.13 GB) about 5.8 GB of the 6.3 GB. NOT handles (all processes hold 262k handles): a kernel-side reference leak.
  The program behind it is NOT found. Ruled out by test (each run many times, token count before/after): starting cmd,
  python, PowerShell; WMI queries; Get-Counter; LibreHardwareMonitor sensors; 3,000 file writes on E:; git status; 300 board
  requests; pc_watchdog -Once; new hidden consoles (conhost rises then falls back within 30 s). Now it grows ~0.5 a second;
  the average since boot is ~10 a second, so it leaks during something not running at the test: suspects not yet tested =
  Godot runs on the hidden desktop (CreateDesktop), the heat governor's suspend/resume, agent seat runs, Chrome/Claude
  sandboxed child processes, the 05:00 full test run, Windows build 26300 (26H2 Insider) itself. DONE (his "Yes, log it"): the metrics sampler appends one line a minute to ops/AgentComms/token_log.csv (time, tokens, delta, counts of godot / conhost / powershell / python / node / chrome / claude / git / qwen / cmd). At the next start: read it, find the minutes with a big delta, name what ran then, and remove the block from pc_metrics.ps1 once named. WAS: log the Toke count
  once a minute from the metrics sampler beside what is running, read the jumps the next day. A restart clears it.
- "Build the flowchart plan in three steps, simplest first? : ok" -> three build steps (look + habits + fired branch; plan
  size + state and clock triggers; bait + composure). It is in Kalli's brief.

## WHAT S469 DID (docs/CLASH2_RESULT.md, section "S469", is the whole story)
- Played-fight ruler `tools/hit_gap_probe.gd` (hidden desktop, 150 s, 33 landed): shown more than 15 cm off the target
  21 % -> 15 %, middle punch 6.1 -> 2.1 cm, worst 0.69 -> 0.19 m, body hooks 3 of 10 far -> 0.
  Cause: inside punches (ShortPunch) started 0.06 s before the hit. `BeatFire.SHORT_WIND_S` 0.16 (`-- shortwind=0.08` old).
- `ReachLimit.carry_base` takes the reach weight (`-- noweightbase` old): block_meet 6 -> 3 the same day.
  The planned test change (hold the clip's start, then seek) was NOT made: it reads worse, the drive is paced.
- Film seed 4242 for his C391: docs/mockups/s469/match_jab_cross_seed4242.png (0.3-1.6 cm off the face at the hit).
- Clinch: `Clinch.HANDS_M` 0.85 / `HANDS_S` 0.3 (`-- farhands` old): the hands go for the tie only within an arm and
  with nobody in a hit reaction. The second cross's 18 clipped frames -> 2. clinch_check 5/6 with both rules.
  `tools/layer_trace.gd` (new): names every layer that moves the hands after ArmClash; the film prints it per red frame.
- GUARDKNEE2 (Qwen): first bad commit 79665239 (the footwork rig's hip offset). Fix NOT merged, PR 275 closed.
  ops/research/TASK_GUARDKNEE3.md queued for Qwen (rig kept on, knee pole from the clip).
- LIVERPROBE1 (Qwen) launched 14:11; its branch qwen/liverprobe1 has commit 194a8c05 (fold tuned to 6.0 / 1.00,
  share 0.160). Not collected.

## FIRST
1. His answer on the flowchart fight plan (above).
2. Collect LIVERPROBE1 -> LiverFold.shot_points / fold_scale.
3. Collect GUARDKNEE3 when it lands (guard still on the game camera before merge).
4. Lead hooks land ~0.15 m LOW in the played fight (3 of 9, inside and pocket, full reach weight); a cross from a
   1.15 m pelvis gap stops 0.17 m short (ReachLimit CORR_M 0.30 cap or the range): hit_gap_probe is the ruler.
5. punch_speed_test: 41 failures with the old rules, 48 with the new the same day; rows flip between runs. Find out
   whether carry_base-by-weight adds POP rows (run each arm twice). punch_range_test has an old script error at line 366.
6. LIVERRIBS1 step 4: the corner retiring a cracked boxer + the 3-choice crack card (design s4.1).
7. Clash leftovers: jab 2 of the film (glove x forearm, 5 frames, 0.055 m), a boxer's own two gloves.
8. Seat answers SQ109/111/113 (Dola), SQ115/116 (Kalli) -> ops/research/DESIGN_LOOP_S459.md.

## NOTES
- Regression the same day: hit_carry 36 (38 before), hit_frame 11, block_set 0, sound_sync 0, short_punch 0, clinch tests green.
- Clinch.gd is at 496 lines, PunchReach.gd 498: the next change there splits the file first.
- 16 worktrees are HELD by `start` (dirty, nothing unpushed) - old seat runs.
