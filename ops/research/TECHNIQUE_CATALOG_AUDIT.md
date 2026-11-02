# Technique Catalog Audit

Part of the CLAUDE RESEARCH ASSIGNMENT (see `HANDOFF.md`, 2026-08-30). Reviews
all 150 nodes in `technique_catalog.json` v2 (15 disciplines × 10 nodes) for
naming accuracy, structural gaps, and rule-incompatible assumptions. Every
existing node ID is preserved — nothing here proposes a rename or deletion.

Status: **PROPOSAL, not final.** Technique *names* below are evaluated
against general, well-documented martial-arts terminology (these are not
in dispute across sources — "o-soto-gari" is o-soto-gari regardless of which
federation's rulebook you open). Per-ruleset **legality** conclusions are
evaluated separately in `COMPETITION_RULESET_RESEARCH.md` and the
`technique_legality_matrix.json` proposal — this document flags where a
node's real-world legality is federation-dependent, but the citation for
that legality lives in the ruleset research, not here.

## Per-discipline naming/terminology review

All fifteen disciplines use correct, real, standard technique vocabulary
for their tradition (Japanese for Judo/Karate, Korean for Taekwondo, French
for Savate, Portuguese for Capoeira, Filipino for Arnis, Indonesian/Malay for
Pencak Silat, Thai transliteration for Muay Thai). No mistranslations found.
Specific notes:

- **Wrestling — `wrestling_suplex` (tier 4):** "suplex" is used colloquially
  by wrestlers for several high-amplitude throws but is not itself a single
  official UWW-classified technique name the way "gut wrench" or "ankle
  pick" are. Not an error, but flagged `INFERRED` rather than `DIRECT` —
  recommend confirming against UWW's actual technique classification once
  available, and potentially renaming display text only (not the stable ID)
  to a more specific UWW term if the research turns one up.
- **Judo — leg-grab throws (`osotogari`, `ogoshi`, `seoinage`, `uchimata`):**
  all four are hip/leg-sweep throws that do not rely on directly hand-gripping
  the opponent's leg, so they should remain unaffected by the IJF's
  leg-grab restriction rule changes — flagged for direct confirmation in the
  ruleset research rather than asserted here, since rule-change history
  matters and this document does not cite a source for it.
- Everything else reviewed clean: no duplicate concepts, no obviously
  mistranslated or invented terminology across Boxing, Kickboxing, Muay Thai,
  Karate, Taekwondo, Sanda, Savate, Capoeira, Arnis, Pencak Silat, BJJ, Sambo,
  or MMA Integration.

## Structural gaps — proposed additions

### 1. BJJ: Kimura and Omoplata are named in chains but never taught as base nodes

`bjj_kimura_chain` ("Kimura Control Chain," tier 3) and
`bjj_submission_chain` ("Armbar-Triangle-Omoplata Chain," tier 4) both name
a submission — Kimura, Omoplata — that has **no standalone node anywhere in
the catalog**. Contrast with Armbar and Triangle, which both have their own
dedicated nodes (`bjj_armbar`, `bjj_triangle`) *before* they appear inside a
chain name. As written, an athlete can complete "Kimura Control Chain"
having never learned a plain Kimura. This is exactly the kind of "meaningful
gap" the assignment asks this audit to fill — both are extremely common,
IBJJF-recognized, clearly distinct submissions from Armbar/Triangle (Kimura
is a shoulder lock via a figure-four grip on the wrist/arm; Omoplata is a
shoulder lock applied with the legs from guard, no hand grip at all — a
genuinely different mechanism worth its own eligibility/reps profile, not a
reskin of Armbar).

**Proposed new nodes** (additive; existing IDs and their `requires`/`match`
data untouched):

```json
{"id":"bjj_kimura","name":"Kimura (Shoulder Lock)","kind":"move","tier":2,"branch":"submissions","requires":{"discipline":42,"attributes":{"technique":46,"power":40,"fight_iq":40},"prerequisites":["bjj_guard_pass"],"reps":260},"match":{"role":"submission","phases":["ground_top","ground_bottom"],"effects":{"submission":11,"shoulder_isolation":8}}}
```
```json
{"id":"bjj_omoplata","name":"Omoplata (Shoulder Lock from Guard)","kind":"move","tier":2,"branch":"submissions","requires":{"discipline":44,"attributes":{"technique":48,"fight_iq":44,"speed":38},"prerequisites":["bjj_guard"],"reps":270},"match":{"role":"submission","phases":["ground_bottom"],"effects":{"submission":11,"sweep_threat":6}}}
```

With `bjj_kimura_chain.prerequisites` updated to
`["bjj_armbar","bjj_scissor_sweep","bjj_kimura"]` and
`bjj_submission_chain.prerequisites` updated to
`["bjj_triangle","bjj_kimura_chain","bjj_back_take_rnc","bjj_omoplata"]` —
additive prerequisite entries only, no existing entry removed. Source
strength: `INFERRED` (these are standard, well-documented BJJ techniques;
the specific numeric requirements/reps proposed above are new game-design
values, not sourced from a rulebook — rulebooks don't publish training-time
requirements, only legality, which is a separate matrix entry).

### 2. Sambo: the catalog only models Combat Sambo; Sport Sambo has no representation

The assignment requires Sport Sambo and Combat Sambo as separate rulesets,
but the catalog's single `sambo` discipline includes a striking node
(`sambo_strike_bodylock`, "Overhand to Body-Lock Throw") that would be
illegal in Sport Sambo (no striking permitted). Rather than duplicating ten
nodes into a parallel `sport_sambo` discipline, recommend representing Sport
Sambo as a **legality subset** of the existing Combat Sambo node list: every
node stays as-is, and the legality matrix marks `sambo_strike_bodylock` (and
any other strike-inclusive node) `illegal` under the Sport Sambo ruleset
while every pure grappling/throw/submission node (`sambo_outside_trip`,
`sambo_hip_throw`, `sambo_holddown`, `sambo_straight_ankle`,
`sambo_kneebar`, `sambo_counter_throw`, `sambo_rolling_kneebar`) stays
`legal` under both. `sambo_throw_leglock` (the tier-4 chain) should be
reviewed once its exact content is confirmed against the striking-inclusive
node it currently chains from (`sambo_strike_bodylock`) — if it inherits an
illegal component, the *chain* is illegal in Sport Sambo even though its
other components aren't, per the assignment's "technique sequences inherit
no automatic legality" rule. This avoids doubling the catalog's node count
for a rules distinction that a legality-matrix entry already models cleanly.

### 3. Kickboxing and Savate: one discipline bucket, multiple real rule families

Per the assignment's own required-coverage list, WAKO kickboxing splits into
distinct styles (e.g. Full Contact, Low Kick, K-1 Rules, Point Fighting) that
don't share one legal-technique set (low kicks, for instance, are central to
some styles and excluded from others), and Savate splits into Assaut
(light-contact, technique/precision scored) vs Combat (full-power). The
catalog currently has one `kickboxing` and one `savate` discipline bucket
each. Recommend the same treatment as the Sambo finding above: **keep the
node list unified, differentiate legality per style through the matrix**
rather than forking the catalog. This is lower-effort, preserves every
existing ID, and matches how the assignment's matrix contract is already
designed (`ruleset_id`-scoped entries per technique). Exact per-style
restrictions (which kickboxing style excludes low kicks, whether Savate
Assaut restricts specific techniques outright or only restricts contact
*power* while leaving the technique list itself unrestricted) are deferred
to `COMPETITION_RULESET_RESEARCH.md`.

