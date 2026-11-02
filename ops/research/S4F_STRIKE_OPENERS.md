# S4f — THE FIVE PUNCHES NOBODY THREW, AND THE ONE NOBODY COULD SEE

`strike_openers` is ON by default from 2026-09-17. S4 (3b) built the switch and left it
OFF because turning it on moves every seeded pin in the project; this is that flip, its
re-baseline, and the two questions the roadmap held open behind it.

**Both open questions are answered, and one of them was never an engine defect at all.**

## WHAT THE SWITCH DOES

`chain_open` and `entry_open` are **striking** setup words that sat in
`FightMoves.GRAPPLE_EFFECTS`, so `move_from_node` refused every node carrying one before
any fight started:

`boxing_rear_uppercut` · `boxing_double_jab` · `boxing_jab_body` · `boxing_feint` ·
`boxing_rhythm_change` · `kickboxing_question_mark`

in boxing, kickboxing, muay thai and MMA alike. It was never a deletion: `grapple_move_from_node`
reads the same list POSITIVELY, so removing the words would have dropped `mma_jab_levelchange`
out of both palettes. S4 (3b) fixed the data where the data was wrong and put the rest behind
this switch. `false` still gets the pre-S4f engine back byte-for-byte, and that is the arm the
A/B below measures.

Flipped in three places so that "no argument" means what the engine actually does:
`FightRealtime.begin`'s option default, and the `strike_openers` parameter defaults on
`FightMoves.arsenal`, `moves_for` and `move_from_node`.

## THE A/B — `tools/probe_technique_coverage.gd -- seeds=20 [openers]`

Population, named in the probe's own output: two men differentiated INSIDE each ruleset —
A 183 cm reach with striker attributes, B 176 cm with grappler attributes — neither missing a
technique his ruleset permits (operator rules 2026-09-12). Catalogue
`assets/data/technique_catalog.json`, 696 nodes, 20 seeds per ruleset.

| ruleset | palette OFF → ON | strikes thrown | top-5 share OFF → ON | leg share OFF → ON |
|---|---|---:|---|---|
| boxing | 13 → **17** | 8,581 | 47.3% → **40.0%** | — (boxing zeroes the legs) |
| kickboxing | 24 → **28** | 9,090 | 32.2% → **28.8%** | 7.3% → 7.2% |
| muay thai | 39 → **43** | 11,944 | 13.8% → **12.3%** | 8.9% → 8.9% |
| mma | 51 → **55** | 14,968 | 26.2% → **23.8%** | 8.4% → **8.0%** |

**The fight is measurably less repetitive.** Boxing's five most-thrown punches fall from 47.3%
of everything to 40.0%, and `boxing_rear_uppercut` goes straight into kickboxing's top five at
500 throws. Nothing was tuned to produce that; four techniques stopped being refused.

The only node still refused in boxing, kickboxing and muay thai is `boxing_pivot_footwork`,
whose role is `adaptation` rather than a strike role — **refused correctly**, and C133 Q4
already recorded that this engine has nowhere for a movement that is not a blow.

## FINDING 1 — `boxing_feint` WAS NEVER UNSELECTED. THE PROBE COULD NOT SEE IT.

S4E_MOVE_ANATOMY's open item 1 read: *"`boxing_feint` enters the palette and is still never
thrown in any ruleset, over four arms. Reachable and unselected is a different defect from
unreachable, and it is not diagnosed."*

It is diagnosed now, and the defect was in the instrument:

- `FightRealtime._log_action` types a feint `"feint"`, never `"action"` — deliberately, S4e (5),
  *"a feint is not a strike and is not typed as one"*, so that every consumer filtering on
  `type == "action"` is byte-unchanged and no strike count moves.
- `probe_technique_coverage.gd` filtered on `type == "action"`.

So the probe was structurally incapable of counting the one technique it was reporting as
missing. With the filter widened (feints counted **apart**, so every strike figure above stays
comparable with earlier runs):

| ruleset | `boxing_feint` thrown |
|---|---:|
| boxing | **607** |
| kickboxing | **397** |
| MMA | **289** |
| muay thai | **247** |

**1,540 feints over 80 bouts.** The technique works, it was chosen constantly the moment the
palette admitted it, and four arms of a previous stage reported it as an unexplained hole.

