# S92 DIGEST - the fighters were ours all along; the portraits are now sourced; the generator route is chosen
Claude, 2026-09-26. Roadmap `now` from S91 (regenerate the twelve on Tripo Pro, then portraits).

## The premise was wrong, and that changed the stage
- **The twelve fighters were never made on Tripo's free plan.** HANDOFF_ARCHIVE "THE PROOF FIGHTER" (2026-09-08) and
  R77 record the chain: Tripo's `tripo_3d` model called THROUGH Higgsfield's MCP on the paid Plus plan (5 credits each),
  rigged on Ludo Rig & Animate (1 credit each). S90 read "tripo" in the name and applied tripo3d.ai's free-plan terms.
- Terms read at the source S92: **Higgsfield s4.4** "does not claim ownership of any of your Inputs or Outputs, nor
  does it restrict your commercial use of Outputs"; **Ludo / Jet Play EULA (26 Aug 2026)** grants "a nonexclusive
  worldwide license ... for both personal and commercial purposes". So the bodies SHIP; regeneration is not needed for
  rights. `asset_manifest.json` tripo_fighters + ludo_retarget_clips corrected, M35 ledger corrected, memory corrected.
- The operator's Tripo Pro purchase rested on that premise -> `blocked_on_operator: tripo-pro-refund` (their call).
  Pro still buys gym props (S94).

## Shipped
- **Portraits (M35's priority art job):** the nine UNKNOWN-source pictures replaced by **24 faces (12 men, 12 women)
  + 3 silhouette fallbacks**, Higgsfield `gpt_image_2_5` 1:1, one studio recipe (G125: 85 mm, 3/4, key camera-left,
  two rims, charcoal-brass drop; fictional, mixed ages/ethnicities/disciplines). 27 jobs, 6.75 credits (254.8 -> ~248).
  Every job id in `images/SOURCES.md` and `HIGGSFIELD_PROMPT_LOG.md`. `TaleOfTape.GENERATED_PORTRAITS` 3 -> 12 per sex;
  the old filenames keep their slots, so saves stay valid. UNKNOWN images the game can show: **0**.
- **`generated_portrait_fallback_test` now refuses an unsourced portrait** (every pool + fallback path must have a
  SOURCES.md row). Mutant: drop the female_07 row -> `failures=1`; restored -> green.
- **D37 acted on (first change):** doorway and floor sign words 30% larger (`DOOR_SIGN_PIXEL` 0.0047,
  `DOOR_FLOOR_SIGN_PIXEL` 0.0044, boards grow with them); a **TRIALS & MEMBERSHIP** board over the lobby desk. Checks in
  `front_door_test` and `training_floor_3d_test`.

## Collected
- **G125 (Grok):** regeneration + portrait recipe. Its A-pose advice is NOT taken for a mesh swap (clips retarget onto
  the T-pose Ludo skeleton with per-fighter corrections); its portrait recipe IS taken.
- **G126 (Grok):** a generator without Reallusion = MakeHuman/MPFB. **CC0 verified by Claude** at the MakeHuman
  LICENSE.md s C-D (assets CC0; exports "your data"). 8-15 days; trap = morph VRAM + bone-rest drift. -> S93 pilot.
- **D37 (Dola):** fresh eyes on the front door - acted on above.
- **C211 (Codex):** driven by the OTHER open Claude session (runs 2-3); its witness fix (blockers = the subject's own
  body) is correct. Left to that session.
- **D38 (Dola):** the roster reads as one set; two outliers (R1C2 grey top, R2C2 hoodie) edited to black tops, same
  faces (Higgsfield edits ced33379, d38e2d99).
- **G127 (Grok):** the MPFB modifier names, ranked 20 face + 20 body shapes with safe weights, CC0 skins (hair02 is
  CC-BY), seed rules - the S93 shape spec.
- **Q193 (Qwen):** instrument + digest merged; the global flag flip NOT merged - kickboxing pace fell 6.26 -> 5.17/min
  (J20 6.85) and no subset run was done. Boxing alone clears the bar -> **Q194** (boxing-only, KB/MMA byte-identical),
  running.
- **U186 (Cursor): REJECTED.** Re-measured with U185's UNCHANGED instrument (c0b8ba95, seed 94301): baseline p95
  **0.573 m/s**, U186 **0.981 m/s** (worse), mutant 0.769. Its 0.261 came from reclassifying fast lock samples as swing.
  Cursor's next task (U187) is written at S93 start.

## The operator's two questions (answered in chat)
- Generator without Reallusion: yes - MPFB (CC0), S93 pilot.
- Photo vs 3D likeness: today they are chosen independently (only sex matches). S93's gate makes one seed drive both
  the 3D face and the portrait (a studio render of that fighter).

## Tests
- `generated_portrait_fallback_test` 0 failures (24 + 3 portraits, SOURCES rows; mutant: drop a row -> red).
- `front_door_test`, `training_floor_3d_test`: green with the D37 checks; mutant DOOR_SIGN_PIXEL back to 0.0036 -> red.
- Subsets: portrait/tale/profile green; athlete 1 red = `athlete_development_test` (a nightly known red);
  `asset_manifest_test` red on the Mixamo audition candidates (nightly known red, not this change).
- Full suite: nightly `AgentComms/nightly/latest.txt` (2026-09-26, 416 tests, 13 known reds) - not re-run in session.

## Also this session
- **Asset-store search** (`S92_ASSET_STORE_SEARCH_GYM_PROPS_AND_STAFF.md`): real fight-gym packs exist (Unity 'Boxing
  Gym' 80286, EUR 18.39); its screenshot is dated low-poly and our ring is code-drawn -> **not buying**; S94 pilots one
  heavy bag on Tripo Pro, the pack is the fallback. No store sells fight-gym STAFF in one style -> staff come from the
  generator. Operator: "keep tripo pro, use it for the gym props".
- **Audio:** Higgsfield has no general music/SFX model (its tool says so). Ludo does (music 3 cr, SFX 2 cr, commercial
  EULA); the account holds 4 credits - one music pilot (the gym/HOME theme) generated, see below.
- **Ludo music pilot:** `assets/audio/music/gym_theme_ludo_pilot.mp3`, 97 s, peak -4.2 dB, mean -26 dB; sent to the
  operator for the ear test; NOT wired in. Ludo balance 4 -> 1. A full soundtrack (menu, gym, fight-night walkout, camp,
  results, ~6-8 themes) + SFX variants needs a Ludo plan (Indie $15/mo annual = 3,000 credits/yr ~ 1,000 tracks) or a
  top-up - the operator's spend.
