# TASK_Q146 — WHY ARE MOST GRAPPLE EVENTS UNNAMED OUTSIDE MMA?

**Model: `qwen3-coder`, medium, `--yolo` (NEVER `auto`).** Worktree `FightCamp-Q114`, a FRESH branch
`qwen/q146-unnamed-grapples` cut from `origin/master`. Assigned S59, 2026-09-23. **DIAGNOSE, DO NOT FIX.**

## Owned files

- `Godot/tools/q146_unnamed_grapples.gd` (new) - the census tool.
- `research/Q146_DIGEST.md` (new) - the answer.

## THE FINDING YOU ARE EXPLAINING (your own Q145, merged)

`research/Q145_DIGEST.md` table: grapple events with an EMPTY `technique` field -
judo 746 of 868, freestyle 769 of 1183, greco 803 of 1157, sambo 901 of 1605, bjj 686 of 2417,
**muay_thai 633 of 633**, and MMA only 47 of 1741. The on-screen move name is blank for most of a judo bout.
Identical on both `carry_progress` arms, so it predates S59.

## WHAT I WANT

1. **Break the unnamed events down by `kind`** (and by `via` where present) per ruleset: which event kinds
   never get a name? Print a table: ruleset x kind -> named / unnamed.
2. **For the top three unnamed kinds, find the reason in code.** The namer is `_grapple_technique_for`
   (`Godot/scripts/FightRealtime.gd`, grep it; the kind->effect map sits just above it, grep
   `"clinch_engage":`). Likely candidates - check each and say which it is, with the line:
   (a) the kind has no entry in that map; (b) the map's effects exist but no catalogue node in that ruleset's
   disciplines carries them; (c) the phase filter (S49, "THE NAME MUST BE LEGAL FOR THE PHASE") removes every
   candidate; (d) the call site never asks for a name at all.
3. **Muay Thai 633/633** gets its own paragraph: clinch work with zero names is the cleanest case.

Population: reuse Q145's per-ruleset fighter pairs (two different men, both legal for the ruleset; print them).
Pass the ruleset as a DICTIONARY. 12 bouts per ruleset is enough; seeds `564000 + i`.

## TEST TIER - a new tool only

Parse gate on your tool, then run it. No suite, no subset. No engine file is edited.

```
python Godot/tools/check_scripts.py Godot/tools/q146_unnamed_grapples.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/q146_unnamed_grapples.gd
```

`FightRealtime.gd` is ~4,800 lines - NEVER open it whole; grep and read `sed -n` windows.

## THE ONE TRAP

**A cause you find by reading code is a hypothesis until a number confirms it.** For each reason you name,
show the count it explains (e.g. "kind X: 612 unnamed, all have no map entry"). If your named causes add up
to far less than the unnamed total, say what is left unexplained - do not round it into the nearest story.

Commit, push `qwen/q146-unnamed-grapples`, send one line with `agent_comms.py send --from qwen --to claude
--topic Q146` naming the branch and the top cause. Do NOT edit HANDOFF.md.
