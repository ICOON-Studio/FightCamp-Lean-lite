# Q78 — Judo and Sambo Escapes and Defences That Do Not Exist

S1f found two content gaps: the judo tree (115 nodes) has zero `escape` nodes and one
`defense` node (`judo_ukemi`); the sambo tree (18 nodes) has neither. This file drafts
twelve nodes — six per discipline — in the catalogue's own format, every one labelled
with what supports it.

## Drafted nodes

| id | name | role | seat | effects | grade | label |
|---|---|---|---|---|---|---|
| judo_esc_kesa_nuke | Kesa-gatame Escape | escape | ground_bottom | escape 8, control_escape 6 | 5th kyu (15) | INFERENCE |
| judo_esc_yoko_nuke | Yoko-shiho-gatame Escape | escape | ground_bottom | escape 7, guard_recovery 6 | 5th kyu (16) | INFERENCE |
| judo_esc_kami_nuke | Kami-shiho-gatame Escape | escape | ground_bottom | escape 7, scramble 5 | 4th kyu (22) | INFERENCE |
| judo_esc_tate_nuke | Tate-shiho-gatame Escape | escape | ground_bottom | escape 8, scramble 4 | 4th kyu (23) | INFERENCE |
| judo_taisabaki_defense | Taisabaki (Body Evasion) | defense | standing | takedown_defense 9, evasion 5 | 4th kyu (20) | INFERENCE |
| judo_kumi_defense | Kumi-kata Defense | defense | standing, clinch | takedown_defense 7, scramble 4 | 4th kyu (21) | INFERENCE |
| sambo_esc_bridge | Bridge Escape from Pin | escape | ground_bottom | escape 7, scramble 4 | student (1) | INFERENCE |
| sambo_esc_frame_roll | Frame and Roll from Pin | escape | ground_bottom | escape 7, control_escape 5 | student (2) | INFERENCE |
| sambo_esc_leglock | Leg Lock Entry Escape | escape | ground_bottom | escape 8, scramble 5 | student (3) | INFERENCE |
| sambo_esc_shrimp | Hip Escape from Pin | escape | ground_bottom | escape 6, guard_recovery 5 | student (4) | INFERENCE |
| sambo_throw_defense | Throw Defense | defense | standing | takedown_defense 8, throw_damage_reduction 5 | candidate (5) | INFERENCE |
| sambo_grip_break_defense | Grip Break Defense | defense | standing, clinch | takedown_defense 6, scramble 4 | candidate (6) | INFERENCE |

All twelve are INFERENCE. No node on disk names these techniques explicitly; the drafts
are drawn from the art's known curriculum and the pin/leg-lock content already in the
catalogue and rulesets.

## SEATS

Every escape uses `ground_bottom`, never plain `ground`. The vocabulary file
(`technique_vocabulary.json`, `_phases_note`) marks `ground` as RETIRING: it grants no
seat, and S1d's merge wrote it over authored seats on 128 nodes, leaving 94 techniques
unreachable. `ground_bottom` grants the `ground_bottom` seat — the bottom man's seat —
which is where an escape is thrown from. A defence uses `standing` (and sometimes
`clinch`) because it answers an incoming action from the feet.

**What each escape answers:**

| escape | answers (pin / position) | why this seat |
|---|---|---|
| judo_esc_kesa_nuke | kesa-gatame (scarf hold) — Q72 confirms `judo_kesagatame` is ground_top | bottom man bridges and turns toward uke's head |
| judo_esc_yoko_nuke | yoko-shiho-gatame (side control) — Q72 confirms `judo_yokoshihogatame` is ground_top | bottom man frames and shrimps to recover guard |
| judo_esc_kami_nuke | kami-shiho-gatame (north-south) — Q72 confirms `judo_kamishihogatame` is ground_top | bottom man bridges forward and rolls; harder because uke's weight is centred |
| judo_esc_tate_nuke | tate-shiho-gatame (mount) — Q72 confirms `judo_tateshihogatame` is ground_top | bottom man uses upa bridge; the most dominant pin |
| sambo_esc_bridge | any sambo hold-down — ruleset lists hold_downs as legal | basic athletic bridge, wrestling-influenced |
| sambo_esc_frame_roll | any sambo hold-down | frame against near-side limb, roll to recover |
| sambo_esc_leglock | straight ankle lock / kneebar entry — ruleset lists painful_holds_joint_locks | bottom man rotates the leg to slip the entry |
| sambo_esc_shrimp | any sambo hold-down | hip escape, common to all grappling arts |

**What each defence answers:**

| defence | answers (incoming class) | mechanism |
|---|---|---|
| judo_taisabaki_defense | takedown (via `takedown_defense`), strike (via `evasion`) | body evasion moves off the line of attack |
| judo_kumi_defense | takedown (via `takedown_defense`), control + takedown (via `scramble`) | grip fighting prevents the kumi-kata needed for throw setups |
| sambo_throw_defense | takedown (via `takedown_defense` and `throw_damage_reduction`) | low centre of gravity, hip drop |
| sambo_grip_break_defense | takedown (via `takedown_defense`), control + takedown (via `scramble`) | breaking the jacket grip to prevent throw entries |

