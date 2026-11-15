# TASK PALETTEGUARD1 - a test that blocks loose colours in screen scripts (one palette, his Q-251 "do it and i will judge")

Status: OPEN (S493, Claude main). Discipline: boxing (all menus). Model: Qwen (qwen3-coder), default.

## Why now
The operator asked "do we have a colour pallete? i see some menus look different". The census (ops/AgentComms/board_attach/
Q-S294-251_2_README.md, read the sections "The rule proposed" and "Shade rules") found 136 of 314 screen scripts writing
their own colours. Claude is writing `scripts/ui/Palette.gd` (19 colours named by job) and moving screens onto it one at a
time. This test makes sure no NEW raw colour gets in, and that a file's count only goes down.

## Prior research
- ops/AgentComms/board_attach/Q-S294-251_2_README.md (the palette, the rule, the baseline idea).
- ops/research/C90_COLOUR_ESCAPES.md (an older colour census - shows the patterns screens use).

## What would a human do?
A lead artist keeps one swatch file and a lint check in CI that fails a pull request adding a hex value outside it, with a
grandfather list for old files that shrinks as they are cleaned.

## Prefab check
Godot has no built-in colour lint; gdlint (gdtoolkit) has no such rule. A 150-line GDScript test is the smallest fit.

## Owned files (create; touch nothing else - Claude adds the test to tools/run_tests.sh when collecting)
- `tests/palette_guard_test.gd` (new, extends SceneTree, under 250 lines, no preloads of game scripts)
- `tests/palette_baseline.json` (new, written by the test's write mode)

## What to build
`tests/palette_guard_test.gd`:
1. Walk every `.gd` file under `res://scripts/ui` and `res://scripts/fight3d` (recursive, DirAccess; skip `.uid`).
2. EXEMPT (never counted, listed in the output as `exempt=<n>`):
   - `res://scripts/ui/Palette.gd` (the palette itself);
   - `res://scripts/ui/IsoGym.gd` (a room map, not a menu);
   - any file whose text contains `StandardMaterial3D`, `ShaderMaterial` or `ORMMaterial3D` (3D material tints).
3. Count RAW colours per file, line by line. Skip a line whose stripped text starts with `#` (comments and `##` docs). On
   other lines, cut the line at the first `#` that is NOT inside a double-quoted string (a trailing comment), then count each
   match of these (a RegEx each; one line can hold several):
   - `Color\(\s*"` (Color("#abc"), Color("red"));
   - `Color\(\s*[-0-9.]` (Color(0.2, 0.3, 0.4), Color(1, 1, 1, 0.5));
   - `Color\.html\(` and `Color8\(`;
   - a quoted hex string `"#[0-9a-fA-F]{3,8}"` that is NOT already inside a `Color("...")` match on the same line (count it
     once, not twice);
   - `Color\.(WHITE|BLACK|RED|GREEN|BLUE|YELLOW|GRAY|GREY|ORANGE|PURPLE)\b` - a named engine colour.
   NOT counted: `Color.TRANSPARENT`, `Color(SOME_NAME, 0.6)` / `Color(x.r, ...)` (first argument is a name), `.lerp(`,
   anything on a skipped comment line.
4. Read `res://tests/palette_baseline.json` = `{"res://scripts/ui/Foo.gd": 12, ...}`.
   - A file with count > its baseline -> `print("FAIL <path> raw colours %d > baseline %d" ...)`.
   - A file not in the baseline with count > 0 -> `FAIL <path> new file with %d raw colours - use Palette.gd`.
   - A file with count < baseline -> print `SHRUNK <path> <base> -> <now>` (not a failure; Claude lowers the baseline).
5. WRITE MODE: when `OS.get_cmdline_user_args()` contains `write`, write the current counts (only files with count > 0,
   keys sorted) to `res://tests/palette_baseline.json` (pretty JSON, tab indent) and quit(0) after printing
   `PALETTE_GUARD wrote <n> files`.
6. Last line in check mode: `PALETTE_GUARD files=<scanned> exempt=<n> raw=<total> over=<n> new=<n> shrunk=<n>` then
   `quit(1 if over + new > 0 else 0)`.
7. Self-check before the scan (so a broken regex cannot pass silently): run the counter on these literal lines and FAIL if
   the result differs: `var a := Color("#ff0000")` -> 1; `x.color = Color(0.2, 0.3, 0.4)` -> 1;
   `const C := "#1a1512"` -> 1; `Color(PAGE, 0.6)` -> 0; `# Color("#fff") in a comment` -> 0;
   `var b = Color.WHITE  # Color(1,1,1)` -> 1; `m.modulate = Color.TRANSPARENT` -> 0; `Color8(10, 20, 30)` -> 1.

Then run write mode once to create the baseline, and check mode once (it must pass on the tree with its own baseline).
Mutant proof: temporarily add `var _t := Color(0.1, 0.1, 0.1)` to `scripts/ui/HomeLook.gd`, run check mode, see it FAIL,
revert. Say so in the PR body.

## Parse gate and the one test command
- `python tools/check_scripts.py tests/palette_guard_test.gd` (if that tool path does not exist, run the test once headless and
  read for SCRIPT ERROR).
- Write baseline: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/palette_guard_test.gd -- write`
- Check: the same without `-- write`. Tier: a new test file only.
- NEVER `_console.exe`. Nothing opens on screen. Do not run the full suite.

## RESULT lines for the PR body
- `RESULT: tests/palette_guard_test.gd -> PALETTE_GUARD files=<n> exempt=<n> raw=<n> over=0 new=0 shrunk=0`
- `RESULT: mutant HomeLook.gd +1 raw colour -> FAIL res://scripts/ui/HomeLook.gd ... (reverted)`

## The one trap
Never `var x := <an Array or Dictionary element>` (Variant -> parse error: write `var n: int = int(d[k])`). RegEx objects:
`var re := RegEx.new(); re.compile(...)`; `re.search_all(line)` returns an Array of RegExMatch. A `"#"` inside a string is not a
comment start - track quote state when cutting the trailing comment.

## Contract
OWNS: tests/palette_guard_test.gd, tests/palette_baseline.json
RED_TEST: tests/palette_guard_test.gd -> PALETTE_GUARD files=<n> exempt=<n> raw=<n> over=0 new=0 shrunk=0 (red on main: the file does not exist)
REGRESSION: tests/wood_kit_test.gd (the palette constants it reads must still load; the guard itself only reads files)
VISUAL: no
NOT YOURS: every other file. Under 250 lines. Never delete or weaken a test. Work on your own branch, open a PR into main, never merge.
