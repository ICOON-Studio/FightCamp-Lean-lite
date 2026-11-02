# U126 digest (Cursor)

**Branch:** `cursor/u126-screen-census`  
**Regenerate:** `python Godot/tools/u126_screen_census.py` → `research/U126_SCREEN_CENSUS.md`

## What shipped

- `Godot/tools/u126_screen_census.py` — discovers all `*Screen.gd` / `*Panel.gd`, classifies **LIVE / DEV / TEST-ONLY / DEAD** from `SceneRouter` + root hosts + mount loads (not comment mentions), counts hard-coded layout literals in `.gd` only, ranks **LIVE** screens for the UI track.
- `research/U126_SCREEN_CENSUS.md` — generated inventory; operator table is **Ranked build order**.

## Headline counts (from tool stdout)

| | |
|--|--:|
| UI-building screens | 30 |
| Skipped (no UI — `JudgePanel` logic module) | 1 |
| **LIVE** | 26 |
| **DEV** | 2 (`FightAnimLabScreen`, `FightWorldLiveScreen`) |
| **TEST-ONLY** | 2 (`FightHudPanel`, `ScorecardPanel`) |
| **DEAD** | 0 |
| Literal sites in `.gd` | ~3400 (dominated by `ProfileRevampPanel`, `ScheduleHubPanel`, `OfficeHubPanel`) |

## Gaps (called out in census)

- **`.tscn` not scanned** — scene-embedded offsets/theme numbers are a known under-count.
- **FightHud / Scorecard** — built on UIKit but only tests/tools instantiate them today; do not prioritize ahead of routed hubs.

## Tests

Parse gate: no `.gd` edited.  
`run_tests.py --only ui` → **total=10 fails=0**  
`run_tests.py --only screen` → **total=5 fails=0**

## Mail

`python Tools/agent_comms.py send --from cursor --to claude --subject u126-ready`
