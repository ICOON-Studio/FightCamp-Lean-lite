# Claude land note — M34 "pitch look" (Maria, 2026-09-25)

Art only. No code touched, nothing committed. Maria delivers.

## What's in it
- `M34_PITCH_PRESENTATION.md`: the full pitch (decisions, reference board, still vs animated, 4 directions, fight-night storyboard, transition spec, buyable assets, never-list, self-attack, sources, honesty flags).
- 8 mocks at 1920×1080: title + home hub for **A Brass & leather** (favourite), **B Fight poster**, **C Arena night**, **D Six A.M.** (M32 tokens, illustrated).
- Fight-night storyboard: 5 beats + contact strip (Direction A styling).
- `M34_reference_board.png`: 12 credited thumbnails of real screenshots.
- `_build/` (Pillow scripts that render everything), `_src/` (fonts with OFL files, reference frames, repo-art copies), `icons/` (52 Lucide SVGs, 28 new since M33).

## Staging (proposed)
- Beast `_maria_delivery/M34/`: everything in this folder except `_venv/`.
- `research/`: `M34_PITCH_PRESENTATION.md`, `CLAUDE_LAND_NOTE_M34.md`, `M34_MANIFEST.md`.
- `research/m34/`: all `M34_*.png`. Don't commit `_src/refs/` (third-party screenshots, internal reference only).

## Key decisions
1. Stills + a thin live layer (parallax ≤ 12 px, dust, one light shaft, crowd foreground on fight night). No frame-by-frame animation. Video only as an optional attract intro later.
2. Favourite = A; fallback = C; cheapest = D. **The operator picks.**
3. **M32 amendment:** 360 ms brass wipe (title→hub, hub→fight night) and 400 ms dissolve/light-bloom (logo→title, fight-night beats) only. Everything else keeps 160–240 ms slides, with the shell still. Bell→fight = hard cut + one 240 ms ring. "Reduce motion" turns cinematic moments into 160 ms cuts.
4. Sheen = one sweep (~600 ms) on hover/focus enter; never loops; no pulse anywhere.
5. No store GUI pack fits; draw our own 9-slices from the chosen direction. Buy the Blender boxing-gym scene ($24.99, check commercial scope first) for background renders. Use the owned Marpa MMA Arena for fight-night renders.

## Build first (once a direction is chosen)
1. Theme tokens for the chosen direction (map table in §3 of the presentation) + display font (OFL).
2. 9-slice frame + button (normal/hover/pressed/disabled) + a sheen shader on the main action.
3. Date/time bar with the Continue unit (existing Continue logic, new skin).
4. Title screen: background still + 2 parallax layers + dust (GPUParticles2D), then the 360 ms wipe to the hub.
5. Hub roster cards with portraits (no initials) and the next-fight hero.
6. Fight-night sequence last (needs 3 illustrations: weigh-in stage, tunnel, arena).

## Open questions
- **Operator:** which direction (A/B/C/D)? Is the cinematic dissolve/wipe amendment OK only for title and fight night? Is a skippable ~15 s fight-night sequence the right length?
- **Kalli:** all words on the mocks are EXAMPLE: tagline "Run the gym. Build the fighter. Make the walk.", "The road here", "On the line tonight", "Six weeks to get here", the bell line "Six weeks. 6.0 kg. Nineteen months. Now it's three minutes.", "Tip 1 of 4" tutorial text, hotspot names (The ring, Office, Staff room, Weights). Please confirm the glossary: "the gym" = the building, "fight camp" = the training block before a fight.
- **Provenance:** repo AI portraits and gym/office art have no recorded generator/terms. They need clean replacements before shipping.
