# S98 DIGEST - LIMB DAMAGE ON BY DEFAULT (2026-09-27)

## Shipped
- **U189 merged** (Cursor, kickboxing legs that land): `KB_LEG_REGION_SELECT_MULT 2.92` at LONG/MID, +19 lines.
  Its "0 KO/TKO" red flag was the CENSUS: `u189_kb_leg_census.gd` read `state["result"]`, which does not exist - the
  verdict is `FightRealtime.result(state)`. Fixed. Re-run (100 bouts per pair, full KB palette both men): per-plan
  leg share of landed - Thai kicker 20.2%, Dutch pressure 28.0%, counter striker 9.6-9.9%; KO+TKO 20% / 26%.
  G134's real bands: kicker 20-40%, counter 8-15%. Both inside.
- **limb_damage ON by default** for every booked bout: `FightWorldLiveScreen._limb_damage := true` (off by option
  `limb_damage: false` or `-- no_limb_damage`; `-- limb_damage` is a no-op) and `FightNightScreen._realtime_begin_options`
  sets it unless the caller did. Spars stay off (the day tick settles them).
- **Census ON vs OFF** (`tools/s97_limb_census.gd`, now `ruleset=kickboxing|mma|boxing`, 100 bouts, seeds 970000+;
  populations printed: Thai kicker vs counter striker / sprawl-and-brawl vs submission grappler / out-boxer vs pressure
  fighter, all full tier 1-2 palettes, never identical):
  | ruleset | OFF (dec/KO/TKO/sub) | ON | leg HURT unstaged | corner minutes with a problem |
  |---|---|---|---|---|
  | kickboxing 3x3 | 59/26/15/- | 59/26/15/- | 6/100 | 9% |
  | MMA 3x5 | 55/31/6/8 | 54/32/6/8 | 28/100 | 31% |
  | boxing 8x3 | 52/43/5/- | 49/46/5/- | n/a (no legs) | 18%; face pips at the bell 125 -> 51 |
  Every shift is inside its CI95 (+-9-10). Doctor stops 0/300 (anchor ~1.09%, inside the CI).
- **D45 (Dola)**: her one change - the treatment cards now carry the number of the problem they treat, matching the
  numbered badge on the body figure; plus her over-time note: the refused card flashes and the line says "+N s over".
- **Research collected/written**: G134 (leg-kick share + limp curve), G135 (famous trainers, 12 archetypes), D45; and -
  because Kalli/John/Maria's Grok Bot is at its weekly limit - J57 (leg-kick reactions, 3-tier ladder, added to C214),
  K81 (how management games make a coach matter), M37 (dressing the generated fighter) done by Claude.
- **Status deck**: new Sponsors slide (built vs not built).

## Broken and repaired this session
- `95c5d221` (a records commit) swept in U189's WHOLE `FightRealtime.gd`/`FightMoves.gd`, taken with
  `git checkout <branch> -- file` from a branch cut before S97, and pushed a master without limb damage (137 lines).
  Repaired in `50b002ce` (restore + apply U189's diff only). Master was wrong for ~40 min. Memory:
  `feedback_never_take_whole_files_from_a_branch`.
- Kalli/John/Maria had been switched ON by S97 on a false "limit reset" note; restored to OFF (`95c5d221` records).

## Suite
- Nightly 2026-09-27 at `40bec39e`: **439 total, 24 fails** (26 Sep: 13). 17 newly red, 6 newly green (incl.
  sponsorship). ~60 commits (S82-S97) landed between the runs. Qwen Q199 is bisecting all 17 (pin vs defect).
- S98 subsets with limb damage ON: corner_ 8/0, fight_realtime 1/0, fight_kb 1/0; judge_panel 1/1 (red on the nightly
  already); fight_night_realtime 1/1 - NOT the flip: a control with the fight-night default OFF fails identically. The
  kickboxing lab bout (seeded) now ends by TKO in round 1 (beats=10, rests=0), so no corner window opens; it passed on
  the 40bec39e nightly, and U189 is the one engine change since - a seed whose outcome U189 moved. Re-pin in S99.

## Not done (carried to S99)
- The UNSTAGED red-leg clip (a seed where a leg reaches HURT on its own, rendered and sent) - census proves it happens
  (MMA 28/100), the render is owed.
- Codex C214 launch (lighter leg reaction) - after the subsets; Qwen Q198 died at launch (empty out file) and was
  replaced by Q199.
