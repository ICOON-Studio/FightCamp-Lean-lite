# TASK U190 - CURSOR - JUDO THROWS THAT ARE TRIED (S98)
Owner: cursor. Assigned 2026-09-27 (S98). Model: Cursor default (auto), medium. Branch `cursor/u190-judo-attempts`
from `origin/master`, in its own worktree. Claude merges; never merge master in.
**Launch only when a shell-agent slot is free (max two at once: Qwen Q199 and Codex C214 hold them at S98 end).**

## Why
Q197 (`Q197_DIGEST.md`) measured the engine's judo: 0.17-0.45 throw ATTEMPTS per bout, 0.08-0.09 SCORING throws. Real
elite judo tries 11-12 throws a match. A judo bout that throws once every two matches is not judo.

## What would a human do?
A judo analyst counts attempts per minute of grip contact: grip fight, a few seconds of kuzushi, an attempt; most
attempts are stuffed or score nothing. A match has many attempts and few scores. Tune the ATTEMPT rate to that, and let
the existing landing / scoring code decide what happens next. G136 (Grok, in parallel) brings the real per-minute
numbers; until it lands, use Q197's 11-12 attempts per 4-min match.

## Do
1. Find why judo attempts are rare: `GRAPPLE_ATTEMPT_BASE` (`FightRealtime.gd:582`), the clinch-to-throw notes at
   `:801`, `throw_gate_base` (`:547`), the `throw_attempt` emit at `:5269`. Measure where the funnel dies (clinch
   entered? grip held? attempt rolled?) with a census before changing anything - print the funnel.
2. Raise the JUDO attempt rate only (ruleset `judo`; MMA/wrestling untouched - they must stay byte-identical) with a
   named constant, until attempts land in 8-14 per 4-min match with scoring throws staying a minority.
3. Population: a thrower vs a grip-fighter (Q197's two, `tools/q197a_pop_a.gd`), both full judo palette; name it in the
   output. Never identical fighters.

## Gate (a CEILING)
- Judo attempts/match inside 8-14 (CI printed), ippon/waza-ari share of attempts printed; MMA + boxing + KB
  byte-identical on 10 seeds (print hashes).
- Parse gate; `python Godot/tools/run_tests.py --jobs 2 --only fight_scoring,judo,grapple` no worse than master
  (`fight_scoring_test` is ALREADY red on master: uchi-mata ippon 19 >= 22 - if your change fixes it, say so).

## Owned files
`Godot/scripts/FightRealtime.gd` (6,250 lines - never open whole; `sed -n` windows at :540-600, :790-830, :5240-5290),
`Godot/tools/u190_*.gd`, `research/U190_DIGEST.md`. Small, read whole: `Godot/tools/q197a_pop_a.gd`.

## Deliver
Commit explicit paths, push the branch, write `U190_DIGEST.md`, `python Tools/agent_comms.py send --from cursor --to
claude --topic U190 --body "<attempts/match, CI, hashes>"`. Do NOT edit HANDOFF.md. All research open: RESEARCH_INDEX.md.
**Trap:** a global constant touched for judo moves MMA's clinch too - gate every change on the ruleset id and prove the
other rulesets byte-identical.
