# S423 handover: MECHANICS FIRST (written 2026-11-10 at the end of S422)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S423` and redraw the map (recipe: ops/Tools/where_we_are_svg.py docstring; Miro refuses to shrink the frame while cards sit low - harmless).
Older handovers: S422's first version and S421's are in git; S396 to S417 in ops/research/HANDOVERS_S349_S417.md.

## The decision (operator S422: "ok prepare next session with your recommendations")
The seven mechanics the critics scored 8+ and he chose (ops/research/S400_REVIEW/MECHANICS_DECISION_S402.md) come before any
more menu polish. Where they stand (checked S422 in code and git, not from memory):
- R11 readable reasons: MOSTLY DONE (R11A-F on main).
- R24 fighters who fight differently: BUILT on main S416 (a1e9dcbc, FIGHTERMODEL4I: 10 attributes, 5 boxing skills). The other
  7 skills of the agreed 12 are BJJ/MMA: later. (S422 told him "not built" first, then corrected it.)
- R28 cutman, R25 the opponent adapts, R37 ask for a fight, R55 two fighters one coach, R58 a fighter leaves: NOT STARTED.
EVERY MECHANIC STARTS WITH A DESIGN MAP (operator Q-173: "so what the player decides exactly and where does that happening ?
which screens ? have you mapped the whole design for the mechanism ?"): one page + one picture: the decision the player makes,
the screen it happens on (drawn), what it changes and by how much (real-world numbers first, prior_research.py), what the
player sees after. On the board with --attach; build only after his OK. Critics judge the map (CRITIC_PACK) and draw a 10/10.
Menus change ONLY when a mechanic needs them (parked: At a glance Q-171, the staff screen Q-172 -> with R55, menu rounds).

## Order for S423
1. Collect KDFIX2 (PR #162): the ruler only (its fix is KDFIX3, queued on Qwen after FIGHTSLIDE3). Collect LEGTREMBLE3
   (Cursor) when it lands: the test must load the SHIPPED .res, red on main; re-render the board films and LOOK.
2. FIGHTDISPLAY1 brief for Cursor (his Q-174: "Use the veteran's drawing"): docs/mockups/s422/fight_10_simvet.html is the
   spec; review fight_critic_simvet.md; data check FIGHT_DISPLAY_DECISION_S419.md section 7 (hint 5's habit = the OPPONENT's
   `mode`, never rec["habit"]); the energy forecast to R3 is not built (keep its warning triangle or drop it). Queue it ahead of
   TRAININGB1 (seat_dispatch queue order).
3. R28 Cutman DESIGN MAP: a closing eye (eye damage must reach the real bout first: c64cead7 has the eye-band probe), stop it
   or go on in the corner minute; real cut and swelling rules (England Boxing / ABC doctor stoppage, cutman tools). Picture
   = the corner minute with the eye. Board question with the map attached.
4. R25 DESIGN MAP: first check that head punches now count (S406: "no setting moves results; the head number must count
   first", ops/research/*S406*), then what the opponent changes by round 2 and how the player sees it.
5. Q-173 dues: design map only (ops/research/DUES_CHOICE_S422.md has the numbers; John's SQ31 answer may add evidence).

## Running / queued
- Qwen: FIGHTSLIDE3 (five slide causes), then KDFIX3 (knockdown sway fix, BASE qwen/kdfix2). Cursor: LEGTREMBLE3 running,
  then TRAININGB1 (Training tab B + the tiredness curve).
- Grok bots WORK again (S422 fix: grokbot_direct.mjs sends via GrokBotService/SendGrokBotUserMessage). SQ29-31 go out on the
  30-min cycle; EnsureSandBox answers 503 now and then (it retries).

## Where he sees the project
- Ops board http://127.0.0.1:8787 : main page = goal, working now, next (in order), parked, done; Questions for you; /review
  (cleared S422: only the fight critics' 10/10s left); /agents = who runs what.
- Miro P0 "Where we are": https://miro.com/app/board/uXjVEV03QWA=/?moveToWidget=3458764689579200297 (DONE / NOW / NEXT).

## Traps
- A `cd` in a Bash call moves the session's working directory: give absolute paths.
- seat_dispatch REGRESSION names must be `<name>_test`. `ask --attach` paths are relative to ops/, pipe-separated.
- The idle guard reads a seat as idle when its CLI exited while the runner still tests: check the runner pid first.
- KnockdownCount.gd is 527 lines (over 500): split it the next time it is touched.

SETTINGS: S422 ran on Opus 5.5. Proposed for S423: Opus, high effort (design maps are the work), Fast off.
