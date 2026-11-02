# S1d — THE GROUND HAD NO SEATS: WHAT THE MERGE ERASED, WHAT CAME BACK, WHAT IT EXPOSED

2026-09-12. Claude. Commits `1f80326` (tooling) · `f160fe9` BJJ roles · `f851924` BJJ
seats · `f14a8cc` sambo · `a495368` MMA · the closing vocabulary commit. **Judo
measured and held back** — `unseated_debt`, owned by TASK_Q72.

## 1. The finding, sharper than S1c §5

`match.phases` is a physics selector, like `match.role`. `FightSimulation._eligible_actions`
offers a fighter only techniques whose phases meet the seat he is in —
`STANDING`, `GROUND TOP`, `GROUND BOTTOM` (`_allowed_catalog_phases`). Its lists never
named plain `ground`, `cage_clinch`, `ground_cage` or the weapon words.

**S1's merge did not just use plain `ground` — it wrote it over seats that had been
authored.** On `f0710f1` (the merge's first parent) BJJ carried `ground_bottom` ×13,
`ground_top` ×8 and explicit pairs (`bjj_armbar` = `[ground_top, ground_bottom]`). The
merge flattened all of it to `["ground"]`, and — the same day it flattened judo's
takedowns to `damage` — flattened BJJ's physics roles too: scissor sweep, kimura chain
and berimbolo `transition → control`, shrimp escape `escape → defense`.

Census before S1d, all 696 nodes: **114 selectable techniques no seat could reach** —
BJJ 59, judo 33, arnis 15 (weapon-only, correctly), MMA 5, sambo 2.

**In real bouts** (`tools/measure_ground_seats.gd`, 40 seeded bouts per matchup, every
pair non-identical, legal for its ruleset and named in the output):

| matchup | ground exchanges | answered by FALLBACK |
|---|---:|---:|
| BJJ guard player vs pressure passer (bjj) | 64.7% | **100% top, 100% bottom** |
| MMA grappler vs striker (mma) | 24.1% | 0% top (elbow GnP only), **100% bottom** |
| Judo thrower vs newaza specialist (judo) | 55.1% | **100% top, 100% bottom** |

## 2. Why not "read plain `ground` as both seats"

That was the handover's proposal and the data refutes it. A guard pass is the top man's
action and a sweep the bottom man's; both-seat `ground` lets the man underneath pass
guard. And 22 judo sacrifice throws are `[clinch, ground]` because they **end** on the mat
— read as a seat, a tomoe-nage becomes throwable by a man already lying down, through the
one arm that can declare an ippon.

## 3. The repair — `tools/derive_technique_phases.py`, one discipline per commit

Every input is read off the node or off what master authored; no list of ids.

- **C — a landing, not a seat.** Drop `ground` when role is `takedown`, or when the node
  also has a standing seat and carries `sacrifice_throw` / `phase_transition`.
- **A — restore what was authored** on `f0710f1`.
- **B — derive from the node's own effects.** Bottom markers (`guard_control`, `sweep`,
  `sweep_threat`, `escape`, `control_escape`, `guard_recovery`, `counter_to_pass`) →
  `ground_bottom`; else top markers (`pass_guard`, `pin_control`, `control`,
  `back_control`, `ground_damage`, `turn`, `top_control`, `damage_to_submission`) →
  `ground_top`; else an explicit pair. The last four top markers came from the
  calibration: master authored every node carrying them top-only.
- **Qualifiers** (`ground_cage`) keep their word and get a seat appended.

**Calibration:** rule B agrees with master on **39 of 47** authored nodes; the report prints
the 8 (four are master's `scramble`, which reaches both seats; two are judo submissions
master put on top). And `derive_technique_roles.py` gained **rules 4 and 5**: a
ground-seated `sweep` in role `control` → `transition` (the only arm that hands over
`top_side`); a ground-seated `escape` in role `defense` → `escape` (the only road back to
STANDING, and the only thing that clears a submission attempt).

## 4. Per tree, measured

