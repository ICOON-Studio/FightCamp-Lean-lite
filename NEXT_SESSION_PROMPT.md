# S435 handover: foundation rework in flight, four collects done, pro tables on main (written 2026-11-11, end of S434)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S435`
and redraw Miro (recipe: ops/Tools/where_we_are_svg.py docstring; STRIP the `data-deleted` lines; the frame update itself fails
while the 14 surplus slots stay - the cards still update; deleting them needs his OK).

## USAGE FIRST
`get_usage`. End of S434: all models 47 %, Fable 68 % (reset Thu 2026-11-12 16:00), extra usage EUR 37.92 of 40.

## HIS WORDS
- Q-190 OPEN (the paid seat): he asked what it is; proposed "gym sponsorship ... link it to external sponsors?"; then
  "no i do not think that is the correct approach" to a local sponsor paying the boxer. Q-190 asks: sponsors back the
  gym and the gym sponsors a boxer / just rename / something else. Then: a design page + two fresh critics 7+ (the seat
  was only ever scored inside the Club week map, 7 and 7).

## 1. FIRST: the foundation branch (claude/foundation-s433, worktree E:/FightCamp/wt/LEAN_FOUNDATION_S433)
Rebased onto main by S434's workflow (360ddf39 CARDIO1, b310627c NOCAMP1, cc81f972 PUNCHSTART1; no conflicts). The fix
rounds (wf_91da691c-70b) die with S434: `git log main..claude/foundation-s433` shows what landed (commits "S434 <TASK> fix:").
Re-run what is left from the script (edit out the Rebase phase and the done tasks first):
C:\Users\user\.claude\projects\E--FightCamp-Lean\cc06cf94-1b7f-4ff3-ac8d-fa7ac72dd524\workflows\scripts\foundation-fixes-s434-wf_91da691c-70b.js
The review lists are in ops/tmp_s434/foundation_reviews.json; the developer decisions are written in the script's TASKS.
Collect by diff only when each item's skeptic reads "ready" and the final list is green on main's tree.

## 2. THEN
- HIS BOARD MARKS (S434, read and answered in chat; files ops/Feedback/2026-11-11-08 and -10, marked.png + README.md):
  TRAINSCENE1 (C293 on training_v2.png): "too much room for a simple slider and headline weekload"; the abilities table "i dont
  understand any of this"; "whatif the re is no fight booked ... the whole page needs better communication to the player and what
  exactly happens when he changes or sets the program ? where is he learning the moves ;and the combos ? ... the training should be
  seperate on a different scene i think and here only display a sumamry maybe ?" -> a Training scene + a summary tab, redrawn,
  two critics, then him. RESULTLOOK1 (C295 on fightlink_v2.png): the towel box "useless info i would expect to see the fighter
  after the fight tired with sign of the fight onhim/her , try to use more graphics and visual effects"; the four-part split
  "what is that for ?"; "there are more greens that reds on the stats and still didnt win a signgle round" -> redraw led by the
  fighter's picture, why each round was lost first. Both maps had passed critics at 7: his eye found what they missed - the
  critics' brief must ask "would a player who never read the map understand this screen?"
- TURNPRO1 (his words S434: "yes put the comparison on the cards"; then "So the choice to turn a fighter to pro should be linked
  to hype,wins,streak,morale and player goals ? proffesionals should be linked to an organization ?"): ONE design page "Turning
  pro" - the season-as-amateur vs season-as-pro comparison on the fighter cards and the pro offer (money, bouts, cost now,
  club time, room to grow; numbers from CLUBWEEK_MAP_V41 section 7 and Roster/ProDebut); the offer read through HYPE_MAP_S432
  4.8 (already passed) plus the boxer's own wish (Recruit.ambition, morale/loyalty) and the season target; the links named
  (British Boxing Board of Control licence $1,105, the manager's share 25%/10%, a fictional promoter's offer). Two fresh
  critics 7+, then the board, then a Cursor task. He also asked: professionals on the market (a pro walking in with a
  manager)? - a scope question to put to him with the page.
- Collect HUMANFIGHT2B (Cursor; the animation item; guard_knee_test must turn green), DUESSUMS3B (Antigravity, measure
  only), CORNERFACE2 (Qwen, VISUAL: read the stills yourself) through the review workflow
  (C:\Users\user\.claude\projects\E--FightCamp-Lean\cc06cf94-1b7f-4ff3-ac8d-fa7ac72dd524\workflows\scripts\collect-review-s434-wf_34f2c92c-33a.js:
  set PRS, re-invoke).
- After the foundation lands: dispatch CALLSPREAD1 (Qwen, briefed); F2b GAIN14, F4 LOADWORK1, F9 LIVESPLIT1 (Claude);
  KNOWN0's wiring into the attribute board / Profile / trial card / bout sheet (Cursor brief); the stand-down's
  SPAR ANYWAY choice and a lock mark on the night (with the Training tab build).
- Training rule modules (STEP 2 Training group) and the mat plan's build tasks (CORE_LOOP section 5).

## Traps (S434)
- After inserting lines, check that later line-number edits landed (golden_path's `_play()` was left un-awaited once).
- A brief whose Status says OPEN gets relaunched even if another seat did it: close it when its work is read.
- CI tests job now has 32 min; main's suite was 19.4 min.
- Digest: ops/research/S434_DIGEST.md.

SETTINGS: S434 ran on Opus 5.5 high, ultracode on. Next: Opus 5.5 high (the foundation rework is balance work); Fast off.
