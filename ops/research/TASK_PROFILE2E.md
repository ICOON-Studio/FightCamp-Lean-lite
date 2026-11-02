# TASK PROFILE2E (S209) - fighter profile: 7 tabs -> 5 full-screen tabs, MEDICAL & BIO from the operator's four boxes

Model: Cursor (local CLI, `cursor_task.cmd`), worktree E:/FightCamp/wt/PROFILE2E, branch cursor/profile2e. Commit + push the branch; never master.
Operator approved Ludo round 43 on the board (Q-S207-2, verbatim answer: "Approve all"). Verdict: `research/LUDO_ROUND43_VERDICT_S208.md`
(read it whole - it is short). Ludo's pixel specs: `research/LUDO_ROUND43_S208_reply1.txt` .. `reply4.txt` (~100k chars - read
ONLY the sections named below, by line window).

## What to build
1. TAB BAR 7 -> 5 (`Godot/scripts/ui/ProfileOverview.gd` line 26 holds the 7 names; `_build_tab_bar` ~142, `_build_tab_body` ~125):
   OVERVIEW, TECHNIQUES, PERFORMANCE & CAMP, MEDICAL & BIO, CAREER & CONTRACT. Live number on two tabs: TECHNIQUES "{learned}/{total}"
   (TechniqueTree counts already used by `ProfileTabHost._build_techniques`), MEDICAL & BIO "WEAR {career_wear}%" (the wear the profile
   already reads in `_build_medical_wear`). Spec: reply1 line 48 "1.4 Tab Navigation Header Bar".
