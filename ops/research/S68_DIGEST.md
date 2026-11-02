# S68 DIGEST - the body map on the profile; take four (2026-09-24)

## Shipped
- **THE BODY MAP** (`26abcc80`), the operator's request verbatim in the roadmap: "move the cursor on the hand ... get
  highlighted ... a tooltip pop up and says the condition of that limb".
  - `scripts/BodyMapFigure.gd` (new): our OWN segmented mannequin in the BODY LAB figure column - six polygons = the six
    BodyReadiness regions (left arm/leg on the reader's left, the same side as the cells). Sound = plain grey (his
    picture), SORE amber, HURT `T.BAD`, a named injury never plain grey. Hover lightens the region and outlines it;
    an opaque tooltip opens beside the cursor: `<REGION> · <v> / 100 · SOUND|SORE|HURT`, the injury
    (`InjuryWords.headline`, else `NO INJURY`), its RecoveryWords phase, `GYM 80 · CLEAR|SHORT BY n`,
    `CAGE <line> · ...`, `RESTING: GYM IN n WEEKS · CAGE ...`, and the ceiling words. U10's art plate is gone (its
    cut-outs never registered - the reason it could only tint by the WORST region).
  - `BodyReadiness.forecast_region_weeks` (new): the per-region twin of `forecast_weeks_to_training`, same rest step.
  - `tests/profile_body_map_test.gd`: drives `_gui_input` over all six regions of the REAL panel (torso broken, left
    arm sore): **57 checks, 0 failures; 7/7 mutants caught** (hover dead, injury never named, cage=gym, colour ignores
    band, wrong row, tip stays open, value misprinted). `body_region_screen_test`'s U10 plate check now asserts the
    six-region figure. Focused tier green: profile_body_map, body_region_screen, profile_revamp, body_readiness (3),
    injury (4).
  - Render (`tools/s68_body_map_render.gd`): `previews/s68/s68_body_map_hover_left_arm.png`, sent. The
    first render caught two defects the test could not see - a see-through tooltip and a clipped last line; fixed.
- **TAKE FOUR** recorded and sent (contact sheets opened first): seed 92012 (`take4_s68_seed92012.mp4`, whole strikes +
  whole reactions + C191 `contact_stop` ON), sent beside take three; U164 OFF | ON (`take4_s68_human_speed_ab.mp4`);
  and a seed that GROUNDS: 4004 (`take4_s68_ground_seed4004.mp4`, mount pair from 0:24). My own read of the sheets:
  both men on screen all minute; bodies still overlap in close range at 0:15 and 0:55; on the ground the HUD says
  "Ground-and-Pound from GUARD" while the clip is FULL MOUNT - a position/clip mismatch to look at.
- `record_room.gd` gains `contact_stop` / `hit_physics` (it had no way to turn C191 on). `probe_grapple_seam.gd` takes
  `on=<switches> seeds=<list> survey_only=1`: **the take-four switches change the FIGHT, not just the picture** - 94301
  ends by KO at 1:28 with them ON where the plain probe found a takedown at 102 s. Survey a recording's seed WITH its
  switches.

## Collected
- U164 (Cursor, `67723c34`): 124-clip vendor speed census, 46 above the literature, `human_speed_tempo` default OFF,
  104/0. Merged; one conflict with U163's kicking-foot carry resolved as U163's logic on U164's `take_role`.
- C188 r2 (Codex, `49d75bf8`): hit physics, informative failure, merged **OFF** (overlap +4.25 mm on the capsule proxy;
  the 60-fps floor misses equally OFF, so that gate measured the room, not the physics).
- G75 STRIKE SPEEDS (Grok): saved verbatim `research/G75_STRIKE_SPEEDS.md` (the G75 id collides with
  G75_THE_MAN_UNDERNEATH). Key: speed is not what reads - onset->impact duration is; elbows have NO measured speed.
- C192 (Codex): already merged by the S67 session (56/0, blind test agrees with ManagerContract).
- Focused tiers after the merges: fight_hit_physics 1/0, fight_human_speed 1/0, fight_stage 10/1 (documented
  realism red), fight_world 4/0, fight_strike 3/0.

## Assigned (all running at handover)
- **U165** Cursor: G75's onset->impact floors (`readable_onset`, default OFF) - the elbows the operator named.
- **C193** Codex (luna): BLIND contract test of the body map from its definition.
- **Q169 r3** Qwen: relaunched; the S67 r3 process was still alive and I had reset its worktree under it - killed it,
  mine carries the same rules (FINISH_P stays 1/60, before/after table, trap slice).
- **G86** Grok: FEINTS - rates, reaction rates, payoff, decay (G73's #1 missing mechanism), chat
  `grok.com/c/51ca5758-b573-4e8f-be45-a8347dd98a6a`.

## Suite
`SUITE total=388 fails=12`, read off the run: the nine documented reds (fight_metres is the known ~580 s slow test, timed out under load) + the three Q169 Part 0 owns (fight_pace_anchor, result_screen_why, judge_panel). No new red; S67 was 384/13 (fight_strike_speed now green). New: profile_body_map_test green.
