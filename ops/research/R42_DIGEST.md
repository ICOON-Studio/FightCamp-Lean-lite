# R42 — THE BELT ON THE SCALE (digest)

**Shipped 2026-09-07.** Depends on R41 (`fae3fe8`) and C26 (`c320496`).
J3 ranked this a 3 — "one rule on top of R41's flag" — and it stayed one rule.

## The lie that is gone

`_resolve_weigh_ins` produced a full weigh-in record and `apply_title_logic`
never read it. A champion could miss the contracted limit by three kilos,
fight a catchweight, win, and keep the belt as if nothing had happened.

## The rule

**A contestant who misses the contracted limit cannot win or retain the belt;
the one who made weight still can.** Five cases fall out of it, all covered:

| On the scale | On the night | The belt |
| --- | --- | --- |
| champion misses, challenger makes it | challenger wins | changes hands normally |
| champion misses, challenger makes it | champion wins | **vacant** — he keeps the win, not the belt |
| challenger misses, champion makes it | challenger wins | does not move; the champion made weight |
| challenger misses, champion makes it | champion wins | ordinary defence |
| both miss | either | untouched — nobody eligible beat the champion |

"Both miss" **does not vacate**: it is the smaller rule, and the code argues
for it — nothing in a bout the champion did not lose to an eligible opponent
knows a reason to strip him.

An interim belt is bound by the same rule, and a returning champion who misses
the limit cannot unify: `unified_week` is never stamped off a missed weight.

## How it is carried

- `WorldPopulation.resolve_title_bout()` is the rule; it returns
  `{title_fight, blocked_by_weight, vacated}`. `apply_title_logic()` survives
  unchanged as a thin bool wrapper, so every existing caller and all three
  frozen regressions kept their signature and their expectations.
- `made_weight` arrives in the same shape R41's flag does: a dictionary of
  athlete id -> bool that **may be absent**. `null` means no weigh-in was
  carried at all and the scale is not consulted — an old save, or a world bout
  that never touched `_resolve_weigh_ins`. An id missing from a dictionary
  that IS present means the same for that one side. **No weigh-in is ever
  fabricated**, least of all for the world, which has no scale.
- `_vacate_on_the_scale()` empties the belt, stamps `vacated_by` /
  `vacated_week` / `title_status = vacant`, and spends any interim claim the
  way `_consume_interim` does. No successor search, no stripping ceremony, no
  press cycle, no commission hearing — `vacate_title`'s elevation answers a
  champion who *gives* a belt up, and this one simply cannot hold it.
- `title_wins` is not banked by a winner who could not win a belt;
  `title_fights` still counts on both records, because the bout WAS a title
  fight. Nothing is flattened into "not a title bout".
- The reason survives on the result: `title_blocked_by_weight` on the world's
  bout and on the player's fight-log row (`GameState.gd:10604`).

No new fine, no purse arithmetic, no UI, no rule knob — `championship_rules.json`
was not touched, because the code never argued for a dial.

## Files

- `Godot/scripts/WorldPopulation.gd` — `TITLE_BLOCK_*`,
  `_made_contracted_weight`, `_vacate_on_the_scale`, `_title_outcome`,
  `resolve_title_bout` (`:1140`), and both world call sites (`:885`, `:1467`).
- `Godot/scripts/GameState.gd` — the settlement only (`:10441–10467`, `:10604`).
- `Godot/tests/belt_scale_test.gd` (new, 43 checks).

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/belt_scale_test.gd
```

43/43 first run. `title_flag_test.gd`, `titles_rankings_test.gd` and
`championship_read_test.gd` all pass **unedited** — no old expectation had
encoded the defect, unlike R43's nine tests that asserted the gym was paid.
Full suite green before the commit.

## Left for later

The belt surface is K23's ruling and a later stage; `title_blocked_by_weight`
is on the result waiting for a screen to say it.
