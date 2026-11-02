# TASK U75 - CURSOR - WHICH REGIONS A STRIKE MAY REACH, RULESET BY RULESET

Model: Composer, **medium effort**. Owner: cursor. Launched `-p --force --trust`.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GODOT AT ALL.** Claude is running S2's test
subsets in this checkout and only one Godot may run at a time. Your gate is a Python
script that MUST exit 0.

## Owned files

- `research/U75_strike_target_legality.json` - **NEW, yours alone.**
- `research/U75_STRIKE_TARGET_LEGALITY.md` - **NEW, yours alone.**

Nothing else. Do NOT edit any script, test, `combat_rulesets.json`,
`competition_rulesets_v2.json`, the catalogue, `U75_check.py`, `HANDOFF.md` or
`AgentComms/roadmap.json`.

## Why this exists

S2 gives every kick an explicit target (Qwen's `research/Q70_kick_targets.json`:
head / body / leg / spread), one discipline per commit. **A target is only real if the
ruleset allows it.** Standing operator rule: a fighter must be legal for the ruleset he is
in. A WT taekwondo kick below the waist is a foul; a WKF karate attack to the legs is a
foul. Before S2 writes a single `leg`, it must know which of the engine's rulesets let a
kick - or a punch - reach the legs, and where the engine disagrees.

The engine has **eleven** rulesets (`Godot/assets/data/combat_rulesets.json`: mma, boxing,
kickboxing, muay_thai, judo, freestyle_wrestling, greco_roman, karate, bjj, sambo,
taekwondo). The sourced rules are **already on disk**:
`Godot/assets/data/competition_rulesets_v2.json`, 30 competition rulesets, several with
`legal_targets`, `illegal_targets`, `fouls` and `restrictions`. This task is a
cross-reference of those two files and the code - **no web, no invention**.

## Where the engine decides a region today (read only these windows)

- `Godot/scripts/FightRealtime.gd` (2,535 lines - never open it whole): `sed -n '318,345p'`
  - `TARGET_WEIGHTS` and `TARGET_WEIGHTS_BY_RULESET`. Only four rulesets have an entry;
  every other ruleset gets `TARGET_WEIGHTS`, which lets legs be struck.
- `Godot/scripts/FightMoves.gd` (1,138 lines): `sed -n '212,230p'` (the fallback table and
  `DISCIPLINE_TAG_ALIASES`), `sed -n '257,288p'` (`disciplines_for` - which disciplines a
  ruleset's fighters draw on), `sed -n '639,690p'` (`_regions_for` - a region the ruleset
  weights at zero cannot be struck at all).
- `Godot/scripts/FightSimulation.gd` (3,489 lines): `sed -n '2195,2300p'` -
  `_technique_target_region` and `_pick_target_region`. Say in your report whether this
  path enforces ANY region legality.

## Scope

**1. One row per engine ruleset, all eleven.** For each:

- `engine_ruleset` - the id.
- `disciplines` - exactly what `FightMoves.disciplines_for` resolves: the ruleset's
  `discipline_tags`, each mapped through `DISCIPLINE_TAG_ALIASES`, kept only if it is a
  discipline id in `technique_catalog.json` (`disciplines[].id`), first occurrence order.
- `competition_rulesets` - the competition ruleset ids (same discipline family) that
  stand behind it.
- `punch` and `kick` - for each of `head_neck`, `torso_core`, `legs`, one verdict:
  `legal` (the rules name it a target), `legal_by_exclusion` (the rules list fouls and
  this is not one of them), `illegal`, `not_applicable` (no such strike in this sport),
  `not_on_disk` (the file does not say - **write this rather than guess**).
- `evidence` - a list of `{"competition_ruleset", "field", "quote"}`. **Every quote
  VERBATIM** from that field of that competition ruleset - a substring of one of its
  strings. A `legal` / `illegal` / `legal_by_exclusion` verdict needs at least one.
- `engine_realtime` - the six region weights FightRealtime uses for this ruleset
  (`head_neck`, `torso_core`, `left_leg`, `right_leg`, `left_arm`, `right_arm`), and
  `engine_realtime_source` - `TARGET_WEIGHTS_BY_RULESET` if it has an entry, else
  `TARGET_WEIGHTS default`.
- `mismatches` - a list of one-line strings: every place the engine allows what the rules
  forbid, or forbids what they allow.

