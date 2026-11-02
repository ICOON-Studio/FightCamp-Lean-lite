# S332 digest - every lightweight her own face, the hit ring off her face (2026-11-01)

Lean commit fc4713a (pushed). Operator answers: Q-S294-52 "B Gym whiteboard", Q-S294-51 "Yes, soon enough", Q-S294-47
"Right", Q-S294-53 "Still off - I'll mark it" + C151 (Maria's body panel: the white hit ring on her face, "wtf is that").
In chat: "why you build new metahumans ?" (answered: all three HOME looks show faces; every lightweight opponent wore one
face), "remake sophie turner", "remake erin doyle and dana whitfield make them all hotter", "how fast a fighter can read
opponent pattern needs to be a factor".

## What changed
- Faces.gd: a body per woman (Lucy 11, Maria 13 Celeste, Priya 14 Sunita, Erin 15 Jelena, Dana 16 Tuya, Chloe 17 Aera,
  Aisha 10, Megan 12). FightCast picked 1 of 3 by weight class before - every lightweight opponent was Etta (12).
  Sophie Turner: body 18 came out with a man's face (preset "Bo"); dropped, she takes a body by her name until remade.
- BodyFigure: hurt / just-hit face and rib sides redden her own skin (shader SPOTS, soft edge); no rings over her.
- Portrait baker: 8x MSAA (hair cards baked as dots without it), stems= argument, list from Faces.
- Tools/metahuman/mh4_sidecar.py: writes the Lean sidecar json (skin tone, measured height) for a built body.

## Evidence
faces_test, body_figure_test 7/7 (test 7 red on master), tale_of_tape_test, body_map_test, fight_feel_test: failures=0.
Stills: S332_stills/faces_lineup.png (first 9, Sophie's man face), faces_lineup_v2.png (the 8 shipped, on the review
board), hair_msaa_maria.png. NOT verified on the game camera: the face spot in a live fight (no still this session).

## Found
- MetaHuman Creator subsystem exposes get/set_face_model_coefficients + commit_face_state: faces can be BLENDED - the way
  to "hotter" with only Ada/Vivian/Lani left unused.
- UE runs can hang on "Waiting for groom bindings" (17 BobSlick, 18 Grace); kill by PID, retry. The tool reuses
  /Game/MH/MH4_<name> - delete it before changing a preset.
- The PC went RED on commit memory (1.8 GB) during the UE builds with Chrome + Brave open; E: free 36.8 -> 18.4 GB
  (pagefile growth, not the builds: .mh4 is ~3.5 GB).

## Next (S333)
Q-S294-54 fonts; face blends for Erin/Dana/Sophie + hotter pass (lineup to him first); whiteboard look on HOME; pattern
read speed (Exchanges IQ_FINDS -> repeats needed from fight_iq). Full plan: Lean NEXT_SESSION_PROMPT.md.

## HANDOFF
Working commit Lean fc4713a. Next action: S333 per NEXT_SESSION_PROMPT.md. Nothing in flight.
