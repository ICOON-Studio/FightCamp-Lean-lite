# TASK U207 - the bots' art on screen: 14 shipped pieces nobody draws (UI, Cursor)
Model: Cursor default (operator settings in Tools\cursor_task.cmd).
Owner: Qwen CLI on kimi-k2.7-code (VISION; S138 reassigned - Cursor is on U208/U209). Worktree E:/FightCamp/wt/U207, branch qwen/u207-bot-art (from master).
Operator 2026-10-01, verbatim: "kalli has so much art i havent seen ? why is it out of the game" and "is all art form kalli
an maria in the game ?". Answer found (S138): 19 bot pieces were imported into `Godot/assets/ui` and NOTHING loads them.
S138 wired 7 (trophy/medal/belt cutouts in the profile honours strip + office trophy cabinet via `UIKit.art_plate`).
This task wires the other 14. Operator-cleared to ship (`Godot/assets/ui/README.md`).

## Prior research
`python Tools/prior_research.py bot art glyph trophy plate`: M2_CAGE_DESK_MANIFEST.md (what each file is for, Maria),
M34_PITCH_PRESENTATION.md, research/topics/gym_rooms_art.md. S138 commit 59cac9b5 = the pattern to copy:
`UIKit.art_plate(art_path, fallback_icon, kind, size, gym)` (UIKit.gd, search `static func art_plate`) and the navy-keyed
`*_cutout.png` files (the source PNGs are 512x288 cards on a dark navy ground - drawn raw they read as a tiny stamp).

## What would a human do?
A UI artist with a folder of finished art and a shipped game: put each piece where the player already looks, at a size
where it reads, full colour, with the word in a tooltip (operator rule: icons over text, with tooltips). Never stretch a
card PNG - cut it out first.

## Prefab check
All art is ours and in the repo. Cutouts: copy the S138 Pillow recipe (luminance + warm-minus-blue alpha, blur 0.8, trim)
into `Godot/tools/u207_make_cutouts.py` and run it for the files below.

## The 14 pieces and where each goes
| file(s) | where |
|---|---|
| `glyph_boxing/mma/kickboxing/muay_thai/judo/freestyle_wrestling/greco_roman/karate/bjj/sambo/taekwondo.png` (11) | every place a fighter's DISCIPLINE is shown as a word (profile header "BOXING", roster rows, scouting rows, offer cards): an art_plate before the word, tooltip = the discipline name. Census first: `grep -rn "discipline" Godot/scripts/*Panel.gd Godot/scripts/UIKit.gd \| grep -i "label\|caps\|text" \| head -40` |
| `trophy_fight_night.png`, `trophy_performance_night.png` | FightResultPanel.gd (1,485 lines; `grep -n "tiles.append" Godot/scripts/FightResultPanel.gd`): a reward tile when the bout earned Fight / Performance of the Night (GameState ~12679 `FightAwards.judge_card` grants). Also into the trophy cabinet tally if the gym holds one. |
| `plate_corner_stool, plate_fight_week, plate_locked_cage, plate_gym_floor, plate_fighter_identity, plate_ring_dual_sil` | empty states that today show only words (e.g. "NO BOUT BOOKED", "NO HONOURS YET", a locked tier): the plate at 160-240 px beside the line. Pick 6 places by census, one per plate, named in the digest. |
| `body_muscle_map_front.png` / `_cutout.png` | Body Lab, ONLY if it has no colour figure today - otherwise list it as not needed. |

## Owned files
New: `Godot/tools/u207_make_cutouts.py`, the new `*_cutout.png` (+ .import), `Godot/tests/u207_bot_art_test.gd`,
`Godot/tools/u207_render_art.gd`, `research/U207_DIGEST.md`, stills in `previews/u207/`.
Edited: the panels the census names (list each with line numbers in the digest), `Godot/assets/data/ui_kit_manifest.json`
only if a new UIKit factory is added (then also run `tools/render_kit.gd` and commit ONLY the new renders + renders.json).
GameState.gd (17k+ lines) is NEVER read whole - `sed -n` windows only.

## Test (tier: scripts edited)
1. `python Godot/tools/check_scripts.py <every touched .gd>` (parse gate - a parse error hangs a headless test).
2. NEW `tests/u207_bot_art_test.gd`: mounts each edited panel with a fixture that SHOULD show the art and one that should
   not (control), and asserts an `ArtPlate` node with the right `art` meta is present / absent. A green test must be able
   to read worse: break one path and see it fail (say so in the digest).
3. `python Godot/tools/run_tests.py --jobs 2 --only ui_kit,profile_revamp,office_hub,fight_result,honours,roster,scouting`.
4. Stills: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/u207_render_art.gd`
   -> `previews/u207/`; OPEN EVERY STILL before you call it done. If the worktree has no import cache, run
   `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --import` once first.
Watchdog before every heavy run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`.

## The one trap
TextureRect: set `expand_mode` and `stretch_mode` BEFORE `texture` (and never assign `size` on a full-rect-anchored
Control). And a new .png needs the import step before a headless test can `load()` it - `ResourceLoader.exists` is false
until then and art_plate silently falls back to the line icon (your test must catch that).

## Finish
git add by explicit path, commit, git push -u origin qwen/u207-bot-art. Never edit HANDOFF.md. Do not stop at written.

## PART 2 - the operator's 12 picks (2026-10-01, verbatim "Bot art picks: #0, #11, #28, #47, #51, #86, #99, #106, #110, #125, #200, #201")
Imported by Claude into `Godot/assets/ui/bot_art/` (Kalli/Maria via Grok Bot; originals D:/FightCamp/bots_art/cache).
| file | where it goes |
|---|---|
| `scouting_room.jpg` | Scouting screen: header art band (cropped 16:5, darkened 35% under the title) |
| `gym_office.jpg` | Office hub: header art band, same treatment |
| `film_room.jpg` | the fight camp FILM tab / opponent study: header art band |
| `garage_gym.jpg` | main menu / new-career "choose a life" backdrop (the starter gym) |
| `gym_with_ring.jpg` | the gym-expansion / next-tier card: "what your gym becomes" image |
| `club_hall_bout.jpg` | the REGIONAL venue (R1) card on fight offers and the fight-night intro card |
| `green_ring.jpg` | the fight-week / weigh-in loading card |
| `training_floor_look.jpg` | NOT a UI image: the target look for the training floor - attach to C233 (floor + lobby build) as reference |
| `belt_world_title.png` | the TOP world title (above `belt_world`): navy-keyed cutout, used by honours/cabinet/result when the title's level is world |
| `gold_icon_sheet.png` (24 icons) | slice into 24 cutouts (`bot_art/icons/gold_*.png`) and use them where line icons stand for attributes/achievements today; name each slice in the digest |
| `gold_skill_badges.png` (15 badges) | slice into 15 cutouts (`bot_art/badges/*.png`) for skill-tree unlock badges |
| `fighter_card.jpg` | layout reference for the fighter card (scouting + VS screen) - build our card to it, do not ship the image |
Rule for every header band: TextureRect expand/stretch set BEFORE texture, `STRETCH_KEEP_ASPECT_COVERED`, a dark gradient
under any text on top, and the title text stays readable (check the still).