2. MEDICAL & BIO (new builder; new file `Godot/scripts/ui/ProfileMedical.gd` so ProfileTabHost.gd does not grow; route it from
   `ProfileTabs.medical`). Four boxes, rects from Ludo:
   - LEFT rect(16,128,500,936): body diagram, 6 regions coloured by wear green->yellow->orange->red, FRONT/BACK toggle, injury pins, then the
     injury list (region, severity, weeks out); career-wear badge on top. Spec reply1 line 213 "3.1". Reuse the existing body-map
     drawing (`profile_body_map_test.gd` covers it - find the drawer it tests) and `_build_medical_wear` / `_build_medical_injuries`
     reads (ProfileTabHost.gd 330-465) - same data, new layout.
   - CENTRE TOP rect(532,128,776,420) DIAGNOSIS: doctor's verdict line, STRESS meter with the APPROVED bands CALM 0-49 / STRAINED 50-79 /
     ON EDGE 80-99 / BREAKING 100 (never Ludo's 0-25-50-75 zones), the active affliction or virtue card, weight status, fit-to-fight week.
     Spec reply1 line 244 + reply2 line 6 "3.2 (Continued)". Stress data = `athlete["stress"]` written each week by
     `GameState.advance_week` (STRESS1B_B, merged this session; StressWeek.gd / StressRules.gd in scripts/rules give the keys - open them).
   - CENTRE BOTTOM rect(532,560,776,504) FACE CLOSE-UP: a live SubViewport + Camera3D on his MetaHuman head (portrait lens ~50 mm equiv,
     soft key + rim light), cut pins on the face with stitches and reopen chance from CutScar (`scripts/rules/CutScar.gd`, already preloaded
     in ProfileTabHost). Spec reply2 line 43 "3.3". Use the same MetaHuman load path the profile stage uses (`scripts/ui/ProfileStage.gd`).
     Headless (`--headless` tests): no model load - the tests already pass `load_models=false`-style flags; follow ProfileStage's pattern.
   - RIGHT rect(1324,128,580,936) TREATMENTS, one card each: who, cost (money/days/stress), effect, one button + confirm. Spec reply2
     line 69 "3.4". A card is shown ONLY when a real GameState action exists for it: grep GameState.gd for it (e.g. `set_weight_cut_plan`
     line 2201, `act_on_weight_cut` 2214; physio / deload / medical hold / office talk - search, never invent). Buttons emit signals; the
     caller wires them to GameState as the existing tabs do. A missing action = no card (list the ones you left out in the digest).
   - Unhurt boxer: still a full screen - "CLEARED TO SPAR", clean body, the treatments he can book ahead (reply2 3.4 end).
3. PERFORMANCE & CAMP = the current TRAINING PLAN builder (`ProfileTabHost._build_training_plan` ~466) + CAMP (`ProfileTabsB.camp` ~152)
   in one 3-column screen. Spec reply2 line 126 "4.1".
4. CAREER & CONTRACT = FIGHT RECORD (`ProfileTabsB.record` ~88) + CONTRACT (`ProfileTabsB.contract` ~125) in one screen. Spec reply2 line 168 "4.2".
5. AAA polish (reply4 line 213 "11.1".."11.5"): soft panel shadows, faint inner glow on the active card, tab switch ~180 ms fade,
   hover lift 2 px, one type scale. Apply to the five tabs only.

## THE RULE ABOVE LUDO'S SPEC: his LAYOUT, only REAL data
Ludo's numbers and names are examples. A field is drawn ONLY when a real read supplies it; otherwise the element is left out or shows
the honest empty state. Never a placeholder number, invented person ("Marcus Abernathy", "Tariq Aziz"), event ("BFC 108") or ranking.
No grappling anything (boxing demo). Tooltips name real causes from his stress log, effects only from our stress rules. kg / $ only.
Fonts: the project's ChakraPetch + JetBrainsMono (ProfileOverview preloads them). Colours: ProfileTabsLayout.gd tokens.

## Owned files (line counts at brief time)
ProfileOverview.gd 612, ProfileTabs.gd 73, ProfileTabHost.gd 535, ProfileTabsB.gd 714, ProfileTabsLayout.gd 172 (all Godot/scripts/ui/),
NEW Godot/scripts/ui/ProfileMedical.gd, NEW Godot/tests/profile_medical_bio_test.gd, and the existing profile tests that assert the
7 tab names (update them to 5: profile_tabs_test, profile_tabs_wiring_test, profile_overview_test, profile_tabs_b_test,
profile_techniques_test, profile_layout_test). Never GameState.gd (read windows only: `sed -n 2195,2230p`), never FightRealtime.gd.

## Tests (tier: scripts edited)
- Parse gate first: `python Godot/tools/check_scripts.py <every touched .gd>`.
- New `profile_medical_bio_test.gd`: (a) 5 tab names exactly, in order; (b) an injured fixture athlete (two DIFFERENT fixture athletes,
  different stats - never identical) shows the 4 boxes with his real injury rows and a stress band label that matches his stress value
  under CALM/STRAINED/ON EDGE/BREAKING; (c) an unhurt athlete shows "CLEARED TO SPAR" and no injury rows; (d) no Label anywhere in the
  five tabs contains a string from this blacklist: "Abernathy", "Aziz", "BFC", "Grappling", "Lorem", "TBD", "#14"; (e) treatment cards
  only for actions GameState really has (test asserts each card's action name `has_method` on GameState).
  Prove it red first: run it on the untouched branch start - it must FAIL (7 tabs), then green on your work.
- Then: `python Godot/tools/run_tests.py --jobs 2 --only profile` (all profile tests green; jobs 1 if the watchdog is not GREEN).
- Stills: extend `Godot/tools/profile2_stills.gd` to save the 5 tabs (injured boxer + unhurt boxer for MEDICAL & BIO) to
  `previews/profile2e/`. Windowed runs ONLY via
  `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/profile2_stills.gd` (hidden desktop).
  Never open an image viewer, explorer or browser; look at stills only with your file-read tool (you cannot see images - instead check
  geometry in code: every panel rect inside 1920x1080, no two panels overlapping, every Label's text fits its rect).

## Before every heavy step
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` - exit 1 (RED) = wait, never start a Godot run on RED.

## Prior research
LUDO_ROUND43_VERDICT_S208.md (this design, approved), LUDO_ROUND41_S206_reply1-3.txt (7-tab spec it replaces), TASK_PROFILE2D.md (real
reads for record/contract/camp), LUDO_ROUND37_VERDICT_S202.md (no invented numbers).

## What would a human do?
Football Manager's player screen / OOTP player card: every tab a full designed page, real numbers, honest blanks, the medical page a
doctor's chart with the treatment decisions beside it.

## Prefab check
None - project UI kit (ProfileTabsLayout tokens).

## The one trap
Ludo's spec names fields we do not store (treatment costs, recovery %, scar reopen odds per cut). Check each key exists in the real
read before drawing it - a missing key means the element is left out, not filled.

## Done = branch pushed with: 5 tabs live, MEDICAL & BIO 4 boxes, merged PERF&CAMP and CAREER&CONTRACT, the new test red->green, the
profile suite green, stills in docs/previews/profile2e, and `research/PROFILE2E_DIGEST.md` (what was built, which Ludo elements
were left out for lack of data, test lines).
