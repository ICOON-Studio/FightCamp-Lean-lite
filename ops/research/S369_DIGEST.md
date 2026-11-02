# S369 digest - management pages as cards, the BJJ belt match, a planning playtest, the operator's fight feedback (2026-11-02/03)

Main: 67499f2 -> 287f17d (RivalPast collected) -> b9330fa (agy = Argon) -> 114a309 (UI merged) -> 81eb941 (seat count) ->
d36736b / f9f1b93 (playtest report). Branches: claude/bjjmatch1 e115893 (pushed, NOT merged), agy/camclinch1 9d861cf
(PR #20, uncollected), agy/refbreak1 0b854b4 (superseded - do not merge).

## Shipped on main
- RivalPast (PR #19, Qwen via seat_dispatch, the first unattended run): 8/8, rival_past_test into run_tests.sh (CI never ran it).
- UI polish (operator "Yes, merge UI"): FighterCard.gd - face cards two to a row on Fighters > Training / Fight camps,
  Fights > Offers standing column + the real next-offer date (next_offer_day), Money where-from / where-to bars; every bar
  tweens. tools/ui_pages_still.gd. Export 117/117, exe rebuilt, booted clean.
- Antigravity runs Gemini 4 Argon High (operator "antigravity should have argon now"): seat_dispatch AGY_MODEL. A "quota for
  166 h" 429 on 3.8 Flash cleared 20 min later. seat_dispatch counted one Qwen run as 3 agents (3 node pids) - fixed.
- Playtest report ops/research/S369_PLAYTEST_TWO_FIGHTERS.md (run 2, the planning game) + stills ops/previews/S369_playtest/.

## On claude/bjjmatch1 (pushed, suite 118/118 at a978816; +HUD e115893, fight_meters + golden_path green)
- BJJMATCH1: BjjMatch.gd (clock by belt, IBJJF points, owned-only offers with odds + miss cost, 3 calls on heavy settles,
  Hold and breathe, initiative, subs only on a finish, open guards classified) + BeltMatch.gd on the GrappleBrowser pair:
  `FightCamp.exe -- jump=grapple match=1` (auto=1 fast=N for probes). bjj_match_test. Waits for the operator's playtest.
- Ana's strength + cardio (Miro card 3): in the match odds/gas, trained by the mat classes (NoGi.body_gain: a year at 3
  classes cardio 58 -> ~67, strength 52 -> ~58), HER BODY card on her page, the week report carries before/after.
- The fight HUD rings show their numbers (operator "also add numbers here?"); tools/hud_still.gd.

## Agent runs
- REFBREAK1: r4 (Qwen) glide 1.92 -> 0.00; Claude's audit fixed the step-out lag 0.13 -> 0.43 s (Clinch BREAK_HOLD_S);
  r5 (Qwen) still FAIL (elbows 178, a frame through). SUPERSEDED: operator "remove ref and make them recover their
  positions pushing slowly each other".
- CAMCLINCH1 (Antigravity on Argon, seat_dispatch): PR #20, checks 4/5, Argon 2 -> 4/10 - but the dispatcher's BEFORE film
  was 6 s of ring walk-in (no clinch), and cam_view_probe needs a window: collect by running cam_view_probe windowed on
  the branch, then film a clinch both ways.

## The playtest (operator: run 1 "was no playtest")
Run 2 played the planning game: recruited Tess Reilly via Scouting, scouted Priya Nair (file, tape room: flow, tell, SPOT),
built Playbook plans, a short-notice swap to Erin Doyle, Tess vs Amy Croft live with calls and corners -> split win.
Chain verdict: the tape room is the best scouting screen; the tape's answer cannot enter a full plan (dead click); the
plan board rates the opponent's archetype only (no weapon/habit/weakness, no rounds); the plan is invisible in the ring
(double jab 7/10 shown only on the result's hidden THE PLAN, LIT UP); double jab dominates; corner panel collapses into
"1 THE MINUTE / 3 PICK THE PLAN"; templates (29-28 x2 / 28-29 in both wins, same weakness, same coach line).

## Operator decisions this session (memory project_fight_feedback_s369)
Remove the referee - boxers push each other off slowly; tired = red legs on the holo + weaker shots; body shots need a
hit reaction; the flow (THE PLAN, LIT UP) saved per bout on the fighter page; "exchanges won" must explain itself;
significant strikes (never in Lean) as the broadcast stat.

## Next session (S370), in order
1. Ask which fight change first (the box asked: remove the referee / tired legs + power); build it on claude/bjjmatch1 or
   a fresh branch from main; then the other: tired legs red + tired shots lighter; body-shot reaction clips (Playbook
   partner already plays pro_hit_by_gutshot_v2); the flow per bout on her Record tab + plan-line win rates in the Playbook.
2. Scouting -> plan (proposal in the playtest report): the tape answer replaces its line; the plan board reads the file +
   a ROUND row; "PLAN: DOUBLE JAB - landed 4/5" in the ring and in the corner; one fact per film session; a swap resets it.
3. Corner summary readable ("Corner done: water and breathing - fixing X - round 2 plan: Y"); rename exchanges won.
4. Collect PR #20 (CAMCLINCH1) windowed; retire agy/refbreak1 + wt/LEAN_REFBREAK1; merge claude/bjjmatch1 after the
   operator plays one belt match.
5. Not done S369: the Miro production map (3b) was not moved this session.
