# TASK K13 — CAREER CREATION (Kalli)

Model: top tier (Opus-class), effort high, Fast off. **Study only** — no
`.gd`, no `.tscn`. Deliverables in `research/`, pushed by you; Claude
writes your `HANDOFF.md` block. Nothing blocks this task.

## Why

Career creation is the last stretch of the pre-kit game. `CountryMap.gd`
(252 lines), `CityScreen.gd` (404) and `GymHub.gd` (156) still carry the
2026-08 look, and by the user's 2026-09-05 decision every pre-kit scene is
**discarded and rebuilt from the kit**, never migrated. Five hubs have been
rebuilt this way on your studies — GYM (K8), TRAINING (K9), SCHEDULE (K10),
SCOUTING (K11), OFFICE+STAFF (K12). This is the same job for the three
screens that run **before** a career exists.

They are not hubs, and that is the interesting part: there is no rail, no
top bar and no Continue, because `ShellChrome` is career-only. Creation has
to say where it is and how far along without the furniture every other
board leans on.

## Answer these, in this order

**A. The shape.** Three scenes, one flow with steps, or one board that
swaps its middle? Give ONE recommendation and name what you rejected and
why, as K8-K12 did. The decision is a real one: country → city → gym is
three choices of decreasing scope, and the player cannot judge the third
without remembering the first two.

**B. The chrome.** What does a pre-career board wear instead of
`ShellChrome`? K7's approved set-piece frame
(`research/SETPIECE_FRAME_K7.html`) is the only other frame the
project owns — say whether creation reuses it, extends it, or needs its own,
and how a player reads "step 2 of 3" without a rail.

**C. What the choice actually needs.** Each screen asks for a decision the
player currently makes half-blind. The data exists:
`get_country_combat_profile()` (economy, talent depth, combat popularity),
`get_country_data()`, `get_rival_gyms()`, `get_world_organizations()`,
`get_world_events()`, `get_world_coaches()`, `get_world_prospects()`. Say
what each of the three decisions needs on screen to be a real decision
rather than a coin flip — and what should be left out because it cannot be
judged yet.

**D. The handoff.** Creation ends by writing a save (`begin_new_career` →
`generate_starter_boxing_floor` → `finalize_new_career`) and dropping the
player into THE DAY. That seam is the first thing anyone sees of the game
proper. Draw it. If it belongs to K7's frame, say so.

**E. One line on the boot menu.** `MainMenu.gd` is 691 lines of slots, load
and settings. It is NOT in this study's scope — but say in one line whether
it belongs to the same rebuild stage as creation or to its own, and why.

**F. Kit gaps.** After trying the gym / training / schedule / scouting
families first, table the instruments that are genuinely missing, one line
of need each. Reuse before you mint. **No drag primitive** unless you draw
its states separately.

## Boards (1920×1080)

1. **THE COUNTRY** — choosing a market, with what makes one market differ
   from another visible.
2. **THE CITY** — choosing a city inside it: rivals, organisations, events.
3. **THE GYM** — naming the gym and taking the starter floor and roster.
4. **THE HANDOFF** — the save is written and the career opens.
5. **STATES** — nothing chosen yet, a market with no detail generated, an
   invalid or empty gym name, and the return path if the player backs out.

## Kit rulings to obey

Bebas / IBM Plex Mono; SIZE_MIN 12; **gold once per board**; green is
CONTINUE only; `pair` is slate; the facility is a **gym**, never a camp;
females never fight males and weight classes must match; money is real;
silhouettes, never ripped art; body rhythm ~210. The kit book is
`DesignLibrary/kit/index.html` (181 variants, 16 families) — read it before
inventing anything.

## Files to deliver

- `research/CREATION_K13.html` — the full study
- `research/CREATION_K13_{country,city,gym,handoff,states}.png`
- `research/K13_DIGEST.md` — the short version: the pick, the
  rejected alternatives, the chrome ruling, the kit-gap table, blockers

## Finish

Push only your `research/` deliverables. Never edit `HANDOFF.md` —
Claude writes your block. Keep the digest short.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/CREATION_K13.html
research/K13_DIGEST.md
```
