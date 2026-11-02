# S80 DIGEST - the front end in M34 direction A, real sound, the arena, the fight-night sequence
Claude, 2026-09-25. HEAD at end: see `git log` (last S80 commit is the handover). Look: `research/s80_look/`.

## Shipped (all on master, all pushed)
- **Backgrounds (the operator steered five rounds):** dark/empty gyms rejected ("abandoned"), gyms with generated people
  rejected, the empty-wall compositions rejected; the operator generated his own picture in Higgsfield and it became
  the title (`title_gym_bg.jpg`, brand name and then the heavy bags removed on his word). HOME got a picture drawn FOR
  its pins (`home_gym_bg.jpg`: glass office, staff door, ring, weights), then the three areas: FIGHTERS locker room,
  FIGHTS office wall, FINANCE desk (`hub_*_bg.jpg`). Every source in `Godot/assets/images/SOURCES.md`. ~54 credits.
- **Title to A exactly** (operator: "match A exactly" after he caught that A's palette had been put on the old
  layout): brass wordmark shader, left stack, chamfered leather buttons, LAST SAVE card with portrait, warm grade.
- **HOME to A:** the picture is the hub - pins on the office, staff door, ring and weights; NEXT FIGHT (portraits,
  records, camp, weight vs limit, the one gold), NEEDS YOU, ON THE WIRE, portrait fighter cards (distinct faces).
- **Shell to A** on every career screen: crest + club top-left, brass date plate with the green Continue (no day
  strip), cash/upkeep/bell top-right, framed menu with the teal active row.
- **Area hubs** (`AreaHubScreen.gd`, routes `fighters_hub` / `fights_hub` / `money_hub`): picture + pins + caption.
  The rail's area row opens the hub; its pages stay under it. **MONEY renamed FINANCE** (operator).
- **Inner pages** sit on one brass-edged leather plate; kit frames/buttons are A plates with cut corners.
- **Inter 4.1** is the body/data face (`T.MONO` -> `inter_row.tres`, tnum). **Direction A palette** in UITokens.
- **HOME J54 + K78 words** (24 coach lines, camp gate row, rail tips, CORNER · HUD labels).
- **Fight-night sequence** (`FightNightIntro.gd`, on BEGIN): tale of the tape -> ROUND 1 bell with the recorded bell,
  ~9 s, skippable. The walkout still was REMOVED (operator recognised the composition from another game); the walkout
  returns as a live 3D shot - **C207 (Codex) assigned and running**.
- **Collected:** U175 real recorded sound (Freesound CC0, SOUND_ENABLED), C205 + C206 Marpa arena (behind `venue_art`,
  OFF; fits the engine walls within 3.4 cm), G101, G102, G104, K78.

## Tests (subsets only - the full suite is nightly)
104 screen tests green across ui_, profile_, rankings, schedule, training_hub, scouting, office, gym_hub, fight_night,
boot_, skill_tree, amateur, corner, staff, career_, setpiece, creation, day_feed, menu_clarity, shell, smoke, walk,
coach, header_continue, news_morale, icon_kit, venue_art, fight_world_live, fight_audio, tale. **One red:
`fight_body_overlap_test`** (hand>head 0.19 m at frame 112) - fight-motion code this session did not touch; the
nightly must confirm whether it predates S80.

## Known, not fixed
- Fighter B fights boxing bare-handed (C206 control arm: OFF and ON) -> **U176 (Cursor)**.
- A boxer's foot crosses the rope line (both arms) - footwork lane, not art.
- Only 3 male + 3 female portraits: a 4th man repeats a face.
- Pictures do not change with gym size/tier - the operator's next question (HUB_DISPLAY_EVAL).
- Beats 1-2 of the fight-night storyboard (announcement, weigh-in faceoff) still use the old screens.
- The whole road booking -> bell at 1X is still not recorded (owed since S79).

## Operator rulings this session (verbatim where quoted)
- "i dont like any of these pirtures they look like abandonned gyms , why they are all so dark ?" / "all terrible
  again , better with no people" / "an empty wall is dominating all 4" / "use the picture i just generated in
  higgsfield" / "remove the heavy bags form the picture".
- "i already picked and you already ignoring what i picked , correct ?" -> "go ahead, match A exactly".
- "change money to finance ?" -> done.  "no sense" (a floor pin on lockers) -> fixed.
- "i have seen this picture on another game take it out" (the walkout still) -> removed; "is bad idea to generate this
  in our 3d engine ?" -> no, better: C207.
- "i want everyone on the next session to do an evaluation of the current state and propose ways to diplay the hubs"
  -> `TASK_HUB_DISPLAY_EVAL.md`; "make sure they can see how the game looks like now" -> `research/s80_look/`.
