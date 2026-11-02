# M5 — THE SCORECARD: THREE JUDGES, ONE DECISION

Maria Art Director · 2026-09-06 · art only (no `.gd` / `.tscn` / `HANDOFF.md` / assets/data)

Dresses the post-fight scorecard now that **R38 seats three judges** on a
ten-point-must bout. Extends M4’s card family and stamp language to the panel,
the disagreement, the swing round, and the one-judge federation layout.
Binds `JudgePanel.gd` decision types and `median_card()`.

## Grid call: EXTENDED (not replaced)

M4’s round grid **carries three judges** without becoming a spreadsheet:

| M4 | M5 extension |
| --- | --- |
| RND · A · B · MARKS | RND · **CONSENSUS** (median, primary) · Judge 1 · Judge 2 · Judge 3 · READ |
| Empty J1 gutter | Gutter becomes three quiet ordinal mini-columns |
| Single score pair weight | Consensus keeps that weight; judges are secondary (smaller, dimmer) |

If the M4 grid had been unable to carry this, this pack would say so and show a
replacement. **It can — so this is an extension, not a quiet substitute.**

## What this dresses (engine-true as of R38)

1. **Three cards, not one** — per round `{judge, a, b}` × Judge 1/2/3.
   Labels are ordinal only. **Never real names** (J1 §4.1 / T17).
2. **Consensus vs judges** — primary read = `median_card()` (a card a judge
   actually filed). Secondary = panel rows. Never an average (would invent
   scores and break ten-point-must).
3. **Disagreement mark** — amber triangle pip on rounds where judges differ;
   spread meter when disagreement runs across many rounds (no single pip owns
   the story).
4. **Swing round** — the round that, flipped, changes the decision. Emotional
   treatment: warm hinge bar + SWING chip + nested warm outline. **Not gold,
   not BAD, not a plain highlight.** Arithmetic owned by Codex C25; art dresses
   the mark. Absent when no swing exists.
5. **Decision stamp family meets R38** — six typed states + plain `decision`:
   `unanimous`, `majority`, `split`, `unanimous_draw`, `majority_draw`,
   `split_draw`, `decision`. See stamp board.
6. **One-judge layout is first-class** — federations (`judge_count≤1`) and
   legacy saves. Not empty J2/J3 columns of a three-col grid. Stamp =
   `DECISION`, never `UNANIMOUS` (T7).
7. **Honest empties** — R1 KO = no cards; legacy = one-judge no panel.
   Neither is an error state (DIM why-copy, never BAD chrome).
8. **Three scoring styles, one family** — ten-point / points / ippon keep M4
   shared chrome; only the panel columns differ by `judge_count`.

## What this does NOT do

- No `.gd` / `.tscn` / `HANDOFF.md` / `Godot/assets/data/` edits.
- No judge names, personalities, flags, reputation, controversy.
- No live-fight surface.
- No invented scoring rules — designed-ahead states are labeled.
- Gold ×1 = verdict word only; CONTINUE = GO only; doctor = BAD;
  IPPON / TECHNICAL ≠ KO.

## Token map (Cage Desk boards ↔ UITokens)

| Role | Board hex | UITokens | Notes |
| --- | --- | --- | --- |
| Ground | `#0B1220` | `GROUND` / `TRACK` | Deep cage desk |
| Panel | `#162033` | `PANEL` / `PANEL_LO` | Card / stamp chrome |
| Panel edge | `#24324A` | `LINE` / `LINE_SOFT` | 1–2px |
| Text | `#E8EEF8` | `TEXT` | Primary / consensus |
| Muted | `#8B97AD` | `MUTED` / `TEXT_2` | Judge columns, labels |
| Dim | `#5C6A82` | `DIM` | Agree copy, empties why |
| Verdict gold | `#E8B84A` | `GOLD` | **×1 = verdict word only** |
| CONTINUE | `#2ECC71` | `GO` | Only green |
| Condition / median cue | `#3DB8D4` | `LINK` / cool | Consensus label, range |
| Disagreement | `#E89A3C` | `AMBER` | Pip + disagreeing pair |
| Swing hinge | `#E8A060` | warm stand-in (AMBER family) | Hinge / chip / outline — not gold |
| Danger | `#E24B4B` | `BAD` | Doctor only |
| IPPON / TECHNICAL | gym ladder hi | `gym_ladder(hi)` | ≠ KO |
| Range cool | `#24486f` / `#3f86cc` / `#8cc4f4` | `COOL_RAMP` | Ownership on composed |

**Gold ×1:** decision / draw **verdict word** (+ stamp border). Scores, pips,
swing, range, CONTINUE never take gold.

## Consensus vs judges (relationship)

