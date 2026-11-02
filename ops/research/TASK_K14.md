# TASK K14 — THE BOOT: TITLE, SLOTS, SETTINGS (Kalli)

Model: top tier (Opus-class), effort high, Fast off. **Study only** — no
`.gd`, no `.tscn`. Deliverables in `research/`, pushed by you; Claude
writes your `HANDOFF.md` block. Nothing blocks this task.

## Why

You already ruled, in K13's question E, that the boot menu is its own stage
rather than part of career creation. This is that stage.

`MainMenu.gd` is 691 lines and `Splash.gd` is 73, both pre-kit, and by the
user's 2026-09-05 decision every pre-kit scene is **discarded and rebuilt
from the kit**, never migrated. Six hubs have been rebuilt on your studies —
GYM (K8), TRAINING (K9), SCHEDULE (K10), SCOUTING (K11), OFFICE+STAFF (K12),
and creation is designed (K13). The boot is the last unstudied surface, and
it is the **first thing a player ever sees**, so it sets the bar for
everything behind it.

It is also the one board with no career behind it at all: no rail, no top
bar, no Continue, and — unlike creation — not even a step to be on.

## What is there today, so you can judge it

- Three save slots (`SAVE_SLOT_COUNT := 3`, `GameState.gd:73`).
- `get_save_summary(slot)` (`GameState.gd:2716`) is what a slot row can say.
  Read it and say what a player actually needs to tell two saves apart.
- The current menu wraps this in a "career dossier" for the newest save
  (`MainMenu.gd:77` `_build_career_dossier`, `:199` `_continue_latest`) and
  an overlay panel for the other slots (`:211` `_build_slot_overlay`), with
  one overlay reused for both NEW and LOAD via `_slot_mode` (`:32`) and an
  overwrite confirmation (`:33`).

## Answer these, in this order

**A. The shape.** Is the boot one board or two (title, then slots)? Does the
splash survive at all, or is it a load screen pretending to be a title? Give
ONE recommendation and name what you rejected and why, as K8-K13 did.

**B. The chrome.** The project owns three frames: `ShellChrome` (career
only), K7's set-piece frame, and K13's new `CreationChrome`. Say which one
the boot wears, or make the case for a fourth — a fourth needs a reason
stronger than "it is different", because every frame is code someone
maintains.

**C. The slot.** A save slot is a decision surface: the player is choosing
which life to re-enter. What must a row carry — gym name, city, career week
or date, roster size, record, cash, fame, last played — and what should be
left off because it cannot be judged at a glance? Say plainly which of those
`get_save_summary()` does not currently return, so Claude knows whether this
stage needs a Codex read task before it can be built.

**D. The two seams.** NEW CAREER hands to K13's `CreationChrome` step 1;
CONTINUE / LOAD hands straight to THE DAY with the shell installing. Draw
both, ms-labeled, consistent with K13's **780 ms** creation handoff and K7's
enter/exit timings. They should not feel like two unrelated transitions.

**E. Settings.** What belongs on the boot versus inside a running career,
and what does a settings board look like when the kit has no form family
yet? Audio, resolution and the ruleset selection are the real cases.

**F. First run.** An empty slot board is what a brand-new player sees before
anything else in this game. Draw that state deliberately — it is not an
error state.

**G. Kit gaps.** After trying the gym / training / schedule / scouting /
office families and K13's creation instruments first, table what is
genuinely missing, one line of need each. Reuse before you mint. **No drag
primitive** unless you draw its states separately.

## Boards (1920×1080)

1. **THE TITLE** — the first frame, with whatever CONTINUE affordance you
   recommend.
2. **THE SLOTS** — three saves, one of them clearly the newest.
3. **SETTINGS** — the board from E.
4. **THE SEAMS** — the two handoffs from D, ms-labeled.
5. **STATES** — no saves at all (F), a save from an incompatible version,
   delete confirmation, overwrite confirmation, and the return path from
   creation if the player backs out.

## Kit rulings to obey

Bebas / IBM Plex Mono; SIZE_MIN 12; **gold once per board**; green is
CONTINUE only; `pair` is slate; the facility is a **gym**, never a camp;
money is real; silhouettes, never ripped art; body rhythm ~210. The kit book
is `DesignLibrary/kit/index.html` (181 variants, 16 families) — read it
before inventing anything. K13's study
(`research/CREATION_K13.html`, `K13_DIGEST.md`) is the board this one
hands off to; read it first so the two seams agree.

## Files to deliver

- `research/BOOT_K14.html` — the full study
- `research/BOOT_K14_title.png`
- `research/BOOT_K14_slots.png`
- `research/BOOT_K14_settings.png`
- `research/BOOT_K14_seams.png`
- `research/BOOT_K14_states.png`
- `research/K14_DIGEST.md` — short: the shape, the chrome, the slot
  row, the two seams, the settings ruling, the kit gaps.

Push only your `research/` deliverables. Do not edit `HANDOFF.md`,
any `.gd` or any `.tscn` — Claude writes your block and does the build.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/BOOT_K14.html
research/BOOT_K14_title.png
research/BOOT_K14_slots.png
research/BOOT_K14_settings.png
research/BOOT_K14_seams.png
research/BOOT_K14_states.png
research/K14_DIGEST.md
```
