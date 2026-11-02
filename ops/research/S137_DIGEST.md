# S137 digest - cloud work verified, arenas by level, the wiring audit, the loop wave started (Claude, PC, 2026-10-01)

Request: "git pull && start, check the work done from the cloud the last 24 hours if everything is ok, summary". Then the
operator's rulings (verbatim, in order):
- "We need a couple of different arenas ... regional fights ... national fights ... international fights. So build as many
  as possible depending on the championship."
- "Do not build another exe unless everything we've built so far is all gated to the gym, fight and the fight engine. Do a
  thorough check what other mechanics are built and are not gated the game"
- "go ahead, wire everything with all the agents i want everything to be intergraded at AAA game level ... prioritize game
  loop to be fun and addictive not boring everything needs to have a meaning and reward the player for progressing and
  try to get the feeling of just one more turn"
- "another art direction is use icons when its possible to skip text (with the necessary toolltip of course)"
- "use grokbots mostly for visual refining our rooms and the arena, for research use dola"; "use codex for animation with
  cascadeur" -> "cascadeur for those two moves, go ahead then proceed according to roadmap"; "use astra model for 3d, luna
  for other things"; "you can use all agents that are green on opsboard".

## 1. Cloud work (S134b-S136) verified on the PC
Parse 31/0 on every touched .gd; focused 33 tests 1 red = asset_manifest (S132 office props unclaimed) - fixed 44491124;
fight_strike_whole passes on Windows (cloud red was environment). .exe built (BUILD OK, pck 426 MB) and walked IN THE EXE
83 steps / 0 failures / 0 SCRIPT ERROR at db8d8693 (stills docs/previews/s137_exe_walk/) - before the no-exe ruling.
S136's cross fix confirmed on stills (six-punch 4.3 s: upright, was head at the chest).

## 2. What now works (each with evidence)
| What | Evidence | Commit |
|---|---|---|
| The room no longer folds the cross 22 -> 44 deg: `stop_contact_torso` lean capped (CONTACT_TORSO_MAX_DEG 35 -> 5; the fold bought 7 cm) | s134_pose_probe off=contact_stop isolates it; seed 94301 extremes 4 -> 0, 92012 0 -> 0; room tests 9/10 (fight_body_overlap = nightly red) | ffc10c4c |
| VENUE LADDER: booked bouts fight in the venue of their level - regional R1/R2, national R3/R4, international (title / abroad) R5/R6; FightNightScreen passed no venue before (grey void) | venue_ladder_test 28/0; renders of all six docs/previews/s137_venues/ | 6f067f37 |
| Ring dressing: corner pads red/blue/neutral, hairline, skirt, benches, steps (spec-driven) | arena tests 7/0 | 7847e6ae |
| FIGHT GATE (Grok G153): one checklist at offer/book/fight week/weigh-in/fight night | fight_gate_test 0 fails, 23 related tests; amateur_circuit fixture fixed (old book_fight booked an injured man) | 5afbdd52, 8d1d5a67 |
| Fight pays out: settlement carries record/rank before-after/points; result screen icon tiles with tooltips | fight_result_rewards_test 18/0, result tests 12/0 | 65a72d78 |
| Fight effects (Qwen Q222) + 3 merge fixes: particles had NO MESH (invisible), sweat on blocked shots, bone name; bell pulse every round | fight_vfx_test 25/0 (draw checks fail on the unfixed builder); probe: bell f1 + f7202, 20 effects / 250 s | 3b855616, e3e41783 |
| Menu + room effects (Cursor U204): screen fade/slide, hover, money count-up, dust + light shaft in 7 rooms | 13/0 after money_display declared a kit helper; HANDOFF edit dropped | 78080a91 |
| Wiring census tool | `python Tools/wiring_census.py`: 29 of 283 scripts unreachable | ffc10c4c |

## 3. The audit and the plan
- `S137_WIRING_AUDIT.md`: unreachable player features (HUD, honours/medals/tenure, portraits, 44 GameState actions with no
  button incl. short notice / promotion bouts / signing / sponsorship offers / media / weight-cut plan / cancel booking),
  fight data the engine ignores (personality, rivalry heat, 47 technique effects, training strands, speed), switches off by
  failed gates (stay off), dev tools. Correction: ScorecardPanel is SUPERSEDED (the result screen draws the cards itself).
- `S137_LOOP_PLAN.md`: wave L (week in review, offer desk, fight payoff, matchup), wave E (identity, strands, effects,
  speed, feints), clarity (D66 top 10), look (venues, rooms, scorebug). No exe until L + E are wired.
- Research collected: D67 bout rules (Dola, sourced), M38 arena concept (Maria: green ring, club hall), K82 floor+lobby
  (Kalli). C229 Codex Cascadeur: shovel + inside uppercut REJECTED (evidence merged f72ad148; finding: the single-strike
  graft has no Cascy map) -> C231.

## 4. Rules this stage earned
- A CPUParticles3D with no `mesh` draws nothing - a test that counts particles passes on an invisible effect; check `mesh`.
- From a SceneTree `_initialize`, `get_nodes_in_group` reads 0 and global positions read 0 - search the shell instead.
- Capture tools run as `--script`: room switches are OFF unless `as_game` is passed - an agent's "no effect visible" still
  may be the switch, not the effect.
- `grokbots read --to "John Research"` opens the first plain-labelled thread (archived); a `--new` chat is titled with the
  task's first line - click that row and dump `document.body.innerText`.
- Codex's first C229 run hung on every shell call (transient); a probe `echo` through the same launcher tells sandbox from task.
- `start /low` from Git Bash is "Access is denied" - launch through Tools\agent_window.ps1 (Idle, hidden), `.ps1` launchers
  (grok_task.ps1) run directly, not through agent_window's cmd.
- Heredocs with backslashes get mangled by the shell hook - write scripts with the Write tool.

## 5. In flight at the end (collect next session; all Idle priority)
Codex C230 (identity in fight, luna, wt/C230), Codex C231 (Cascy strike graft + inside uppercut, astra, wt/C231 - needs
the Cascadeur script server: `python Tools/cascadeur/ensure_server.py`), Grok G154 (offer desk, wt/G154), Cursor U205 (week
in review, wt/U205), Qwen Q223 (honours, wt/Q223). Bots: Maria M39 (chat '# TASK M39'), Kalli K83 (scorebug), John J58
(plain 'John Research' thread, behind J56/J57), Dola D68 (one more turn). C232 NOT launched (stopped for PC lag; worktree
D:/FightCamp/wt/C232 may be half-made - `git worktree remove --force D:/FightCamp/wt/C232` then relaunch). Queued briefs:
C232 walkout in venue, C233 K82 build, G155 camp consequences, U206 finance, Q224 fatigue/body.

## 6. Next (the decision)
Collect + verify + merge the five shell runs (stills opened, tests on master, diffs only); feed each agent its queued brief
(G155, U206, Q224, C232, C233); collect the bot replies and brief their builds; then wave E's remaining rows. Re-run the
wiring census + audit; only then the .exe.
