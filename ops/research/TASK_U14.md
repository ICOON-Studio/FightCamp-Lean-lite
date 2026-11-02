# TASK U14 — CURSOR — THE PROMOTION THAT NEVER SAYS WHO IT IS

Model: Composer, effort **high**, Fast off. One session.

**Agent:** cursor · **Model:** Composer, effort **high**, Fast **off** ·
**Opened:** 2026-09-08 · **Depends on:** U12 (landed), C47 + C49 (landed)

**Runs immediately. Does not wait for U13** — that task owns
`DevelopmentPanel.gd` and this one never opens it.

## The hole

U12 stored three kind fields plus their three evidence fields on all 18
catalogue rows, and `EntityPathway.kind_read()`
(`Godot/scripts/EntityPathway.gd:149-157`) exists with the header comment
**"One dictionary a screen can print without three lookups."**

Grep it: `ranking_mode`, `regulator_kind` and `outfitting_policy` are read by
`BodyReadiness.gd` (the medical-hold authority) and by the sponsorship branch,
and by **no panel at all**. The read was built for a screen nobody wrote. The
player therefore cannot see:

* **how you climb** — `ranking_mode`: a published ranking, or the matchmaker's
  discretion (C47: `discretionary` is the default and most promotions are it);
* **who can stop you fighting** — `regulator_kind` (C49: GLORY and eight
  others are `unknown`, and medical holds are jurisdiction-blind today);
* **whether you get a kit or must find your own sponsor** —
  `outfitting_policy`: UFC is the **only** sourced `house_kit`; twelve
  promotions are `fighter_sponsors` with UNKNOWN evidence, and that decides
  whether a fight-night patch cheque exists at all.

## What to build

`RankingsHubPanel.gd` already settles a PROMOTION first (R68) and already
takes `get_promotions_read()` once, guarded, at
`Godot/scripts/RankingsHubPanel.gd:169-170`. Add the promotion's own identity
to that surface, beside the belt board.

1. Take the kind read **once per rebuild**, in the same guarded block as the
   existing reads at `:160-174` — `game_state.has_method(...)` exactly as
   `:169` guards `get_promotions_read`. Never call it per row and never call
   it inside a loop; U5 and U7 both landed this shape.
2. Print three labelled lines for the settled promotion. Words, not raw enum
   values: `discretionary` reads as "matchmaker's discretion", `house_kit` as
   "supplies the kit", `fighter_sponsors` as "fighter finds sponsors", and so
   on. Put the words in the panel or a small words helper — **do not edit
   `UITokens.gd`** (R47/R48 precedent: a screen never gets a new token for
   this).
3. **Evidence is visible, not hidden.** Where the matching `*_evidence` is
   `unknown`, the line still prints, with the value marked as unsourced —
   an em dash or a MUTED "UNSOURCED" chip, never a blank and never a
   confident-looking claim. `unknown` as a VALUE (nine promotions have
   `regulator_kind` unknown) prints as "—", never as "none" and never as `0`.
4. Absent read: if `get_promotions_read` or the kind fields are missing
   entirely, the panel renders exactly as it does today. **That absent case is
   a required test.**

## Owned files

* `Godot/scripts/RankingsHubPanel.gd` (1,144 lines — read the
  `sed -n '150,200p'` window and the rebuild it sits in; do not read it whole
  if you can avoid it)
* `Godot/tests/rankings_hub_panel_test.gd` (extend)

Do NOT touch `EntityPathway.gd`, `OrganizationRead.gd`, `GameState.gd`,
`UIKit.gd`, `UITokens.gd`, `DevelopmentPanel.gd` (U13 owns it), or
`HANDOFF.md`. `kind_read()` already returns everything you need — if you find
yourself wanting a new accessor, you are in the wrong file.

## Gates

```bash
python Godot/tools/check_scripts.py Godot/scripts/RankingsHubPanel.gd
```

Focused first, then the full suite once in the background before the commit:

```bash
"$GODOT" --headless --path Godot --script tests/rankings_hub_panel_test.gd
```

`organization_read_test.gd` and `smoke_test.gd` too. The suite was 179/0 at
U12; **179 or better — if it is lower, say so and push anyway** rather than
holding a good result back.

## The trap

`kind_read()` takes an ORGANIZATION dictionary, not an id and not the
promotions-read row. The promotions read and the catalogue row are not the
same shape — resolve the settled promotion to its organization dictionary
once, in the guarded block, and pass THAT in. Calling `kind_read()` with a
promotions-read row returns six defaults and every promotion in the game will
look identically `discretionary` / `unknown` / `fighter_sponsors`, which is
exactly the wrong answer and will look plausible.
