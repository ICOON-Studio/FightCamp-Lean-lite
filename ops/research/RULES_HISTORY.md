# RULES HISTORY - the full CLAUDE.md as it stood before the S127 rewrite (2026-09-29)

Operator working brief, 2026-09-29 (S126/S127), verbatim: "SHRINK THE RULES, KEEP THE GATES. Rewrite CLAUDE.md as one page
(under 150 lines): the objective, settled decisions, safety rules (PC watchdog, two agents max, idle priority, no identical
fighters, legal fighters, commit rules), session start/end. Move every incident story and every retired/superseded rule to
research/RULES_HISTORY.md." and "No gate script is weakened."

Everything below is the pre-rewrite CLAUDE.md, unedited: the incident stories that earned each rule, the retired and
superseded rules, and the operator's verbatim words. It is the RECORD, not the working rules - CLAUDE.md is. Where the two
disagree, CLAUDE.md wins. `Tools/decision_ledger.py` still harvests operator quotes from this file.

---

# FightCamp: rules for Claude sessions (read first; keep this file short)

Godot 4.7.2 GDScript game in `Godot/`; this folder is the repo root. Sync by
reading `CURRENT_STATUS.md` once, then `HANDOFF.md` once. Never read
`HANDOFF_ARCHIVE.md` end to end.

## THE OBJECTIVE - FINISH THE AGREED RELEASE (operator, 2026-09-28, S115; `start` prints it first)

*"Your objective is to finish the agreed FightCamp release. At every session start, read the project objective, settled
decisions, and current assigned task. Resume from the recorded next action. Do not create a new roadmap or reopen accepted
decisions without new evidence. If a change would alter agreed scope or invalidate completed work, explain the evidence and
obtain approval before making that change. Continue routine implementation and fixes autonomously. Judge progress by
verified playable milestones. Before ending, record the working commit, evidence, remaining work, and exact next action in
the existing handoff system."* Lives in `roadmap.json` `objective`; the next action is `now.next_action`.

## THREE RULINGS ON CONFLICTS (operator, 2026-09-28, S115) - these SUPERSEDE the older lines they name
- **Milestone wins over "every agent holds a task".** An agent holds a task only if it advances the ACTIVE milestone;
  otherwise it stays idle and its work waits in `queue.backlog`. RETIRES the 2026-09-22 "every agent must hold a task at
  handover" rule and the "board is a quota" lines below.
- **A defect you notice, you fix NOW** ("when you notice something you have to act on it", 2026-09-27) - even off-milestone.
  The backlog is for features, cleanup, speculative infrastructure and redesign, never for a defect you have seen.
- **Carry on from the recorded next action; ask only on scope.** Stop for approval only when a change would alter scope,
  engine, architecture or visual direction, or invalidate finished work. RETIRES "before a NEW stage give a short summary
  plus 2-3 options and wait for the go-ahead".
- **The release is the WHOLE GAME** (product sheet: Steam EA $19.99, v1 stand-up, MMA as the first update, 1.0 $24.99),
  never the demo; the demo is milestone M5.

## THE SIX CONTROLS (operator, 2026-09-28, S115) - checked by `Tools/check_workflow.py`; `start` prints, `ship` refuses
1 release definition + milestones (`roadmap.json` `release`); 2 settled decisions with reason + reopen evidence
(`DECISION_LEDGER.md` SETTLED table - engine/architecture/visual/scope changes need the operator); 3 ONE active milestone,
every queued task names how it advances it, the rest is `queue.backlog`; 4 resume point in `now` (last_working_commit,
verified_playable, incomplete_blocked, next_action, next_acceptance, awaiting_operator); 5 a milestone is DONE only with
player-flow evidence on disk - a test, render tool or isolated demo is not "integrated"; 6 merge a branch only after
`python Tools/check_workflow.py branch <branch> <task>` passes (owned files).

## A PLAYABLE DEMO BY 2026-10-04 - CLAUDE IS THE LEAD DEVELOPER AND OWNS THIS DATE (operator, 2026-09-27)

The operator's words: *"you are the lead project developer ? you have 7 days to bring the game a playable demo , do you
understand this [will] be remember[ed] after 100 sessions ?"* `agent_comms.py start` prints the DEADLINE block first, with
the days left and the day-by-day road (`roadmap.json` `deadline`). **Every session works that road and ends with a
playable build the operator can open** (`python Tools/build_playable.py`, the career loop walked in the .exe). Nothing
off the road - new research, room art, new features - until the demo ships. Two more S114 gates exist because the
record was ignored: **PRIOR-RESEARCH** (read `research/topics/<topic>.md` first) and **DROPPED-ROUTE** (a task
marked parked/stopped needs a RESUMED or STOPPED decision in `AgentComms/route_decisions.json`; the colour-suit route was
dropped by Claude in S75 with no decision). Ignored rulings: `research/DECISION_LEDGER.md` - read its IGNORED table.

## NO .EXE AND NO PREVIEW VIDEO UNTIL THE BOXING CLIPS ARE DONE AND SMOOTH (operator 2026-09-27; NARROWED to boxing 2026-09-28: "narrow the no exe rule to boxing")

