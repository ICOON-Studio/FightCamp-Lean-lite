# Q56 — THE VOCABULARY GAP

**Three-column map: what the ENGINE emits, what we OWN, what is BOUND.**

---

## THE NUMBERS AT A GLANCE

| | count |
|---|---|
| Animation clips owned (Q47 CSV, loadable) | **160** |
| Distinct techniques (deduped InPlace/Forward, RootMotion) | **~85** |
| RootMotion duplicates (engine owns translation) | **17** |
| Props / reference poses (not clips) | **6** |
| Clip bindings (`FightClipBinding.BINDINGS`) keys | **14** |
| Clip bindings paths (counting variants) | **30** |
| Stage director roles (`FightStageDirector.required_roles()`) | **10** |
| Roles with NO clip bound | **2** (`strike_body`, `strike_leg`) |
| Paired two-body clips owned | **32** (16 pairs) |
| Paired pairs bound | **0** |
| Grapple event kinds the engine logs | **10** |
| Grapple kinds with any clip role | **0** |

---

## COLUMN 1 — ENGINE WORDS WITH NO CLIP

The engine emits far more than ten words. The stage director names ten roles;
the grapple system logs ten distinct `kind` values; the technique catalogue
holds 272 nodes across 15 disciplines. **None of the grapple kinds have a clip
role.** None of the 272 catalogue techniques resolve to a clip except three
(jab, cross, hook_lead via alias).

### 1A. Stage director roles with no clip (DOCUMENTED)

| Role | Source | Clip bound? |
|---|---|---|
| `idle` | `FightStageDirector.gd:28` | YES — `H2H_Idle.FBX` |
| `strike_head` | `FightStageDirector.gd:29` | YES — authored combo file |
| **`strike_body`** | `FightStageDirector.gd:30` | **NO** |
| **`strike_leg`** | `FightStageDirector.gd:31` | **NO** |
| `react_head` | `FightStageDirector.gd:32` | YES — 4 variants |
| `react_body` | `FightStageDirector.gd:33` | YES — 7 variants |
| `react_leg` | `FightStageDirector.gd:34` | YES — 1 clip |
| `block` | `FightStageDirector.gd:35` | YES — `BlockStart` only |
| `slip` | `FightStageDirector.gd:36` | YES — 3 variants |
| `knockdown` | `FightStageDirector.gd:37` | YES — 2 variants |

### 1B. Grapple event kinds with no clip role (DOCUMENTED)

Ten distinct `kind` values written by `_log_grapple` in `FightRealtime.gd`:

| Kind | Line(s) | What it is |
|---|---|---|
| `takedown_attempt` | 2089 | Failed takedown |
| `takedown` | 2096 (via `_move_seat`) | Successful takedown, behind hold gate |
| `throw_attempt` | 2176 | Failed throw from clinch |
| `throw` | 2181 (via `_move_seat`) | Successful throw |
| `clinch_engage` | 2114 (via `_move_seat`) | Tie-up established |
| `clinch_break` | 2186 (via `_move_seat`) | Clinch separated |
| `seat` | 2244 | Seat change (position transition) |
| `position_change` | 2210, 2273, 2366, 2385 | Ground advance (via: pass/mount/sweep) |
| `stall` | 2135, 2320 | Inactivity warning |
| `submission_attempt` | 2353 | Submission opened |
| `submission_finish` | 2417 | Submission completed (tap/technical) |
| `control` | 2450 | Control units scored per cadence |

**No clip role exists for any of these.** The engine scores takedowns, throws,
passes, sweeps, submissions and control — and the 3D stage has no word for any
of them.

### 1C. Technique catalogue IDs with no clip (DOCUMENTED)

`FightMoves.gd` loads 272 nodes from `technique_catalog.json` across 15
disciplines. `FightBeatAdapter.TECHNIQUE_CLIP_ALIASES` maps exactly three:

```
"boxing_jab"    → "jab"
"boxing_cross"  → "cross"
"boxing_lead_hook" → "hook_lead"
```

The remaining **269 technique IDs** resolve to nothing. Every kick, every
uppercut, every elbow, every knee, every grappling technique — all 269 hit the
`_clip_role_for` fallback and return `""` (DOCUMENTED, `FightBeatAdapter.gd`
`_clip_role_for`).

---

## COLUMN 2 — CLIPS WITH NO ENGINE WORD

160 loadable clips. Grouped by family, with the engine's relationship to each.

### Summary by family

