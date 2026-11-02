# TASK U173 - CURSOR - THE DEFENDER MODEL, SLICE 2: anticipate and counter
Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S75, 2026-09-25. Engine lane.

## Why (operator, 2026-09-25, verbatim)
"the defnder, also should to chose to anticipate and counter". Slice 1 (U172, merged S75 default-OFF under
`defence_model`) built perceive -> choose -> execute -> consequence and left the hook
`FightDefenceModel.SLICE2_HOOK_ANTICIPATE_COUNTER` (`FightDefenceModel.gd:24`, `:317`).

## What would a human do?
ANSWERED in `research/J50_HOW_A_DEFENDER_DEFENDS.md` §6 (anticipation: reading the PATTERN and moving before the
tell), §7 (countering), §5 (counter windows after an evade) and §10 "The anticipate-and-counter branch". A fighter who
has seen the same lead three times starts moving early - and a feinter punishes exactly that. Build what those say.

## Slice 2 - under the SAME switch `defence_model` (default OFF)
1. ANTICIPATE: a per-bout memory of the opponent's recent leads (type + setup); after repetition, P(pre-empt) rises with
   fight IQ. A pre-empt defends before the tell (beats a fast strike) but BITES on a feint - wire it to the existing
   feint system (`FightFeint.gd`, the `feint` option), so a feint against an anticipating man is where feints pay.
2. COUNTER: after a successful evade or a well-timed block, the slice-1 opening flag becomes a counter choice weighted
   by style, IQ and stamina; the counter lands into the attacker's J50 §5 exposure. Counter-punchers counter more.
3. Every constant named with SOURCED (J50 §x) / PROXY / AUTHORED.

## Anchors (ceilings) - ON vs OFF, 60+ bouts per arm
Populations: the U172 ones (MMA grappler vs striker, boxing out-boxer vs pressure fighter - never identical, legal for
the ruleset, printed in the output), plus one boxing counter-puncher vs pressure fighter pair.
Defence rate stays 45-65%; D1 6.0-8.0; counters are a minority of landed strikes (use J50 §7/§8's sourced share if one
exists, else report the number); the counter-puncher lands more counters than the pressure fighter (ordering only).
Print the decomposition: pre-empts, pre-empts bitten by feints, counters thrown/landed by style.

## Owned files
`Godot/scripts/FightDefenceModel.gd` (318 lines, read whole), `Godot/scripts/FightRealtime.gd` (5,578 lines - NEVER
open whole; `grep -n "defence_model\|FightDefenceModel"` for the slice-1 call sites, then `sed -n` windows),
`Godot/scripts/FightFeint.gd` (read-only unless the bite needs a hook), `Godot/tests/fight_defence_model_test.gd`,
`Godot/tools/u172_defence_measure.gd`, `research/U173_DIGEST.md`.

## Gate (tier: script edited)
Parse gate first. Then `python Godot/tools/run_tests.py --only <x>` for fight_defence_model, fight_realtime, feint,
judge, fight_pace, fight_hit (fight_pace_anchor fails at D1 5.79 on master - equal or better). OFF hashes from
`Godot/tools/s70_feint_off_hash.gd` byte-identical to origin/master (paste both). Prove each new check with a mutant.
Worktree `C:\Users\user\AppData\Local\Temp\FightCamp-U171`: `git fetch origin && git checkout -B cursor/u173-defender-slice2
origin/master`, then `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --import` once. Commit explicit
paths, push the branch, then `python Tools/agent_comms.py send --from cursor --to claude --topic U173 --body "<numbers>"`.
Do NOT read HANDOFF.md or CURRENT_STATUS.md. All research is open: root RESEARCH_INDEX.md.

## The one trap
An anticipation that only ever helps the defender is a free buff and will push the defence rate out of band. It must be
exploitable: the feint bite is not polish, it is what keeps the number honest.
