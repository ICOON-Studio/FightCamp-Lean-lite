# C78 Digest

- Commit `cb82ac7` is pushed on `master`.
- `FightSimulation.gd` no longer contains the three bare `CompetitionData` references; a lazy helper uses the live autoload when present and a freed temporary instance in `--script` contexts.
- The helper required lines beyond the three replacements so production keeps the autoload's state while fallback nodes are freed instead of leaked.
- `check_scripts.py` now prints `WARN preload-autoload <file> identifiers=<names>` for preloaded modules and makes those warnings fatal only with `--strict-autoloads`.
- Tree scan: 4 files trip the new warning (`AthleteDevelopment.gd`, `FightOpponentGenerator.gd`, `ManagementOverview.gd`, `TechniqueTrainingCoordinator.gd`).
- Gates: parse `2/0`; preload health `1/0`; fight `35/0`; judge `1/0`; sim `1/0`. Strict-mode probe correctly returned `1/1` for one warned module.
- No pinned card moved. Full suite not run, per task.