**AND THE OFF ARM WAS ALREADY FEINTING.** `boxing_distance_read` (814 in boxing) and
`kickboxing_switch_step_read` (450 in kickboxing) are thrown as feints with the switch OFF —
which is the second half of the same blind spot, and a claim to check: the probe classifies
both as PASSIVE `skill` nodes that are *"never meant to appear as an action"*. They are not
passive. `move_from_node` does not read `kind`, the picker selects them, and
`FightCommitment.is_feint_effects` turns them into feints. That is arguably the right
behaviour — a man taking a distance read IS a feint-shaped movement with no damage word — but
the comment asserting otherwise is now false, and the probe's coverage denominator excludes
nodes the engine throws thousands of times. **Reported, not fixed here:** it predates this
flip, it is visible in both arms, and the `THROWN BUT IN NO STANDING PALETTE` line names them
honestly.

## FINDING 2 — THE MMA LEG SHARE DOES NOT MOVE, AND THE PALETTE IS NOT THE LEVER

`fight_realtime_test`'s C85 check, seeds 17001..17020, LANDED targets:

**head 48.1% / body 44.2% / leg 7.7%** against J20 D3's documented **61-65 / 19-23 / 14-18**.

Before the flip it read 7.5%. **Four more techniques per palette moved the leg share by two
tenths of a point.** The probe's THROWN mix agrees independently: MMA 8.4% → 8.0%, muay thai
8.9% → 8.9%, kickboxing 7.3% → 7.2%.

This is the second independent negative on the same hypothesis — S4 (3b)'s unlocked fixture,
which hands both men every node in the catalogue, moved it 7.7% → 7.5%. **A bigger palette is
not the lever**, and the roadmap has named technique selection as the lever for months. What
is left to test is the WEIGHTING, not the contents: `FightMoves.select` walks
`role_w * share * region_w * fit * stance_w`, and the region shares come from
`_regions_for`, where a kick with no named target gets the ruleset's own spread. A negative is
worth writing down; it is not a failure.

## THE RE-BASELINE — four tests moved, none relaxed

Discovery run at the flip: **SUITE total=303 fails=9** against master's known five
(`athlete_development`, `fight_pair_live`, `fight_scoring`, `fight_stage_presenter_contract`,
`fight_stage_realism`). The four that moved:

| test | what it was | how it was answered |
| --- | --- | --- |
| `fight_stage_director_test` | synthetic beat cross-check | **a fixture gap, not a pin**: the mirror omitted `hand`, which `Director.frame` reads |
| `fight_realtime_test` | doctor stoppage, 3 pinned seeds | RE-FOUND by sweep: 4406 4409 4410, 25 of 100 |
| `fight_realtime_test` | corner reaches the `defence` focus | RE-FOUND by sliding the BASE: 81000 → **81004** |
| `grapple_adapter_test` | MT witness seed + 6 striking figures | RE-FOUND by sweep: 93024 → **93049**, 18 of 400 |
| `judge_panel_test` | T4/T8R, 13 seeded scorecards | re-pinned from the test's own printed actual |
| `judge_panel_test` | T11, a SPLIT and a MAJORITY | RE-FOUND by a WIDENED sweep: boxing 381, kickboxing 345 |

### THE MIRROR THAT AGREED BY LUCK

`fight_stage_director_test` builds a synthetic beat from *"the frame-driving fields"* of the
first real action and requires `Director.frame` to return the same thing. `hand` became
frame-driving in S4e (3) and was never added to the mirror, so `hand_for` fell through to TICK
PARITY on the synthetic side. It passed only while the first real action of that seeded bout
named no hand — and `strike_openers` puts `boxing_rear_uppercut`, which names the rear hand,
into boxing's palette. **A mirror that omits a field the function reads is not a mirror; it is
a second fixture that agrees by luck.** Adding the field is a strengthening, not a re-pin.

### THE CORNER PIN IS A FORMULA, SO THE BASE IS WHAT SLIDES

`_test_the_corner_actually_speaks` pins `81000 + which * 700 + index * 19`, not a seed list, and
asserts the corner reaches the `defence` focus. `defence` needs a head at or under 28
(`CornerAdvice.gd:15`) with nothing gassed in front of it. `tools/find_s4f_seeds.gd -- corner`
reports what the ENGINE reaches before it reports which base reaches it — lowest head any
corner saw, per base: 81000 **35.6** / 81001 **29.3** / 81002 **43.3** / 81003 **32.2** /
**81004 20.4**. 81004 is the first base where every assertion holds at once (defence 3, all
three urgencies, varied 16 of 24). Picking seeds to match would have been choosing the
population; the judo window got this same treatment in S4 (4).

