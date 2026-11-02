# S78 DIGEST - MENU CLARITY (2026-09-25)

Operator, verbatim: "i need tooltips start removing uneccessary text from the menus and use tooltips and also we will
need a tutorial"; "showcase in the tooltips if there are things that are not linked properly"; "i want you to be able
to do the tutorial in front of me and watch you playing it".

## What shipped (db8ca616 + follow-ups)
- **One tooltip for the whole game** - `scripts/TipLayer.gd`, autoload. J52 timings (show 500 ms, adjacent re-show
  100 ms, hide grace 500 ms), placement below-right and flipped at the edges, Ctrl pins, Esc/click closes. Three
  sources, one look: an explicit tip (`UIKit.tip(node, spec)` - a Handbook id, a line, or {term,title,text,now,
  unlinked}); **any caption that names a Handbook term explains itself on hover with no call site** (found by
  geometry, since labels ignore the mouse; the pair's value becomes the "Now:" line); and NOT LINKED. A legacy
  `tooltip_text` is moved into the layer the first time it is hovered, so two tooltip styles never show.
- **The Gym Handbook** - `scripts/Glossary.gd`, 46 terms, J52 template NAME / definition (<=15 words) / Now / Why
  (<=12 words). `match_text` takes the whole caption or the alias followed by a value ("COND 64%"), longest alias
  wins, "BOXER" is not "BOX". Words are PROXY until Kalli's K77 and John's J53 land.
- **NOT LINKED** - `scripts/UICensus.gd`: one definition (a visible, enabled button with no pressed/toggled/
  button_down/button_up/gui_input connection, no script handler, no button group; or a control a screen marks
  `unlinked`) read by BOTH the census and the tooltip's red line, so they cannot disagree. First real finds: the gym
  creation floor drew **14 buttons that did nothing** (every station and free cell) - now a read-only floor draws no
  buttons and its stations carry tips; the office's **ABSENT money lines** (no system feeds them) now show the red
  line in their tooltip.
- **Census** - `census <name>` in the walk driver (`tools/s64_career_walk.gd`), plan `research/s78/census.plan`:
  caption words outside buttons, buttons, unlinked, Handbook terms seen / explicitly tipped, clipped to scroll windows.
- **Text cut** - gym creation (heading lines into tooltips, "WHAT OPENS WITH THE DOORS" and the duplicate readout
  lines gone, starter-floor/roster captions shortened with tips, the dev foot cues "... 780 MS" replaced), THE DAY
  (eyebrow, empty states to one line per M32 7.11, "TODAY · WHAT IS DATED" -> "TODAY"), offers (two dev lead lines ->
  one eyebrow + tooltip; "OPPONENT TBC" beside a named opponent was the offer's hold date -> "EXPIRY TBC"), office
  (the candour caption -> the header's tooltip). Rail, top-bar pills, bell, day strip and CONTINUE all carry tips.
- **M32** - the day strip was placed as 320 px and drawn 380, so CONTINUE covered SAT/SUN (M32's computed defect,
  confirmed in the live build): placed by its real width now, test + mutant. MUTED -> `#a3afc4`, `BAD_TEXT #f2766f`.
- **The tutorial** - `scripts/CoachMarks.gd`, autoload: 19 coach marks over the REAL controls for the first career
  month (J52 §6d: new career -> gym -> training -> schedule -> offers -> even match -> the card -> Continue to fight
  week -> weigh-in -> fight night -> result), head-coach voice, <= 2 sentences a step, dimming is visual only (can
  never lock input), NEXT appears after 6 s on every step, SKIP ends it for good, F1 replays it, starts itself once on
  a profile that never finished it (never headless). Two steps open a real tooltip as a demonstration.
- **Watchable** - `tutorial` in a walk plan plays it like a player (reads each mark, presses what it points at);
  waits are counted in frames so a `--write-movie` recording paces like a live window. Recorded ~5:45 at 720p (coach card hidden during the bout):
  `research/_captures/s78/s78_tutorial.mp4`. Live, in a VISIBLE window:
  `Godot_v4.7.2-stable_win64.exe --path Godot --script tools/s64_career_walk.gd -- plan=research/s78/tutorial.plan out=res://docs/previews/s78_live`.

## Census (caption words outside buttons / unlinked)
| Screen | Before words | After words | Before unlinked | After unlinked |
|---|---|---|---|---|
| country | 3,452 (unclipped, see below) | 226 | 0 | 0 |
| city | 96 | 71 | 0 | 0 |
| gym creation | 215 | 150 | 14 | 0 |
| THE DAY | 92 | 70 | 0 | 0 |
| offers | 251 | 233 | 0 | 0 |
| office | 201 | 181 | 0 | 2 (the ABSENT lines, now flagged honestly) |
| gym / staff / training / schedule / scouting / rankings | 128 / 106 / 181 / 185 / 159 / 99 | unchanged (S79) | 0 | 0 |

Per-screen caption lists: `previews/s78_census_before/`, `s78_census_final/` (`census_<screen>.txt`).

The country "before" (3,452 words) was read by the first census, which counted the whole 180-row country list; the
instrument was fixed to clip at scroll windows mid-session, so that one row is not a before/after. The other screens
have no scroll lists and are comparable. A fresh worktree to re-run the new census on the old tree would have
re-imported 1.7 GB, so it was not done.

## Tests
`tests/menu_clarity_test.gd` 25 checks, 0 failures; mutant (old 320 px strip placement) caught. Subsets green:
boot_root 1/0, creation_ 2/0, day_feed 1/0, gym_floor_layout 1/0, gym_hub 2/0, ui_kit 3/0 (after declaring `tip` a
helper in `assets/data/ui_kit_manifest.json`), smoke 1/0, office_hub 2/0, schedule_truth 1/0, schedule_hub 2/0.
No nightly line exists yet (`AgentComms/nightly/latest.txt` absent).

## Collected / assigned
- Collected: J52 (John), M32 (Maria), G100 (Grok, verbatim `G100_TIME_MOTION.md`), D22 (Dola, blind, verbatim
  `D22_TIME_MOTION.md`). **G100 and D22 agree the engine over-travels in boxing and disagree on magnitude** (G100
  boxing 36-52 m/min, gate 32-48, "do not gate on % frames > 0.25 m/s"; D22 30-38 m/min and a 25% cap at 0.25 m/s).
  G100 wins: named papers with n (Thomson GPS 35.9, FFB homography 52), and D22's "work:rest 1:3" is a different
  quantity from Davis' activity:break 18:1.
- Landed, NOT collected (both need their own verification pass): **Q176** (`qwen/q176-footwork` 2539d2e6) - ON puts
  boxing at 21-26 m/min, BELOW both studies' floors, with 0.75 s bursts vs G100's 1.5-3 s -> Q177 pass 2 assigned;
  **C203** (`codex/c203-standing-sources` f125a4ab) - 32 IK-authored standing clips behind `standing_sources_v1` OFF.
  **Q175 p3** (00612582) still owes the pooled 256-bout re-run here before merge; not run because two agents held the
  CPU all session (operator cap).
- Launched: **C204** (Codex, gpt-6-astra medium, worktree Temp/FightCamp-C203 on codex/c204-alive-stance), **U174**
  (Cursor, worktree Temp/FightCamp-U171 on cursor/u174-punch-output).
- Assigned: Q177 (Qwen, queued behind the cap), G101 (Grok, grok.com/c/ed41837d-f034-4ae0-b87f-87ddce782965) and
  D23 (Dola, blind) skill-band words for the "Now: 60 -> band" line, J53 (John) Handbook terms vs the rulebooks,
  M33 (Maria) icon map + type spec, K77 (Kalli) Handbook and coach words.

## Not done (S79)
The M32 LOOK across every screen (font, radius 8, rail icons, no header bars, Continue INK); text cut on staff,
training, schedule (week), scouting, rankings; a Handbook screen (J52 §6b.4) and the tooltip-speed setting.
