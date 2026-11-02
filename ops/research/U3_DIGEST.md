# U3 DIGEST — THE BODY BY REGION

Cursor · 2026-09-07 · art-direction pack ahead of per-region implementation.

## What shipped

**1. Ruling pack** — `research/U3_THE_BODY_BY_REGION.md`. Five questions
in Maria form: spatial lab sheet (not anatomy, not six stacked rows); all six
clocks visible on BODY with binding region emphasis; `minimum_readiness` becomes
`LOWEST · NN` on glance surfaces; one M6 badge from one evaluation; NOW gauge
vs EVER ticks on the same cell; clean-surface list by name.

**2. Engine boards** — five PNGs under
`DesignLibrary/screens/body_by_region/` from real kit state via
`Godot/tools/CaptureU3BodyRegions.gd`.

**3. Harness left in repo** for re-render when the kit moves.

## Render command

```bash
LIBGL_ALWAYS_SOFTWARE=1 xvfb-run -a -s "-screen 0 1920x1080x24" godot --path Godot --script tools/CaptureU3BodyRegions.gd --rendering-method gl_compatibility
```

Boards confirmed on disk: `u3_01` … `u3_05` (includes refusals + minimum glance).

## Verification

- Parse gate: `CaptureU3BodyRegions.gd` clean.
- Full suite: fail=0 (background run before commit).
- No HANDOFF block (Claude writes it).
