# TASK MATCHMAKE1A - promoter matchmaking stages instead of "TBD" (pure state machine + test) (S198)
Model: Qwen (qwen3-coder) - pure module, no UI, no GameState. Worktree E:/FightCamp/wt/NIGHTLY2. NEW branch qwen/matchmake1a:
`git fetch && git checkout -B qwen/matchmake1a origin/master`.

## Owned files
- `Godot/scripts/rules/Matchmaking.gd` (NEW)
- `Godot/tests/matchmaking_test.gd` (NEW)

## Spec (operator approved, board Q-S196-4: header 10 - the fight contract shows "TBD" as the opponent). Source:
research/LUDO_ROUND33_S198.txt "Header 10" (~lines 401-410). A promoter finds the opponent over 48-72 in-game hours in stages:
- SHORTLISTING: "PROMOTER SHORTLISTING (N CANDIDATES AUDITED)" - lasts 24 h.
- OFFER_EXTENDED: "OFFER EXTENDED TO: <NAME> (PENDING SIGNATURE - <H>H)" - 24 h window.
- LOCKED (opponent signed) or WITHDREW: "OPPONENT WITHDREW - PROMOTER PURSUING REPLACEMENT" -> back to SHORTLISTING with that name
  excluded; after 2 withdrawals the next offer is always accepted (the bout must happen).
`class_name Matchmaking extends RefCounted`, pure static, no RNG inside (the caller passes `accept_roll` 0..1):
- `start(candidates: Array, hour: int) -> Dictionary` (state: stage, started_hour, candidates (names), excluded, withdrawals, opponent);
- `advance(state: Dictionary, hour: int, accept_roll: float, accept_chance: float = 0.75) -> Dictionary` - returns a NEW state;
  SHORTLISTING -> OFFER_EXTENDED after 24 h (opponent = first candidate not excluded); OFFER_EXTENDED after 24 h -> LOCKED if
  accept_roll < accept_chance or withdrawals >= 2, else WITHDREW (excluded += name, withdrawals += 1) and immediately SHORTLISTING
  from that hour; no candidates left -> stage NO_OPPONENT;
- `label(state: Dictionary, hour: int) -> String` - the header text above, with the hours left (ceil) and "MATCHMAKING: <H>h REMAINING";
  never "TBD".
Test (`extends SceneTree`; prints `MATCHMAKE total=N fails=M`; quit(1) on fail): stages advance exactly at 24 h boundaries (23 h stays,
24 h moves); accept -> LOCKED with the name; reject -> WITHDREW then SHORTLISTING excluding it; third offer always LOCKED; empty list
-> NO_OPPONENT; label never contains "TBD" in any stage; input state never mutated. Name 3 REAL mutants (code changes you ran red).

## Gates
`python Godot/tools/check_scripts.py <new .gd>`; `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot
--script tests/matchmaking_test.gd` -> exit 0, no FAIL, no SCRIPT ERROR. Typed GDScript (never := on a Variant).
## Prior research
LUDO_ROUND33_S198.txt Header 10; scripts/FightContractScreen.gd:503 (read-only: where "TBD" shows).
## What would a human do?
A matchmaker phones around, offers the fight, waits for a signature, and calls the next name when one says no.
## Prefab check
None - our own rules.
## The one trap
Do not commit AgentComms/messages files. Commit on qwen/matchmake1a, push; never master; never open windows, image viewers or browsers.
