# TASK TPMSCREEN1 - the gym screen at Two Point Museum quality (S248)

Model: Claude (integration) + Ludo (art verdict) + an agent for the asset pass. Discipline: boxing demo (gym layer).

## Why (operator S248, verbatim)
"why the gym is not full screen, did you fully reversed enginned 2point musem ? their screens look way better than this"
Answer given: no - S243-S244 took TPM's camera numbers, build rules and per-room item slots, not its SCREEN. Framing fixed the same
session (d08e4940: the whole-club view is fitted per yaw, 85-97% of the screen). What is still missing is below.

## The gaps (each closes on a game-camera still at 4 yaws, beside a TPM reference picture)
1. THE PLOT: the building floats on flat grey. TPM sits it on a plot - ground texture, pavement, kerbs, grass verges, planters, a
   few street props, a soft boundary that fades out. Ours: a street-side pavement + road with markings + grass/planter strips +
   a car park or alley, CC0 kit (Kenney City/Roads, Quaternius), never a TPM asset.
2. LIGHT AND FINISH: TPM reads bright, saturated, soft. Measure from their install the same way S243 did (numbers only, raw dumps
   outside the repo in E:\FightCamp\tmp\tpm_study): their post-processing volume (tonemapper, exposure, bloom, colour grading,
   SSAO), sun angle/colour/intensity, ambient. Map each number to Godot's Environment/WorldEnvironment + DirectionalLight3D.
3. OUTLINE / MATERIAL STYLE: TPM props are chunky with clean flat-ish shading. Audit our props (S247 operator: "assets like they
   are from hte 90s") - the OFFICEPC3 list from John is the first batch.
4. HUD LAYOUT: TPM keeps a compact bottom toolbar + top-right info; ours floats labels over the scene. The Ludo re-ask
   (LUDO_ASK_S248_HUD.md, PC deep-sim manager, number-led) sets the panels; this task places them on the TPM screen frame.

## Prior research
- research/TWOPOINT_ALIGNMENT.md (camera FOV 17, pitch, yaw, rooms, items) and TWOPOINT_MUSEUM_STUDY_S243.md (method).
- reference_twopoint_museum_study memory: UnityPy + fallback version; numbers only; dumps outside the repo.

## What would a human do?
Put a TPM screenshot and ours side by side at the same zoom and fix the biggest visible difference first (ground, then light,
then props, then HUD), checking each against the reference before the next.

## Prefab check
Ground/street/planters: Kenney City Kit (Roads, Suburban), Quaternius - CC0. Lighting is settings, no assets.

## Acceptance
Per gap: TPM reference + our still at the same framing on the board; the operator's OK closes it (visual-gate skill).

## Contract
(S249 machine-readable block - Tools/brief_contract.py. VISUAL: yes = never auto-merged; Claude collects by hand + stills.)
OWNS: Godot/scripts/club_look/GymLook2.gd, Godot/scripts/TrainingFloor3D.gd, Godot/tests/tpm_screen_plot_test.gd (new)
RED_TEST: Godot/tests/tpm_screen_plot_test.gd -> TPM_SCREEN_PLOT failures=0
REGRESSION: gym_look2, iso_
VISUAL: yes

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped gym screen: it must read RED on <the gap - e.g. no plot mesh under the building / exposure
   and saturation numbers off TPM's>; paste that number in your report.
2. Stills only on the game's own gym camera (iso, FOV 17, the 4 yaws) beside the TPM reference at the same framing - no fight stills here.
3. For every still report: what is around the building (ground, kerb, verge), light/exposure read, prop shading, HUD position, the gap it closes.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.
