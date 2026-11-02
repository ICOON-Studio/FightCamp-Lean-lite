# Q154 digest - gloves are ruleset data, not a copy in the skin module

## What changed
- `combat_rulesets.json`: added `"gloves"` field to all 11 rulesets (boxing | mma | mitt | none)
- `CCFighterSkin.gd`: removed the hardcoded `GLOVES` table; `_gloves_style_for()` reads the style from `combat_rulesets.json` at bind time. Added `MITT_GLOVE` spec (thin padded knuckle, open fingers, deep=0.03). `_STYLE_TO_SPEC` maps style string -> spec dict.
- `tests/ruleset_gloves_test.gd`: new, 38 checks - every ruleset legal, module matches data, anchors catch corruption, unknown is bare, all three specs present

## Gloves assignment table

| ruleset | gloves | v2 entry id | source phrase |
|---|---|---|---|
| mma | mma | mma_abc_professional | ABC pro MMA: 4-6 oz open-finger gloves (domain knowledge; v2 has no equipment field) |
| boxing | boxing | boxing_abc_professional_male | ABC pro boxing: 8-10 oz padded gloves (domain knowledge; v2 has no equipment field) |
| kickboxing | boxing | kickboxing_wako_full_contact | Wako/ISKA kickboxing: boxing gloves (domain knowledge; v2 has no equipment field) |
| muay_thai | boxing | muay_thai_ifma_combat | IFMA/Muay Thai: boxing gloves (domain knowledge; v2 has no equipment field) |
| judo | none | judo_ijf | IJF judo: no gloves, grip the gi (domain knowledge; v2 has no equipment field) |
| freestyle_wrestling | none | wrestling_uww_freestyle | UWW freestyle: no gloves, grip the opponent (domain knowledge; v2 has no equipment field) |
| greco_roman | none | wrestling_uww_greco_roman | UWW greco: no gloves, upper-body grip (domain knowledge; v2 has no equipment field) |
| karate | mitt | karate_wkf_kumite | WKF kumite: WKF-approved padded mitts (domain knowledge; v2 has no equipment field) |
| bjj | none | bjj_ibjjf_nogi | IBJJF: no gloves, grip the body/gi (domain knowledge; v2 has no equipment field) |
| sambo | mma | sambo_fias_combat | FIAS combat sambo: open-finger striking gloves similar to MMA (domain knowledge; v2 has no equipment field) |
| taekwondo | boxing | taekwondo_wt | WT taekwondo: WT-approved fist protectors, padded like boxing gloves (domain knowledge; v2 has no equipment field) |

**Note:** `competition_rulesets_v2.json` has no `equipment` field for any of the 11 matching entries (only capoeira and arnis have one). All assignments above are from domain knowledge of each sport's governing-body rules.

## Break-twice verification
- Break 1 (data says mma for boxing): anchor check fails - `anchor: boxing must be 'boxing' (got 'mma')` - 1 fail
- Break 2 (module returns "" for everything): 10 fails - all module-vs-data checks and all anchors fail

## Gate
- Parse gate: 2 files, 0 fails
- `ruleset_gloves_test.gd`: 38/38 pass
- `fight_cc_skin_test.gd`: SKIP (no CC export in worktree - Claude rerun on main checkout)
- `run_tests.py --only ruleset,grapple,fight_ground_policy`:
  - master baseline: 13 total, 1 fail (the new test file, expected - feature not on master)
  - Q154 branch: 13 total, 0 fails
