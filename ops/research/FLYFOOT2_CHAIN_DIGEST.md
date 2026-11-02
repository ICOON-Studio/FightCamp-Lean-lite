# FLYFOOT2 chain digest — WIP, orientation gate RED

Branch: `codex/flyfoot1`. No production animation, IK, capsule, or threshold changed. The chain advances under its explicit stop-and-move exception. Visual review remains OPEN.

## Red evidence and first writer

Read-only `foot_orientation_probe.gd` runs inside `record_room.gd -- as_game`, after draw, and logs the existing pose-writer callbacks. It measures `LeftFoot/RightFoot`, `LeftToes/RightToes` (MetaHuman `foot_l/r`, `ball_l/r`) and `bigtoe_02_l/r`, `littletoe_02_l/r`. Raw ankle-to-ball pitch and bind-calibrated sole pitch are separate columns; roll is the rest sole normal's tilt around the foot's long axis. The CSV also retains the toe-tip direction and marker heights.

Master `d87a99e5` plus instrumentation, seed 94301, Malik Adebayo / Tommy Perez, 180 frames / 5.992 s:

```text
RED mh_boxer_05 Left: raw_pitch_max=41.373 sole_pitch_max=17.255 roll_abs_p95=5.753 raw_outside=100.00% sole_outside=72.78%
RED mh_boxer_05 Right: raw_pitch_max=42.566 sole_pitch_max=18.342 roll_abs_p95=1.059 raw_outside=68.33% sole_outside=31.67%
RED mh_boxer_02 Left: raw_pitch_max=41.335 sole_pitch_max=14.889 roll_abs_p95=6.086 raw_outside=100.00% sole_outside=100.00%
RED mh_boxer_02 Right: raw_pitch_max=42.413 sole_pitch_max=15.754 roll_abs_p95=0.800 raw_outside=100.00% sole_outside=0.00%
RED coverage: two seeds, four bodies, >=60 seconds per foot required
```

The first `animation_sample` writes raw 41.335/42.413 degrees in guard; subsequent body-layer, inertia and foot-lock callbacks preserve the initial bad angle. The first writer is the retargeted clip sample, not the recorder or foot lock. Independent GLB transform composition finds source flat-rest raw pitch **39.179 degrees**, versus **24.224–29.270 degrees** across the four MetaHuman rigs. `FightClipRetarget.SILHOUETTE_SEGMENTS` aligns Foot→Toes as a 3D segment, transferring the source anatomical slope to differently proportioned target feet. This explains the extra sole tilt; a repair still needs live validation.

## Why this cannot honestly be marked green

The task's literal lead-foot ankle→ball limit is 0–12 degrees, but an anatomically flat MetaHuman foot is already 24–29 degrees by that measurement. Making that raw line horizontal would tilt the actual sole upward. The scorer preserves the literal limits and reports sole angles separately. A user clarification is pending about applying the existing bands to sole orientation; no permission to change the gate has been assumed.

Three diagnostic paths were attempted: current merged FLYFOOT1 recording, exact master recording, and a matched-cast master recording after fixing its missing cast selector. These are instrument/baseline attempts, **not three animation repairs**. The initial invalid cast-ID run was stopped and is excluded. Multiple later parse/record attempts were refused because another TECHSTAGE1 Godot process occupied the engine; the queued seed-930093 recorder was cancelled before switching branches. No unrelated process was stopped.

The exact `93a2c7d6` run and full-duration two-seed coverage remain unperformed. The current pre-fix recording at `29a898c8` has the same foot-player, lock, retarget and clip files as `93a2c7d6`, but differs in other game switches; it is not relabelled as an exact historical run. The earlier master take named `master_94301.csv` used Vance/Miller because master ignored `cast_fighters`; only `master_cast_94301.csv` is the matched Adebayo/Perez comparison.

## Changes and checks

- Added a read-only orientation/writer instrument, a Python scorer retaining the literal limits, and a synthetic probe test.
- Synthetic flat-foot, 60-degree pointed-foot, 15-degree sickle, and downward-toe witnesses: `SUITE total=1 fails=0`.
- Initial instrument/recorder/test parse: `CHECK total=3 fails=0 autoload_refs=0 autoload_warnings=0`.
- Final metadata/coverage instrument parse (03:38 host time): `CHECK total=3 fails=0 autoload_refs=0 autoload_warnings=0 time=1s`.
- No animation repair, green rendered gate, or affected production-system test run is claimed.

Evidence: `E:/FightCamp/tmp/flyfoot2/red_evidence.json`, `rest_anatomy.json`, `master_cast_94301.csv`, `master_cast_94301_engine.log`, `red_current.csv`. Temporary measurement branch: `codex/flyfoot2-master-probe`.

## Visual status

No new candidate stills, crops, or 20-second clip were produced. Prior FLYFOOT1 `E:/FightCamp/tmp/flyfoot1/delivery_stills/guard.png` was opened as diagnosis only: clear body gap; both heads face across/down toward the opponent; Adebayo's raised glove is high and Perez's forearms follow the gloves; Perez's rear foot appears pointed and Adebayo's lifted foot angles downward. Bodies are mh_boxer_05/02. Those qualitative observations are not new frame-matched measurements or acceptance evidence.

K46 allows rear heel lift and ball support; it does not require the whole foot to point downward. Coaching references: [MyBoxingCoach stance](https://www.myboxingcoach.com/stance-and-on-guard/) and [IBA coaching manual](https://www.iba.sport/wp-content/uploads/2018/07/AIBA-Coach-Regulations-Manual_WEB.pdf). They support qualitative heel/lead-foot cues; the numerical bands are task-authored. Claude and the operator still need the repaired, measured guard/mid-move/contact stills and clip before closure.
