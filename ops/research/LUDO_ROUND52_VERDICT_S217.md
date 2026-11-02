# LUDO ROUND 52 VERDICT (S217) - story skippable, story = the tutorial
Operator (verbatim): "i want the story to be able to be skipped and be played as a normal management/simulator , use the story
as a tutorial and confirm with ludo if it agrees". Ludo reply: 27,966 chars, one message, chat "Gym Management Screen"
(Brave blocks saving the page; decisions transcribed below, full text stays in the Ludo chat).

## Ludo: "STRONGLY AGREE WITH ONE CRITICAL ARCHITECTURAL REFINEMENT"
Refinement: two independent switches, not one - STORY (CAMPAIGN interrupt / BESIDE inbox / OFF) and GUIDANCE (ON / OFF).
New Career shows 3 presets + an advanced override:
1. THE HOUSE THAT HOLDS (recommended) - story ON + guidance ON (Mara Solano at Calder House).
2. GUIDED SANDBOX - story OFF + guidance ON (generated gym and roster, neutral checklist, no named cast).
3. OPEN SANDBOX - story OFF + guidance OFF (every system open day 1).
(custom) CAMPAIGN VETERAN - story ON + guidance OFF (replays without hand-holding).

Leave the story any time: Settings -> "CONVERT TO PURE SANDBOX" with a confirm modal. Cash, roster, injuries, records, attributes
and signed contracts carry on unchanged; Rook Hale / Hale Yard / Jace Vellin / Northline become ordinary sim entities (rivalry
heat -> the sandbox rivalry metrics); story_mode = OFF permanently - ONE-WAY (cannot be turned back on). Guidance toggles any time.

One cast: Leo and "Anvil Street" retired; Mara "Wire" Solano (orthodox welterweight) at Calder House Gym. The 16 first-hour
beats map onto Kalli's Chapter 1 (Ludo's table): keys/hub -> Mara's profile -> technique tree (one_two) -> week plan -> advance
-> week review (wear) -> amateur draw + scouting (Perez) -> bout 1 -> corner -> verdict -> the bill + Cass Orth/Northline offer
-> regional card shared with Hale Yard (Vellin) -> weigh-in (rivalry heat starts) -> bout 2 -> swelling + doctor + towel ->
Chapter 1 end, full sandbox unlocked.

Sandbox parity (nothing story-gated): procedural predatory promoters; the doctor/towel from the real medical engine; organic
rivalries; all 54 techniques by coach/attributes only; facilities by cash only.
Edge cases: a lost bout never ends the run (line changes, ladder updates); cash < 0 two weeks -> debt event (loan / short-notice
fight / cut amenities); guidance never blocks Advance (objective tray); BESIDE cards expire with a neutral flag.
Tests (7): sandbox_zero_story (52 weeks, no story state), abandon_story_state (world bit-identical, listeners off),
sim_loss_continuity, guidance_non_blocking, full_tree_sandbox, beside_card_expiry, unified_roster_names (no Leo/Anvil Street).

## CLAUDE VERDICT - TAKE IT, with three corrections
TAKEN: the two switches + 3 presets + custom; the one-way convert-to-sandbox; one cast (Mara/Calder House; Leo + Anvil Street
retired); the 16-beat mapping; sandbox parity; the edge-case rules; the 7 tests.
CORRECTIONS:
1. Ludo's mapping DROPPED two lessons the first hour teaches today: "Lock one, sacrifice one" at the Thursday test spar (SPAR1,
   taken S188) and the weigh-in cut choice (safe sweat / sauna). Both go back in: lock/sacrifice on the fight-week beat before
   the weigh-in; the cut choice on the weigh-in beat.
2. "9 player-facing attribute bars" is wrong - the profile shows the 6 core stats + the 2 approved readouts (Recovery Rate,
   Cut & Swell Resistance, board Q-S212-7). Beat 2 teaches what the profile really shows.
3. Mara is a woman: her opponents are women (Perez is written as Elena Perez - correct); the fight bodies come from the 3 female
   MetaHumans (boxers 10-12, S217 cast fix). Females never fight males.
BUILD (after the operator's OK, in this order): STORYMODE1 (StoryCampaign two switches + presets + convert, tests 1/2/6) ->
STORYTUT1 (first_hour.json recast to Mara/Calder House + the 16-beat card text, tests 3/4/7) -> STORYPARITY1 (procedural
promoter offers + debt event in sandbox, test 5).
