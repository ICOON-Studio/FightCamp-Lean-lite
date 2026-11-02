# S247 DIGEST - 2026-10-17 - pad round guard head-locked, NIGHTLY9 #252, ActionForge route opened, HUD art gap named

Operator, this session (verbatim): Q-S242-4 "OK, close it"; Q-S242-6 "ActionForge clip"; Q-S242-5 comment "2-person) - real pad footage :
what do you mean by that ? we pay actors?"; C100 "remove the text office and make a proper label"; C101 "remove the office pc text and
label it properly"; "you can import all our animations on actionforge adn fix them ?"; "watch the whole video and learn how to make any
animation you want" (askNK i4lCE-_Uem0); on the goal card screenshot "what is this ? is this final and in the game ?"; on the fighter
panel "where is the art there ? just plain text ?".

## What now works (pushed)
- **CAMFOV17 closed** (operator Q-S242-4). Q-S242-6 was already built in S246 (UALMotion hands every MetaHuman to AFMotion).
- **NIGHTLY9 #252 collected** (89c22bcd, Grok Dev): fight_identity "rivalry heat costs stamina" measures stamina SPENT per live tick (rest
  recovery hid the cost at end of bout) - FIGHT_IDENTITY_TEST checks=9 failures=0 re-run here; mutant stamina_per_heat 0 goes red (PR).
  Thin margin (+0.9%: impact drain is unscaled) noted, not changed.
- **ASSETAUDIT1 part B: nothing to swap** (ed87faa1): the 4 SWAP rows are already GYMPACK models via GymPack.BY_DRESSING at load; the
  speed bag already draws the GYMLOOK3B pouch. Trap written into ASSETAUDIT1_INVENTORY.md (the audit reads JSON paths only).
- **Goal card status pill** (ef21707e): "AT RISK"/"ON TRACK" centred (the 14 px label box dropped the caps line onto the pill edge);
  goal_card_test 27/0.
- **PADPAIR1 guard head-locked** (Tools/cascadeur/padpair1/author_padpair.py): probe on the GAME body showed the rear glove 6.5 cm inside
  his head ALL loop (9.9 cm at the body hook's dip) and the lead 5.3 cm in on the slip. The guard was a fixed rig point + slip/sway/bob
  while the head also took the stance drop, punch dips and torso pitch. Now each guard = head + upper-body rotation x (guard - neutral
  head); rear guard moved to the MEASURED target (12 cm right, 4 cm down, 13 cm in front of the head centre - it sat 8.7 cm BEHIND it,
  in the jaw); lead +4 cm forward; the glove-tap path bows 12 cm forward (it crossed the chin). Contacts unchanged (<= 2 mm, tap 2.5 cm).
  Glove-head clearance: -0.099 -> -0.087 -> -0.078 -> -0.023 -> -0.003 m over four rebuilds: PADPAIR_CONTACT failures=0 (gate >= -0.01).
- **ActionForge route opened**: research/ACTIONFORGE_HOWTO_S247.md (full transcript of the askNK video, every tool with its
  timestamp, our route, what it cannot do). In actionforge.app (operator's Chrome, local storage): mh_boxer_01 imported as a rigged
  character - auto-recognised "Unreal Engine 5 (Manny)", own skeleton; our 5 solo clips imported (mh_jab, mh_cross, mh_lead_hook,
  mh_inside_uppercut, mh_guard_pose) and play on him. Nothing fixed or exported yet.
- **Ludo r111** (LUDO_R111_raw.txt 24.6k + LUDO_R111_cont_raw.txt 27.2k; ask_r111_s247.txt): world labels (screen-space tag spec per
  zoom, badge, room labels, WorldTag code), key light numbers, build-mode look. S243's r109 file was overwritten by the save and restored
  (00015128). Ludo HUD MOCKUP ask sent (image answer, live HUD still attached) - not collected.
- **Office label** handed to its own session (local_389abcca, "Office PC screen-space label"): WorldTag per Ludo r111 section 1, iso_camera
  test rewrite, stills, then Ludo + operator.

## Evidence
- probe (4th rebuild): contacts f024/42/66/96/134/144/172 gap <= 0.002 m (tap 0.025), glove-head min -0.003 m at f052 LeftHand, PADPAIR_CONTACT failures=0.
- run_tests --only pad_pair,padpair,goal_card,iso_camera --jobs 2: SUITE total=3 fails=0. fight_identity 9/0, goal_card 27/0.
- Office label d1b298d0 (session local_389abcca): still previews/s247_office_tag (pin sits right of the desk model - check the anchor).

## Not done / still wrong
- PADPAIR1 visual gate: side sheet vs Pexels 7187396 + game-camera stills (guard + contact) - after the probe is green.
- ActionForge fixes: the pilot jab is imported but not fixed. Route for the fix (decided): AF's own Punch Jab/Cross read as boxing punches
  (S246 sheet) - Compose them with OUR guard (pose layer: rear hand at the chin, elbows in via IK pole), Adjust posture, export FBX
  UE5 in place animation-only -> assets/anim/actionforge/ours/ -> AFMotion one-to-one -> side sheet vs Dola D69 jabs. The viewport in the
  Chrome tab is small (left panel + THE SHOT inset): close the left panel first.
- HUD art: every floor panel (fighter panel, goal card, cue bar, coach card, mood toast) is a text layout built from Ludo TEXT specs.
  Ludo mockup asked; then a TEXT pixel-spec ask; board approval; then build (one family).
- Q-S246-1 (QuickMagic, re-asked with "no actors") open on the board.
- NIGHTLY9 items 2+3 with Grok Dev: switch_gate PR coming; fight_clip_slice - asked for the rear hook's contact + back-to-guard times
  before deciding (it plays 1.724 s, over the 1.4 s hook cap).

## Lessons (rules this session earned)
- A Ludo round number must be checked against research/ludo_rx before saving (arena_rx overwrites silently).
- Measure the offset on the GAME body before moving a guard: a rig-space guess moved the rear glove 1.6 cm of the 8 cm intended.

## Operator at the end of S247 (verbatim) - next session's first items
On the office pin: "shouldn't htat be onthe side panelui and on the actual office i can clickthe pc on the desk and open it ? whystop
making the gym looking cheap make a fucking proper pc why do you make the assets like they are from hte 90s , the roomsi think need to be
bigger". Queued as OFFICETAG2 (alert in the side panel, click the PC on the desk), OFFICEPC3 (proper modern PC + prop audit), ROOMSIZE1
(rooms to Two Point sizes) - roadmap now. Ludo HUD mockup (r112, docs/previews/s247_hud_mockup) on the board as Q-S246-2.
