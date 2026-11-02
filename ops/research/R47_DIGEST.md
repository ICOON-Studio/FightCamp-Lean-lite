# R47 — THE BELT ON THE BOARD (Claude, 2026-09-07)

Third stage of THE SCREENS CATCH UP CYCLE. Spends Codex **C26**
(`get_championship_read`) and builds Maria **M7 THE BELT** — the oldest
unbuilt pack, drawn 2026-09-06.

## What changed

`RankingsHubPanel.gd`'s CHAMPIONS tab was a holder list: five keys handed to
`UIKit.belt_holder_row()` — label, holder id, holder name, vacant, note. It
could not say a belt was **interim**, that a champion was **held out**, how
long a reign had run or how often it had been defended, although R41 has
written `title_status` at booking since 2026-09-06 and C26 has returned all
of it since.

It is now M7's **division board**: one entry per weight class, one fixed
skeleton in all three states, everything from `get_championship_read(key)`.

- **The belt mark** — one per entry, one geometry, three fills: a solid
  SODIUM plate (champion), an ICE outline with a dashed eight-tick ring
  (interim), a MUTED empty plate (vacant). Never two solid marks: the engine
  cannot hold two champions (J3 Q3).
- **The holder band**, fixed height. The recognised champion in SODIUM; when
  the belt is stood in for, the interim on a **second line inside the same
  band** in ICE, "STANDING IN" — never "also champion", never a second
  column. A held-out champion keeps the belt, the slot and the reign, with
  M6's `HELD · N WEEKS` in BAD beside their name as *body* chrome.
- **The reign strip** — defences, since-week, last-defended in LINK. The
  seeded belt really does read `0 DEFENCES · SINCE WEEK 0 · NEVER DEFENDED`
  and is printed as such.
- **Honest empties.** `vacancy_reason` arrives `{"value": "", "source":
  "absent"}` and the board says so — `VACATED BY <NAME>, WEEK N. NO REASON
  RECORDED.` — it never infers a reason and never leaves the vacated name
  greyed in the holder slot. A division the world never seeded a belt in
  still draws its entry and says why: a belt needs three fighters.
- The press now carries the **weight class**, not the holder id: a vacant
  belt has no id, and two vacant belts in one scope used to match each other
  on an empty string. OPEN HOLDER survives as the tab's one primary action
  and opens the *recognised* champion only.

## The token ruling (settled, not reopened)

Two constants added to `UITokens.gd`, the only lines this stage put there:
`SODIUM #f2c14e` and `ICE #5ec8e0`. M7's written argument holds — GOLD stays
M5's verdict word, because a belt sits on the rankings desk all week and a
gold board would teach the player that a championship *is* a result.
`SELECT` was refused (it does not exist and was not invented); the reign
numbers wear `LINK`. CHAMPION / INTERIM / VACANT are **not** mapped onto
GOOD / AMBER / BAD — those are M6's medical family, and a vacant belt is not
broken.

`UIKit.belt_holder_row()` is untouched (the Kit Book renders it and its
parity is tested) and simply has no caller in this panel any more.

## Cost note for whoever spends C26 next

`get_championship_read()` deep-copies the whole career **twice** per call
(`GameState.gd:9750`, `:9755`). Eight calls measured at 84 ms on the seeded
save, so the panel takes them only on the CHAMPIONS tab and only on a
rebuild, which happens on a press. A batched read would be a GameState
stage, not a screen one.

## Test

`tests/rankings_hub_panel_test.gd` — **69 checks, 0 failures** (was 30).
All three states are drawn and asserted, not just the one the seed holds:
the test installs an interim the way the engine writes one
(`title_status`, `interim_holder_id`, `interim_holder_name`, plus a real
`medical_hold_until_week` on the champion), then vacates the belt, then puts
the save back exactly as it found it.

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/rankings_hub_panel_test.gd
```

Systems green alongside it: `championship_read_test` 8/8,
`rankings_api_test` 49/49, `titles_rankings_test`, `title_flag_test`,
`ui_kit_book_test` (the token file moved). Full suite run once before the
commit.

## Left standing

`get_organization_read` (C24) is still the last orphan read — the stage
after this one. M7's calendar `TITLE BOUT` chip is not this stage's board
and stays with SCHEDULE.
