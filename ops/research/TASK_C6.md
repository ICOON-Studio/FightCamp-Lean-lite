# TASK C6 — CODEX — the FIGHTER CARD read API

Model: medium. Fast mode off. Decided at assignment; do not self-escalate.
Self-contained. Read this file and nothing else except the anchors named
below. Do not read `HANDOFF_ARCHIVE.md`; do not read `GameState.gd` whole
(10,864 lines), use the anchors. START WHENEVER YOU HAVE CREDITS — not
gated on a date, and nothing blocks you: Claude's R22 is a different
region of the file (see Files, below).

## Why this exists

The kit fighter profile (`ProfileRevampPanel.gd`, 1878 lines, shipped R18
and mounted as the live `fighter_card` route in R19) is the last screen
still assembling its own data. It makes **25 separate GameState calls per
rebuild**, and it rebuilds on every tab switch, every answered ask and
every route arrival.

R23 (Claude, next) deletes the legacy `AthleteProfileScreen.gd` (1863
lines) and its scene, leaving this panel as the only fighter card in the
game. Before that lands the panel needs one read, the way the GYM hub got
`get_gym_hub()` (C4) and the TRAINING hub got `get_training_hub()` (C5).

You are writing that read. **No screen changes, no save-field changes, no
new game logic** — this is pure composition of calls that already exist.

## Deliver

    func get_fighter_card(athlete_id: String) -> Dictionary

One read-only projection. Compose it from the twenty-five methods the
panel calls today — that list IS the contract, do not invent sources:

    get_athlete_rating              get_athlete_current_rating
    get_athlete_current_conditioning  get_athlete_fight_ready_snapshot
    get_athlete_training_clearance  get_athlete_competition_clearance
    get_athlete_average_fight_seconds get_athlete_titles
    get_athlete_awards              get_athlete_loyalty
    get_athlete_request             get_career_goals
    get_division_rankings           get_booked_fight_due_week
    get_fight_offers                get_fight_offer
    get_fight_log                   get_fight_record_stats
    get_fight_camp                  get_fight_camp_options
    get_week_program                get_recovery_options
    get_weight_status               get_fighter_flags
    respond_to_request  ← WRITE. Stays on the panel; never call it here.

Suggested top-level keys, one per region of the card as it is drawn:
`identity`, `now`, `record`, `next_bout`, `this_week`, `flags`, `goals`,
`titles`, `ranking`, `loyalty`, `awards`, `weight`, `camp`, `contract`,
`log`, `clearance`. Name them for what the card shows, not for the getter
they came from. Claude adapts the panel in R23, so a clean shape beats a
shape that matches the panel's current locals.

### The five rules that decide whether this is correct

1. **It must not mutate.** `get_fight_offers` / `get_fight_offer` can
   GENERATE offers as a side effect — that is exactly the trap C4 hit on
   the Gym hub, where the empty-book rule had to read the guaranteed base
   division slate instead of calling the mutating getter. Do the same
   here: never call a getter in a way that creates state, and deep-copy
   before handing anything to a helper that might write into it. The test
   asserts the save and the athlete dictionary are deep-equal before and
   after.
2. **It must work for a fighter who is not on the roster.** The card
   opens on opponents from an event's bout list, not only on your own
   fighters. A world fighter returns a card with `roster: false` and the
   gym-only regions (`camp`, `contract`, `flags`, `goals`, `this_week`,
   `clearance`) present but empty — never missing keys, never an error.
3. **An unknown or empty `athlete_id` returns `{}`.** Not a half-filled
   dictionary.
4. **Two consecutive calls return equal dictionaries** and leave the save
   unchanged.
5. **Numbers agree with their sources.** `record` agrees with
   `get_fight_record_stats`; `flags` arrives in the same priority order
   `get_fighter_flags` already guarantees (C4 shipped that ordering —
   re-use it, do not re-sort).

## Files you own

- `Godot/scripts/GameState.gd` — **append only, at the end of the file.**
  `forecast_training_week` (C5) ends the file at 10,864. Add your block
  after it and change nothing above it. Claude's R22 works in the
  training region and on screens; staying at EOF keeps you both clear.
  Rebase on `origin/master` before you push.
- `Godot/tests/fighter_card_test.gd` — new.

Nothing else. No `.tscn`, no screen script, no `project.godot`.

## Anchors

    Godot/scripts/GameState.gd:10192  get_fight_record_stats  (G8 wrapper, already in)
    Godot/scripts/GameState.gd:10198  get_gym_hub             (C4 — the house style)
    Godot/scripts/GameState.gd:10480  get_training_hub        (C5 — deep-copy discipline)
    Godot/scripts/GameState.gd:10813  forecast_training_week  (C5 — the current EOF block)
    Godot/scripts/DevJump.gd:35       the test harness API
    research/C4_DIGEST.md       the flag ordering and the mutating-getter trap
    research/C5_DIGEST.md       the deep-copy rule that kept forecasts honest

To see what the panel reads without opening 1878 lines:

    grep -o '_call("[a-z_]*"' Godot/scripts/ProfileRevampPanel.gd | sort -u

## Test

`Godot/tests/fighter_card_test.gd` builds a real career through DevJump
(set `SceneRouter.navigation_enabled = false` first) and asserts: every
roster athlete returns a non-empty card; **the athlete dictionary and the
save are deep-equal before and after the call** (the mutation trap); two
calls are equal; an unknown id returns `{}`; a world fighter returns
`roster: false` with the gym-only regions present and empty; `record`
matches `get_fight_record_stats`; `flags` order matches
`get_fighter_flags`; a booked fighter's `next_bout` is populated and an
unbooked one's is empty without any offer having been generated (compare
the offer count before and after). Then run `profile_revamp_test.gd` and
`smoke_test.gd`.

    python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/tests/fighter_card_test.gd
    Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fighter_card_test.gd

Full suite once before the commit (Git Bash, from `Godot/`, `GODOT` = the
console exe): `for f in tests/*.gd; do timeout 600 "$GODOT" --headless
--path . --script "$f" >/dev/null 2>&1 || echo "FAIL rc=$? $f"; done`.
Check `git status -s` first, `git add -- <your files>` only, one commit,
push `master` if you can (else Claude pushes), then convert your
`HANDOFF.md` block to COMPLETE with the hash (max 8 lines) and write
`research/C6_DIGEST.md`.
