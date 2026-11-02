# TASK U189 - CURSOR - KICKBOXING LEG KICKS THAT LAND (U178B FOR THE KICKBOXING RULESET) (S97)
Owner: cursor. Assigned 2026-09-27 (S97). Model: Composer, medium, `-p --force --trust`.
Branch: `cursor/u189-kb-leg-share`, cut from `origin/master` in Temp/FightCamp-U171. Claude merges; never merge master in.
If the quota runs out, COMMIT AND PUSH with a digest saying where you stopped.

## Why
S97 built live limb damage behind `limb_damage` (a HURT leg slows the feet and limps; the corner ices it). It cannot
fire: in kickboxing only **~2.3 leg strikes land per fighter per bout** (S97 census, 40 bouts: torso 22.4, head 27.1,
legs 4.6 landed per bout, both men) - about **8%** of landed strikes, from a THAI KICKER on `kickboxing_thai_kicker`
(legs bias 1.4). Your U178B fixed exactly this for MMA (6.3% -> 13.6% significant leg share, kicks at LONG/MID only,
`FightMoves._select_mma_technique_then_region`) and its own digest says **the kickboxing ruleset does not receive the
selection keys**. That is the whole gap.

## What would a human do?
A kickboxing coach counts his fighter's low kicks on film - a Dutch-style or Thai-style kicker lands the calf and thigh
kick all fight, from kicking range, as the set-up for everything else; a counter-striker kicks less and checks more.
Glory's video study puts kicks at ~35% of landed strikes (G108, PROXY; head+body+legs). The kicker's legs are a
selection question (which technique, aimed where, from which range), never a damage-number question.

## Do
1. Read `research/U178_DIGEST.md` (your own, both halves) and `FightMoves._select_mma_technique_then_region`.
2. Give kickboxing the same technique-then-region selection, with its OWN constant (e.g. `KB_LEG_REGION_SELECT_MULT`),
   standing kicks at LONG/MID only - never a global leg weight (S4e measured that the TARGET_WEIGHTS table is not the
   lever). Do not change MMA's numbers.
3. Instrument: `Godot/tools/s97_limb_census.gd` (Claude's, already in the tree - kickboxing, thai kicker vs counter
   striker, both with the full KB tier 1-2 palette). Add a SECOND pair in your own tool `tools/u189_kb_leg_census.gd`:
   `kickboxing_dutch_pressure` vs `kickboxing_counter_striker`, different frames and attributes, both full palette.
   **NEVER identical fighters and never a kicker who cannot kick** (CLAUDE.md). Print the population in the output.

## Gate (a CEILING - over-deliver and say so)
- KB landed leg share (clean + glancing, all landed strikes) **14-20%** on both pairs, 100 bouts each - a PROXY band
  (Glory kicks ~35% of landed, low kicks the commonest kick); Grok's G134 re-pins it when it lands. Head stays the top
  landed region on the counter striker.
- The kicker's leg share > the counter striker's (the style must show).
- KB outcome mix: KO+TKO share no lower than master's on the same seeds (print both arms, 95% CIs).
- `python Godot/tools/run_tests.py --jobs 2 --only fight_realtime,fight_kb,fight_footwork,judge_panel` no worse than master
  (run the control on master's engine files the S41 way: revert the ONE file in your worktree, run, restore).
- Parse gate on touched files first.

## Owned files
`Godot/scripts/FightMoves.gd` (1,690 lines - read `sed -n` windows around `_select_mma_technique_then_region` and
`select`; never whole), the KB call site in `Godot/scripts/FightRealtime.gd` (6,300 lines - NEVER open whole; grep
`mma_leg_region_mult` and read 40-line windows), `Godot/tools/u189_*.gd`, `research/U189_DIGEST.md`.

## Deliver
Commit explicit paths, push the branch, write `research/U189_DIGEST.md` (before/after tables with divisors),
then `python Tools/agent_comms.py send --from cursor --to claude --topic U189 --body "<pair 1 and 2 leg share before/after, KO+TKO both arms>"`.
Do NOT edit HANDOFF.md. Research is open: RESEARCH_INDEX.md.
**Trap:** raising legs by making the men stand at kicking range longer (U178's first version cut MMA m/min 14.6 -> 11.2).
Print bout m/min before/after; it must not fall below master's by more than its CI.
