# TASK INTROCORNER1 - QWEN (qwen3-coder) - the fight intro starts in the corners: each boxer shadow-boxes, bounces and celebrates the name call in a way of their own (the rope entry out)

Status: DONE - NOT COLLECTED (S435: did not compile, intro cut to 6 s, no name call shown; re-run as INTROCORNER2). Was OPEN (S434, Claude main). Discipline: boxing. Model: qwen3-coder (moved from agy: it has no shell for Godot runs; Claude reads the stills at collect).
Operator S434, on the ring entry: "the animation when mounting the ropes to enter is not very good from their initial pose to
how high the lift their legs ropes no weight", then on the plan to start in the corners: "ok add some celebrating animations or
shadow boxing during the introduction and do not make each fighters animations identical".

## What is wrong today (read in the code, S434)
scripts/fight3d/FightIntro.gd (500 lines - AT the cap) opens with the rope entry: cue_enter_red / cue_enter_blue play the Mixamo
clip "entry_ring" PURE from its first frame (no blend from the stance), captured for another rope height (the leg lifts too high),
with stage._ropes.calm = true (the ropes never give). A `from_corners` mode already exists (static var from_corners, line 21:
"film tools or the user arg fromcorners") that starts in the corners. In the corners, _start_warm plays one CornerWarm clip per
boxer (scripts/fight3d/CornerWarm.gd: owned takes, two seeds that differ), and at the name call _raise() lifts the rear glove by IK
(the same gesture for both boxers).

