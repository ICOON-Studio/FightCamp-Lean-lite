# TASK_Q154 - which gloves a ruleset requires is DATA, not a copy in the skin module (Qwen)

Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S61, 2026-09-23.

## Why
S61's `Godot/scripts/CCFighterSkin.gd` decides a fighter's gloves from a hand-written table
(`GLOVES`: boxing/kickboxing/muay_thai -> boxing glove, mma -> mma glove, all else bare). That is a
COPY of ruleset knowledge - the rule this project earned twice ("never keep a copy of the engine's
vocabulary"). The rulesets already live in `Godot/assets/data/combat_rulesets.json` (11 rulesets:
mma, boxing, kickboxing, muay_thai, judo, freestyle_wrestling, greco_roman, karate, bjj, sambo,
taekwondo), and the sourced equipment rules in `Godot/assets/data/competition_rulesets_v2.json`
(`equipment` text per sanctioned ruleset). Karate (WKF mitts), taekwondo (WT gloves) and sambo are
currently bare in the table - check whether that is right.

## Owned files
`Godot/assets/data/combat_rulesets.json` (add ONE field per ruleset), `Godot/scripts/CCFighterSkin.gd`
(ONLY the `GLOVES` table and the one line in `_bind` that reads it - `grep -n GLOVES`),
`Godot/tests/ruleset_gloves_test.gd` (new), `research/Q154_DIGEST.md` (new).

## Do
1. For each of the 11 rulesets add `"gloves": "<style>"`, style in `boxing` | `mma` | `mitt` | `none`,
   chosen from the `equipment` text of the matching `competition_rulesets_v2.json` entry. In the
   digest, a table: ruleset, style, the v2 entry id, and the verbatim equipment phrase (under 15
   words) that decides it. Where v2 has no matching entry, say so and give your source.
2. `CCFighterSkin.gd`: replace the discipline-keyed `GLOVES` with a read of `combat_rulesets.json`
   (`rulesets[i].id == discipline` -> its `gloves`), mapping style -> spec. Keep `BOXING_GLOVE` and
   `MMA_GLOVE`; if you assign `mitt`, add a `MITT_GLOVE` spec (thin, padded knuckle, open fingers - size
   it like `MMA_GLOVE` but `deep` ~0.03) with `"style": "mitt"`. `glove_kind` must stay the style
   string; `none` / unknown discipline -> no gloves, `glove_kind` "".
3. `tests/ruleset_gloves_test.gd`: every ruleset has a legal `gloves` value; the module's choice for
   each id equals the data's (build a tiny synthetic src/dst pair in code - the real CC export is
   gitignored; see `TASK_U148_CC_SKIN_CONTRACT.md` for the contract); an unknown discipline is bare.
   Break it twice (data says `mma` for boxing; module ignores the data) and confirm both fail.

## Gate
Tier: a script edited. Parse gate on the touched `.gd` files, then:
`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/ruleset_gloves_test.gd`,
`... --script tests/fight_cc_skin_test.gd` (must stay 17/17 - it runs on this PC where the export exists),
`python Godot/tools/run_tests.py --only ruleset,grapple,fight_ground_policy` (combat_rulesets.json is read
by FightRealtime - an added key must break nothing). Fails there: ceiling is the pre-change count; run the
same `--only` on master first and print both. Branch `qwen/q154-gloves-data`, digest, one
`agent_comms.py send`. Do NOT edit HANDOFF.md.
