Task TUT1C - the HANDBOOK button (Godot 4.7.2 GDScript game, repo Guru-Meditation/FightCamp, base branch master).
Work on your OWN new branch (openhands/tut1c-handbook), push it and open a PR into master. NEVER merge it yourself.
Read .github/CLOUD_AGENT.md first (how to run Godot headless and the tests; never delete or weaken a test).

WHAT: the guided tutorial (4 chapters: gym, bout, money, ladder) can already be replayed in code - GameState has
`tutorial_replay(chapter_id: String) -> bool` and `get_tutorial_read() -> Dictionary` (its "chapters" rows carry id,
title, done, total; its "replay" is the chapter being replayed or ""), and `is_tutorial_guide_on() -> bool`. What is
missing is the button the player uses. Add it:
- In the career top bar built by `Godot/scripts/ShellChrome.gd` (632 lines; `static func build(...)` at line 113; the
  existing BACK button is made around line 175 - copy its style), add one icon button named "Handbook" with tooltip
  "Handbook - replay a tutorial chapter". Visible only when `game_state.is_tutorial_guide_on()` is true.
- Pressing it opens a small popup listing the 4 chapters by title with "done/total". Clicking a chapter calls
  `game_state.tutorial_replay(id)`, closes the popup, and asks the owner to refresh the guide card: if the owner
  (CareerRoot) has a method `_guide_changed`, call it.
- Files you may change: `Godot/scripts/ShellChrome.gd` and a NEW test `Godot/tests/tutorial_handbook_test.gd`.
  Do not read `Godot/scripts/GameState.gd` whole (17,000+ lines): the tutorial API is at lines 17521-17640.
  `Godot/scripts/TutorialGuide.gd` (129 lines) holds the chapter list.

ACCEPTANCE (the new test, an `extends SceneTree` headless test modelled on `Godot/tests/shell_back_button_test.gd`,
which mounts CareerRoot by hand): (1) with the guide ON the top bar has a visible "Handbook" button; (2) with the guide
OFF it is hidden; (3) pressing it shows a popup with exactly 4 chapter entries; (4) choosing the "bout" entry makes
`get_tutorial_read()["replay"] == "bout"`; (5) control: without choosing, replay stays "". Print one line per check
(`ok ...` / `FAIL ...`) and a final `TUTORIAL_HANDBOOK checks=N failures=M`; quit(1) on any failure.
Commands that must pass, with their output pasted in the PR:
  python3 Godot/tools/check_scripts.py scripts/ShellChrome.gd tests/tutorial_handbook_test.gd
  $GODOT_EXE --headless --path Godot --script tests/tutorial_handbook_test.gd
  python3 Godot/tools/run_tests.py --only tutorial_guide,shell_back_button,tutorial_handbook --jobs 2
TRAP: a GDScript variable name reused in one function is a parse error; `var x := <call>` fails when the call returns
Variant - type it. If Godot is not on the sandbox, download 4.7.2 Linux from the godotengine/godot-builds GitHub
release (Godot_v4.7.2-stable_linux.x86_64.zip) and run `--headless --path Godot --import` once first.
