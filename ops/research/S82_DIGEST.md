# S82 DIGEST - HOME tells the truth, the nightly's reds triaged, Mixamo in the building
Claude, 2026-09-26 (operator present from ~09:00).

## Shipped (all on master, all pushed)
- **HOME with state.** `HomePinReads.gd` gives each HOME pin ONE live count read from the SAME GameState read as the
  page behind it: Office = offers + open asks (`get_fight_offers`, `get_open_requests`); Staff room = fighters with no
  coach + coach contracts ending in <= 2 weeks (`get_staff_board`); The ring = fighters whose week plan uses a ring
  station; Gym floor = fighters on any station (`get_gym_hub` floor users). Grammar from G109: an amber count badge only
  when there is something to act on, a zero says so in words on the plate ("Set this week's training", "No ring work
  this week"), extra nouns in the tooltip. `home_pin_counts_test` derives every expectation from the PAGE's own getter,
  not the module: 38/0, two mutants caught.
- **Occupancy picture swap.** HOME's picture follows fighters on a plan: sparse <= 3 (the S80 picture), working 4-9,
  packed 10+ (`home_gym_bg_working.jpg` / `_packed.jpg`, gpt_image_2_5 edits of the same shot, ~0.5 credit total,
  logged in HIGGSFIELD_PROMPT_LOG). A missing variant falls back to the sparse picture. `CareerRoot.home_picture()`.
  Sent to the operator as `research/s82/home_before_after.jpg`. D26 (Dola): keep all three; packed "edges toward
  uncanny" - the operator's eye decides; FALLBACK is one picture + the counts.
- **The four S81 bugs**: Continue's subtitle now "N to answer" beside the word (no overlap); the Needs-you badge sits
  after the heading's measured width; the camp tab tells a BOOKED fighter where his camp is set (HOME, Needs you)
  instead of "a camp opens once a bout is booked"; fight week with no camp possible drops the "CAMP WEEKS 0" tile and
  says it in one plain line.
- **Nightly reds triaged (7):** `weight_cut` was a REAL DEFECT - every booked-event read (`_weight_class_for`, the camp
  contract, the ruleset, the country) used the card's bout 0, not the player's open-slot bout; a Middleweight booking
  was weighed as a Flyweight. `open_slot_bout_index()` fixes all four; the test now also checks offer class == contract
  class. `header_real_date` and `sponsorship` were stale tests - fixed to the S80 date format and the S76 real-org-names
  ruling. `fight_pace_anchor` is green after Q183 (6.35/min in 6-8). `asset_manifest` - C207/C209 folders claimed.
  `capsule_coverage_contract` - `CapsuleCoverage.gd` written to the G73 blind contract (1284/0; the blind test caught
  r<0 and float32 surface tolerance). `fighter_reachability_contract` (neck grips unreachable on both rigs since C158)
  -> C211 (Codex, queued).
- **Mixamo, on the operator's word** ("try mixamo for animations as an alternative"): C210 (Codex) found NO owned
  training motion and named Mixamo as the $0 first audition. The operator signed in in the browser pane and approved
  the download: Punching Bag, Jumping Rope, Warming Up (Boxing Warm Up Exercise), Speedbag - FBX, no skin, 30 fps, in
  `assets/anim/mixamo_audition/`, manifest `candidate`. C212 (Codex, gpt-6-astra) auditions them on f01.
- **Collected**: U176 (both corners gloved per ruleset), Q183 (footwork economy ON for all rulesets), G109 (hub live
  counts), G110 (rooms / media hire / scouting file - S83's research with sourced costs and a designer table), C210,
  D26.
- **Assigned from G108**: Q184 (Qwen, kickboxing finishes 7% vs Glory 33%), U178 (Cursor, MMA leg share 5% vs UFC 16%).

## Tests (subsets; the full suite is the nightly)
home_pin_counts 38/0; S82 subset (home_pin, day_feed, shell, fight_week, training_hub, menu_clarity, scene_router,
setpiece, gym_hub, career_loop_walk, smoke) 14/0; booking subset (weight, booking, camp, fight_night, event, open_slot,
career_loop, sponsorship, header_real) 20/0; asset_manifest + home_pin 2/0; capsule_coverage_contract 1284 checks/0;
fight_pace_anchor 20/0; merge subset (gloves, footwork, cc_skin, ruleset_gloves, fight_world_live) 9/0.
**Full suite: last nightly 2026-09-26 04:00 at 9847dd13, SUITE total=416 fails=13** (AgentComms/nightly/latest.txt);
of its 13, five are fixed here and one assigned; tonight's run is the check.

## Operator notes
- Blender: nothing of Claude's was in Blender - the HOME pictures came from Higgsfield's image service. The Higgsfield
  bridge reports Blender NOT connected; the Higgsfield add-on in Blender must be enabled and signed in to drive it.
- Codex's 01:41 401 was a token refresh, not a login problem; C210 and C212 ran on it today.

## Known, not fixed
- Packed HOME picture may read uncanny (duplicate figures) - operator's eye.
- The live fight's debug overlay text still sits under the round plate (U176 stills).
- Kalli, John, Maria blocked until ~2026-10-01 (Grok Bot weekly limit).
