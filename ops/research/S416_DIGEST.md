# S416 digest (2026-11-09)

## His words
Q-S294-146, carried from S415: "dark looks nice , i like the wooden look of the menus though". He had not replied in this session when this was written.

## Built
- Fighter Overview: dark panels in wooden frames. assets/ui/warm/wood_panel.png is the game's own chalkboard art (chalk.png) at 62%, with the board darkened. WarmKit SLICE "wood_panel", DarkOverview.panel. The red top edge is gone. The page fits 1080. Tests: warm_kit, attr_board, next_step_card, menus_round4, golden_path. Not scored by a critic. Q-S294-158 asks whether the other pages move.
- Gym prices, sourced: punching dummy $420, turf strip $1,400 (the guess was $600), conditioning set $550 (the medicine balls are an estimate). URLs in GYM_SLOTS_S415.md.
- Licence list: CLIP_LICENCE_LIST_S392.md had no line for MoCap Online, now 165 of the shipped clips. Added with Flag #5.

## Decided
- No place cap by premises. The premises already cap the members, and a hard cap would stop him buying the full picture he chose.
- REARHAND5: only the plain right hook and its stepping take get the wind-up lifted. Hard takes stay low: pro_left_hook_hard is as low (0.012) as the right.

## Findings to keep
- GYMBUY1: the floor binds from reputation 30. At the opening unit one $400 piece reaches the unit's limit of 70. The agent's "$178,000" was ten times too high; the real figure is about $17,800 (cash difference $16,924 after the price). Every bot club closes, since they have no fighters, so read the members columns only.
- REARHAND4's left-hook low_h rows (0.35) disagree with REARHAND1 (game, 0.177 plain) and REARHAND2 (raw, 0.202). Use REARHAND1's column. The real gap between plain hooks is 0.019 against 0.177, not 0.099 against 0.35.
- CI runs at 18:13Z ended with zero jobs in under a minute (GitHub side). A re-run started them. A failed run with no jobs is not a red test.
- The fighter model chain loosened two old bars, each with a written reason: balance_harness unfit fade 0.04 to 0.035, world_years MAX_DRIFT 7.0 to 8.5.

## Launched
REARHAND5 (Qwen). GYMFIGURES1 (Cursor). GYMKIND1 brief written, launch after FIGHTERMODEL4I is on main.

## Later in S416 (live playtest)
Merged: FIGHTERMODEL4I with 4F and 4H; GYMFIGURES1; GYMKIND1 (off for players); HEADAIM1 (measure only, ruler not shown). PR 140 REARHAND5B held for a film.
Built from his notes: no fight no cut, boxers 0.5 kg lighter; one Gym button; Mail in the top bar; pins go to their own places; Training tab; game plan says what each choice does, no preview; People page in words; Fights has actions; floor people capped 6, 9, 12 by premises.
His calls: Q-159 yes to the painted look. Q-161: the critic's corner 2/10, redo it as graphics.
Disk: E: reached 4.4% free; worktree_retire no longer holds a worktree for line endings alone; 43.7 GB free after.
HANDOFF: NEXT_SESSION_PROMPT.md, top three notes.