## Contract
OWNS: scripts/fight3d/FightIntro.gd, scripts/fight3d/IntroEntry.gd, scripts/fight3d/IntroStyle.gd, scripts/fight3d/CornerWarm.gd, tests/intro_style_test.gd, tests/ring_ropes_entry_test.gd, tools/intro_still.gd
(IntroEntry.gd NEW: the rope entry moved out behind an opt-in; IntroStyle.gd NEW, pure static: who does what; intro_style_test.gd NEW;
ring_ropes_entry_test.gd only to opt into the entry with the new arg; intro_still.gd NEW, the still tool.
Not yours: FightStage.gd, BoxerBuild.gd, BeatClips.gd, BeatFire.gd, PunchReach.gd - the animation route owns them. Call
FightStage's existing functions; never edit it.)
RED_TEST: tests/intro_style_test.gd -> INTRO_STYLE checks=%d failures=0
REGRESSION: ring_ropes_entry_test, corner_warm_test, fight_polish_test, file_limits_test, fight_flow_test, hud_shown_test,
corner_lens_test, theatre_test
VISUAL: yes - stills on the game's camera, read by you, then the operator.

## The job
1. THE ENTRY OUT, KEPT FOR LATER. The game's intro starts in the corners (what from_corners does today). Move the entry code
   (_entry, _enter, _carry_in, the ENTRY constants, the entry shots and cues) into IntroEntry.gd, played only with the user arg
   `ropeentry` (ring_ropes_entry_test passes it). FightIntro.gd must end well under 470 lines. Re-time SHOTS and CUES so the corner
   phase opens the intro (no ENTER_S); no shot under 2 s (docs/TV_CAMERA_RULES.md).
2. EACH BOXER THEIR OWN INTRO. IntroStyle.gd (pure static, no preloads of scenes): `plan(f: Dictionary, seed: int) -> Dictionary`
   returns this boxer's intro: {"warm": [clip, ...] (the corner minutes: a sequence of 2-3), "name_call": clip (when the announcer
   says the name), "hold": clip (until the walk)}. From the fighter's personality (Data.fighter_state "personality": heart,
   discipline, confidence, coachability, loyalty, temper) and style:
   - confidence 65+ or temper 60+: a SHOWMAN - a celebration on the name call (mc_Box1_M3_Win_V1..V7 / mc_Punch_M3_Win_V1),
     bouncing and crowd play while waiting (ow_bounce_idle, Win clips' short windows);
   - discipline 60+: a WORKER - shadow boxing in the corner (ShadowBoxing_mixamo, the owned shadowboxing takes CornerWarm lists),
     a short nod or a single raised glove on the name call (keep _raise for this one);
   - confidence under 50: a NERVOUS one - fidgets (mc_Box1_M3_Idle_Fidget_V1..V8), a small bounce, a quick raise;
   - otherwise a mix, by the seed.
   THE TWO CORNERS NEVER MATCH: never the same clip at the same moment, never the same name-call clip, and a different sequence
   order; the seed is CornerWarm.seed_for(bout seed, boxer). Read which clips exist with ap.has_animation (the game's default
   route has the Punch PRO set + the files under assets/anim/baked; owned rk_ takes are opt-in since S432 - check RkClips.enabled
   and never require them).
3. JOINS. Every change of clip blends (the join the warm-up already uses: a.get("js").join(...), or the AnimationPlayer blend);
   no pop from the stance into a clip or back to the guard at the walk. The feet stay planted in the corner (FootLock / FloorStand
   keep working; a celebration that walks the boxer off the mark is clamped back or not used).
4. The announcer's words stay the caption (ui.say). The announcer's VOICE comes later (VOICEWIRE1 makes a line per fighter's name in
   the voice he picked); leave a hook: `cue_name_red/blue` call one function `_announce(i)` that VOICEWIRE1 fills.

## The checks (tests/intro_style_test.gd, extends SceneTree, counts its own checks)
a. The game's default intro has no entry: FightIntro's first cue is not enter_red, and the entry runs only with `ropeentry`.
b. Three fighters with different personalities (a showman: confidence 75; a worker: discipline 70, confidence 55; a nervous one:
   confidence 40) get three different plans by the rules above (their name_call clips differ in kind: a Win clip / a raise / a quick one).
c. The two corners of one bout never share a clip at the same moment and never the same name_call, over 200 bout seeds, for
   every pair of the three fighters (and a fighter against themself: same personality, still not identical).
d. Every clip a plan names exists in the game's default route (a boxer built the way the game builds one: has_animation true),
   or the plan falls back to one that does.
e. FightIntro.gd is under 470 lines; IntroStyle.gd has no scene preloads.
RED on main: a fails (the entry opens the intro), b and c fail (IntroStyle does not exist).

## The stills (VISUAL: the operator closes it)
tools/intro_still.gd on the hidden desktop (`python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed
--resolution 1920x1080 --script res://tools/intro_still.gd -- <out_dir>`), the game's own intro camera: for two different pairs
(Samira Khan v Priya Nair; Lucy Jackson v Josh), a still of each corner during the warm-up, on each name call, and the two-shot
at the walk - both bodies head to feet (save through tools/still_framing.gd save_if_framed if it applies to the intro, or say why
not). Open every still yourself: feet on the canvas, gloves on the wrists, no limb through the ropes, the two boxers visibly doing
different things. A 20 s film of the whole intro for one pair (the S432 film tools) for the operator. Paste the paths in the PR.

## Prior research
`python ops/Tools/prior_research.py intro "ring entry" walkout celebration "shadow boxing"`: S317 (the entry), S310 (the tale of
the tape in the corners), S392/S393 CORNERWARM, S399/S400 (the raise IK fixes: "the shoulder joint seems broken"), docs/TV_CAMERA_RULES.md.

## What would a human do?
On a fight night the camera finds each boxer in the corner: one bounces and shadow-boxes, one stares at the floor, one plays to
the crowd and raises both gloves when the announcer says the name. No two boxers do it the same way, and it says who they are.

## Prefab check
The clips are ours already (Mixamo win/idle/fidget set, ShadowBoxing_mixamo, the owned takes). No new download.

## Rules
Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> ...`; windowed only on the hidden desktop (never on his
monitors; never the _console exe). Parse first. No file over 500 lines (FightIntro under 470). Never he or she in text. Do not add
tests to tools/run_tests.sh. The game switches: new behaviour ships ON (GameSwitches / the default path).
THE TRAPS: a celebration clip that travels moves the boxer off the corner mark (clamp or skip it); the win clips were captured
for after a fight - use their short in-place windows (CornerWarm.window does this for the warm takes); the two corners share one
seed function - offset by the boxer index, as seed_for does.

## Result lines (PR body)
RESULT: tests/intro_style_test.gd -> INTRO_STYLE checks=<n> failures=0 (and its FAIL lines on main)
RESULT: tests/<each REGRESSION test>.gd -> <its pass line>
RESULT: the stills and the film paths, with one line each on what you saw
