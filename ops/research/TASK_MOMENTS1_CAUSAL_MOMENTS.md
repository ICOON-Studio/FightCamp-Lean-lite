# TASK MOMENTS1 - three moments that say WHY, not the score (design review finding 3) - a pure module + its test

Model: Arena (cloud). New file only, zero preloads. Repo ICOON-Studio/FightCamp, your own branch, open a PR, never merge.
Tier: new pure module + new test -> parse + that test.

## Prior research
DEMO_DESIGN_REVIEW_S172.md finding 3: "'why' is the score, not the cause. The three moments must be causal and tied to the player: the
round the plan changed, the punch type that won it vs the scouting read, the corner call and what followed (example: 'Round 4 - you
switched to body work; his output dropped 30% after it')." J36/K70: 3-5 causal bullets from numbers the engine already computed.
Today `FightCausation.gd` ranks lines like "outlanded 41-24" - a score restated.

## What would a human do?
A TV analyst after a fight: "the turn came in round 4 when his corner told him to go to the body - look at the output after that."

## Prefab check
None: a pure sentence builder over numbers we already have.

## Owned files
- NEW `Godot/scripts/FightMoments.gd` - `extends RefCounted`, NO preload, NO autoload, static functions only:
  `static func causal_moments(rounds: Array, calls: Array, scout: Dictionary, names: Dictionary) -> Array`
  - `rounds`: one Dictionary per round, in order, for BOTH sides:
    `{"round": int, "a": {"thrown": int, "landed": int, "jab_landed": int, "power_landed": int, "body_landed": int, "knockdowns": int}, "b": {same}}`
  - `calls`: the player's corner calls (player = side "a"), in order: `{"round": int (the round he went OUT for), "label": String, "emphasis": String ("body"|"head"|"jab"|"power"|""), "pace": String ("press"|"balanced"|"ease"|"")}`
  - `scout`: `{"read": String ("jab"|"power"|"body"|""), "label": String}` - what the scouting report said would win.
  - `names`: `{"a": "Surname", "b": "Surname"}`
  - returns at most 3 Strings, most important first, each ONE sentence <= 90 characters, each starting "Round N - " and naming a cause
    AND an effect with a number from the input. Candidate kinds (rank by the size of the effect, never invent):
    1. CALL -> EFFECT: for each call, compare the rounds BEFORE it (from the previous call's round, or 1) with the rounds FROM it to the
       next call: the opponent's `thrown` per round, and our `landed` per round in the call's emphasis (body_landed for "body", etc.).
       A change of at least 20% (and at least 3 per round in absolute) is a moment: "Round 4 - you called body work; Diaz's output fell 30% after it."
    2. SCOUT READ PAID (or did not): the punch type with the biggest landed share for side a over the fight vs `scout.read`:
       "Round 3 - the jab the scouting picked landed 18 of his 31 shots from here." / or the mismatch.
    3. TURNING ROUND: the first round where the landed lead (a minus b) changes sign and holds to the end - only if a call or knockdown
       sits in that round or the one before; name it ("Round 5 - the knockdown turned it; he led every round after.").
  - Fewer than 3 when fewer qualify. An empty `rounds` returns []. Deterministic: same input, same output.
- NEW `Godot/tests/fight_moments_test.gd` - `extends SceneTree`, `_init()`, prints `FIGHT MOMENTS PASS` and quits 0, or prints `FAIL <why>`
  and quits 1. Cases (hand-built fixtures, at least 6): a body call followed by a 30% output drop -> the CALL sentence with "30%";
  a 10% change -> NO call sentence; scout "jab" with jab dominant -> the SCOUT sentence; a knockdown turning round -> the TURNING
  sentence; no calls + flat fight -> [] or only qualifying lines; never more than 3; every line <= 90 chars and starts "Round ";
  determinism (two calls equal). Write each case from THIS spec, not from your implementation.

## Running the test in your sandbox
Download the official PREBUILT Godot 4.7.2 Linux binary (github.com/godotengine/godot/releases, `Godot_v4.7.2-stable_linux.x86_64.zip`)
- NEVER compile Godot from source (a past Arena run stalled 34 minutes doing that). Run:
`./Godot_v4.7.2-stable_linux.x86_64 --headless --path Godot --script tests/fight_moments_test.gd`. The project imports may print
warnings about missing LFS assets - ignore them; this test loads none.

## The one trap
Do not edit any existing file (Claude wires it into FightCausation and the result screen after review). Do not delete or weaken a test
to go green. Everything you send is public - no secrets.
