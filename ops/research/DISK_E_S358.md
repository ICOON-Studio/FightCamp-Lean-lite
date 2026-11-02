# E: disk - what to remove (S358, 2026-11-02)

E: had 8.5 GB free at session start (your S249 floor: "around 100 gb free at least"). The auto-retire job now
also covers the Lean repo's worktrees; its first pass freed 3.5 GB (9 merged worktrees) -> 12.1 GB free.

Everything below is ours, and none of it is used by the Lean game. Deleting it needs your OK.

| Folder | Size | What it is | Kept before deleting |
|---|---|---|---|
| E:\FightCamp\wt\ZIVA | 12 GB | Ziva's OLD worktree of the old Game repo (last commit 10-21). Ziva works in wt\ZIVA_LEAN now. | its 4 unpushed commits pushed to origin as backup/ziva-playtest-s358 |
| E:\FightCamp\metahuman_pilot | 5.9 GB | MetaHuman pilot exports + jab frame sheets (S2xx). The boxers in Lean are already imported. | final_sheet.png, jab_sheet.png |
| E:\FightCamp\gloves2 | 4.7 GB | Blender glove-fix scratch (screens, logs, .bak) from the old repo | nothing |
| E:\FightCamp\tmp | 3.7 GB | agent prompts/outputs and probe logs, S343-S357 | the last 7 days' files |

Total: about 26 GB -> E: about 38 GB free. The rest of E: is your own folders (Steam, SpaceGame, EVE, AI, Projects) -
not touched, not counted.

Still HELD by the auto-retire job (dirty or unpushed, kept until collected): LEAN_FIGHTCARD1, LEAN_TRAINCLIPS1,
LEAN_GROUND3, LEAN_BODYMAP1, LEAN_BODYTRACK1, LEAN_GYMBILLS1, LEAN_PACEAIM1, LEAN_BEFORE (about 2 GB).