The operator: *"do not produce exe or clips until all boxing and kickboxing animation clips are completed and checked they
work smooth and perfect."* This OVERRIDES "every session ends with a playable build" above. `TASK_C223` is the gate: every
BOXING move (36) plays its OWN clip that passed the smoothness gate on both rigs (narrowed 2026-09-28: kickboxing no
longer holds the .exe). Until then: no
`build_playable.py`, no video sent to the operator (internal stills for Claude's check are fine).

## PRIMARY SOURCE BEFORE ACTION - NEVER ACT ON A SUMMARY (operator, 2026-09-27, S114)

The operator: *"we have already done these steps and produced clips that fixed the grip ... why we are moving backwards?"*
and *"why didn't you catch that earlier?"*. S114 re-routed C221/C222 and retired the C199 branch on a memory note ("the suit
route ... failed") and a digest's FIRST LINE ("NOT PROVEN - stopped at row 2"), while the same digest's body said the Blender
method WORKED and a finished closed guard was waiting to be bound. Summaries - memory notes, topic pages, a digest's headline,
a triage verdict, a roster note - are POINTERS, never evidence. **Before you write a task, stop or retire a route, merge or
discard a branch, or tell the operator what exists: open the primary source and read the WHOLE relevant section** (the digest
body, the delivered files, the branch diff, the live tool state). Say which source you read. If a summary and its source
disagree, the source wins and the summary is fixed in the same session. Gate: a brief's `## Prior research` must name at least
one primary study - topic pages alone do not pass.

## THE QUEUE IS STATED AT BOTH ENDS OF EVERY SESSION (operator rule 2026-09-27, S114)

The operator's words: *"on the session end list me the queued tasks and what everything does and on the new session i
want you to state those tasks at the start so i can verify integrity"*. The queue lives in `roadmap.json` `queue.tasks`
(id, owner, state, what it does) and `start` prints it. **The session's FIRST message states that list to the operator
before any work. The session's LAST message lists it (as it now stands) ABOVE the git handover block.** This amends the
"block only" ruling below: the handover message is the queue list, then the one `bash` block. Keep the queue current on
every assignment, landing, merge and state change.

## THE HANDOVER PROMPT IS ONE BLOCK, OR ONE FILE (operator rule 2026-09-11)

**NARROWED 2026-09-13: give the operator ONLY the git command** - one `bash` block,
`git pull && python Tools/agent_comms.py start` from the repo root. Everything else
lives in `AgentComms/roadmap.json`, which `start` prints and the ops board shows.
So keep the roadmap's `now`/`handover` complete; do not send a long prompt file.

**The prompt Claude hands over for the next session is delivered exactly ONE of
two ways: a single copy/paste fenced block, or a file sent with `SendUserFile`.**
The operator's words: *"it either a copy/paste block or a download file"*. Both
is fine. Neither is not.

**EVERYTHING the next session needs goes inside the block (or the file), and
NOTHING required goes outside it.** A `bash` fence followed by prose paragraphs
is the defect: it cannot be taken in one action, so half of it is lost.

**Self-check before ending a session: if the operator took ONLY the block, would
the next session have everything?** If no, it is not finished.

**THE GO AND THE PROMPT ARRIVE IN THE SAME MESSAGE (operator rule 2026-09-15:
*"Always deliver next sessions prompt when I can clear"*).** Telling the operator
they can clear, and giving them the block, are ONE action - never two messages
and never two turns. A "you can clear now" without the block makes them come back
and ask for it; a block handed over while the session still owes work invites a
clear that loses it.

So the block is emitted at exactly one moment: when the stage is genuinely
finished - commit pushed, suite run and its real number in the digest, roadmap
`now`/`handover` current, `ps -eo args | grep -c '[s]leep'` reading zero. Before
that, say what is still owed and DO NOT send the block. At that moment, send the
GO and the block together. If the operator asks for the prompt earlier, give it
with a plain sentence naming what is still outstanding.

**THIS IS NOT THE AGENT START PROMPT AND MUST NOT BE CONFUSED WITH IT.** The
Codex/Cursor/Qwen START PROMPT below keeps its own two-part shape (a `bash` fence,
then a blockquote) - that rule is for ASSIGNING AN AGENT. Generalising it onto the
session handover is exactly how this was got wrong for ten sessions running: it
was the only codified paste-prompt template, and it says "two blocks".

**BLOCK ONLY, NOTHING ELSE (operator ruling 2026-09-26, S89: "1, block only").** The
handover message is `git pull && python Tools/agent_comms.py start` in one `bash` block -
no `#` comment lines inside it, no report before or after it. The stage report lives in
the digest; runs in flight live in `roster.json` notes and roadmap `now`, which `start`
prints. This SUPERSEDES the old "commentary after the block is welcome" line, which is
how S80-S89 drifted into a block plus a page of prose.

## CHECK THE PC BEFORE ANY HEAVY JOB - RED MEANS DO NOT START (operator, 2026-09-26)

The operator's words: *"i do not want this to happen ever again"*, *"you need to give me warnings everytime the computer is
low on memory or cpu usage or temp etc"*, *"if have to close tabs let me know"*. S92 lagged the PC: C: was full (3.7 GB
free) while a 2.4 GB download, a whole-disk `du` scan and Defender ran together. **Before any heavy job** - a Godot suite
or subset, a model install, a big download, an agent launch, a disk scan - run
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`; exit 1 (RED) means do not start it -
tell the operator what is RED and what to close. Never scan a whole drive (`du` over AppData); size named folders only.
Drives: C: NVMe (Windows - keep free), E: SATA SSD, D: old 1.5 TB HDD. Operator: *"try to use d when ssd and old hdd
dont matter"* - downloads, caches, archives, installers -> D:; hot data where speed matters -> E:; nothing new on C:. The logon task "FightCamp PC Watchdog" warns the operator by pop-up every
minute it sees trouble (C: space, memory, CPU, temperature where exposed); its last reading is `AgentComms/pc_health.txt`.

## AT MOST TWO AGENTS RUN AT ONCE, ALL AT IDLE PRIORITY (operator, 2026-09-25)

The operator's words: *"the pc is always at 87% cpu capacity we need to slow i want to
be able [to do] other things too"*, *"do not use too many agents at the same time"*, and
*"i cant buy new pc"*. So **no more than TWO shell agents (Codex/Cursor/Qwen) running
at once, and no daytime test run of mine alongside two of them** - count the live runs
`start` prints before launching. "Every agent holds a task" still stands: a held task
waits its turn, it does not run in parallel. Browser agents (Grok, Dola, grokbots) cost
this PC nothing and are not counted. `run_tests.py` and `Tools/agent_window.ps1` now
start everything at IDLE priority; never remove that.

## A NEW SESSION OWNS EVERY AGENT RUN IN FLIGHT (operator, 2026-09-25)

**The operator opens NEW sessions rather than clearing, so agents the last session
launched are still running when the next one starts.** The operator's words: *"you
should handle new sessions properly ... if you leave agents running"*. S76 opened,
called Q175 and C202 "stopped" from a process scan that missed them, and asked the old
session what it held. `start` now prints **AGENT RUNS IN FLIGHT - THEY ARE YOURS NOW**
from worktree write times, not process names. Believe it: do not relaunch, do not ask
the old session, collect when they land. **At handover, name every run still in flight
in `roster.json`'s note and roadmap `now`** (agent, task, worktree, merge bar) - NOT in the
handover block, which is the git command only (2026-09-26).

## MORE THAN ONE STAGE PER SESSION IS ALLOWED WHEN SAFE AND EFFICIENT (operator, 2026-09-26)

**The operator's words: *"from now you can move past 1 task each session if you think it's safe and efficient"*.**
This RELAXES the 2026-09-19 rule below; the gate stays as a checkpoint BETWEEN stages. Each stage still ships whole:
digest committed, roadmap `now` rewritten for the next stage, memory updated, `agent_comms.py ship`. Then
`python Tools/agent_comms.py start` again mints a fresh id and opens the next stage - no override needed. Carry on
only when the next `now` is already decided, nothing is half-collected, and the context is still lean; otherwise hand
over. Never use `FIGHTCAMP_STAGE_GATE=off` to skip the ship step.

## ONE SESSION, ONE STAGE - NOW A HARD GATE (operator, 2026-09-19)

**`python Tools/agent_comms.py ship` when your digest is committed. After that
the parse gate and the suite REFUSE further build work in this session.**

This was prose from 2026-09-03 and it did not hold: on 2026-09-19 one session
shipped FIVE stages and fifteen commits, and the operator's verdict was that it
was obstructing the project. Reviewing that session, **every rule broken was one
with no mechanical gate behind it** - unsigned commits, handover notes written
to a key `start` never prints, a JSON list appended to as a string, a decision
filed as a question. **Not one gated rule was broken**: the parse gate ran every
time, the suite ran, the one regression it caught was fixed rather than shipped
around. So the unenforced rules become gates.

- `agent_comms.py start` mints a session id (`AgentComms/.session`, untracked).
- `agent_comms.py ship` records it as shipped (`AgentComms/.shipped`).
- `check_scripts.py` and `run_tests.py` refuse when the CURRENT id has shipped.

**A fresh session on the same day is NOT blocked** - that is the whole reason
the gate keys on a minted id rather than a date, and it is tested in both
directions.

**The override is `FIGHTCAMP_STAGE_GATE=off`, and it prints when used.** It is
for work that is genuinely part of the stage you already shipped - a red test
you caused, a review reply. **A new stage is a new session: tell the operator to
clear.** Do not use the override to carry on building, and do not weaken the
gate to make a session pass.

## EACH SESSION IS CONNECTED TO THE LAST (operator rule 2026-09-19, no exceptions)

**The operator's words: *"This should never happen again I expect each session
to be connected."*** They cleared, ran the handover command, and the new session
opened by asking which option to build. **The handover caused that, not the
session** - the previous session had filed a stage choice under
`blocked_on_operator` and opened `now` with "THE OPERATOR HAS NOT PICKED THIS",
and `start` renders that section as "WAITING ON THE OPERATOR". A recommendation
had already been given in chat before the clear, so the question was never open.

**TWO DUTIES, AND THEY ARE DIFFERENT.**

**READING a handover:** `now` is what you build. Build it. If `now` is unclear,
ambiguous or reads like a question, **take the most likely reading, say in one
line which you took and why, and get on with it.** `start` will shout
`HANDOVER DEFECT` at you when it detects this - that warning means BUILD ANYWAY
and then fix `now`, never stop and ask. Nothing in `blocked_on_operator` gates
`now`; those are raised ALONGSIDE the work, never before it.

**WRITING a handover:** you are the lead developer, so decide. `now` carries a
DECISION, and any alternative is named as a fallback ("if X proves impossible,
do Y"), never as a menu. **`blocked_on_operator` is ONLY for what the operator
alone can supply** - their eye on a recording, credits, a file that exists only
on their machine, a product ruling nobody can derive. If you could decide it,
deciding it is the job.

**This was a written rule before it was a check and it was routed around
anyway** (the 2026-09-12 rule already said "DO NOT ASK THE OPERATOR WHAT TO
WORK ON"), so `agent_comms.py start` now enforces both halves in the renderer.
Do not weaken those checks to make a handover pass.

## EVERY BRIEF ASKS "WHAT WOULD A HUMAN DO?" (operator rule 2026-09-25, a gate)

**The operator's words: *"in all researches i want this questioned and answered : what a human would do ?"*** Every
task file and research brief carries a `## What would a human do?` section: how the real professional (animator,
promoter, matchmaker, coach, fighter) actually does this job, answered BEFORE a method is chosen. Earned by the
colour-suit route, which copied one piece of studio mocap and skipped calibration, calibrated views, joint markers
and the body-model solve. `agent_comms.py start` prints `RESEARCH DEFECT` for any S73+ brief without it.