### T11 AND THE ONE PLACE A WIDER SEARCH WAS THE RIGHT ANSWER

The canonical sweep (`find_r101_seeds.gd -- panel`, 1..300 per ruleset) returns **no split in
either ruleset** after the flip — boxing 3 majority / 6 majority_draw, kickboxing 1 / 1. That is
the position S4e (2) answered by pinning two weaker non-unanimous families, and S4 (4) answered
by giving up cross-ruleset coverage.

Neither compromise was needed. A split needs closely matched men and R100 measured it at **1 in
360**, so the SEARCH was widened on the SAME 62-v-64 fixture rather than the fixture being
changed to produce one (`find_s4f_seeds.gd -- panelwide`, seeds 301..900 per ruleset):

| ruleset | unanimous | unan. draw | majority | maj. draw | **split** | split_draw | stopped |
|---|---:|---:|---:|---:|---:|---:|---:|
| boxing | 401 | 29 | 10 | 11 | **3** (381 454 659) | 2 | 144 |
| kickboxing | 483 | 50 | 9 (345 first) | 8 | **1** (513) | 1 | 48 |

Both rulesets reach both families for real, so T11 gets the strongest pair it has ever had AND
recovers the cross-ruleset coverage S4 (4) recorded as the thing it gave up: **SPLIT boxing 381,
MAJORITY kickboxing 345**, each the first hit in ascending order in its own ruleset.
**Widening a SEARCH is not relaxing an ASSERTION** — the men, the rounds and the catalogue are
untouched, and what changed is how many bouts were looked at.

### FIGHTS RUN SHORTER, WHICH IS THE OPPOSITE OF S4 (4)

Recorded because the last engine stage moved it the other way. Off the 13 re-pinned cards:
`boxing_300` went from an eight-round unanimous decision to a **round-3 KO**, `boxing_23` from
an eight-round decision to a **round-7 KO**, `mma_5` from a three-round decision to a **round-2
KO**, `boxing_20`'s KO from round 6 to round 5. Two went the other way (`boxing_11` 1 → 2
rounds, `kickboxing_13` a round-1 KO → a three-round decision). Men with more punches available
land more of them. REPORTED, NOT TUNED — not one constant was moved.

## WHAT THIS DELIBERATELY DOES NOT DO

- It does not touch `GRAPPLE_EFFECTS`. The two words stay in the list and stay read positively
  by `grapple_move_from_node`; the switch skips them on the striking side only.
- It does not fix the probe's PASSIVE classification (finding 1, second half) or the coverage
  denominator that follows from it. Both predate the flip and changing the denominator now
  would break comparability with every run recorded in S4E_MOVE_ANATOMY.
- It does not chase the leg share. Finding 2 says where the lever is not; it does not build one.

## OPEN

1. **The leg share needs a WEIGHTING experiment, not a palette one.** Two independent negatives
   now. `FightMoves._regions_for`'s `kick_damage` spread and `select`'s joint walk are where to
   look.
2. **`boxing_pivot_footwork` and `kickboxing_switch_kick` are still in no palette**, correctly
   for the first (role `adaptation`) and undiagnosed for the second.
3. **Two `skill` nodes are thrown as feints in both arms.** Either the catalogue's `kind` is
   wrong for them or the probe's comment is. Worth one pass, worth nothing urgent.
4. **`mma_guard_gnp` is thrown but is in no standing palette** — unchanged by this stage and
   still the grapple arsenal's own business.

## Re-running it

```
python Godot/tools/check_scripts.py Godot/scripts/FightMoves.gd Godot/scripts/FightRealtime.gd
godot --headless --path Godot --script tools/probe_technique_coverage.gd -- seeds=20
godot --headless --path Godot --script tools/probe_technique_coverage.gd -- seeds=20 openers
godot --headless --path Godot --script tools/find_s4f_seeds.gd -- doctor
godot --headless --path Godot --script tools/find_s4f_seeds.gd -- corner
godot --headless --path Godot --script tools/find_s4f_seeds.gd -- panelwide
godot --headless --path Godot --script tools/find_r102_seeds.gd -- mt
python Godot/tools/run_tests.py --timeout 1200
```
