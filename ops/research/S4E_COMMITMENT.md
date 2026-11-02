# S4e (5) — FEINTS AND COMMITMENT: WHAT THE ENGINE HAD, WHAT IT HAS NOW, AND WHAT IS STILL OPEN

Claude, 2026-09-15. The fourth of the five behaviours the operator named on 2026-09-14 night when he ruled ENGINE
FIRST. C133 Q5 is the audit this closes; `S4E_STANCE.md` is the shape this follows — one model, one switch (two here),
the whole delta on the new side, and a checksum rather than an argument.

## POPULATION

Every figure below comes from bouts between men who are **not the same man** and who are **legal for the ruleset they
are in** (operator rules, 2026-09-12, both halves).

- **BOXING** — a rangy out-boxer (190 cm reach, 188 cm, technique 70, speed 72, defense 68, power 48, out-boxer plan)
  against a short pressure fighter (175 cm reach, 177 cm, power 70, conditioning 76, defense 50, technique 55, pressure
  plan). Neither can kick and neither is asked to. The same pair S4e (1), (2) and (3) measured.
- **MMA** — a striker (188 cm reach, power 68, technique 66, grapple 38, orthodox, kickboxer plan) against a grappler
  (178 cm reach, grapple 78, conditioning 74, southpaw, grappler plan). Both able to do everything MMA permits;
  differentiated by style and attributes inside the ruleset, never by removing a technique it allows.
- **CATALOGUE** — the shipped `Godot/assets/data/technique_catalog.json`, no shadow (R137: a fixture is the fighters
  AND the data they fight under).
- 30 seeded bouts per row, seeds 815000+, switches off and on.

## WHAT WAS THERE BEFORE — C133 Q5, verbatim

> "**Nothing makes a feint fail to land by construction** — `boxing_feint` runs the same contact ladder as a cross —
> and **there is no open-window state at all**. The only post-throw state on a fighter is `last_throw_tick` (`:640`),
> stamped as soon as the attempt gate passes whether the blow landed, was defended or missed, and read only to boost
> his own next throw-share. A commitment model needs a second field beside it — an until-tick during which the
> thrower's own defence roll is suppressed — and no such field exists."

Both halves were true of the engine. The first half was wrong about `boxing_feint` specifically, and finding that out
is half of what this stage did — see **THE CORRECTION** below.

## THE CORRECTION — `boxing_feint` WAS NEVER IN THE FIGHT AT ALL

`tools/probe_feint_palette.gd`, run 2026-09-15, over the shipped catalogue:

```
PALETTE ruleset=boxing      feint_in_strikes=false feint_in_grapples=true feint_in_guards=false
PALETTE ruleset=kickboxing  feint_in_strikes=false feint_in_grapples=true feint_in_guards=false
PALETTE ruleset=muay_thai   feint_in_strikes=false feint_in_grapples=true feint_in_guards=false
PALETTE ruleset=mma         feint_in_strikes=false feint_in_grapples=true feint_in_guards=false
NODE move_from_node={ }  grapple_move_from_node={ "id": "boxing_feint", ... "effects": { "entry_open": 8, "distance_read": 6 } }
```

`boxing_feint` carries `entry_open`, `entry_open` is in `FightMoves.GRAPPLE_EFFECTS` (`:113`), and `move_from_node`
returns `{}` on any node carrying one. So it never reaches the striking palette. It lands in the GRAPPLE palette
instead, where `_grapple_technique_for`'s five `wanted` lists (`FightRealtime.gd:2706`) contain neither `entry_open`
nor `distance_read` — so it can never be named there either. **It is the seventh piece of correct, tested, unreachable
code this project has found.**

Two of the three nodes in that condition are correctly excluded: `wrestling_level_change` and `mma_jab_levelchange`
carry `entry_accuracy` / `entry_open` and are takedown entries, which is exactly what the comment at
`FightMoves.gd:98` says that filter is for. `boxing_feint` is a word collision — a boxing `footwork_ring` node whose
`entry_open` means "opens an entry for the next punch", not "opens a takedown". **Fixing it is its own slice**: it adds
a tier-2 node to four rulesets' striking palettes and moves every seeded fight. Open 2.

What this stage therefore acts on is the feint nodes that ARE reachable, and the engine found them by itself:
`boxing_distance_read` (boxing, tier 1 — in every default boxing arsenal) and `kickboxing_switch_step_read`
(kickboxing, tier 2, reachable in MMA).

## WHAT CHANGED

