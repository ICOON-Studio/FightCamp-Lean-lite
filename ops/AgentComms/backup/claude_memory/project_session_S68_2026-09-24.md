---
name: project_session_S68_2026-09-24
description: S68 - body map shipped in BODY LAB, take four sent (92012 + ground seed 4004); take-four switches change the fight; duplicate Qwen trap
metadata:
  type: project
---

S68 (2026-09-24) shipped the operator's BODY MAP: `BodyMapFigure.gd` draws our own six-region mannequin in the profile's BODY LAB tab (grey sound / amber sore / red hurt), hover highlight + opaque tooltip (value, injury, gym 80 / cage line, rest forecast from the new `BodyReadiness.forecast_region_weeks`). Test 57/0, 7/7 mutants. Take four sent: seed 92012, U164 human-speed A/B, seed 4004 on the ground.

**Why it matters / how to apply:**
- The take-four switches (strikes/reactions_play_whole, contact_stop) change the FIGHT, not just the picture: pick a recording seed with `probe_grapple_seam.gd -- on=<switches> seeds=... survey_only=1`. Seed 4004 grounds at 22 s with them ON.
- A process list piped through `head` hid a live Qwen from the previous (still-open) session; two Qwens then shared one worktree after a reset. List node.exe processes whole before relaunching an agent. See [[feedback_drive_qwen_and_grok_to_delivery]].
- ffmpeg cannot overwrite a file OneDrive holds open: encode in scratch, then copy.
- The first UI render showed a see-through, clipped tooltip the test could not see - render before trusting a UI test ([[feedback_open_the_output_before_the_gate]]).
- Running at handover: Cursor U165 (G75 onset floors), Codex C193 (blind body-map test), Qwen Q169 r3, Grok G86 FEINTS. Next: S69 G74 gym market slice one.
- PC slowness 2026-09-24 was the DISK (730-875% busy), not CPU: 17 Godot boots + Defender scanning every file. The operator added Defender exclusions for the repo and Godot; disk fell to 2%. If it recurs, count Godot processes and check disk time first. See [[project_pc_thermal_limit]].
- fight_metres failed ALONE under agent load; its "passes alone" note is unproven - re-run on a quiet machine.
- The operator asked about selling the engine on Fab: advised NOT YET (unfinished; the bought clips' licences forbid resale; ship the game first, then extract the sim core). A research task was only offered, not assigned.
