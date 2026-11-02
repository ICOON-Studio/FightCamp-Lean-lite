# TASK FIGHTBOARD1 - FIND A FIGHT list + the opponent's style + ONE film tell, as one pure module (S239, LOOP1 slice 4)

Seat: Arena (pure module + test, cloud). Branch `arena/<chat-id>-fightcamp`, PR to master; Claude merges by diff - never the Merge
button. Model: Arena default. Discipline: BOXING (the demo). No kicks, knees, clinch, MMA anywhere in fixtures or text.

Operator (board Q-S237-1, verbatim): "build it, the equipment wear is not what matters on this , the loop , animations,workout,feeling
of progrsession and improvement from training these are what matters for now". Verdict: research/LOOP1_VERDICT_S238.md loop
step 6 ("Find the opponent, book the fight, then one-click film study revealing one tell"). Design source: lead designer Ludo r105,
`research/ludo_rx/LUDO_R105_raw.txt` PART B (B2 the list, B4 the film tell). Its numbers are DESIGN VALUES - mark them so.

## Do - new `Godot/scripts/rules/FightBoard.gd`
extends RefCounted, static funcs only, no class_name, no autoload, NO preload, NO file reads, NO randomness except a seeded pick
`float(absi(hash("%s|%d" % [seed, i])) % 10000) / 10000.0`. Never modify an argument; return fresh containers.

1. `style_of(opponent: Dictionary) -> Dictionary` -> `{"style": String, "stance": "orthodox"|"southpaw", "source": "style"|"plan"|"stats"}`.
   The styles are GameplanReadiness.STYLES (copy the list as a const, do NOT preload it):
   swarmer, out_boxer, counter_puncher, brawler, southpaw, pressure_fighter.
   - opponent["style"] if it is one of those (also accept "slugger" -> brawler, "boxer_puncher" -> out_boxer).
   - else opponent["fight_plan"] by keyword: contains "pressure" -> pressure_fighter; "counter" -> counter_puncher; "out" or
     "jab" or "distance" -> out_boxer; "swarm" or "inside" -> swarmer; "power" or "brawl" or "slug" -> brawler.
   - else from opponent["stats"] (keys power, technique, speed, defense, conditioning, fight_iq; missing = 55): the HIGHEST of
     these four scores wins (ties -> the first in this order): out_boxer = (speed + technique + defense) / 3;
     counter_puncher = (fight_iq + defense) / 2; pressure_fighter = (conditioning + power) / 2 - 2; brawler = power - technique / 4.
   - stance: opponent["stance"] if "southpaw"/"orthodox", else "orthodox".
   This exists because GymHall3D passes the booked opponent to GameplanReadiness.plan_for, which reads "style" - and the game's
   opponents (GameState.get_booked_fight_opponent / get_fight_offer_opponent) carry "fight_plan" and "stats", no "style".
2. `rows(offers: Array, fighter: Dictionary, goal: Dictionary, opponents: Dictionary, today_day: int) -> Array` - the list Ludo B2
   shows. offers = GameState.get_fight_offers() rows (keys: id, label, opponent_name, opponent_sex?, opponent_rating, opponent_record
   {wins, losses, draws}, weight_class, purse, win_bonus, fame_required; an offer MAY carry "fight_day"). opponents = {offer_id:
   opponent dict} (may be missing an id). fighter = the roster athlete (weight_class, sex "male"/"female", record).
   - Keep only offers in the fighter's weight_class and his sex (an offer with opponent_sex "female" is women's; no key = men's).
     Females never fight males.
   - Row: `{offer_id, name, record_text "9-3-1", rating, style, stance, style_word ("OUT-BOXER", "PRESSURE FIGHTER", ...),
     scout_line (one short sentence from the style - write 6, one per style, a coach's words, no numbers), purse, fight_day,
     days_out, fits_goal: bool, tag: "FITS YOUR GOAL" | "STANDARD BOUT"}`.
   - fight_day: offer["fight_day"] if present, else today_day + 14 (design value: a two-week camp).
   - fits_goal: the goal has target "booked_fight" (any booking moves it), OR the goal id is "southpaw_answer" and the stance is
     southpaw, OR the goal id is "upset_the_gatekeeper" and the opponent's rating is above the fighter's ("rating" key, missing = 50).
   - Sort: fits_goal first, then fight_day ascending, then purse descending, then offer_id. At most 4 rows (Ludo B2).
3. `film_tell(opponent: Dictionary, tells: Dictionary, seed: String) -> Dictionary` - one click of film study (Ludo B4).
   tells = the parsed `Godot/assets/data/tells.json` ({"styles": {style: [ {id, kind, name, effect, blunder} ]}}) - the caller reads
   the file. Style lookup in tells: brawler -> "slugger", the rest by name, falling back to "default".
   Pick ONE entry of kind "tell" for his style with the seeded pick (same seed -> same tell). Return
   `{tell_id, text: "HABIT REVEALED: <name>.", station_kind, minutes: 30, readiness_bonus: 20.0, gain_mult: 1.25}` where station_kind is
   the HIGHEST-weight station of his style in the GameplanReadiness COUNTERS table (copy those 6 station tables as a const; a
   southpaw stance with another style still uses the style's table). minutes / readiness_bonus / gain_mult are Ludo r105 design values.
   {} when the opponent is empty.

## Tests (red on master first - paste the red line in the PR body)
New `Godot/tests/fight_board_test.gd` (extends SceneTree, `_initialize`, prints `FIGHT_BOARD failures=N`, quit(1) on fail).
Population printed - three DIFFERENT fighters: a 0-0-0 male welterweight with the debut goal (booked_fight target), a male
middleweight 9-3-0 rated 62 with "upset_the_gatekeeper", a female featherweight 6-1-0 with "southpaw_answer". Offers: at least 7
across welterweight/middleweight/featherweight, men's and women's, two with the same fight_day to prove the purse tie-break.
Opponents: one with "style", one with only "fight_plan" ("pressure_jab_body"), one with only stats, one southpaw.
Assert: weight-class + sex filter (the woman sees only women's featherweight rows); sort order; <= 4 rows; fits_goal each rule;
style_of each branch + the stats tie-break; film_tell same seed -> same tell, kind "tell" only, station_kind = the style's top station,
"default" fallback for an unknown style, {} for {}; arguments unchanged (deep-compare a copy).
Tells fixture: build a small dict in the test with the SAME shape as tells.json (do not read the file - CI has no LFS issue here, but
keep the test self-contained). Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/fight_board_test.gd`.
Parse gate first: `python Godot/tools/check_scripts.py Godot/scripts/rules/FightBoard.gd Godot/tests/fight_board_test.gd`.

## Rules
Read research/GDSCRIPT_TRAPS.md (Variant `:=`, `%%`). Create only those two files. New features ship ON (CLAUDE.md s10) - the
wiring round (GymHall3D, the panel) is Claude's and Cursor's. THE ONE TRAP: never delete or weaken a test to go green.

## Prior research
LOOP1_VERDICT_S238.md; LUDO_R105_raw.txt PART B; scripts/rules/GameplanReadiness.gd (COUNTERS, STYLES, LINES - match its words);
assets/data/tells.json (the tell names); GameState.get_fight_offers() (offer shape, ~line 8886); FighterGoal.gd (goal ids/targets).

## What would a human do?
The manager lays the promoter's four offers on the desk, the one that fits the fighter's goal on top; after he signs, the coach puts
one tape on and says "watch his left hand before the overhand" - and the week's pads are built around that one habit.

## Prefab check
None - our own rules over our own data (tells.json, GameplanReadiness).