**One model, `FightCommitment.gd`, and two switches** — `commitment_window` and `feint_window`, both default on,
because a merge is not its branches and a change nobody can switch off is a change nobody can attribute.

- `FightMoves.move_from_node` settles `feint` on each move ONCE, beside `stance_family`, off the catalogue's own effect
  vocabulary: a `feint` or `distance_read` word, overruled by any damage word. `_chosen` carries it through — which is
  the half R102's `fit` was missing, and the reason `RANGE_FIT_PENALTY` has never once fired.
- `FightRealtime._build_fighter` carries `commit_until_tick` (-1 until he throws), beside `last_throw_tick` exactly
  where C133 said it had to go.
- `_run_impact` stamps it once the chosen move is known, because a feint commits a man for less time than a punch.
  **No draw.**
- The answering defence roll is still DRAWN unconditionally and its EFFECT is dropped when the defender is committed.
  That is the whole of what commitment does — no damage multiplier, no extra miss chance.
- `_run_evasion` refuses to START a defensive movement for a committed man. Its two draws are still taken at the top.
- A feint's contact word is forced to `missed` after both defence channels and before `make_impact`, and the event is
  typed **`feint`** rather than `action`. Every consumer in the project filters on `action`
  (`RealtimeRoundStats:119`, `BroadcastRead:83`, `FightBeatAdapter:538`), so no strike count moves — which is also
  what UFC Stats does with a feint. It is emitted rather than dropped because an invisible failure and an absent
  feature look identical.
- A feint is never `significant`. **The test caught this**: FightMetric's rule counts every throw at distance as
  significant, so the first run had 202 of 202 feints marked significant and `S4E5-5` failed.

### THE SWITCH IS A SWITCH, PROVEN WITH THE OLD ENGINE

`tools/probe_commitment_off.gd` checksums the whole action log of three seeded boxing bouts. Run against **HEAD's own
`FightRealtime.gd` and `FightMoves.gd`** (`git show HEAD:`, restored in `finally`) and against the new files with both
switches off:

```
HEAD PROBE commitment=off feint=off bouts=3 actions=3357 sha256=20ed8b001f91a02d...
NEW  PROBE commitment=off feint=off bouts=3 actions=3357 sha256=20ed8b001f91a02d...
NEW  PROBE commitment=on  feint=off bouts=3 actions=3936 suppressed=519 sha256=e2c881c0...
NEW  PROBE commitment=off feint=on  bouts=3 actions=3617 feints=295   sha256=21eb9bac...
NEW  PROBE commitment=on  feint=on  bouts=3 actions=3285 feints=267 suppressed=502 sha256=120f4dd0...
```

Byte-identical off; each switch moves the log on its own; the two differ from each other. **Unlike S4e (3), this stage
is not free**: the shipped default is both on, so every seeded fight moves and the pins are re-found from each test's
own printed actual.

## THE MEASUREMENT

**THE REALISM RULE IS FOOTAGE, AND IT IS LABELLED THAT WAY.** Q110 / U107, 16 YouTube videos of two men side-on,
MediaPipe Pose, 10.33 tracked minutes, 423 lead-hand moves with rise ≥ 0.12 torso-lengths, folded by
`Tools/footage/fold_jab_types.py` into `research/S4A_PAIRS/footage_jab_types.json`. Not a published study.

