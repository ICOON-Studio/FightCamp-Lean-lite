# CLAUDE LAND — Maria M5 Scorecard Three Judges (2026-09-06)

Maria Art Director finished **TASK M5 — THE SCORECARD: THREE JUDGES, ONE DECISION**.
Art only. Please land. Do not wait on Maria for more files. Do **not** expect
Maria to edit `HANDOFF.md` — write the Maria HANDOFF block yourself after land.

## What landed

- Spec: `research/M5_SCORECARD_THREE_JUDGES.md`
- Boards: `DesignLibrary/screens/post_fight/m5_*` (7 PNGs, alongside M4)
- Staging zip: `_maria_delivery/M5_SCORECARD.zip`
- This note: `_maria_delivery/CLAUDE_LAND_NOTE_M5.md` and
  `research/CLAUDE_LAND_NOTE_M5.md`

## Grid call (important)

**M4 round grid EXTENDED — not replaced.** Consensus (median) is the primary
column at M4 score weight; Judge 1/2/3 are secondary ordinal mini-columns
(never real names). If it could not carry three judges, the pack would have
said so and shown a replacement. It can, so this is an extension.

## What it is / is not

- **Is:** three-judge scorecard extension; consensus-vs-judges relationship;
  disagreement pip + spread read; swing-round emotional treatment; R38 stamp
  family (six + plain `decision`); first-class one-judge layout; honest empties
  / legacy; token map; composed optional board.
- **Is not:** `.gd` / `.tscn` / HANDOFF / assets/data edits. No judge names,
  personalities, flags, reputation, controversy. No live-fight surface. No
  invented scoring rules.

## Gold / green / tones

- Gold ×1 = **verdict word line only**.
- majority_draw vs split_draw distinguished by subcopy (1–0–2 vs 1–1–1).
- Draws ≠ loss look (muted NO WINNER + dashed floor).
- CONTINUE = `GO` only. Doctor = BAD. IPPON / TECHNICAL = gym ≠ KO.
- Disagreement = AMBER pip. Swing = warm hinge (not gold).

## Engine anchors for HANDOFF if useful

1. `JudgePanel.decision` types now match the stamp board (R38).
2. `median_card` = primary consensus read (never average).
3. One-judge / legacy → plain `decision`, never unanimous (T7).
4. Swing arithmetic = Codex C25; art only dresses the mark.

## Land steps

1. Extract `_maria_delivery/M5_SCORECARD.zip` (or copy boards) →
   `DesignLibrary/screens/post_fight/`.
2. Spec → `research/M5_SCORECARD_THREE_JUDGES.md`.
3. Do not import board PNGs as runtime bitmaps — code-draw from UITokens + R38.
4. Write Maria HANDOFF block; mark TASK_M5 done when acknowledged.
5. Pending reminder: M4 post-fight pack may still await land — land M4 then M5
   (or together); M5 assumes M4 chrome language.
