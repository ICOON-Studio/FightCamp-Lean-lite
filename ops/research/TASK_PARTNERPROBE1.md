# TASK PARTNERPROBE1 - what a close sparring partner is worth on fight night, in wins (a probe; headless, measure only)

Status: OPEN (S480, Claude main). Discipline: boxing. Model: Goose (cloud, needs Godot 4.7.2 headless).

## Why now
The owner approved fight week v9 with the sparring partner screen (board Q-S294-238, "Yes, approve"). The board said: "A probe
measures it before the build (target: CLOSE beats LOOSE by 3-5 wins in 100)". Map: ops/research/DESIGN_AMATEURWEEK1_V9_REVISE_KALLI_KALLI.md
section 4.1. The partner's match word (scripts/rules/PartnerMatch.gd, on main) decides two things on fight night:
- the round-1 edge: bout["r1_edge"] = PartnerMatch.EDGE[word] (CLOSE 1.0, PART 0.5, LOOSE 0.0) - wired since S474
  (BoutRules.r1_edge, read by LiveRound and the forecast);
- how many of the plan's unsparred lines the night readies: PartnerMatch.LINES[word] (CLOSE 3, PART 2, LOOSE 1). A line still
  unsparred on the night fires ONE LEVEL DOWN in rounds 1-2: bout["unsparred"] = Array of the move ids of those plan arrows
  (wired S480: FireLevel.round_mastery, read in LiveRound.exchange; no key = today's game).

## Prior research
- tools/fightweek_probe.gd (288 lines, S449-S450): the same kind of measure through the game's real bout (Bouts.fight_step +
  LiveRound), calibrated opponents (EVEN 50 / EDGE 70 / UNDER 30), seeded. FIGHTWEEKPROBE1/2 found a 0.6 flat round 1 worth
  about 1 in 100 and fight-night levers topping out near 5 in 100.
## What would a human do?
A coach would compare camps that sparred a close match against camps that sparred whoever was free, same boxer, same opponent.
## Prefab check
None: game-specific measure.

## What to do (measure only - change no game script)
Write tools/partner_probe.gd (extends SceneTree, headless, under 500 lines). COPY what you need from tools/fightweek_probe.gd
(do not edit it): Career.quick_start, its three calibrated PAIRS (never two identical fighters), its bout loop, its seeds.

Give our boxer a plan with exactly THREE arrows that the fight will actually use against each opponent (read how
bout["arrows"] is built in tools/fightweek_probe.gd / PlanFile; name the three move ids in the output), at mastery that makes
the level matter: one combination at Sharp (mastery 70), one at Usable (40), one at Sharp (65). All three are "changed since she
last sparred" (unsparred) before the night.

Arms (each the SAME boxer, opponent and seeds; only these keys differ):
- NONE (no sparring night): r1_edge 0.0, unsparred = all three ids
- LOOSE: r1_edge 0.0, unsparred = the last two ids (the night readied 1)
- PART: r1_edge 0.5, unsparred = the last one id (readied 2)
- CLOSE: r1_edge 1.0, unsparred = [] (readied all 3)
- EDGE_ONLY (control to split the two effects): r1_edge 1.0, unsparred = all three ids
- LINES_ONLY (control): r1_edge 0.0, unsparred = []

Print one line per pair x arm:
`PARTNER pair=<even|edge|under> arm=<arm> wins=<w> of=<n> win=<share in 100> moves=<id,id,id>`
Then per pair:
`PARTNER_DELTA pair=<tag> close_v_loose=<x in 100> part_v_loose=<y> edge_only=<EDGE_ONLY - NONE> lines_only=<LINES_ONLY - NONE>`
And the summary:
`PARTNERPROBE1 close_v_loose=<mean over pairs> part_v_loose=<mean> dice=<1 s.d. of a delta in 100> pass=<0|1> why=<...>`
Gate (the owner's board): CLOSE beats LOOSE by 3 to 5 wins in 100 on the mean of the three pairs, and PART sits between them.
N: enough bouts per cell that 1 s.d. of a delta is under 1 in 100 (say which N and why); keep the run under 40 minutes; seeds
4801 (and 4802 for a second set if time allows). If a gate fails, REPORT it - do not tune anything.

## Contract
OWNS: tools/partner_probe.gd, docs/PARTNERPROBE1_RESULT.md
RED_TEST: tools/partner_probe.gd -> PARTNERPROBE1 pass= (a new probe; nothing is red on main - it has no file yet)
REGRESSION: tests/fire_level_test.gd, tests/fight_week_test.gd (no game script changes)
VISUAL: no
NOT YOURS: every script under scripts/, every test under tests/, tools/fightweek_probe.gd. No number changed anywhere.

## Test command (tier: a new probe only)
`godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/partner_probe.gd -- nb=<N> seed=4801`
Paste the full output into docs/PARTNERPROBE1_RESULT.md and the summary line into the PR body.

## The one trap
The plan's three arrows must be ones the boxer's game actually CHOOSES against these opponents (PlanFight.choose picks an
arrow by card + situation). If an arrow never fires, the arms will read identical and the probe proves nothing. Before the
full run, print how many times each of the three arrows was picked in rounds 1-2 in 50 bouts of the NONE arm; each must be
picked at least 5 times a bout on average, else pick other arrows and say so.
