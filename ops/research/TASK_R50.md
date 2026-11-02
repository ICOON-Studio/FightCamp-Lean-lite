# TASK R50 — THE PROMOTION: C24'S READ FINALLY GETS A SCREEN (Claude)

**Status: ASSIGNED 2026-09-07.** The last item in the read backlog. C24 itself
shipped and is COMPLETE — what is open is its **caller**. `get_organization_read`
and `get_organizations_read` have had no reader outside `Godot/tests/` since the
day they landed, so the game holds 18 organizations, their real rulesets, their
sanctioning authority and its evidence, and shows the player none of it.

Model: Opus, effort high, Fast off. One session.

## What C24 already answers (do not rebuild any of it)

`GameState.gd:11684` `get_organization_read(organization_id)` and `:11694`
`get_organizations_read(country_name)` project `OrganizationRead.build`. One
organization returns:

- `id`, `name`, `short_name`, `country`, `tier`, `reputation`
- `entity_type` + `entity_label` (J2's federation pathway)
- `disciplines`, and per discipline a `rules` row: `ruleset_id`,
  `ruleset_name`, `competition_ruleset_id`, `authority`, **`evidence`**,
  **`fallback`**
- `rounds[discipline]`: `rounds`, `round_seconds`, `rest_seconds`
- `events`: upcoming, with `id`, `name`, `week`, `venue`, `discipline`, `status`
- `standing`: `signed`, `goodwill`, `bouts_taken`, `last_result`
- `official_url`, `source` (provenance)

`get_organizations_read` takes `include_details = false` for the list shape.
Contract test: `Godot/tests/organization_read_test.gd`.

## The one thing this screen exists to say

**`evidence` and `fallback` are the point.** J1 established that the 18
organizations carried not one rule between them; C22 and C24 gave them real
rulesets *with the provenance attached*, including where the game is guessing
(`fallback: true`, `evidence: "UNKNOWN"`). A screen that prints the ruleset and
hides how well it is sourced throws away the only honest thing the read has.
Show the sourcing on the rule row. **Never** dress a fallback as a citation.

## The mount point — RULED 2026-09-07 by the operator: **B and C, both**

One read, one panel, **two hosts**, each showing the half that matches its own
charter. Not the same slab dropped in twice.

- **B · SCHEDULE, a fourth tab.** `ScheduleHubPanel.gd:36`
  `TABS := ["month", "cards", "offers"]` and `:37`
  `TAB_LABELS := ["MY MONTH", "THE CARDS", "OFFERS"]`; the segmented control is
  built at `:257` and `_on_tab` at `:961`. Add `"promotions"` / `"PROMOTIONS"`.
  This tab is **the fight half**: who sanctions what, under which ruleset, how
  many rounds of what length, and their upcoming cards. THE CARDS already lists
  these organizations' events, so this is the drill-in it implies.
- **C · OFFICE, a third tab.** `OfficeHubPanel.gd:56`
  `TABS := ["desk", "books"]`, `:57` `TAB_LABELS := ["THE DESK", "THE BOOKS"]`,
  `MODULE_TABS` at `:61`, router args read at `:116`. This tab is **the business
  half**: our standing with each promotion — `signed`, `goodwill`,
  `bouts_taken`, `last_result`. That is exactly OFFICE's stated charter at its
  own file head, "what does the gym owe, and what is it owed".

Both halves come from the same `get_organizations_read` / `get_organization_read`
projection, and the **provenance is drawn once, by shared code, and identically
in both** — a fallback must not look sourced on one tab and honest on the other.

## Settled

- Read-only. No booking, no signing, no write of any kind. A bout is still
  booked through the existing offer flow.
- Kit-built from `UIKit` + `UITokens`. **No new UIKit factory and no new token.**
  `SODIUM` / `ICE` stay the belt's (R47), `BAD` / `AMBER` / `GOOD` stay M6's
  medical family (R48). Sourcing quality is neither: band it with what exists.
- `ORIGIN (402, 120)`, `WIDTH 1494`, `HEIGHT 900` — the shell geometry every
  hub since R21 uses.
- Honest empties everywhere: an organization with no upcoming event says so;
  `UNKNOWN` evidence says `UNKNOWN`, never a blank that reads as verified.
- No `FightSimulation.gd`, no `Sanctioning.gd`, no `OrganizationRead.gd` edit.
  If the read is missing something the screen needs, **name it as an engine gap
  in the digest and build around it** — do not widen C24's file.

## Parse gate

```
python Godot/tools/check_scripts.py <every .gd touched>
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/organization_read_test.gd
```

Then the new panel's own test and **both** hosts, because both gain a tab:

```
--script tests/schedule_hub_panel_test.gd
--script tests/office_hub_panel_test.gd
--script tests/office_nav_and_profile_overlay_test.gd
```

Then the full suite ONCE in the background before the commit.

## Done

Commit and push `master`, write `research/R50_DIGEST.md` (short), convert
this block in `HANDOFF.md` to COMPLETE, and regenerate `TASKS.md`.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/tests/organization_read_test.gd
Godot/tests/schedule_hub_panel_test.gd
Godot/tests/office_hub_panel_test.gd
Godot/tests/office_nav_and_profile_overlay_test.gd
research/R50_DIGEST.md
```
