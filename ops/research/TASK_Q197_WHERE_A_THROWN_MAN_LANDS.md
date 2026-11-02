# TASK Q197 - QWEN - WHERE DOES A THROWN MAN LAND, AND DOES FOOTWORK ECONOMY MOVE IT? (S96)
Owner: qwen. Assigned 2026-09-27 (S96). Model: qwen3-coder, medium effort (the qwen_task.cmd pin).
Branch: `qwen/q197-throw-landings` from `origin/master` (13f023a5 or later), worktree `Temp/FightCamp-Q164`
(`git fetch origin && git checkout -B qwen/q197-throw-landings origin/master` there first).

## Why
Your Q196 was MERGED (13f023a5): submissions are unchanged by `footwork_economy` (7.5% vs 6.0%, CIs overlap) - settled.
The JUDO half is NOT settled. Your own table: economy OFF lands side 8 / half 8 and scores yuko 8; economy ON lands
side 4 / half 14 and scores yuko 4 - at only 16-18 throws per 100 bouts. That is "not detectable at N=100", not "noise".
G131 (Grok, real judo statistics, `research/G131_HOW_OFTEN_A_JUDO_THROW_SCORES.md`) says a band split needs
~100 SCORING throws to hold +-10 pp. It also says a seated/half landing scores NOTHING under post-2017 rules (yuko at
most under 2026 rules) - so if economy really moves landings from side to half, real rules say scores must fall, and
we need to know whether that is the ENGINE being right or a side-effect.
Also from G131: real elite judo is ~11-12 throw attempts per match, ~10% score, ~1 scored throw per match. Our
grappler-vs-fish fixture gives 0.17 THROWS per bout in both arms - a standing gap, separate from economy.

## What would a human do?
A judo performance analyst codes every throw attempt from match video: attempt, landing position (back / side / seated
or half / front / knees), score given. They compare two coaching conditions only once each has ~100 scoring throws, and
they report attempts per match and score rate against published competition numbers before believing a difference.

## Do
1. **Population - NEVER identical fighters, legal for judo** (CLAUDE.md rules). Two arms of fighters, both competent
   judoka with DIFFERENT styles and stats: a tachi-waza thrower (high grapple + power, lower fight_iq) vs a grip-fighter
   (high technique + defense + fight_iq, lower power); plus keep Q196's grappler-vs-fish as the legacy fixture. Print the
   population (both stat blocks, ruleset id, catalogue) in the output. Check the stats KEY is `"stats"`, not `"attributes"`.
2. For each fixture, run economy ON and OFF (the same switch Q196 flipped) until EACH arm has >= 100 SCORING throws or
   1,200 bouts, whichever first. Print per arm: bouts, throw ATTEMPTS/bout, throws landed/bout, landing split
   (back/side/half/other), band split (ippon/waza-ari/yuko/none) - each with a Wilson 95% CI.
3. Verdict per fixture: does economy move the landing split? SAME / MOVES (with the size and CI) / STILL UNDERPOWERED.
   If it MOVES, find the code path: print, for 20 sample throws per arm, the thrower's and victim's footwork state and
   stance at the throw frame, and name the line in `FightRealtime.gd` / the grapple adapter that picks the landing seat.
4. Compare attempts/bout and score rate to G131's anchors in one table (ours vs real). Do NOT tune anything.

## Owned files
`Godot/tools/q197_*.gd` (new), `research/Q197_DIGEST.md`. Read-only: `Godot/scripts/FightRealtime.gd` (large -
never open whole; `sed -n` windows around `footwork_economy` (~line 1032) and the throw/landing-seat code, find it with
`grep -n "seat\|yuko\|waza" Godot/scripts/FightRealtime.gd`), your `Godot/tools/q196_census_judo.gd` (small, read whole,
reuse its Wilson CI and ruleset loader).

## Gate (research tier - no script edited)
- NO script is edited. Parse gate on your new tool files only (`python Godot/tools/check_scripts.py Godot/tools/q197_*.gd`).
  NO test run is required (a new tool cannot break a test). Headless Godot at IDLE priority, one run at a time.
- Digest has the table per fixture and arm with CIs, the verdict line, the population printed, the G131 comparison.

## Deliver
Commit (paths on the commit line), push the branch, `research/Q197_DIGEST.md`, one line with
`python Tools/agent_comms.py send --from qwen --to claude --topic Q197 --body "<verdict per fixture>"`. Do NOT edit HANDOFF.md.
Research is open to you: RESEARCH_INDEX.md.
**Trap:** a verdict at N=100 bouts is the mistake this task exists to fix - count SCORING THROWS, not bouts.