## CHECK FOR PREFABS BEFORE BUILDING ANYTHING NEW (operator rule 2026-09-27, a gate)

**The operator's words: *"when we decide to add somehting new always check for prefabs etc"*.** Before a new system,
asset or tool is built, search for a ready-made one: Godot Asset Library, GitHub, itch.io, Fab, Mixamo, datasets, and
Unity/Unreal stores for the idea. Name its licence and why it is used or not. Earned in S101: an active ragdoll was
about to be built from scratch when Kickback (MIT, Godot 4.7, Euphoria-like) turned up. Every task file and brief from
S101 on carries a `## Prefab check` section ("None: this fixes our own engine" is valid; empty is not);
`agent_comms.py start` prints `PREFAB DEFECT` for any that lacks it.

## RESEARCH IS THE PROJECT'S MEMORY - SEARCH IT BEFORE ASSIGNING ANY (operator 2026-09-27, S114, a gate)

**The operator's words: *"do you understand the role of research? it is not done just for 1 session and forget
everything about it"*, *"i am sure this research has been done at least 3 times already"*, *"this is violation of the
rules"*.** Research is paid for once and read forever; a study nobody reads again is money burned twice. S114 sent G145
(takedowns) to Grok unsearched when J20/J33/G141/G143/G138 held it, and Q209 nearly built a second ground machine beside
`GroundGraph.gd` (S57/S58). Before ANY task file or brief: `python Tools/prior_research.py <terms>`, read the hits, and
ask only for what they do not answer. Every brief from S114 on carries `## Prior research` naming the studies (the gate
checks each file EXISTS) or `searched: <terms>`; `agent_comms.py start` prints `PRIOR-RESEARCH DEFECT` otherwise.

