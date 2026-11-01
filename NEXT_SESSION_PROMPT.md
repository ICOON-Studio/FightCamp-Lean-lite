# S333 - next session (written S332, 2026-11-01)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.

His S332 answers: Q-S294-52 "B Gym whiteboard" (build it), Q-S294-51 "Yes, soon enough", Q-S294-47 "Right",
Q-S294-53 "Still off - I'll mark it" (one mark, C151: the white hit ring on Maria's face, "wtf is that" - fixed S332:
a hurt/just-hit face reddens her own skin, BodyFigure SPOTS). In chat: "remake sophie turner", "remake erin doyle and
dana whitfield make them all hotter", "how fast a fighter can read opponent pattern needs to be a factor".

Done S332 (Lean fc4713a): Faces.gd - each lightweight her own MetaHuman (13 Maria/Celeste, 14 Priya/Sunita, 15 Erin/
Jelena, 16 Dana/Tuya, 17 Chloe/Aera; Lucy 11, Aisha 10, Megan 12). Sophie has none yet (18 = "Bo", a man's face; dropped).
Portrait baker has 8x MSAA (hair no longer dots).

1. Fonts DONE (his "downalod yes"): assets/fonts PermanentMarker-Regular.ttf, Kalam-Regular/Bold.ttf (Lean 2967c35).
   THE READ (item 4) APPROVED - operator S332: "Yes, build it", then "and make it look as good and how UFC would make
   it": the read on screen in TV fight-broadcast graphic style (study real UFC/ESPN broadcast overlays first - strike
   stats, the corner-colour bars, bold condensed type, animated fills; their style, never their logos or branding).
   Build it on the fight's existing Broadcast.gd / RoundGraphics.gd look; menus stay whiteboard. Stills to him before done.
2. FACES "hotter" (his words). MH4 tool: E:\FightCamp\Game\Tools\metahuman (mh4_run.py build|finish <name>, specs
   <name>_mh4.json, MH4_TARGET_DIR=E:/FightCamp/Lean/assets/models/metahuman; sidecar json: python Tools/metahuman/mh4_sidecar.py <names>, run from Tools/metahuman). Only Ada (cutman face), Vivian, Lani (older) are unused women's
   presets, so BLEND faces: the subsystem has get_face_model_coefficients / set_face_model_coefficients / commit_face_state
   (probe S332). Add to mh2_build.py: optional cfg "face_blend": [[preset, weight], ...] -> load each preset's coefficients,
   weighted sum, set, commit_face_state, before body constraints. Make Erin, Dana, Sophie (new 18) from blends of the best
   faces (Celeste, Aera, Jelena, Asha); then a lineup still to him on the board before they ship.
   Also: hair_lod 0 in the spec (fuller cards; `finish` only, no UE). TRAPS: a UE run can hang on "Waiting for groom
   bindings" (17 and 18 did; kill by PID after ~15 min quiet log, retry); delete .mh4/project/Content/MH/MH4_<name>.uasset
   before changing a preset (the tool reuses the old character); a singlet woman is built bare - audit with sex M.
   After: import (Start-Process -Wait, the GUI exe does not block), bake_body_portraits stems=..., bake_body_masks, tests
   faces_test + body_figure_test.
3. Build look B (Gym whiteboard) - mockup Game Godot/research/S331_looks/b_whiteboard.html/.png: UI.gd palette to the
   whiteboard (wall #CFE0EA, board white, frame #AEB8C0, blue #2F6FDB primary, red #E2483D, yellow #FFD54A, green #2FA36B,
   marker ink #22262E), font kinds "marker"/"hand" (fallback when the files are absent), Shell top bar + nav, then HOME:
   board with her polaroid (Faces portrait crop: top 42 % width x 1.15) + marker notes + next 4 weeks, sticky notes for
   Needs, cash tin. Before/after stills (tools/pages_now_still.gd), board question. Then GYM, MONEY, FIGHTS, her page.
   UI.gd 394 lines, BodyFigure.gd 497 (500-line rule - split before adding).
4. PATTERN READ (his ask): Exchanges.gd already has IQ_FINDS (a clever fighter finds the answer when the same game carries
   on) - make it a SPEED: repeats of an opponent's habit before she reads it, from fight_iq (+ film study), shown on the
   corner card. Real-world basis first (John/research), then a pure module + test.
   MERGED with his S332 ask "every fighter needs a different trigger/threshold for the perfect move execution, how can
   this become a mechanism a player can enjoy": THE READ - APPROVED (S332 "Yes, build it") - per
   opponent habit a read meter; read speed (fight_iq + film study + scouting pre-fill), trigger threshold (temperament:
   patient/gambler, per fighter), execution (MoveMastery of the counter); corner calls "Wait for it" / "Take it now"
   shift the trigger; opponents drop a habit after being punished; payoff = the counter in the 3D fight + "READ IT" replay.
5. Q-S294-53 "Still off": after the face fix, send him a fresh close-exchange still and ask again.
