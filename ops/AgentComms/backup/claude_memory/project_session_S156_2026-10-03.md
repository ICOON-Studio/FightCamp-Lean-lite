---
name: project-session-s156-2026-10-03
description: "S156 Q213G - gate measured a bare fist; glove-as-drawn arm, glove_contact switch (glove capsule + head surface cloud), uppercut lean-back, gate move-order leak; VENUES2 reopened (Boxing Arena downloaded)"
metadata:
  node_type: memory
  type: project
  originSessionId: 06b576c7-f9f3-49b8-afae-d6991f4a9cdf
  modified: 2026-10-03T17:12:41.175Z
---

S156 (2026-10-03, Opus): Q213G. The Q213 clip gate measured a bare fist; the game draws a closed glove over a cut-out
hand, and as drawn it sat up to 7.9 cm in the foe's skull. Fix = switch `glove_contact` (FightWorldLiveScreen, game ON,
`--script` OFF): FightBodyCapsules `_fit_glove_parts` (capsule from the glove mesh) + `_fit_head_part` (capsule along UP
+ a 486-point head SURFACE cloud read by FightContactSolve.pair_contact). The p80 head sphere left the CROWN out - the
real root cause. Uppercut got a Spine -12 deg recovery lean-back (operator: "go ahead with the uppercut lean-back").
Result: all 23 singles + 2 sequences PASS 4/4 on the glove arm; 3 combos fail bare-handed too -> Q213H.

**Why:** a gate that measures something the game no longer draws certifies nothing (see
[[feedback_open_the_output_before_the_gate]], [[feedback_measure_the_posed_thing_not_the_rest_box]]).

**How to apply:** the Q213 gate had a MOVE-ORDER LEAK (receiver idle phase via R110, foot lock at old spacing, attacker
starting from last move's pose) - any gate/test that reuses a FightStagePlayer must reset it (Cline found the same in
readable_onset: `_shown_*` inertializer state). Queue: public `reset_to_fresh_mount()`. Background Bash tasks die at
30 min unless `timeout` is raised (max 2 h) - their Godot children keep running orphaned.
Operator downloaded Marpa "Boxing Arena - Game Level" (not the MMA Arena we ship) -> VENUES2 brief, next stage.
Cline's free model hit its DAILY limit mid-NIGHTLY1. Links: [[project_session_S155_2026-10-03]].

Later the same session: VENUES2 (operator downloaded Marpa Boxing Arena; merged 59e6ca89), VENUES3 grand-arena venues
(Northlight) draw the Marpa hall (operator "top of the ladder"), FANS1 floating crowd fixed in VenueRig (0c5a6104),
Arena became a cloud seat (CI .github/workflows/ci.yml, 5 tasks live at handover), cloud-first rule (Agent remote
isolation silently falls back to local - never use). Digest: research/S156_DIGEST.md.