### 4. Optional, lower-priority: Boxing has no clinch/tie-up node

Real amateur and professional boxing both feature clinching/tying up as a
common, legal (if time-limited and often broken up by the referee) defensive
tactic, and it's absent from Boxing's ten nodes. Lower priority than items
1–3 since it's a completeness gap rather than a structural naming
inconsistency, and ten nodes were always going to be a curated subset, not
exhaustive. Flagged for consideration, not proposed as a required addition.

## Cross-ruleset legality flags worth carrying into the matrix

These are well-established, widely documented facts about how these sports'
rules work, independent of which specific rulebook edition confirms the
exact wording — carried here as a heads-up for the matrix build, with the
matrix itself citing the specific primary source once available:

- **Greco-Roman wrestling prohibits attacks below the waist.** Wrestling's
  `wrestling_single_leg`, `wrestling_double_leg`, and `wrestling_ankle_pick`
  nodes (all leg-attack takedowns) should be marked `illegal` for the
  Greco-Roman ruleset variant and remain `legal` for Freestyle. This is one
  of the clearest, highest-confidence entries in the whole matrix.
- **`bjj_scissor_sweep` is not IBJJF's banned "scissor takedown."** IBJJF's
  illegal-moves table bans a "scissor takedown" (a standing/flying
  technique) at every belt/age with no exception. The catalog's
  `bjj_scissor_sweep` node is a different, fundamental ground-based guard
  sweep (`phase: ground_bottom`) that does not appear anywhere in IBJJF's
  restricted list — confirmed legal at every level. Flagged explicitly
  here because the similar name is genuinely confusable and a future
  editor could otherwise mismark a legal, fundamental technique as banned.
