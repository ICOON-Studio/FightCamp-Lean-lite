# S69 DIGEST - the gym market, slice one; the roadmap tree (2026-09-24)

## Shipped
- **THE GYM MARKET, slice one** (Grok G74 "Smallest first slice", `21854048`). The operator's ask (S66, verbatim in
  membership.json `flat_count_rule`): equipment should attract members, members pay, and that is the motive to expand.
  - `Membership.gd` (pure, no preloads): `city_pool` (D from world_regions' per-city gym count: small 180 / mid 320 /
    large 480 x (0.75 + 0.005 x combat popularity)), `attractiveness` (3 coach + 2 facility + 1 kit + 0.4 reputation on
    0-100 scores; G74's ORDER, invented magnitudes), `player_scores`, `rival_scores` (a rival's facility_quality scores its
    facility AND kit - it has no floor list), `market` (share = A / sum A; target = round(share x D)), `crowd_ratio`,
    `crowd_yield_factor`.
  - `GameState`: `get_floor_station_capacity` (station_capacity x condition), `get_membership_market` (the live read);
    the weekly settlement's target is now the market's unless a test pins one, and the read is kept at
    `career.membership_market`. **CROWDING**: `_apply_focus_stat_gains` multiplies each gain by the crowd factor - 1.0
    whenever the floor fits, so an uncrowded gym trains exactly as before.
  - `GymLedgerRead`: the membership line says "walking toward N: a X% share of <city>'s pool of D, split with k rivals ...
    floor load R x its stations - the team trains at Y%".
  - **Decided on measurement, not taste** (`tools/s69_market_probe.gd`, starter boxing floor, five countries): at G74's
    suggested 0.2 peak share and a 1/ratio cut, a big-city STARTER gym (Bangkok, target 143 on 15.3 stations) trained at
    HALF speed from week one - a punishment for picking a city. Shipped: peak share 0.15 (G74's low end), yield
    1 - 0.3 x (ratio - 1), floor 0.6. Bangkok now walks up to 1.60x (yield 0.82); small cities (Nicosia, Suva) sit
    under 1.0 and their target (57-59) is BELOW the old natural count (78), so small-city dues fall ~$250/wk over weeks.
  - `tests/gym_market_test.gd` **30 checks, 0 failures**: G74 weight order, one pool split to 1.0, a floor item raises
    the live target (134 -> 139), a rival's facility change moves it (139 -> 170), the settlement uses it, the ledger names
    it, a packed floor trains worse by exactly the factor, and the MUTANT (slope sign flipped) no longer trains worse.
  - Everything past G74's order is INVENTED and labelled so; G88 (Grok, sent) asks for real peak-share / class-size data.
- **OPS BOARD** (`3cc6da12`, operator requests this session): a **ROADMAP TREE** panel (stage > session > sub-session;
  the `now` session and every agent whose handover line says RUNNING pulse blue; next / deferred / idle branches);
  **Dola on the board** (she was missing from server.py's AGENTS, so a board save silently dropped her); **Kalli, John,
  Maria back in rotation** (operator: "grokbots are back, add them in rotation"); roadmap rows normalised (18 unstaged
  sessions filed, S1 marked done, S69 row added); the NEXT card no longer renders "—" for a string `next`.

## Collected
- **C193** (Codex, blind body-map test): merged. Both of its contract "disagreements" were FIXTURE defects, judged and
  fixed: `Injury.build("laceration", "left_leg", ...)` returns `{}` (a laceration is not a leg injury - `contusion` gives
  train_week 4), and `BodyFigure` sits in a container BELOW `TabBody`, not directly under it. FAILURES 0 after.
- **Q169 r3** (Qwen): taken IN PART. The result_screen_why re-pin (92043) is on master and green. The four GroundGraph trap
  edges were REJECTED: `edges_from` does not filter by kind, so they go live in every mount exchange with no switch.
  judge_panel's boxing_219 (and the later local-only 677/727) were found WITH those edges - on master 219 is a draw.
  Round 4 puts the edges behind `trap_arm`.
- **U165** (Cursor, readable_onset, default OFF): merged (record_room conflict with S68's contact_stop kept both). Its
  headless A/B render had hung 2 h and a stale duplicate cursor-agent from 15:32 shared its worktree - both killed.
- **G86 FEINTS** (Grok): saved verbatim, `research/G86_FEINTS.md`. Feint rate 9-13/min elite amateur (Hussein 2004, the
  only video count); reaction share, landed-rate lift and decay NOT FOUND - gate bands proposed, "the AI must stop biting".
- S66 (stale peer session) review of U164: the kick effector comes from clip_phases.json, which names the PLANT foot ->
  assigned as U166.

## Suite
SUITE total=391 fails=11 (read off the --jobs 4 run): athlete_development, capsule_coverage_contract, fight_body_overlap, fight_metres (runner 600 s timeout, also alone), fight_pace_anchor, fight_pair_live (PARKED), fight_scoring, fight_stage_realism, fighter_reachability_contract, judge_panel (T11), weight_cut - every one on the S67/S68 list; result_screen_why now green; no new red. New green: gym_market_test, body_map_blind_test, fight_readable_onset_test.
The first run was SERIAL (the runner defaults to --jobs 1; S69 forgot the flag): 205 tests in ~75 min at 8% CPU. Killed and rerun with --jobs 4: the whole suite in ~20 min. The roadmap's suite setting now says --jobs 4 on the PC.

## Shown to the operator
U165 A/B (seed 92012 MMA, shot=standing - the digest's shot=tight frames only the legs): rear hook 5.0f -> 10.0f and jab-low-kick 2.9f -> 10.0f, contact unchanged, NO elbow in the 10 s. The two new Cascadeur holds (ClosedGuard, Turtle) as MP4s. Files in research/_captures/watch_loop/s69_*.

## Operator asks, planned (2026-09-24)
Retired fighter -> coach: DOABLE, S72 (J11 already rules it: an offer, roles, coaching from knowledge not wins). Fight hype / gym-vs-gym / tournaments: S73, G89 sent. Named judges/referees + coach leaderboard: S74, G90 sent. Own promotion (late game): S80, TASK_J46 written for John - NOT sent (the Grok Bot app is open without its debug port). Skill-tree-shape blocker removed: the operator had chosen C, phase first.

## Assigned (every agent holds a task)
Codex C194 (blind gym-market contract test, luna) - Cursor U166 (the kicking foot: fix the Q167 effector, re-run the
U164/U165 censuses) - Qwen Q169 r4 (traps behind trap_arm) - Grok G88 (the crowded floor, chat
https://grok.com/c/73e13e39-2230-445d-9725-7e728bd3afa9) - Dola D17 - John R151/SOUND_RESEARCH - Kalli GAME_FLOW/K76 -
Maria ARENA_LOOK.