## EVERY SESSION STARTS HERE (operator rule 2026-09-10; no exceptions)

1. **`python Tools/agent_comms.py start`. ONE COMMAND, AND IT IS THE WHOLE
   ORIENTATION** (operator rule 2026-09-12): what to do now and its gate,
   what is genuinely waiting on the operator, live triage, every agent with
   its rotation state and how to drive it, the fixed settings, the traps, and
   what has ALREADY BEEN DECIDED and must not be re-asked. It derives all of
   it from `AgentComms/roadmap.json`, `roster.json` and the live board, so it
   cannot go stale the way a pasted summary does.
   **After running it you know exactly what to do. DO NOT ASK THE OPERATOR
   WHAT TO WORK ON** - `now` says it, and `blocked_on_operator` is the only
   thing that is theirs to answer. Then the status/handoff read above.
   The written rule exists because on 2026-09-12 a session read the ops board
   at `127.0.0.1:8787` and still opened with "where do you want me?". The
   board renders the roadmap for the OPERATOR'S PHONE and does not render the
   `handover` block at all - which is the half a session needs.
2. **CHECK AND EXECUTE QWEN'S AND GROK'S OPEN TASKS, IN THIS CONSOLE, WITHOUT
   HUMAN INPUT.** `python Tools/agent_comms.py board` says what they hold.
   Qwen is its CLI in this checkout (`--yolo`, never `auto` - auto leaves it
   with no shell tool at all); Grok is the in-app browser
   (`mcp__Claude_Browser__*`). Drive each to DELIVERY - a pushed commit you
   verified, not a summary it wrote. Neither is listed by `ListAgents`, and an
   empty listing is not evidence they are unreachable.
3. Only then start your own stage.

**Not optional, and not conditional on what this session was opened to do.** It
also belongs in every post-`/clear` prompt Claude hands over: a prompt without
it has put the operator back in the relay seat, which is what the 2026-09-09
direct-reach ruling exists to stop. **[RETIRED 2026-09-28 - milestone wins, see THREE RULINGS]** EVERY AGENT MUST HOLD A TASK AT HANDOVER
(operator rule 2026-09-22: *"In the new session all agents need to have tasks"*),
which RE-REVERSES the 2026-09-21 "an idle agent is not a failure" ruling after it
stood one day. Assigning them is THIS session's job, done before the block goes
out. The quality bar survives - a real slice, never manufactured spec. THE
ROSTER IS THE OPS BOARD, all nine; the "four" and the `roster.json` PARKED flags
below are both stale.

@RTK.md

## Agent Comms

**"Task" is always a `research/TASK_<id>.md`**, never a chat or a
session in any client's task list. `python Tools/agent_comms.py tasks` is the
one answer to "check for tasks"; `tasks --write` regenerates root `TASKS.md`,
which is what an agent with no shell reads. Claude regenerates it on every
assignment and every completion (2026-09-06, after an assistant answered
"check for tasks" with its own chat list).

After the status/handoff read, run `python Tools/agent_comms.py inbox --agent claude`.
`AgentComms/README.md` defines the conflict-free mailbox. **It carries Claude,
Codex, Cursor, Qwen and John only** (scoped 2026-09-07: Grok, Kalli and Maria
run off the GitHub API with no Windows shell and cannot run the script, so 25
messages sat unread. Cursor joined 2026-09-07 and DOES have a shell: it is a
full citizen like Codex, identity `cursor`. **Qwen was restored to full
citizenship 2026-09-08** once its CLI authenticated: identity `qwen`, a real
shell in this checkout, its own `QWEN.md` context file, and the same start
prompt as Codex and Cursor - it is no longer a paste-only relay and no longer
limited to pure modules). They are reached through root `TASKS.md` plus their own task file - and
for Grok, the `## GROK START HERE` block. Sending FROM them still works: that is
Claude relaying their report.
Claims, assignments and durable conclusions remain in `HANDOFF.md`.
On any "status" / "what next" question, also run
`python Tools/agent_comms.py board` (one status table) instead of
hand-parsing HANDOFF.md; use `brief --agent <x>` to paste an agent's open
task, `block`/`unblock` to record a blocker that survives `/clear`, and
`done --task <id>` to gate a task's own files before calling it COMPLETE.

## Credit rules (user decision 2026-09-03: minimise consumption)

- Bash for reads and edits: `grep -n`, `sed -n A,Bp`, heredocs, small Python
  patch scripts. Read only the lines you need. `GameState.gd` is ~8k lines:
  never read it whole. Do not re-read a file you already hold anchors for.