| Family | Files | Distinct techniques | Bound | Engine could use it? |
|---|---|---|---|---|
| Strikes — punches | 18 | ~13 | 6 (jab/cross/hook + mirrors) | YES — 12 unbound punches |
| Strikes — kicks | 18 | ~18 | 0 | YES — for MMA/KB/MT rulesets |
| Blocks (hands) | 4 | 1 family (state machine) | 1 (BlockStart) | YES — 3 unbound (Loop/End/Idle) |
| Blocks (legs) | 4 | 1 family (state machine) | 0 | YES — 4 unbound |
| Slips & dodges | 7 | 7 | 3 (SlipL/R, FadeBack) | YES — 4 dodges unbound |
| Reactions (hit) | 4 | 4 | 4 (react_head variants) | YES — all bound |
| Reactions (stagger) | 16 | ~6 severity/direction groups | 7 (react_body) + 1 (react_leg) | YES — 8 unbound variants |
| Knockdowns | 2 | 2 | 2 (knockdown variants) | YES — all bound |
| Get-up | 1 | 1 | 0 | YES — after knockdown |
| Idle / stance / turns | 11 | 11 | 1 (H2H_Idle) | YES — 10 unbound |
| Jumps | 5 | 5 | 0 | INFERENCE — engine has no jump vocabulary |
| Power charge | 3 | 1 family (Start/Loop/End) | 0 | INFERENCE — no charge vocabulary |
| Locomotion (walk/run/sprint) | 34 | 17 | 0 | YES — engine has no locomotion roles yet |
| Weapon / utility | 2 | 2 | 0 | **NO** — unarmed game |
| Paired — ground H2H | 8 | 4 pairs | 0 | YES — armbar, headsmash, punches, strangle |
| Paired — takedowns | 8 | 2 sequences (BodyLock, DoubleLeg) | 0 | YES — takedown entries |
| Paired — weapon/other | 16 | 8 pairs | 0 | **NO** — weapon clips, not this game |
| Props / reference | 6 | 0 | 0 | **NO** — not animation clips |
| **TOTAL** | **160** | **~85** | **19** | |

### What could play if the vocabulary were widened

**Could play (engine could plausibly emit a word):**
- 12 unbound punches (haymaker, uppercut, backfist, spinning hook, etc.)
- 18 kicks (all — for MMA/KB/MT rulesets)
- 7 unbound blocks (BlockLoop/End/Idle + 4 leg blocks)
- 4 unbound dodges (Forward/Back/Left/Right)
- 8 unbound stagger variants (by severity and direction)
- 1 get-up
- 10 unbound idle/turn clips
- 17 distinct locomotion clips (34 files minus 17 RootMotion duplicates)
- 8 paired ground H2H (armbar, headsmash, punches, strangle — Att/Vic)
- 8 paired takedown entries (BodyLock Start/Loop/End, DoubleLeg Start)
- 8 paired other (PushOff, Reversal, AttackBlock, VictimAttack — ground transitions)
- 5 jumps (if jump vocabulary added)
- 3 power charge (if charge vocabulary added)

**Subtotal: ~102 clips could play** (counting files, not distinct techniques)

**Could never play (not this game or not a clip):**
- 2 weapon/utility (Equip, Unequip) — unarmed
- 16 paired weapon clips (1HM_AxeToFace, KnifeStab, SlashNeck, BluntSmack + Victim/Block variants) — armed combat
- 6 props/reference (Android_SkeletalMesh, Hammer_Mesh, OneHandAxe, T_pose ×2, Standing_Idle) — not animation clips
- 17 RootMotion duplicates — engine owns translation (G42 §4), these are the same clips

**Subtotal: 41 clips could never play**

**102 + 41 + 17 bound = 160.** ✓

---

## COLUMN 3 — BOUND BUT NARROW

Roles bound to exactly one clip (or a small number), so the same film plays
every time.

| Role | Clips bound | Variants | Notes |
|---|---|---|---|
| `react_head` | 1 primary | 4 variants | 56.9% of all receiver demand (C87) — 4 takes helps |
| `react_body` | 1 primary | 7 variants | 37.1% of receiver demand — 7 takes, best-covered |
| `react_leg` | 1 | 0 | **Single clip, no variants** — every leg reaction looks identical |
| `knockdown` | 1 primary | 2 variants | 2 takes — the minimum for a set piece |
| `slip` | 1 primary | 3 variants | 3 takes — adequate |
| `block` | 1 | 0 | **Single clip** — BlockStart only; 7 owned block clips unbound |
| `idle` | 1 | 0 | Loop — single clip is correct for idle |
| `strike_head` | 1 (authored) | 0 | Full combo file — not from the 160 |

**The worst cases:**
- `react_leg`: 1 clip, 0 variants. Every leg reaction is the same LowHit stagger.
- `block`: 1 clip, 0 variants. Seven owned block clips sit unused.
- `strike_body` and `strike_leg`: 0 clips. Not narrow — absent.

---

## THE ONE NUMBER

**Of the 160 owned clips, 102 could be on screen if the vocabulary were
widened, and 41 could never be** (weapon clips, props, RootMotion duplicates,
and Equip/Unequip in an unarmed game).

The bottleneck is not the clips. It is the vocabulary. The stage names ten
things — all striking — and the engine emits ten grapple kinds the stage cannot
see. Bridging that gap activates two-thirds of the library we already paid for.

---

## SOURCES

All claims are DOCUMENTED from these files:
- `Godot/scripts/FightStageDirector.gd` — 10 roles, `required_roles()`
- `Godot/scripts/FightClipBinding.gd` — 14 keys, 30 paths in `BINDINGS`
- `Godot/scripts/FightBeatAdapter.gd` — `TECHNIQUE_CLIP_ALIASES` (3 entries), `_clip_role_for`
- `Godot/scripts/FightRealtime.gd` — 10 `_log_grapple` call sites, lines 2088–2449
- `Godot/scripts/FightMoves.gd` — `GRAPPLE_EFFECTS` list, `RULESET_DISCIPLINES`, `STRIKE_ROLES`
- `Godot/scripts/GrappleAdapter.gd` — award kinds per ruleset
- `research/Q47_INVENTORY.csv` — 161 rows, 160 loadable
