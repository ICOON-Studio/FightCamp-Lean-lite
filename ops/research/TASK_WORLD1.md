# TASK_WORLD1 - the living world, as rules only (Qwen)

Model: Qwen (qwen3-coder). Discipline: boxing. Repo: E:\FightCamp\Lean, on your own worktree and branch. Lean rules: its CLAUDE.md,
no script over 500 lines, Godot headless only (`--headless --audio-driver Dummy`), nothing opens on the operator's screens.

## Contract
OWNS: scripts/world/, assets/data/world/, tests/world_rules_test.gd, tests/world_years_test.gd
RED_TEST: tests/world_years_test.gd -> WORLD_YEARS failures=0
REGRESSION: world_rules_test
VISUAL: no

## Why
The operator approved the S395 structure design (docs/STRUCTURE_DESIGN_S395.md, read sections 5.3, 5.3a rule 2 and 3, 5.3b,
5.7 P2 P3 P10 P16, 8 rank 7). The career becomes open-ended: a world of boxers who age, peak, decline, retire and are replaced,
with a pro ladder and fictional belts. This task builds the RULES ONLY, as pure modules with tests. No screen, no change to
`scripts/state/` or `scripts/ui/`; Claude wires it into the career later. Corner King (our closest rival) has this, so it is the
price of entry: it must hold up for 20 game years.

## Do
1. **Open data first (P16).** Everything a fan might rename lives in plain JSON under `assets/data/world/`: first names and
   surnames (varied, many countries, women and men), fictional club names (NO real clubs; `scripts/state/Data.gd` uses real ones,
   do not copy them), four fictional organisations' belt levels (area, national, continental, world), the divisions. Code reads the
   files; nothing fan-editable is hard-coded.
2. **Generate the world** (`scripts/world/WorldGen.gd`): four divisions to start (women's and men's lightweight, women's and men's
   welterweight), amateur and pro; about 20 ranked pros per division plus more below. Each boxer: id, name, sex, club, age, stance,
   style, rating on the `BoutRules.fight_power` scale (read `scripts/rules/BoutRules.gd` and `scripts/state/NationalField.gd` for
   the scale and the opponent dictionary shape the fight already reads: name, first, club, stance, style, record, rating, threat,
   weak), record, damage ledger, peak age. Seeded: the same seed gives the same world.
3. **Age and the career curve** (`WorldAge.gd`): yearly tick. Rise to a peak, plateau, decline; damage (hard fights, stoppage
   losses) brings decline forward. **Ground the numbers in real boxing before writing them** (team rule: benchmark real-world
   numbers, never invent): peak ages, career length, fights per year for amateurs and pros, retirement ages. Write the sources and the
   numbers you took in `assets/data/world/SOURCES.md`. Retirement by age and decline, never by a fixed timer (rule 3): give each
   boxer a fights-left forecast from age and ledger. New arrivals each year balance retirements.
4. **Rankings that move by taking places** (`WorldRank.gd`): beat someone above you and you take their place, beat someone below and
   nothing moves (rule 2). Champions per belt level, mandatory challengers, vacated belts when a champion retires.
5. **The world fights itself** (`WorldSim.gd`): a cheap result for bouts the player is not in (rating gap + luck, stoppages more
   likely at a big gap), so records, ranks and belts move every month. Rival boxers improve too, or the world weakens as its first
   generation retires (Corner King's lesson).
6. **The 20-year test** (`tests/world_years_test.gd`, the RED_TEST): run 20 game years with no player and check: every division's
   ranking stays full; age spread stays believable each year; arrivals roughly match retirements; ratings at the top do not drift
   up or down over 20 years by more than a few points; every champion has a credible next challenger; no boxer fights more than a
   real schedule allows. Print `WORLD_YEARS checks=<n> failures=<n>`, and write a plain record book of the 20 years (champions by
   year, longest reigns, best records, retirements) to `user://world_years_book.txt` and print its first 40 lines, so a person can
   read whether there is a story in it.
7. `tests/world_rules_test.gd`: the small rules one by one (seeded generation repeats, a win over a higher-ranked boxer takes the
   place, a belt vacates on retirement, the forecast falls with damage). Add both tests to `tools/run_tests.sh`'s TESTS list.

## Done
Both tests pass, the record book is printed in your notes, SOURCES.md names every real number. Open a PR. Do not claim a score.
Do not touch scripts/state/, scripts/ui/ or scripts/fight3d/ (other sessions are working there).