- **BJJ's `bjj_omoplata` and `bjj_triangle` are age-gated, not belt-gated**
  (illegal only for the 4–15yrs age divisions per IBJJF's table; legal from
  Juvenile/white-belt Adult up) — confirmed by research after this document
  was first drafted; see `COMPETITION_RULESET_RESEARCH.md`'s BJJ section
  and `technique_legality_matrix.json` for the applied entries.
- **Arnis nodes are weapon-only** — already correctly flagged in the catalog
  itself via the existing `ruleset_note` field on the `arnis` discipline
  block ("Weapon techniques require an Arnis ruleset or exhibition; they are
  not legal in unarmed MMA"). No catalog change needed; the matrix should
  simply carry this through as `not_applicable`/`illegal` for every
  non-weapon ruleset.
- **MMA Integration nodes inherit their source disciplines' legality** where
  they reference one via `cross_discipline` (e.g. `mma_mount_finish`
  requires `bjj_armbar` — if a specific MMA ruleset variant ever restricted
  a particular submission by age/division, that restriction should propagate
  to the MMA node that depends on it). Flagged as a matrix-construction rule,
  not a specific finding, since MMA's own researched ruleset will determine
  which submissions if any are restricted.

## Coverage summary

| Discipline | Nodes | Naming issues found | Structural gaps found |
|---|---|---|---|
| Boxing | 10 | 0 | 1 (optional, low priority) |
| Kickboxing | 10 | 0 | 1 (style-split, matrix-level fix) |
| Muay Thai | 10 | 0 | 0 |
| Wrestling | 10 | 1 (terminology precision) | 0 |
| BJJ | 10 | 0 | 1 (2 proposed new nodes) |
| Judo | 10 | 0 (pending rule-history confirmation) | 0 |
| Karate | 10 | 0 | 0 |
| Taekwondo | 10 | 0 | 0 |
| Sanda | 10 | 0 | 0 |
| Sambo | 10 | 0 | 1 (Sport Sambo representation, matrix-level fix) |
| Savate | 10 | 0 | 1 (style-split, matrix-level fix) |
| Capoeira | 10 | 0 | 0 (competition-ruleset status pending research) |
| Arnis | 10 | 0 | 0 (already correctly scoped) |
| Pencak Silat | 10 | 0 | 0 |
| MMA Integration | 10 | 0 | 0 (correctly cross-references real source nodes) |
| **Total** | **150** | **1** | **2 node additions proposed, 3 matrix-level fixes** |

Net proposed catalog change: **+2 nodes** (`bjj_kimura`, `bjj_omoplata`),
**0 renames, 0 deletions** — fully consistent with the assignment's
requirement to preserve every existing stable ID. **Applied:**
`technique_catalog.json` is now v3 with 152 nodes (150 audited + these 2
additions); validated unique IDs, valid prerequisite references, and an
acyclic prerequisite graph across all 152.

## Per-node legality matrix

Not reproduced in full here — see `Godot/assets/data/technique_legality_matrix.json`
for the machine-readable per-node, per-ruleset entries. This document's job
was the qualitative naming/structure audit; the matrix file is the
assignment's required exhaustive per-technique legality record.