| footage class | n | /min | `matched_share` (a detector also called it a punch) | `reacted_share` (receiver's nose moved ≥0.15 T) | hand away from the face, p50 |
|---|---|---|---|---|---|
| feint | 152 | 14.72 | **0.0066** | **0.684** | 0.227 s |
| partial | 133 | 12.88 | 0.376 | 0.722 | 0.200 s |
| full planted | 117 | 11.33 | **0.684** | **0.718** | **0.267 s** |
| full stepping | 16 | 1.55 | 0.938 | 1.000 | 0.250 s |

Two facts fall straight out of that table and they are the whole model: **a feint is not a punch** (0.66% against
68.4%), and **it buys 95% of a real jab's reaction anyway** (68.4% against 71.8%).

`COMMIT_S` = 0.267 and `FEINT_COMMIT_S` = 0.227 are the two p50s of extension + return, unrounded.

### What the engine delivers

`tools/measure_commitment.gd`, 30 seeded bouts per row:

| bout | switches | actions | connect% | feints | feints/min | feint landed share | drew a movement | answering rolls suppressed |
|---|---|---|---|---|---|---|---|---|
| BOXING | off | 30,641 | 50.90 | 0 | 0.00 | — | — | 0 |
| BOXING | **ON** | 30,940 | **53.12** | 2,602 | **3.24** | **0.0000** | 1.88% | 4,749 (**45.97%** of all defensive chances) |
| MMA | off | 20,670 | 52.81 | 0 | 0.00 | — | — | 0 |
| MMA | **ON** | 20,793 | **54.49** | 688 | **1.61** | **0.0000** | 1.16% | 3,030 (**46.56%**) |

Feint techniques thrown: boxing `boxing_distance_read` ×2,602; MMA `kickboxing_switch_step_read` ×369 and
`boxing_distance_read` ×319.

**THE BOUND THAT IS MET.** The feint-landed share is **0.0000** against a footage ceiling of **0.0066**. The engine
takes the stronger form of the claim — zero by construction, not rarely — because the contact word is forced before
anything is applied.

**THE CONSEQUENCE, REPORTED RATHER THAN TUNED.** Connect% rises 51 → 53 in boxing and 53 → 54 in MMA. The direction is
J24's documented one and **the size has no published figure**: J24 verdict 3, verbatim, *"Published 'hit X% harder
than covering' for a mistimed check hook / stop-hit: NOT FOUND."* So no damage multiplier was added and no number was
tuned toward anything. A committed man simply does not get to answer.

**TWO GAPS, NAMED RATHER THAN CLOSED.** The engine throws feints at 3.24/min in boxing against the footage's 14.72,
and a feint draws a movement 1.88% of the time against the footage's 68.4%. Neither is tuned. The first is Open 2, the
second is Open 1, and the second is the more important of the two: *the engine does not yet CAUSE the reaction at all.*
It only records the coincidence where the other man was already moving. That is stated in the test's own output as a
PROXY rather than presented as a weak version of 68.4%, because comparing a rate calibrated to Davis's 3.6
movements-per-minute against "the nose moved 0.15 torso-lengths" is the mistake this project has already paid for.

## WHAT THE ROOM SHOWS NOW

Nothing. The `feint` event type and `drew_movement` are on the log and no presenter reads either yet, exactly as the
three S4e (4) bearing fields are. A cloud container cannot record the room (`--headless --write-movie` aborts and
leaves a 0-byte AVI, measured 2026-09-15), so showing this to the operator is a PC job and it is owed for four landed
engine stages now, not one.

## OPEN

1. **A FEINT DOES NOT YET CAUSE A REACTION — the next slice, and it needs its own switch.** Footage says 68.4% of
   feints move the other man's head. The engine draws a movement on 1.88%, and only by coincidence: `_run_evasion`
   decides on its own decision tick and a feint can do no more than be in flight when it does. Making the feint CAUSE
   the movement means a draw at impact time on `_rng_evasion`, which moves that stream's position and therefore every
   seeded fight — so it is its own slice with its own re-baseline, never folded in here.
2. **`boxing_feint` IS UNREACHABLE and the fix is a slice too.** See THE CORRECTION. The narrow repair is to let a node
   whose ONLY grapple word is `entry_open` and which carries a feint word through `move_from_node`; it adds a tier-2
   node to four striking palettes and moves every seeded fight.
3. **THE REAR HAND AND THE KICK HAVE NO MEASUREMENT.** Q110's instrument tracked the LEAD hand only, so `COMMIT_S` is
   a lead-hand figure applied to every throw. Every coaching text says a cross and a kick commit a man for longer; by
   how much is not measured. **TASK_U110 is the assigned research** — the same instrument, the same 16 videos, widened
   to the rear hand and the kick.
4. **45-47% of defensive chances are suppressed**, which follows from the engine throwing ~41 actions a minute. That
   throw rate is a pre-existing engine property and not this stage's, but it is what sets the size of this effect, and
   it is the number to re-read when the between-exchange stage (C133 Q6) lowers the action rate.
5. `boxing_distance_read` is tier 1, so every boxer has it by default and every boxing bout now contains feints. A
   fighter with a real `technique_progress` record who has not learned it will throw none. That is correct and it is
   also untested — no fixture in this project carries a progress record for it.

## Re-running it

```
godot --headless --path Godot --script tests/fight_commitment_test.gd
godot --headless --path Godot --script tools/measure_commitment.gd -- bouts 30
godot --headless --path Godot --script tools/probe_commitment_off.gd            # both off: must equal HEAD
godot --headless --path Godot --script tools/probe_commitment_off.gd -- commit feint
godot --headless --path Godot --script tools/probe_feint_palette.gd
```