**2. `illegal_leg_targets`** - every row of `Q70_kick_targets.json` with `"target": "leg"`,
paired with each engine ruleset whose `disciplines` include that row's discipline AND whose
`kick.legs` verdict is `illegal`: `{"id", "discipline", "engine_ruleset"}`.

**3. The report** `U75_STRIKE_TARGET_LEGALITY.md`, with these sections:

- a table of the eleven rulesets x (punch, kick) x (head_neck, torso_core, legs);
- **KICKBOXING** - the engine's `kickboxing` ruleset could stand for WAKO full contact
  (legs: ankle-level sweeps only), WAKO low kick (thighs) or K-1 (legs, any part). State
  which you mapped it to and why, what the other two would mean for Q70's kickboxing leg
  kicks, and that this is a ruling for Claude, not a fact;
- **THE ENGINE TODAY** - what FightRealtime, FightMoves and FightSimulation each enforce,
  with line numbers; which disciplines no engine ruleset draws on at all (their kicks
  cannot appear in any bout);
- **OPTIONS** - where strike-target legality should live, at least: (a) a per-ruleset
  `strike_targets` block in `combat_rulesets.json` that both resolvers read; (b)
  `TARGET_WEIGHTS_BY_RULESET` extended to all eleven, plus a legality filter in
  FightSimulation reading it; (c) no region legality in the resolvers - illegal techniques
  removed through `technique_legality_matrix.json` (`FightSimulation.gd:2708` already
  refuses a technique whose status is `illegal`). Consequences of each; recommend one.
  **Do NOT build it.**

## The JSON

    {"rulesets": [{"engine_ruleset": "taekwondo", "disciplines": ["taekwondo"],
                   "competition_rulesets": ["taekwondo_wt"],
                   "punch": {"head_neck": "illegal", "torso_core": "legal", "legs": "illegal"},
                   "kick": {"head_neck": "legal", "torso_core": "legal", "legs": "illegal"},
                   "evidence": [{"competition_ruleset": "taekwondo_wt", "field": "fouls", "quote": "kicking_below_waist"}],
                   "engine_realtime": {"head_neck": 0.6, "torso_core": 0.28, "left_leg": 0.06,
                                       "right_leg": 0.06, "left_arm": 0.0, "right_arm": 0.0},
                   "engine_realtime_source": "TARGET_WEIGHTS default",
                   "mismatches": ["realtime lets a taekwondo kick reach the legs; WT fouls it"]}],
     "illegal_leg_targets": [{"id": "...", "discipline": "...", "engine_ruleset": "..."}],
     "recommend": "a"}

(The taekwondo row is illustrative - verify every verdict yourself.)

## THE TRAP

**Absence is not legality, and it is not illegality either.** Most competition rulesets
have no `legal_targets` field. Where a ruleset lists fouls, a region no foul names is
`legal_by_exclusion` - quote the fouls list. Where the file says nothing that decides the
region, the verdict is `not_on_disk`. Never fill a gap from memory of the sport: this task
exists because the engine already carries a table somebody typed from memory.

## The gate

    python research/U75_check.py

It recomputes `disciplines`, `engine_realtime` and `illegal_leg_targets` from the code and
data, checks every quote is verbatim, and holds anchors the on-disk rules state outright.
It fails now because your files do not exist. **Fix YOUR FILES, never the checker.**

## Done

- Stay on `master`; no branch. **Never** `git checkout`, `switch`, `branch`, `stash`,
  `reset`, `clean`, `add -A`, `pull` or `push`.
- `git status -s` first. Commit exactly your two paths, ON the commit line:
  `git add -- research/U75_strike_target_legality.json research/U75_STRIKE_TARGET_LEGALITY.md`
  then `git commit -m "U75: ..." -- research/U75_strike_target_legality.json research/U75_STRIKE_TARGET_LEGALITY.md`
  ending `Co-Authored-By: Cursor <noreply@cursor.com>`.
  Then `git show --stat HEAD` must list exactly those two files. **Do not push.**
- Mail: `python Tools/agent_comms.py send --from cursor --to claude --topic U75-done --body "<hash> rulesets=11 illegal_leg_targets=<n> not_on_disk=<n> kickboxing=<wako_full_contact|wako_low_kick|wako_k1> recommend=<a|b|c> check=exit0"`
- Do NOT edit `HANDOFF.md`.
