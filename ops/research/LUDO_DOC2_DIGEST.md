# LUDO-DOC2 — live doctor, retirement and career scar

Delivered on `codex/ludo-doc2`. `ludo_doctor` remains opt-in and absent from
`DEMO_SWITCHES`; it applies to boxing bouts, excluding spars.

The existing `trauma[brow].cut` slot carries the 0–5 cut model, including half
pips. Clean head hooks and clinch clashes open cuts through `CutsDoctor`;
jabs/crosses worsen an existing cut. Legacy swelling copies and corner seals
preserve fractional cuts in those same slots. Every cut change is logged.
Doctor checks use the engine RNG, inspect bell pips before corner treatment,
and stop immediately at five pips. A continuing inspection pauses engine time
and holds the presented clock when the inspection reaches the picture.

The UIKit inspection card shows brow, five pip icons, word/percent odds and
TOWEL / WAVE HIM ON buttons with tips. `doctor_choice` resolves headless runs.
Towel records RTD, the approved $150 gross purse and a healed cut. Wave-on
settles the approved purse and scar level from finish pips; repeated inspections
retain the worst brow the fighter waved through. Career settlement writes the
structured scar and its trait without duplicating or downgrading an existing
same-brow scar. The existing fighter sheet trait plate displays its icon and tip.

LUDO-CORNER2's swab/coagulant spending is not wired in this checkout. The live
mitigation list starts empty, as the task permits; the pure rule and tests cover
both reductions. The old corner's seal still treats the shared pips.

## Verification

- RED, before engine edits: **1,491 checks, 3 failures, 0 natural cuts**. Missing
  witnesses were cut events, the inspection seam and the decision seam.
- GREEN: **1,566 engine checks, 0 failures, 13 natural cuts** for actual Leo Vance
  and Ray Miller data over eight seeds; **146 UI checks, 0 failures** at
  1920×1080 and 1280×720. Covers doctor pause, five-pip TKO despite mitigation,
  `doctor_choice: towel`, $150 RTD, four-pip level-two scar, shared half-pip
  worsening/corner sealing, actual sheet renderer and clock hold.
- Parse: **8 touched GDScripts, 0 failures**, one expected autoload reference.
- `--only fight_realtime --jobs 2`: **SUITE total=1 fails=0**.
- `--only corner --jobs 2`: **SUITE total=16 fails=0**.
- `--only cuts_doctor --jobs 2`: **SUITE total=1 fails=0**.
- No related gate failed; no master-failure comparison reruns were needed.

## OFF-arm proof

Master was **62306415d54d6bf92ef841bca98bcb402f886df7** at baseline capture.
Branch HEAD **f528af8de2a9297333659c34b2801baf2c3e56f0** differed from that master
only in `AgentComms/live_runs.json` and `AgentComms/roadmap.json`; all gameplay
code and test dependencies were identical. Baseline and RED ran on that
master-equivalent code in the assigned branch, avoiding a checkout or write to
master. The GREEN test compares the complete JSON round/event log against all
eight SHA-256 values captured before engine edits:

| Seed | SHA-256 |
| --- | --- |
| 1 | `49f188e6ccb5c6e35cebab5db4e898019f2db73ebfd5d5e38d98484b6e4bd757` |
| 2 | `ec0b2097def3320e756f46ed4a546e83776c2542c4cd8710ec2fada9aad12b1b` |
| 3 | `9772b76025fe36bf615a9cf5cb471c9e91464ac4ae3c5a46591c50fda0c1acf3` |
| 4 | `8ae8189fa56266364a3c48cb3e40f7862f1918cbe3d18595b7a2f6ae9611bc42` |
| 5 | `e38c0beaa9d0be2818fde1fb5bbd393845960b26f506e45244d86f6b9871c100` |
| 6 | `d7f67ca66d218da12ded20999f73335b401f3a944bc0d2b211aba431a93ab866` |
| 7 | `67d970e1d4cb1ca217c9b3e09306730f06764446a9a8234fe932aac53463a859` |
| 8 | `ad956fc7b8fbbc24f3bea889ed10e8094f69636424cf55f75c3634cd25a7de8c` |

## Stills and scope

`Tools/godot_hidden.ps1 --path Godot --script tools/doctor_still.gd -- as_game ludo_doctor`
rendered both stills on the hidden desktop. `still_framing.save_if_framed` passed
for both with the game's `broadcast` camera, both fighters' heads and feet in
frame. Both final PNGs were inspected with the file tool:

- `previews/doc2/01_doctor_overlay.png`: round-three inspection,
  three pips, 35% risk, both player choices.
- `previews/doc2/02_scar_sheet.png`: wave-on win and the existing
  fighter sheet's **Cut-Prone Scar (Level 1)** line.

The still harness uses an explicit acceptance fixture for the round-three cut
and final winning cards; it is a view of the actual engine choice and career
scar writer, not evidence that this seeded natural bout reached those cards.
The existing FBX retarget reader prints short-read warnings during scene setup;
the capture also prints scene-resource leak noise at teardown. Neither prevented
the two guarded PNG saves. The initial feet/head framing refusal was fixed in
the harness by selecting the standing broadcast shot and running the existing
camera fit; the guard was never bypassed.

Task precedence set aside the general master-rebase instruction. The required
existing sheet hook adds a narrow `DevelopmentPanel.gd` edit beyond the owned
list; its trait note now uses an explicit line break to avoid clipping. No
master checkout/write, visible application window, image viewer or browser was
used. Headless import artifacts are excluded from delivery. No full suite ran.
