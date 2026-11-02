# S213 DIGEST (2026-10-12) - skill learning reaches the fight (approved), Jev routing, usage meter

## Operator rulings (verbatim)
- Q-S211-1/2/3 board: "Yes - build it as in the verdict" (gym look, equipment slots), "Yes - file read/write only" (Antigravity).
- Q-S212-1 board: "Yes - build it as in the verdict" (Ludo r46 skill learning -> TECHSTAGE1 launched).
- "do not fall to defaults/averages when you have no conclusive direction , use your skills or communicate with ludo and other agents" -> CLAUDE.md s2.
- "keep claude.md under 200 lines" -> 198 (GDScript traps moved to research/GDSCRIPT_TRAPS.md; no gate dropped).
- "i do not understand jev just incorporate it i trust it works" -> Jev machine-wide (below). Cost question answered: ~$0.30/month Jev; Claude stays on Pro; tiers capped at Opus (cheaper mode).
- "move the limit to 512k is good idea ?" -> Claude: no, keep 330k (each message re-reads the context; weekly limit at 76%).

## What now works (evidence)
- Ludo round 46 (skill learning): ask LUDO_ROUND46_ASK_S213.txt (facts sheet + code audit + real-world research), reply verbatim
  LUDO_ROUND46_S213_reply.txt (27,660 chars, one message, complete), verdict LUDO_ROUND46_VERDICT_S213.md: technique stages LEARNED >
  DRILLED > SPARRING-PROVEN > SIGNATURE read by the live fight; fight writes back; losses set next week; fatigue slows learning; rust; taper.
- Defects fixed (each test red on the shipped tree, green after): career strand edge never reached the fight (4d8d724d,
  strand_edge_career_key_test); grapple stats never aged (aging_grapple_keys_test). fight_stage_realism + q226_strands reds are pre-existing.
- Antigravity allow-rule live: ~/.gemini/antigravity-cli/settings.json permissions.allow read_file/write_file(E:/FightCamp/wt), no command().
- STRESSHDR1 landed (agy/stresshdr1): Antigravity's banner + Claude's animated meters + identity clip fix; profile_overview 164/164, --only profile,stress 19/19. Merge after PROFILE2E (built on it), then stills -> Ludo -> board.
- EQUIPSLOTS1A landed (codex/equipslots1a) + Claude review commit: MMA kit stays buyable with requires=mma, hidden only in the boxing club;
  equip_slots / market_filter / catalog_full green on the branch. NOT on master: the dependent run never started (waiter bug below);
  diff applied then reverted from the shared checkout.
- Usage meter mod (C:\Users\user\.claude\dev-mods\...\usage-meter): graphic bars above the chat box for 5-hour / week / session (session scaled to 330k), toasts at 80/95% and 250k/330k.
- Jev router machine-wide: task "FightCamp Jev Router" (C:\Users\user\jev-router, S4U, restarts), ~/.claude/settings.json env ANTHROPIC_BASE_URL=127.0.0.1:4000;
  first live call Haiku 5.5 $0.0003 vs $0.011. Undo steps in memory reference_jev_router.
- Board Q-S212-2 (Jev trial) is superseded by the operator's "just incorporate it".

## Decided (developer calls)
- GYMLOOK3A round 1 rejected on its own stills (no maple, orange zones, orange emblem square, no brick/posters, 28 fps) -> TASK_GYMLOOK3A_FIX1.
- Grok Bot "route all heavy work to a CLI" rule: possible (gbot codex/claude bridge) but not adopted - a second router outside our worktree/watchdog/merge gates.

## Traps earned
- `grep` inside a background waiter gets rewritten to `rtk grep` by the hook and never matched " GREEN " -> use `findstr` or python to test watchdog output.
- This app is MSIX: %APPDATA% writes from inside it are virtualized; anything a scheduled task runs must live outside AppData.
- cursor_task.cmd takes a PROMPT FILE, not text (r2 launch silently did nothing).
- STRESSHDR1's brief cut it from cursor/profile2e which predates StressCauses -> merged origin/master into the branch.

## Next (decision, in order)
1. Collect TECHSTAGE1 (codex/techstage1 2a6fe76a): parse, its two tests, --only technique,q226,switch_gate,pad_chain,certified,game_switches; merge by diff.
2. Collect GYMLOOK3A r2 (0e2cb30c): open after-stills yourself (maple 60%, no orange square, brick+posters, fps vs 43.7) -> Ludo (chat 'Gym Management Screen') -> board.
3. EQUIPSLOTS1A: apply the branch diff (minus HANDOFF), run --only equip,club_fill,equipment,purchase,market,club_capacity,gym_club on GREEN, commit.
4. ANIMSOURCE1D gloved batch landed (ca610d40) -> merge ANIMSOURCE1D + MHNATIVE1 together -> MHSPACING1 on Codex.
5. PROFILE2E r7 -> merge -> STRESSHDR1 -> stills -> Ludo -> board.
6. NIGHTLY5 face_drawn_foe: BISECT DONE - first bad = 174f3a23 SWITCHALL1 itself (parent 2ea1ca92 good). One of the switches it turned ON
   breaks the ON arm (p90 41 vs OFF 24): flip them back one at a time in the test's ON options (start with the engine set: trap/defence/output,
   separation_strip_velocity, limb_damage, corner_wired) to name it; worktree E:/FightCamp/wt/NIGHTLY5B (seeded).
7. TECHSTAGE1 slice 2 (FIGHTLOG1: live fight records technique usage) brief.

## Delegation (live_runs.json)
Codex TECHSTAGE1 (landed), Codex EQUIPSLOTS1A (landed), Cursor GYMLOOK3A r2 (landed), Cursor PROFILE2E r7 (running), Codex ANIMSOURCE1D (landed batch),
Antigravity STRESSHDR1 (landed), Arena Q226TECH1 (running), Maria M_ICONS54 (delivery pending).