1. Eye hits **CONSENSUS** first — same visual weight as M4’s single A—B pair.
2. Judge 1/2/3 sit quieter to the right — on demand, never competing.
3. All agree → judge columns dim (“3 agree” / quiet matching scores).
4. Split → amber pip + disagreeing pair warms to WARN.
5. Totals strip: consensus total primary; per-judge totals secondary; decision
   types derived from those totals (`JudgePanel.decision`).

## Disagreement & swing

| Mark | Tone | Means |
| --- | --- | --- |
| Amber triangle pip | `AMBER` | Judges disagreed this round |
| Spread meter | `AMBER` | Disagreement across many rounds; no single hinge |
| Hinge bar + SWING chip + warm outline | swing warm | Flipping this round flips the bout |

Pip ≠ swing. No swing → no chip (honest absence).

## Decision stamps (R38 emit)

| Stamp | `decision_type` | Subline cue | Emit |
| --- | --- | --- | --- |
| UNANIMOUS DECISION | `unanimous` | 3–0 cards | R38 |
| MAJORITY DECISION | `majority` | 2–0–1 cards | R38 |
| SPLIT DECISION | `split` | 2–1 cards | R38 |
| UNANIMOUS DRAW | `unanimous_draw` | 3 even / 0–0–3 | R38 |
| MAJORITY DRAW | `majority_draw` | **1 win · 2 even / 1–0–2** | R38 |
| SPLIT DRAW | `split_draw` | **1–1–1** | R38 |
| DECISION | `decision` | one judge · not UD | R38 (federations + legacy) |

**majority_draw ≠ split_draw** at a glance via distinct subcopy.
**Draws ≠ loss:** muted “NO WINNER”, dashed floor, no hero surname — still gold
on the verdict WORD.

Finish tones unchanged from M4: KO = finish gold; IPPON/TECHNICAL = gym;
DOCTOR = BAD; CONTINUE = GO.

## One-judge (first-class)

- Reuse M4 single-card chrome. **Do not** reserve empty Judge 2/3 columns.
- `decision_type = "decision"` — never retitle unanimous (T7).
- Applies to judo / BJJ / TKD / karate / sambo / wrestlings + every legacy save.
- Points / ippon keep the same one-judge chrome (one family).

## Honest empties

| Case | Visual |
| --- | --- |
| R1 KO | Finish stamp + empty scorecard + why (“no scored rounds”) |
| Legacy save | One-judge layout + `DECISION` stamp + why (“legacy single card”) |
| IPPON mid-card | M4 honest-empty rows for unfought rounds |

Empty ≠ error. DIM why-copy; never BAD chrome; never warn triangles for absence.

## Motion

| Element | Motion |
| --- | --- |
| Verdict stamp | Border + word fade-in ~180ms |
| Swing hinge | Static on report (no pulse competing with stamp) |
| CONTINUE | Idle / press only (`GO`) |
| Card rows | No score ticker |

## Engine anchors

- `Godot/scripts/JudgePanel.gd` — `panel`, `score_round`, `median_card`, `decision`
- `Godot/tests/judge_panel_test.gd` — T3 emit states; T7 legacy not UD
- `research/J1_ORGANIZATION_RULES_AND_JUDGES.md` §4.1 — no living officials named
- M4 delivery — chrome / stamp family / range slot this extends
- Swing arithmetic — Codex C25 (art dresses; does not invent)

## File list

### Spec
- `research/M5_SCORECARD_THREE_JUDGES.md` (this file)

### Boards → `DesignLibrary/screens/post_fight/`
- `m5_01_three_judge_grid.png`
- `m5_02_consensus_vs_judges.png`
- `m5_03_disagreement_and_swing.png`
- `m5_04_decision_stamps_r38.png`
- `m5_05_one_judge_layout.png`
- `m5_06_empties_legacy.png`
- `m5_07_composed.png` (optional compose)

### Staging
- `_maria_delivery/M5_SCORECARD.zip`
- `_maria_delivery/CLAUDE_LAND_NOTE_M5.md`
- `research/CLAUDE_LAND_NOTE_M5.md`

## Operator / Claude land

1. Extract zip → `DesignLibrary/screens/post_fight/` (`m5_*` alongside `m4_*`).
2. Copy spec → `research/M5_SCORECARD_THREE_JUDGES.md`.
3. Boards are design refs — runtime is code-drawn from UITokens + R38 reads.
   Do not import board PNGs as runtime HUD bitmaps.
4. Claude writes Maria HANDOFF block; Maria does not edit HANDOFF.
5. Grid call for HANDOFF: **M4 grid EXTENDED** (consensus primary + three
   ordinal judge columns) — not replaced.