- If `rtk --version` works on this Windows user, prefix repetitive diagnostic
  shell (`git status`, `git diff`, `git log`, `grep`) per `RTK.md`. Raw
  commands when RTK is missing, on parse-gate errors, or on destructive git.
- Parse gate BEFORE any test run:
  `python Godot/tools/check_scripts.py <touched .gd files>`
  (about one second per file; fails on syntax, Variant-inference and
  redeclaration errors; the autoload-identifier compile errors it sees are
  expected and filtered; runtime errors still need the tests). A parse
  error that reaches a headless test HANGS it until the timeout instead of
  failing.
- **Tests are TIERED by what a task actually touches (operator rule
  2026-09-10: agents were spending most of their wall clock on the suite,
  Qwen worst).** The suite is 304 tests (COUNTED 2026-09-17, S6; it was
  written here as 220 and had been 303 for weeks - the count is READ off a
  run, never remembered), each a fresh Godot boot, and a run costs about
  twenty minutes; the cost is the boot, not the work. So:
  - **Research task, no `.gd` touched** - NO gate at all. Not the parse gate,
    not a test. `git status -s` before staging is the whole check.
  - **A NEW test file only, no script edited** - parse gate plus that ONE
    test. **A new test file cannot break another test**, so a full suite run
    there buys nothing and costs twenty minutes. This covers every blind
    contract test.
  - **A script edited** - parse gate, the focused test, then the tests of the
    systems it touches via `run_tests.py --only <substring>`. Name the subset
    in the task file so the agent does not have to guess it.
  - **THE FULL SUITE RUNS ONCE A DAY, AT NIGHT - NEVER IN A SESSION (operator rule 2026-09-25:
    *"can we run the full suite only 1 time per day when i am asleep ?"*).** Windows task "FightCamp Nightly
    Suite" runs `Tools/nightly_suite.ps1` at 05:00 - it warns, the operator may postpone 20 min, skipped if he is still on the PC at 06:00 - then `nightly_suite.cmd` (`--jobs 2`; a daytime `--jobs 4` with agents running took
    the CPU to 90 C). Read `AgentComms/nightly/latest.txt` for the real number and cite it (date + HEAD) in the
    digest; a session runs only the subsets its change touches. The old "full suite once at integration"
    line below is SUPERSEDED.
  - **The FULL suite is CLAUDE's, once, at integration.** It is the
    integration gate, not every agent's private one, and running it four
    times over one day's work also produced the false all-failed results that
    concurrent Godot causes. An agent is given a suite ceiling only when its
    change genuinely reaches across the tree.
  Give the tier in the task file explicitly; an agent that is not told a tier
  will run everything.
- No screenshots or browser work in build sessions; research gets its own
  session.
- One session per stage. The moment a stage ships (commit pushed, digest
  written), end the session with the report and start a fresh one; never
  compact or continue into the next stage. A fresh turn carries ~55k tokens;
  409k of history produced 383M cached reads on 2026-09-04.
- At every `/clear`, before the next task starts, recommend three settings -
  model, effort and Fast mode - for this session and for every task assigned
  to Codex, Grok or Kalli (user rule 2026-09-05). All three are fixed at
  assignment and no agent self-escalates, so match them to the work -
  mechanical passes (config, git chores, mirroring a known pattern) to a
  cheaper model and lower effort, new systems and `GameState.gd` to Opus at
  high effort.
- **Status on request** (user rule 2026-09-05): when a session opens with
  "status", "what next" or anything like it, read the queue before
  answering - the `## Active claims` slice of `HANDOFF.md` plus
  `git log --oneline -5` - and report what is scheduled, who owns it, and
  what blocks what. Then repeat the three settings for EVERY agent that
  currently holds an open task file, not only for this session. The user
  reads that answer to decide what to start and how to configure it.
- No separate "record the commit hash" commit: cite the hash in the next
  HANDOFF digest. Digests stay short.
