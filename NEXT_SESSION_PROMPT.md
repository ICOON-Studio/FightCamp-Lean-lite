# S493 handover (written 2026-11-15 at the end of S492)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S493`.

## FIRST - ANIMATION ITEM: BODYLOOK1 MOVED TO A FABLE SESSION (operator's click, end of S492)
Session "BODYLOOK1 on Fable: body seams, shoulders, walk" (local_43234449-27fa-4767-ae29-8f567b15015c, own worktree)
stops Ziva first, takes over its measurements, fixes, opens a PR with before/after stills. Collect from ITS PR (open every
still); Ziva's chat below is the older run it supersedes.

### Ziva (superseded by the Fable session)
Chat "BODYLOOK1 task in progress" at http://127.0.0.1:7012 (browser pane). Its first long message never reached the model;
a short nudge did and it found ops/research/TASK_BODYLOOK1.md itself. Branch ziva/bodylook1 in E:/FightCamp/wt/ZIVA_LEAN
(its old dirty project.godot is parked on local branch wip/ziva-s492). Read the chat, open EVERY before/after still
yourself (coach neck seam, shoulders, walk, see-through parts), collect by diff or re-task. If the editor is down, start
prints the relaunch line. A new Ziva chat: short first message with the brief's absolute path, details as a follow-up.

## WHAT S492 DID
- WHYGRADE1 closed: the test's good plan had lines with no WHEN, which since CARDFIX1 fire on every situation at their place
  (any-time tie up on a merely tiring opponent: 36% won vs 49% with no plan). The 6-line plan that says WHEN reads GOOD
  411 of 540 (was 278), bad plan 2. Probe: `tools/why_fires_probe.gd -- 1-1,step_back,pivot_out,tie_up:she_tired,...`.
- ROPESCONTRACT1 (Arena PR 317) collected: 5/5 mutants red.
- COACHSPEC1 round 3 written + probed (map s11, probe_coachspec_r3.py); critics SQ183 Kalli, SQ184 Maria queued.
- Digest: ops/research/S492_DIGEST.md.

## HIS BOARD ANSWERS (given 2026-11-15 19:00-19:17, after S492's start - quote them and act)
- Q-248 rival club card: "c but make it simpler to understand i think its to complecated" -> option C (3 answers: match,
  half, let go - this changes the R58 mechanic), and fewer things on the card. Redraw simpler, then build.
- Q-249 Training K v3: "Change first (say what)" -> he wants changes before the build: list what you would change (plain
  words, with the picture) and ask again.
- Q-250 season ladder: "Why do you make the ladder scripted, make it so player can deicde whos the best opponent for his
  fighter at any given time and apply rules" -> redesign: the player picks the opponent for the fighter at any time, the
  rules (rank gap, mandatory, eliminator) limit and reward the pick. LADDER1 back to design (critics 7+ before his board).
- Q-251 one palette: "i have no idea , do it and i will judge" -> do the sweep (19 gym colours, every screen, a test that
  blocks loose colours), then send him before/after stills.
- Model question in chat: whether Fable should take the animation from Ziva - see the S492 closing message / session card.

## THEN (roadmap now.next_action has the order)
1. The Miro question (may the P0 redraw delete its 16 empty surplus card slots? the svg is ready -
   `python ops/Tools/where_we_are.py svg` - one canvas_update_from_svg, then the LEARN / TRIM steps it prints).
2. Collect SQ183 + SQ184 (start prints SEAT ANSWERS): both depth 7+ -> his board with the map (`ask --attach`); else round 4.
3. ONELOOK1: Q-251 palette sweep if approved; remaining fight hovers on the house card; playbook step buttons; guide bubble.
4. Show the WHYGRADE1 lesson to the player: a line with no WHEN fires on everything at its place (PLANFLOW1 "uses" lines).
5. plan_bots red (NIGHTLY1): check whether its bot plans have the same any-time lines.
6. CLASH10 audit; FIGHTWEEK3 leftovers; Arena pure module (`python ops/Tools/lite_mirror.py --lean push` first).

## USAGE RULES (kept)
- get_usage first; wrap up from ~310k, hand over by 420k. Godot through `python ops/Tools/godot_slot.py run --who s493 --`.
  Write repo-root .tmp_s493_*.sh runners with the Write tool (rule_guard blocks a heredoc holding the Godot command); delete after.
- His game on the PC (ArcheAge ~8 GB) makes the watchdog RED on memory: Godot jobs wait in godot_slot.
- Probe/test output file names: no ":" (Windows streams).
- New tests go into tools/run_tests.sh's list.

## Known reds (NIGHTLY1): plan_bots, block_meet B_A pro_left_hook control row. fight_why fixed S492.
