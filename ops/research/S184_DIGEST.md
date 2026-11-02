# S184 digest - 2026-10-09 (Sonnet 5.5) - a slicker interface: icon top bar, full-screen club, tooltips, animated ground

## What now works
- **Collected the three S183 runs**: MOMENTS1W (Cursor 766067c4, diff applied 1ca12853 + a guard so a fight with no round clock does not
  crash the corner log), NIGHTLY1D (Arena PR #66, squash-merged: wins gate = one-sided exact sign test on discordant pairs, self-checks present),
  CAMPWORDS1 (Qwen 709a2538, applied f219ad5f; Qwen scaled stat POINTS per week x100 - kept in points).
- **THE NEW TOP BAR (operator: "this part needs to go ... full screen the gym ... icons with tooltips")**, mock A picked from `docs/previews/ui_s184`:
  `ShellChrome.gd` (rail never draws; 64 px `Strip`; `NavIcons` icon bar built by `_build_icon_bar`/`_icon_button`; compact date plate + Continue;
  cash with the roster/upkeep line in its tooltip), `GymHallPanel.gd` (HALL_POS/HALL_SIZE = the hall fills the screen), `CareerRoot.gd`
  (HOSTED_SHIFT slides hosted panels left, the page plate follows, the hall route lights HOME), `LucideIcons.gd` (+11 glyphs).
- **Fighters / Fights / Finance bubble pages dropped from the nav** (operator: "why are these still in the game"): the icons go to the real pages
  (roster, schedule, office). The pages are still routable; HUBS-DELETE removes them.
- **Animated ground** (operator: "remove this brown background and use animated background"): `AmbientBackdrop.gd` shader (drifting light shafts + rising dust)
  behind every hosted screen, the old gym photo hidden, the page plate 80% opaque so it shows.
- **Tooltips**: Antigravity (agy.exe, first run denied shell, second run file tools only) wrote `S184_TIPS_AUDIT.md` (89 controls, 16 covered); Claude applied
  67 `UIKit.tip` lines (`3d328a04`) and moved 9 native `tooltip_text` lines (wiped at runtime by TipLayer) to `UIKit.tip`.

## Evidence
- as_game nav walk `research/s184_nav_walk.plan`: 32 steps, 0 failures, stills opened (`docs/previews/s184_nav`, `s184_bg`).
- Tests: shell/hall/hub/tip slice 49 -> gym_menu_test control arm rewritten (rail is hidden with the switch off too, S184); 34/0 on the tooltip files; 5/0 shell.
- Not done: the club walk to a FOUGHT first bout (`research/s184_club_bout_walk.plan`): on Mon 2 Feb the "Fight night" card keeps SKIP THE DAY greyed
  until Continue has been pressed twice. Not seen: tooltips on hover in the running game (stills cannot show a hover).

## Traps this session
- The walker finds buttons by text; icon buttons have none -> `press [Nav_<id>]` (the node name in brackets). `s64_career_walk.gd` got a `soft` 4th field on `until`.
- Headless Edge screenshots: use a fresh `--user-data-dir` per page and wait for the PNG (it lands late).
- agy headless: shell commands are auto-denied -> tell it "file read/write tools only".
- A python heredoc string with `'\b'` writes a backspace into a regex; use raw strings.
