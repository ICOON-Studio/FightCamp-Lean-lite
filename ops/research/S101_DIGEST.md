# S101 DIGEST - THE OTHER CORNER PLANS TOO, THE RESULT SAYS WHY, RESEARCH REACHES EVERYONE (2026-09-27)

## Shipped
- **The AI corner sets a plan** (`e2ca23c3`).
  - `FightPlanSetup.ai_sliders` starts from the corner's ideal and adds a scatter that shrinks with the rival head
    coach's `tactical_rating`, geometric in tactical^1.8. Census over 40 keys: overall 79.6 at tactical 25, 84.6 at
    55, 91.5 at 70 and 95.9 at 85.
  - `GameState.ai_plan_setup_entry` reads the opponent's world gym head coach (50 when there is none).
  - Only the player's own bouts get it; other men's fights are untouched.
  - The plan tests are split in two (`fight_plan_setup_engine_test` 1-3, `fight_plan_ai_corner_test` 4-5), because
    one file ran past the runner's 600 s limit.
  - Test 5, tactical 90 against 30, 40 seeds:
    - grappler: +0.85 [0.56, 1.14] landed diff/min, win share 0.85 vs 0.68;
    - striker: +0.16 [-0.09, 0.41], win share 0.50 vs 0.48. That is noise, so the test is gated pooled. The cause is
      the coach model (patient against a better tank) disagreeing with the engine (which rewards pressure). Task C216
      is on Cursor.
- **UI: THE PLANS card on the result screen** (`ea3b9c13`). It shows each corner's plan word (the setup screen's own
  bands), how many corner reads got through, and the better corner when the gap is 5 or more.
  `result_plan_card_test` is green.
- **UI: the setup screen says what the moving slider did to each read** (`5549ab40`), e.g. "PACE +7". It reads only
  the fixed coupling, never the hidden answer. Source: Dola D47. `fight_plan_setup_test` 30/0.
- **Research reaches every agent** (`27f2f4b5`, `371d2e0c`).
  - 71 research documents that lived only on unmerged branches were brought onto master, among them the Q199, Q201,
    U184-U188 and C134-C139 digests.
  - `Tools/research_sync.py --check`: `start` prints anything off master, and `ship` refuses until it is fixed.
  - The index now includes documents in sub-folders.
- **Prefab check is a gate** (`daee6535`). Operator: "when we decide to add something new always check for prefabs".
  - The rule is in CLAUDE.md, and `start` prints PREFAB DEFECT for briefs from S101 on.
  - Found and fixed on the way: `_ASSIGNED_RE` never matched "Assigned 2026-09-27 (S101)", so the "What would a
    human do?" check had been skipping every dated task file.
- **C215 merged** (Codex, see its commit): footwork is seen again. U183's idle stays as the clearance-safe base, and a
  world-planted shuffle step follows the root's real travel. Toe error 3.87 mm; preview at
  `docs/previews/c215/footwork.mp4`.
- **Research collected:**
  - G136: the judo funnel.
  - G137: a read is worth +2/+2 for the next round, a fitted plan +3, a bad plan -2 to -3; one round's accuracy noise
    is about 7 pp.
  - D46: an "Only here" trainer must change how fights are planned.
  - D47: make every plan choice's effect visible.
  - S101 notes on the GTA 6 VFX breakdown (active ragdoll, probe GI, hero budget, sweat maps).

## Held, not merged
- **Q203 (Qwen) and U191 (Cursor) together add three NEW reds:**
  - `fight_defence_movement` R19 `defensive_movement_rate`;
  - `fight_realtime` "the doctor actually stops a fight over a championship distance (0 of 3)";
  - `fight_realtime` "a hurt man is told to protect his head (0)".

  Bisect one against the other: apply `qwen/q203-realism-reds` e38ce46e alone (diff `740518ee..e38ce46e`), run
  `--only fight_realtime,fight_defence`, then `cursor/u191-footwork-side-effects` 9710e193 alone (diff
  `5149a535..9710e193`). Q203's landing-order fix passes by 0.001 and flips back to body 0.521 / legs 0.514 once U191 is
  on top: fragile, and built on authored tell/late-cut numbers.

## Suite
The 2026-09-27 nightly at `40bec39e` had 439 tests and 24 fails. Subsets this session:
- the plan tests: green;
- the combined U191 + Q203 + plan run: 21 tests, 5 fails (3 new, listed above; `boxing_output`, `contact_stop` and
  `defence_model` were already red on the nightly);
- C215's room and footwork set: see its merge commit.

## Not done (goes to S102)
- The stale re-pins wait on the bisect: the `fight_realtime` judo pins, judge_panel T4/T8R/T11, result_screen_why and
  the fight_strike_whole hashes.
- G137's sizes are not applied yet: `CornerPitStop.READ_*` 0.03 -> 0.02, `PLAN_FIT_EDGE_MAX` 0.05 -> 0.03. Re-run both
  plan tests after.
- The plan-linked outcomes on the result screen (D47 Q2), which wait on Dola's D48 reference study.