- No subagents unless the user asks.
- **Every Codex or Cursor assignment ends with the copy-paste START PROMPT** (user rule
  2026-09-07). The operator is the one who pastes it, so an assignment that
  stops at "the task file is pushed" is unfinished. Two blocks: a `bash` fence
  with `git fetch origin && git rebase origin/master && cat
  research/TASK_<id>.md`, then a blockquote saying - you own `<id>`, the
  task file is self-contained; do NOT read
  `HANDOFF.md`, `CURRENT_STATUS.md` or `HANDOFF_ARCHIVE.md` (logs, not research), and do
  not explore to "get oriented" - but **ALL RESEARCH IS OPEN TO EVERY AGENT** (operator
  2026-09-25: *"full access to all researches for everyone"*): point them at root
  `RESEARCH_INDEX.md` and let them open any study or digest it lists that bears on the task; **name the big owned file, its real line count
  and its anchors** ("`GameState.gd` is 12,938 lines - never open it whole; read
  `sed -n 'A,Bp'` windows at `:x`, `:y`") and say which owned files are small
  enough to read whole; parse gate before any test, focused tests first, full
  suite once in the background before the commit; commit, push, write the
  digest, send one line with `agent_comms.py send`, do NOT edit `HANDOFF.md`.
  Close with the one trap specific to that task. **Qwen takes the same form**
  (restored 2026-09-08), launched with
  `qwen --approval-mode default` from the repo root. Grok, Kalli, Maria and
  John have no shell and take no mail - they get the `TASKS.md` + task-file
  form, never a git/agent_comms prompt.
- **A SHELL-LESS agent's module and its test are TWO tasks, never one**
  (user decision 2026-09-08; rescoped 2026-09-08 when Qwen got a shell). It
  was written for Qwen, whose Q2/Q3/Q4 each asked for a module plus its test
  and three times sent the module alone. **Qwen is out of this class now** and
  takes ordinary build tasks, module and test together, because it can run the
  test. The rule still governs Grok, Kalli and Maria: ONE FILE, DO NOT SEND A
  TEST, and the test is its own `TASK_<id>T.md` written from the SAME contract
  rather than from the delivered code - a test written against an
  implementation only agrees with it. Keep that split even where an agent
  could do both: it is the stronger arrangement, not a workaround. The two run
  in parallel; the test task never waits for the module. Because an unseen
  test will call it, the module task's API section is labelled a contract:
  exact names, argument order, strings and separators.
- **Never gate a task on an EXACT failure count** (lesson 2026-09-08).
  TASK_C43F said "the suite must end at exactly one failure" and "if it is
  not fails=1 do not push". Codex fixed the pre-existing failure too, landed
  fails=0, and was forbidden by its own task file from pushing the better
  result. Write gates as a CEILING - "fails=1 or better; if lower, say so and
  push" - so over-delivery is never trapped.
- **Grok and Qwen are reached DIRECTLY, inside the app** (operator rule
  2026-09-09). Qwen through its CLI in this checkout; **Grok through the
  in-app browser** (`mcp__Claude_Browser__*`). Assign them in-session rather
  than ending at "the task file is pushed" and waiting for the operator to
  relay. This supersedes the `SendUserFile` rule below **for Grok only**. It
  changes DELIVERY, not capability: Grok still has no checkout and no Godot,
  so its work stays pure modules with zero preloads, it is never handed a repo
  test command, and its module and test remain two tasks from one contract.
  `ListAgents` does not list either of them - an empty listing is not evidence
  they are unreachable.
- **Every OTHER shell-less assignment is delivered as the file itself**
  (operator rule 2026-09-08; rescoped 2026-09-09 to exclude Grok). Kalli,
  Maria and John have no
  checkout, and the operator will not go dig a path out of the repo: end the
  assignment by calling `SendUserFile` on `research/TASK_<id>.md`, plus a
  short paste-ready cover prompt in the reply naming EVERY file they must send
  back. No git command, no `agent_comms.py`, no repo test command. **Qwen is
  no longer in this group** - it has the checkout and gets the start prompt.
- Task files: every assignment (mine or another agent's) is a
  self-contained `research/TASK_<id>.md` - the spec, the owned
  files, `file:line` anchors, the parse gate and the one test command.
  It also carries a `Model:` line (lean mode, 2026-09-05): the tier is
  decided once at assignment, an agent never self-escalates.
  Read your task file and only the files it names. Never read
  `HANDOFF.md` whole; take the slice
  `sed -n '/^## Active claims/,/^## Direction notes/p' HANDOFF.md`.
- Write ONLY your own block in `HANDOFF.md` (append, or convert IN
  PROGRESS to COMPLETE; max 8 lines). Never rewrite, reformat or
  compress another agent's block - emitting a file costs more in output
  tokens than reading it costs in input, and a concurrent rewrite eats
  someone's live claim. **Sweep at each day's start with
  `python Tools/agent_comms.py sweep`** (`--dry-run` first if unsure): it moves
  every finished `### ` block into `HANDOFF_ARCHIVE.md` and never touches the
  prose above the first `### `, so standing rules, token rulings and operator
  decisions stay put. This was a manual rule with no tool behind it until
  2026-09-07; it stopped on 09-04 and the "cheap" Active-claims slice grew to
  2,324 lines - about 38k tokens every session, for every agent.

## A CLOUD CONTAINER ONLY RUNS WHILE A COMMAND IS IN FLIGHT (operator, 2026-09-15)

A backgrounded Godot run makes **no progress between tool calls** - the VM is
frozen. So a long test or sweep needs a command actively waiting on it, and that
is where an hour of this session went.

**ONE blocking `until` loop per thing you are waiting for, and never a second
one on the same file.** Stacking waiters does not make the work finish sooner;
it makes eighteen shells that spin forever, fire a notification each, and keep
the container busy after the work is done. The operator saw "background tests
still running" long after the suite had finished - those were the waiters, not
the tests.

**A waiter outlives its condition.** Delete the log a loop is grepping and it
waits for a file that will never exist again. Before removing any scratch file,
kill the loop watching it; before ending a session, `ps -eo args | grep -c
'[s]leep'` must read zero.

**And a variable does not survive a newline in this harness's Bash**: `S=/path
&& nohup ... > $S/a.log &` works on line one, and the same `$S` on line two is
EMPTY - the file lands at `/a.log`. Three sweep logs went to the filesystem root
before anyone noticed. Absolute paths in every redirect.

## Test commands (exe in `%LOCALAPPDATA%\Programs\Godot\`)

- One test: `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/<name>.gd`
- **ANY WINDOWED Godot run (renders, captures, probes) goes through
  `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <godot args>`**
  (operator 2026-09-23: "the windows the agents open ... run silently in the background").
  `--position -3000,-3000` NEVER hid anything: Godot clamps it back onto a monitor. Put this
  line in every task file that renders.
- Full suite: `python Godot/tools/run_tests.py` (from the repo root, any shell).
  `--verbose` for a line per test, `--compare` to also print what the old
  exit-code-only gate would have said, `--reclassify` to re-judge the last
  run's captured logs without paying for the run again, `--only <substring>`
  for a subset. Prints `SUITE total=N fails=M`; exit 1 if anything failed.
- **The exit code alone is NOT a pass** (R75, 2026-09-09). A GDScript runtime
  error leaves rc=0, so a test whose module was clobbered prints twenty
  `SCRIPT ERROR` lines, then prints `0 failure(s)` - the counter it reports
  was never reached - and exits 0. The old `for f in tests/*.gd` loop called
  that green. Do not reintroduce it.
- The runner fails a test on any of: a real script error, its own `FAIL` /
  `failures=N` line while exiting 0, no output of its own, or rc != 0.
  Godot's `N RID allocations ... were leaked at exit` and `N resources still
  in use at exit` are teardown chatter on any run that touches a scene, not
  failures, and are filtered - do not "fix" the gate by grepping for ERROR.
- Every file in `Godot/tests/` must pass; `smoke_test.gd` is the real gate.
  rc=124 means a hang: suspect a parse error in a script the test loads.

## GDScript gotchas that cost a fix cycle every stage

- `var x := <call>` fails when the call returns Variant (`.size()` or
  `.get()` on an untyped value, a static on a `load()`ed script): write the
  type, `var n: int = ...`.
- `%` inside a format string must be `%%`.
- Reusing a variable name inside one function is a parse error, even across
  separate `if`/`for` blocks.
- UI rebuilds: `remove_child(node)` before `queue_free()`, or new nodes get
  renamed.
- Scene scripts compiled before the autoloads (`AthleteProfileScreen.gd` and
  friends): use `get_node_or_null("/root/GameState")` plus `has_method`,
  never the bare `GameState` identifier. Never add a top-level `preload` of
  such a script to `smoke_test.gd`; `load()` it inside `_initialize()`.
- A helper defined in a module is called through it
  (`FightContract._money(...)`); a screen has no copy of it.
- A `Label` outside a Container does not autowrap reliably; break lines
  with `\n`.
- A Control with full-rect anchors must never have `size` assigned when it
  is mounted: with anchors at 0..1 that writes the OFFSETS and the node ends
  up twice the parent (R31). Let the anchors fill it and pass the size down.
- Same family: a `TextureRect` keeps the TEXTURE's size as its minimum until
  `expand_mode` is set, so set `expand_mode` (and `stretch_mode`) BEFORE
  `texture`/`size` or the size you assign is clamped straight back up (R31).
- Weekly pass helpers (`_advance_*`) take an `overrides` dict so tests are
  deterministic. News headlines `push_front`: tests search the first N.

## Commit rules

- Stage explicit paths only (`git add -- <files>`); never `audio_exports/`.
  Check `git status -s` first: another agent's WIP may be pre-staged.
- **Never a bare `git stash` / `reset --hard` / `checkout .` / `clean`** in this
  shared checkout (2026-09-07: a concurrent session's `git stash` + `pull
  --rebase` wiped an entire finished-but-uncommitted stage off disk). Scope it
  to your own paths and commit before rebasing. Recovery is `git stash list` /
  `git reflog` - check both before reporting work as lost.
- Commit messages end with `Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>`.
- Push `master` on every completed task. Mirror every new project fact from
  chat into `HANDOFF.md` so Codex and Grok see it.

## NEVER TEST IDENTICAL FIGHTERS (operator rule 2026-09-12, no exceptions)

**"You can never put to test identical fighters. We are trying to simulate
reality and that's not real."**

This binds EVERY measurement, tool, fixture and test in the project - mine and
every agent's. Two fighters built from the same numbers are not a control group,
they are an unreal population, and what they measure is the fixture rather than
the engine.

**It has cost this project four times already.** R132 reported 12% draws and 3%
submissions as engine defects; both were artefacts of two identical generic
fighters and were RETRACTED in R133, which measured a grappler against a striker
and got 25% submissions and zero draws. A "varied fighters" mode used
`((idx * 37 + k * 53) % 37)` - and `idx * 37 % 37` IS ALWAYS ZERO - so five
different matchups printed byte-identical rows. And Q67's kick funnel labelled
its two men "kicker" and "boxer" while giving them the same stat block, the
same palette and different reach.

**IDENTICAL IS NOT ONLY THE STAT BLOCK.** A fixture is unreal if the two men
share any of:
- the same `stats` values (or an empty `stats` block - check the KEY NAME:
  `"attributes"` silently yields empty stats, three separate times now),
- the same known techniques - a boxer with no `technique_progress` record is
  handed his RULESET's whole tier 1-2 palette (`FightMoves.gd:191`), so a
  "boxer" in a kickboxing bout knows every kick unless you say otherwise,
- the same physical frame, the same discipline, the same plan.

**A measurement must NAME its population in its own output**, so a later reader
can tell a finding from a fixture. And per R137: a fixture is not only the
fighters, it is the fighters AND the data they fight under - name the catalogue
too.

The one legitimate use of a same-seed rerun is the DETERMINISM tripwire (the
same seed twice must be byte-identical). That is not a population measurement
and never produces a finding about the engine's behaviour.

## A FIGHTER MUST BE LEGAL FOR THE RULESET HE IS IN (operator rule 2026-09-12)

**"The fighter you put in the fight must be in accordance to fight rules."**

A boxer does not appear in a kickboxing bout. A man who cannot kick is not
matched under rules that permit kicking. Booking already enforces weight class
and sex; this is the same principle applied to DISCIPLINE, and it binds every
fixture as hard as it binds the game.

**THIS IS THE SECOND HALF OF THE IDENTICAL-FIGHTERS RULE AND IT BITES THE OBVIOUS
FIX.** Q67's funnel put a "boxer" in a kickboxing bout; he had no
`technique_progress` record, so he was silently handed the whole kickboxing
palette and knew every kick - two kickboxers with different reach. The obvious
repair, giving him a BOXING-ONLY progress record, produced a man who genuinely
could not kick - and that is not a legal kickboxing matchup either. It halved
the kicks thrown (540 -> 245) and dropped the pooled leg share to 1.64%. **A
second unreal fixture, not a better one.**

**So differentiate fighters by STYLE AND ATTRIBUTES INSIDE the ruleset, never by
removing techniques the ruleset legally permits.** A kickboxing bout is an
outside kicker against a pressure puncher - both able to kick, weighted
differently. An MMA bout is a grappler against a striker, both able to do
everything. That is what R133 did when it replaced the retracted R132 findings,
and it is why its numbers landed on J20's anchors.

The anchors themselves assume this: J20's 14-18% leg share comes from real bouts
where BOTH men were legally able to kick. Measuring it in a fixture where one man
cannot is comparing to the wrong thing.

## Product and process rules (standing)

- The facility is a "gym", never a "camp"; a fight camp is only the pre-bout
  preparation.
- Females never fight males; booking matches weight classes.
- Assets ripped from other games stay in the session scratchpad; never ship.
- **RETIRED 2026-09-28 (THREE RULINGS: carry on, ask only on scope):** Claude is lead developer: before a NEW stage give a short summary plus 2-3
  options and wait for the go-ahead; inside a greenlit stage execute without
  asking. Every report ends with a concrete headless test command.
- Be concise in every response, report and digest (user rule 2026-09-05).
- Grok gets pure modules only (small new files, never a `GameState.gd` or
  `UIKit.gd` rewrite). Its slice lives in HANDOFF `## GROK START HERE` with
  one claim of max 20 lines; Claude splices and runs the suite after Grok
  pushes, Grok never polls for it.
- **Assign the research BEFORE the question arises** (user rule 2026-09-09).
  A question put to the operator is a research task that was not assigned in
  time. The operator's job is to DECIDE, not to supply findings we could have
  gone and got. So: when a stage is greenlit, forecast what it will need to
  know and assign those studies immediately, in parallel with the build - do
  not wait for the build to stall on a gap. An open question with no research
  task behind it is a process failure, and a question the operator has ALREADY
  answered must never be re-asked: grep `HANDOFF.md` **and** `## Direction
  notes` **and** `HANDOFF_ARCHIVE.md` before calling anything open. This was
  written after C17's Q1/Q2 were reported unanswered to the operator hours
  after they had been answered and recorded in the Direction notes - the stale
  prose in `## Active claims` was read and the ruling below it was not.
- **[RETIRED 2026-09-28 - milestone wins, see THREE RULINGS]** EVERY AGENT HOLDS A TASK AT HANDOVER (operator rule 2026-09-22), and the
  quality bar below still applies to each one.** This RE-REVERSES the
  2026-09-21 "an idle agent is not a failure" ruling. That rule turned a full roster into a quota to fill, and on 2026-09-21
  it produced Q126: 130 lines of task file to get back a 60-line digest that ran
  an existing tool nine times and formatted the output. Assign an agent when
  there is a real slice; leave it idle when there is not.
  **Judge every delegation before writing the task file**, on the
  spec-to-delivery ratio and on whether an uninformed second hand is genuinely
  worth more than my own. It is worth more for a BLIND contract test - one I
  write against my own implementation only ever agrees with it - and for
  open-ended investigation where the answer is not known in advance. It is worth
  less than nothing for a mechanical pass I could script in five minutes.
- **THE OPS BOARD IS THE ROSTER AUTHORITY, NOT THIS FILE, AND NOT roster.json's
  `in_rotation` FLAG** (operator, 2026-09-22: *"its green on opsboard what else
  you need?"* and *"you can use them until i remove them from opsboard"*).
  **IF AN AGENT IS STILL ON THE BOARD, IT IS USABLE** - a toggled-off flag is not
  a removal, and the operator's word in chat outranks a stale note. This
  paragraph used to say "the roster is FOUR" while the board had Grok green, and
  a session burned two turns re-litigating that. DO NOT WEIGH THIS FILE AGAINST
  THE BOARD; read the board, then assign.
  **All nine are available as of 2026-09-22**: Claude, **Codex**, **Cursor**,
  **Dola**, **Grok** (usage 0%, PAID UNTIL 30 SEP - drive it hard, the bar is
  useful-at-all because the marginal cost is zero), **Qwen**, **Kalli**,
  **John**, **Maria**.
  **THE BOARD IS NOW A QUOTA AT HANDOVER (2026-09-22)** - every agent holds a
  task before the block goes out - **but `MANUFACTURED WORK IS THE FAILURE`
  still governs the CONTENT of each one.** Judge each slice on spec-to-delivery ratio
  and on whether an uninformed second hand beats my own; say plainly when an
  agent has no real slice rather than inventing one.
  **A quiet agent's LANDED work is still owed a read** - John's J32 sat unread
  for a day and it is the clinch study S43 needs.
  **Codex now picks a MODEL per task** (operator correction 2026-09-21, after a
  session that ran every Codex task on the default): `gpt-6-luna` (low or medium; operator 2026-09-25, was gpt-5.6-luna) for contract
  tests and text, **`gpt-6-astra` via `CODEX_MODEL` for spatial work** -
  procedural assembly, component pairing, structural alignment, scale, and the
  relative placement of separate parts. Ask which KIND of task it is first.
  **Dola is driven DIRECTLY** by `Tools/cici/cici.py` on port 9333 - `launch`,
  `open --chat`, `send --file`, `read`. Never by pasting her output into chat
  and typing answers back: that is the relay seat the 2026-09-09 ruling removes,
  and it went unnoticed for a whole session on 2026-09-21.

- **Never hand an API-side agent a repo test command** (user report
  2026-09-07: an agent spent a pass explaining it could not clone). Grok,
  Kalli, Maria and John have no token and cannot check out a private 1.7 GB
  repo, so a task that needs the suite to be run is a task they cannot do. A
  pure module must therefore have ZERO preloads - it is then testable in a
  throwaway Godot project holding only its own files
  (`research/SANDBOX_MODULE_TESTING.md`), and Claude runs the real
  suite after the push. Where a module wants another module's figure, the
  caller passes it in.
- Kalli's studies: Kalli pushes only its `research/` deliverables and
  never edits `HANDOFF.md`; Claude writes Kalli's block. Before assuming no
  study landed, check `git status` for untracked research files.
