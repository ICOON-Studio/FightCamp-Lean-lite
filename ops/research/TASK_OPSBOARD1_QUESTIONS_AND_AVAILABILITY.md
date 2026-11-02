# TASK OPSBOARD1 - The ops board: answer Claude's questions on the board + tick which agents are available

Model: gpt-5 class (Codex), effort high. Owner: Codex. Work in your worktree (branch `codex/opsboard1`), commit, push the branch;
NEVER push master, never merge. Tier: Python tool + its test (no Godot).

## The operator's words (2026-10-08, verbatim)
"i want on the opsboard pending questions can be answered fromthere also i want to be able to tick which agents are available fro tasks"

## What exists (read before writing)
- `Tools/opsboard/server.py` (1877 lines, stdlib only, binds 0.0.0.0:8787 for the operator's phone). Read windows:
  `sed -n 1,120p` (header, caches), `sed -n 1630,1800p` (do_GET / do_POST: `/api/roster` POST already WRITES roster edits;
  copy its size limits, JSON checks and atomic write), and grep `def _json`, `def _send`, `ROOT`.
- `Tools/opsboard/index.html` (1298 lines) - the MAIN page (reads `/api/roadmap` + `/api/agents`): add two panels here.
- `AgentComms/roster.json` - per agent: `in_rotation` (bool) and `note`. The board's agent list = its keys.
- `Tools/agent_comms.py` (big; never read whole): `start` prints the session orientation. grep `def cmd_start` / `_rule(`.

## Owned files
- `AgentComms/questions.json` (new) - `Tools/opsboard/server.py` (1877 lines) - `Tools/opsboard/index.html` (1298 lines)
- `Tools/agent_comms.py` (start block + `ask` command only) - `Tools/opsboard/test_questions_availability.py` (new)

## Build
1. QUESTIONS FILE `AgentComms/questions.json` (create it): `{"_doc": "...", "questions": [{"id", "asked" (ISO), "session"
   (e.g. "S178"), "text", "options": [..] (may be empty = free text), "answer": null|str, "note": null|str, "answered_at": null|ISO,
   "seen_by_claude": false}]}`. Seed it with ONE real open question: id "Q-S178-1", text "The three Arena runs (GYM4A/B/C) were
   started before FightCamp moved to ICOON-Studio. Is Arena's GitHub app installed on ICOON-Studio so they can push?", options
   ["Yes, installed", "Not yet", "Don't know"].
2. SERVER: `GET /api/questions` -> the file; `POST /api/answer` {id, answer, note?} -> sets answer/note/answered_at, keeps
   seen_by_claude false; 404 unknown id; 400 when options exist and answer is not one of them (free text <= 500 chars when
   options are empty; note <= 500 chars); body <= 4 kB; atomic write (temp file + os.replace) like /api/roster.
   `POST /api/availability` {agent, available: bool} -> sets roster.json `<agent>.in_rotation` = available AND appends a dated
   line to that agent's `note` ("<date> operator via board: available|not available"); 404 unknown agent; atomic write; never
   touch any other roster field.
3. MAIN PAGE (index.html): a "QUESTIONS FOR YOU" panel at the top (open questions first: text, one button per option or a text
   box, a Send button; answered ones collapsed with the answer + time) and an "AGENTS AVAILABLE" strip (one checkbox per roster
   agent, ticked = in_rotation; changing it POSTs /api/availability and shows a tick when saved). Icons with tooltips, readable
   on a phone (min 44 px touch targets), no new libraries.
4. `agent_comms.py start`: print a block "QUESTIONS ANSWERED ON THE BOARD" listing every answered question with
   seen_by_claude false (id, question, answer, note), then set seen_by_claude true; and "QUESTIONS STILL OPEN" (ids + text).
   Add a helper `python Tools/agent_comms.py ask "<text>" --options "a|b|c"` that appends a question (id Q-<session>-<n>).
   Print an "AVAILABLE AGENTS (operator ticks)" line from roster in_rotation.
5. TEST `Tools/opsboard/test_questions_availability.py` (unittest, stdlib): starts the server's Handler on a random localhost
   port with ROOT pointed at a temp copy of AgentComms (questions.json + roster.json fixtures), then checks: GET returns the
   seed; POST /api/answer valid -> saved; wrong option -> 400; unknown id -> 404; oversize -> 413; POST /api/availability flips
   in_rotation and appends a note line, other fields byte-identical; unknown agent -> 404; `ask` appends with the next id; the
   start block marks answers seen exactly once (second run prints nothing new). MUTANTS (comment block; run each, each must
   fail a test): skip the option check; write roster non-atomically; mark seen before printing; flip availability inverted.

## Acceptance
`python -m unittest Tools/opsboard/test_questions_availability.py -v` green; mutants red; `python Tools/agent_comms.py start`
still runs (rc 0, prints the new blocks); the live board at 127.0.0.1:8787 shows both panels (restart it via
`Tools/opsboard/UseSourceBoard.ps1` only if the README says so - do not kill other processes). NOTHING may open on the
operator's screens: no browser, no image viewer (read files with your file tool only).

## Prior research
The ops board history: S157 (main page = roadmap plan), S144 (/agents live runs), S152 ("the ops board amputates roster notes" -
never truncate a note when writing), feedback_opsboard_is_the_roadmap.

## What would a human do?
Reuse the board's existing POST /api/roster pattern (limits, JSON checks, atomic write), keep every write narrow (one field),
and prove each refusal with a test.

## Prefab check
None needed: stdlib server + plain HTML already in place.

## The one trap
roster.json notes are long and other tools rewrite them: append to `note`, never replace or truncate it; write the whole file
atomically and keep its key order and indent (json.dump indent=2, ensure_ascii=False).
