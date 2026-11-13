# S450 handover (written 2026-11-13 ~13:10 at the end of S449; S448's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S450`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 300k context (S449 handed over at ~410k after two outages).
- At most TWO helper sessions.

## HIS WORDS IN S449 (verbatim)
- Camp v2 marks (Feedback 2026-11-13-06..11):
  - "who the fuck goes running inthe same wearing boxing gloves ? why you do not yes our game art style ?"
  - "3 legs wtf , draw less people maybe , use style-art"
  - "better art here ?"
  - "look way too similar to corner king"
  - "need higher art style fonts"

  Answered with camp v3: docs/mockups/s449/camp_v3/camp_plan_v3.png, review board 2026-11-13_1145.
- "there was an outage check everything and other sessions too", "also check for uncommitted work from other agents/bots". Checked: nothing lost. Side sessions were restarted after both outages. 10 dirty agent worktrees: all stale or already on main. 73 PR-less agent branches: every task id is named on main.
- His links (fightiqglobal plan from film, bjjsystems lapel flowchart, shutterstock): ops/research/LINKS_PLAN_TRAINING_S449.md.
- Gear idea: "add gear so that each fighter looks different have buffs ... want buy goals". Q-212 "Yes, map it after the fight week, real effects only". Row GEAR1; memory project_gear_real_effects_s449.
- Board answers:
  - Q-210 "Yes, that order": fight week + Find a fight, then the office computer, then coach depth, then the contract tab.
  - Q-211 "Yes, go ahead": the progression plan v4.1 is approved for building.
- Block reel (C347): "why there are no body reactions on the hits from the red fighter ?" Block stills marks (Feedback 2026-11-13-15):
  - "blue fighter doesntlook like a human"
  - "the arm looks shorter"
  - "90 degrees angle ? wtf is that move ?"
  - "colission!!"

  All of it went to Grok Dev as BLOCKLOOK3.

## RUNNING (collect first)
- **Qwen FIGHTWEEKPROBE1** (wt/LEAN_FIGHTWEEKPROBE1, brief ops/research/TASK_FIGHTWEEKPROBE1.md): the tank and flat-round-1 prices in wins. Its result sets the AMATEURWEEK1 numbers (target: best week vs laziest = 10-12 in 100).
- **Grok Dev BLOCKLOOK3** (branch grok/blocklook3, ops/research/TASK_BLOCKLOOK3.md):
  - the blocker absorbs the punch
  - no glove into glove (the cross: touch -0.026)
  - the puncher's arm matches the landed punch (reach 90%, elbow within 15 deg, chest within 10 deg)

  Collect by RESULT lines, then film `tools/fight3d_gallery.gd -- <out> only=block` through godot_slot + hidden_desktop. Put it on the review board.
- **Progression session** (local_b6266b3e, "Weekly progression plan"): asked to brief the first build wave from PROGRESSION_MAP_S448.md section 10: BODYFACTS1, MOVETREE1 (Goose), PROGPROBE1/HOLD1, and a FIRELEVEL3 check. Push its local commits after reading them.
- **Seat queue:** SQ57 John (camp costs, club matching at walking weight). SQ58 Kalli and SQ59 John score AMATEURWEEK1 map v3 (ops/research/AMATEURWEEK1_MAP_V3_S449.md).
  - Two at 7+: fix the defects they name, then his board with --attach.
  - Below 7: write v4.

## DECIDED IN S449 (do it)
- POWER1C, the uppercut: the POWER1B fix (10c41edc) does NOT hold on today's tree. BLOCKLOOK2 changed the seed 4242 bout, and its first lead uppercut reads 20.1 m/s after the freeze (bar 9.6). The uppercut session tried three reach-solve variants and none passed.
  - Decision: re-cut the uppercut's TAIL. A short upward follow-through, then back to guard, never lifting over her head. The glove is not pinned on the face.
  - Judge it on join_return (RETURN row), hit_carry's three rear-uppercut rows, and the seed 4242 film on 3+ seeds.
  - Brief it to a free seat (animation is delegated); the uppercut session's notes are in its transcript.
- OFFICE1: mockups A (full-screen desktop) and B (monitor on the desk) are on the board as Q-S294-213. Build after his pick: one Grok Dev task a screen.

## WAITING ON HIM (board)
- Q-213: office look A or B.
- His look at camp v3 and the block reel.
- Q-208's regroup default, if still open.
- From before: the voices, the PA mix and the S448 sounds by ear; the result tabs; the Ailive films.

## TRAPS (S449)
- `ask --attach` paths are relative to ops/: "../docs/...". `gbot.py send --file` takes research/<file>, not ops/research.
- live_runs.json `runs` is a dict keyed by id, not a list.
- Comparing an agent branch to main: compare blob ids (`git rev-parse branch:file` vs `main:file`). cmp on the working tree reads CRLF as a difference.
- Outages kill side sessions mid-turn with "API Error 403 Cloudflare". Their edits stay on disk uncommitted. Wake them with mcp send_message (SendMessage by name fails while they are idle).
- tools/fight3d_gallery.gd stages the two boxers closer than fight distance; say so beside any still from it.
- The Miro connector dropped in the second outage; the P0 redraw was not done this session.
