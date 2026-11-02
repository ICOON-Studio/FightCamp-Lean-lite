# TASK EVENTS1A - the 30 gym events as data + a pure resolver + test (S197)

## Owned files
- `Godot/assets/data/gym_events.json`
- `Godot/scripts/rules/GymEvents.gd`
- `Godot/tests/gym_events_test.gd`

Model: Qwen (qwen3-coder) - pure module, no UI, no game wiring. Worktree E:/FightCamp/wt/NIGHTLY2 (reuse: its import cache is built),
NEW branch qwen/events1a from master (git fetch; git checkout -b qwen/events1a origin/master).
Operator approved Ludo round 32 (board Q-S196-2: "amazing, approve all ...") incl. C "members and the living gym".
Spec: research/LUDO_ROUND32_S197.txt - "4.3 Thirty Managerial Gym Events" (E01-E05) and "PART 4.3 (Continued)" (E06-E30).
Build NEW files only:
1. Godot/assets/data/gym_events.json - all 30 events: id (E01..E30), title, trigger {kind, numbers}, choices [{id, label, effects {cash, members,
   prestige, revenue_pct, injury_risk, morale, ... as Ludo states}}], cooldown_days, a note naming the source. Copy Ludo's numbers exactly.
2. Godot/scripts/rules/GymEvents.gd - extends RefCounted, class_name GymEvents, pure static, loads + caches the json like
   Godot/scripts/rules/CareerWear.gd. API: `all() -> Array`; `eligible(state: Dictionary, day: int, history: Dictionary) -> Array` (trigger met,
   cooldown passed; state is a plain dict: cash, members, prestige, hour, stations_in_use, etc - name the keys you need in a header comment);
   `resolve(event_id: String, choice_id: String) -> Dictionary` (the effects); no RNG inside - callers pick.
3. Godot/tests/gym_events_test.gd - extends SceneTree, prints `GYMEVENTS total=N fails=M`, quit(1) on fail: 30 unique ids, every event has >= 2
   choices with effects, E05 noise complaint: A pays $250 fine, B -15% white-collar revenue; each trigger kind has a fire and a near-miss case;
   cooldown respected. 3 mutants (named in your final message) must each fail.
Gates: `python Godot/tools/check_scripts.py <new .gd>`; `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/gym_events_test.gd`
-> exit 0, no FAIL, no SCRIPT ERROR. Typed GDScript (never := on a Variant). Commit on qwen/events1a, push; never master; no windows.