Every commit ran the named grappling subset (34 tests, `run_tests.py --only a,b,c`) and
its failure **lines** were diffed against the previous state — not just its count.

| commit | nodes | subset | measured, 40 bouts |
|---|---|---|---|
| BJJ 1/2 roles | 13 roles | 34/5, lines identical to parent | takedowns landed 95 → 222: four ground escapes had been padding STANDING defense (§6) |
| BJJ 2/2 seats | 70 | **34/4 — `fight_plan_explainer_test` green** | fallback 100% → **0%** both seats; 32 distinct ground techniques; sweeps 0 → 40; wins 9/31 → 17/21 |
| sambo | 3 | 34/4, identical | distinct 6 → 9; submissions 32 → 14 (§6) |
| MMA | 4 via engine + 1 | 34/4, identical | identical — no fixture knows a cage technique |
| **judo** | **55 — HELD** | 34/4, identical | ippon **31 → 11**, decisions 9 → 29, rear chokes from the bottom seat |

BJJ's unreachable selectable nodes 59 → 0; ground-eligible catalogue nodes top 22 → 62,
bottom 13 → 59.

## 5. The vocabulary, and gates that were watched saying no

`technique_vocabulary.json` now authors `phase_seats` (which word grants which seat),
`weapon_only_phases`, `retiring_phases` (`ground`) and `unseated_debt` (judo, with reason
and owner). `FightSimulation`'s three lists must equal what `phase_seats` derives —
`clinch_break` left the engine with the last node that used it; `cage_clinch` joined.

- `tests/technique_phase_seat_test.gd` — vocabulary ↔ engine ↔ catalogue, every
  selectable technique reachable, outside declared debt. **Watched failing:** with judo's
  debt removed it names 55 retiring-word nodes and 33 unseated; with a fake debt for
  boxing it fails "still owed (0 nodes)" — a debt entry cannot outlive its debt.
- `validate_technique_nodes.py` — **watched rejecting** a delivery with a plain-`ground`
  armbar (RETIRING, no seat) and a cage-only escape, while passing a seated probe.
- `fight_plan_explainer_test` now reads the engine's phase lists instead of its own copy,
  and the armbar's name from the catalogue (S1 renamed it; the literal kept the test red
  after the seat was already right).

## 6. What the visible ground exposed — measured, NOT fixed here

1. **Submissions cannot finish** (U70, `2314f9d`). The attempt is replaced whenever the
   same fighter lands a DIFFERENT submission and cleared by any escape, so a finish needs
   5–7 same-id lands in a row: `(1/k)^(n-1)`. BJJ, palettes of 7–9 and escapes on both
   sides: 1 submission in 40. Sambo, the leglocker's effective palette 1.07 and no
   escapes anywhere: 32 in 40 — until S1d gave him a third lock (14). Recommendation (a):
   one accumulator per target, partly kept on a switch.
2. **Judo has no matte and no osaekomi ippon.** Before S1d the bottom man had nothing
   eligible and the fallback escape stood the fight up — an accidental matte. Rules on
   disk: `G38_THE_GROUND_FIGHT_READ.md:59-60`. TASK_Q72.
3. **`_defender_defense_factor` is phase-blind.** It sums every `defense`-role technique a
   fighter knows, so ground escapes defended punches — BJJ 1/2 moved standing takedowns
   by 2.3x without touching the ground.
4. **`bjj_guard_pull` is role `control`**, so a guard pull never takes the fight down; a
   BJJ bout reaches the ground only by a takedown.
5. **Rule B's neutral pair is wrong for a few locks**: americana and gogoplata from the
   wrong seat; judo's back chokes (why judo is held).
6. **The `pocket` word was flattened to `standing`** on 14 boxing and muay thai nodes in
   the merge. Not an eligibility defect — `range_band` carries the distance — recorded.

## Reproducing

    python Godot/tools/derive_technique_phases.py                     # report, all trees
    python Godot/tools/derive_technique_phases.py --discipline judo   # the held tree
    python Godot/tools/derive_technique_roles.py
    Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/measure_ground_seats.gd
    Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/technique_phase_seat_test.gd
