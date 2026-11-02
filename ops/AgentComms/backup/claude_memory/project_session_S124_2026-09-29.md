---
name: project-session-s124-2026-09-29
description: "S124 - G147 clipping re-judge: boxing 19/36 -> 1/36 (operator chose it); catch piece solved by TARGET (s124_catch_solve.gd) on the RamsterZ guard; U197 merged with steps beside the beat; runner tree-kill; Grok CLI; U198 (Cursor) room root writes"
metadata:
  node_type: memory
  type: project
  originSessionId: 3789a020-1b4a-44ae-a0bb-6a86b94e9301
  modified: 2026-09-29T08:14:41.872Z
---

S124 (2026-09-29, Claude, SHIPPED). Commits 28633af8 (U197), 30e61fb9 (catch + re-judge), 00db7e99 (runner/check_workflow/preview test),
2be7e516 (KM1 UI), 6eefbbef (U198 + Q216b briefs), 9db89b3a + 34424195 (handover), dd00d1b0 (ops board: Grok/Kimi/Cursor shown as CLI, found by install path). Digest research/S124_DIGEST.md.
Roadmap `now` = S125 (the G147 clipping fix). KM2 (Kimi) LANDED right after the handover (8e6cf6b8, 'restate reachability
contract for shipped MPFB rigs') - UNCOLLECTED; S125 reads the TEST diff first (may be the test moved to pass).

**THE BIG ONE - the operator caught it from one still ("what is this ???"):** the certified production jab (run 10 RamsterZ,
certified at a 1.06 m gap) lunges the jabber chest-to-chest into the defender, head into his lead glove. C223 only checked the
fist reaching the head, never the two BODIES. Operator chose "add the rule, re-judge all 19" (AskUserQuestion). Q213 clips mode
(G147: head >1 cm >1 f, torso >2 cm >3 f, arm 3/3, leg 2/3, foot 4/5) on every exact binding at its certified spacing:
**pass 4 of 23 = the three pieces (catch, slip, pull) + boxing_jab_body. Boxing is 1/36 under the rule.** HEAD 75 failing events,
worst pair attacker Head > defender LeftHand (the lunge); ARM worst 22.6 cm (glove through the guard); LEG 17.8 cm (hooks and
uppercuts certified at 0.70-0.73 m). Clips mode has NO contact_stop pin - S125 must re-measure with the game's pin to split real
clipping from what the room already stops. Nothing deleted: clips/speed/timing certificates stand; spacing+contact is missing.
Operator: "i do not object just fix it". Why it slipped: the S119 Q213 result (1/11 clips pass) was recorded as "clipping gate
FAIL" in the milestone evidence but the C223 count kept counting - a gate outside the certification path protects nothing.

**Catch (C223):** method that WORKS = tools/s124_catch_solve.gd - graft the base exactly as the gate does, then coordinate-search
ONE layer (RightUpperArm xyz, RightLowerArm x, RightShoulder x; cg_s3's window) on all four rigs at once against a TARGET
(rear wrist tz in front of the Head bone, lat 0, ty). cg_t (wrist at head height) = glove at the forehead in the stills;
cg_t2 (tz 0.18, ty -0.04) = nose height. Bound on the RamsterZ guard H2H_Idle (cr_t, s124_catch_bound.json 4/4, glove >=3.7 cm
below the Head bone). catch_counter [catch, jab] is NOT certified (the jab lunge above) - binding kept as provenance "near".
- My error, caught by the numbers: I gated catch_counter against run8's STALE jab certificate (reach 1.43 m, contact 0.4 s);
  the production jab is run 10 (reach 1.02-1.13 m, contact 0.315 s). Then I claimed the RamsterZ base "fixed" the 26 cm miss -
  it did not; the certificate did. Always pass the certificate of the clip PRODUCTION binds (q213's lookup already filters by path).
- Sequence gate: a DEFENSIVE piece is left out of the fixture-gap min (its spacing is the default placement, not a reach).

**Also shipped:** U197 (Cursor footwork beats) merged as a diff - steps ride BESIDE the chosen beat (`beat["footwork"]`) instead of
competing in `_choose`; my mutant proof FAILED (the delivered design also passes on seed 94301: punches out-rank every step) - the
check is a guard, said so in the test. run_tests.py kills the whole Godot TREE on timeout (subprocess.run killed only the
console wrapper and then blocked on pipes the orphan held - the 05:52 orphan, the 3 h 20 min nightly). check_workflow reads
bullet-style Owned paths (it passed U197 as owning nothing). KM1 fixes: ShellChrome Continue INK on green (2.83 -> ~6.5:1), four
developer cue lines -> player copy, trait note; "amateur pool empty" was STALE (fixed S76) and S123 wrongly confirmed it.
ui_technique_preview derives its NEAR case (one-two got its own clip). Nightly 09-29 (20 reds at 9b143308): re-run alone -> 14 real.

**Agents:** Codex LIVE-probed: locked "try again at Oct 3rd, 2026 9:50 PM" (S123's "Codex is back" was wrong). Grok CLI installed
+ signed in ([[project_grok_cli]]). Kimi KM2 still running (it runs tests in the MAIN checkout as its control arm). Cursor U198
launched (room root writes: 12 cm jumps, 20 cm past the ropes, 4 hangs, pair jab 0, overlap 1.3 mm). Q216b (MMA reds) written for
Grok's first trial when a slot frees.
Related: [[feedback_open_the_output_before_the_gate]], [[project_session_S123_2026-09-29]], [[feedback_primary_source_before_action]].

**After the handover:** U198 (Cursor) LANDED 74dd2d48 (rope clamp + 3 cm root cap made the LAST frame write; teleport +
ring bounds fixed per Cursor; readable_onset passes but takes ~101 min; open: overlap, contact_stop [green on master - regression?],
pair_live, room_positions) - UNCOLLECTED, digest synced 68e78e73. A FOREIGN staged file appeared in the shared index at 11:06:
AgentComms/messages/20260929T110619Z_claude_to_qwen_q217_*.json (another session assigning Q217 to Qwen?) - left untouched;
S125 should find out who sent it before counting agent slots.