Every effect key on every defence node has a `defense_answers` entry in
`technique_vocabulary.json`. No key was borrowed from a different meaning.

## WHAT IS ON DISK

**Judo pins (osaekomi):** `Q72_judo_seats.json` lines 8–62 list eleven osaekomi-waza
nodes, all confirmed as `ground_top`. The pin content is present; the escape content is
absent. `Q75_escape_options.json` line 6 records that the judo matchup landed 82 escapes
across 258 ground exchanges — the engine is using fallback escapes because no judo escape
node exists.

**Sambo ground:** `Q75_escape_options.json` line 7 records that sambo landed zero escapes
across 555 ground exchanges and 278 submission lands with 21 finishes. The sambo tree has
no escape and no defence node at all.

**Sambo ruleset:** `competition_rulesets_v2.json` line 303 lists
`sambo_fias_sport.legal_techniques` as `["throws", "hold_downs", "painful_holds_joint_locks"]`.
Line 316 lists `sambo_fias_combat.legal_techniques` adding chokes and strikes. Hold-downs
and joint locks are legal in both, confirming that escapes from pins and leg-lock entries
are meaningful content.

**Judo ruleset:** `competition_rulesets_v2.json` `judo_ijf` entry lists scoring as
including waza-ari for 10–19s holds and ippon for 20s+ — confirming that osaekomi is a
real scoring path that the pinned man must be able to escape from.

**Existing defences:** `judo_ukemi` is the only judo defence node (role `defense`,
phases `standing` and `clinch`, effects `throw_damage_reduction` 9 and `scramble` 4).
It answers incoming takedown (via `throw_damage_reduction`) and control + takedown (via
`scramble`). It does not answer strikes. No other judo node carries role `defense`.

**Not on disk:** no research file names specific judo pin escapes (kesa-nuki,
yoko-nuki, kami-nuki, tate-nuki) or sambo escape techniques by name. The Kodokan
newaza curriculum and sambo ground curriculum are well-known in the literature but
have not been researched in this project's files.

## WHAT AN OUTSIDE QUERY MUST VERIFY

Before these nodes ship, a single outside research query should confirm:

1. **Pin-specific escape names.** Does Kodokan judo teach distinct named escapes for
   kesa-gatame, yoko-shiho-gatame, kami-shiho-gatame and tate-shiho-gatame, or are they
   variations of a single escape movement? The `-nuke` suffix (抜ける, "to slip out") is
   standard judo vocabulary for escapes, but the specific techniques may not have
   individual names in the Kodokan syllabus.

2. **Grade placement.** Are pin escapes taught at 5th–4th kyu in the Kodokan curriculum,
   or are they introduced earlier (6th kyu) or later? The draft places basic escapes at
   5th kyu (ranks 15–16) and harder ones at 4th kyu (ranks 22–23), matching the
   surrounding judo grade ladder.

3. **Sambo escape curriculum.** Does sambo teach distinct named escapes from pins, or
   does it rely on judo-influenced and wrestling-influenced movements without its own
   terminology? The draft uses English descriptive names because no sambo-specific
   escape vocabulary was found on disk.

4. **Sambo grade placement.** FIAS launched a qualification system in 2026 (Beginner,
   six Student levels, Candidate for Master, Master, Grand Master — see
   `C52_THE_TOURNAMENT_AND_THE_GRADE.md` line 292). The draft uses "student" and
   "candidate" grades; the exact mapping to FIAS levels needs verification.

5. **Standing defence names.** Does judo teach `taisabaki` specifically as throw
   defence, or is it a general movement principle that should not be a standalone
   technique node? Similarly, is there a specific judo term for grip-fighting defence
   beyond `kumi-kata` itself?

## SUBMISSION

No `defense_answers` key in `technique_vocabulary.json` answers the `submission` class.
The `defense_classes` entry for `submission` lists `["submission"]`, but no effect key
in `defense_answers` maps to it. This means a defence node cannot resist an incoming
submission through the engine's defence mechanism — only the `defense` attribute resists
submissions today (Q75, `Q75_WHAT_RESISTS_A_STAND_UP.md` line 36: "The target's defense
stat and camp sub_defense resist the finish, not the attempt").

The sambo leg-lock escape (`sambo_esc_leglock`) is therefore drafted as an `escape`
node, not a `defense` node. It uses `role: escape`, `phases: [ground_bottom]`, and
effect keys `escape` and `scramble`. It goes through the escape mechanism
(`_resolve_escape_attempt`), not the defence mechanism
(`_defender_defense_factor`). This is honest: a man escaping a leg lock entry from
underneath is performing an escape, not a defence, and the engine already has a path
for escapes.

If a future task wants a defence node that resists submissions, it must first add a
`defense_answers` key whose entry includes `submission` — that is a vocabulary change,
not a node draft. This task does not make that change.
