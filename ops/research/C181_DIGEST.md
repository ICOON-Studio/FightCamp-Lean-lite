# C181 digest - Higgsfield loop

The Python-only implementation is present in `Tools/higgsfield/loop.py`. It
preflights the provider estimate against the append-only C181 ledger, prints
the running total, stops at a human still check unless `--auto` is supplied,
downloads the clip, runs the C180 segment tracker with the recipe panel count,
and appends the README and prompt-log rows.

| recipe | panels / duration | visible% / confidence | finding |
|---|---:|---|---|
| `C181_1x2_opposite.json` | 2 / 4 s | not run | blocked: corrected-grips still 5387ac51 is not in the checkout and the Higgsfield Blender client is unavailable |
| `C181_1x3_oblique_high.json` | 3 / 4 s | not run | same prerequisite block |
| `C181_1x3_joint_dots.json` | 3 / 4 s | not run | still-first gate remains closed; no clip spend is possible until dots survive a checked still |

No third-camera or marker-dot measurement can honestly be reported without
the clips. The intended comparison is the C180 per-segment `visible` and
`confidence` values, with special attention to the top athlete's hips and
thighs. The prompts add the proven gloves, mouthguards, loose athletic
tracking suits, gym, and sports-science wording; the 1x3 recipe adds an
oblique-high (not overhead/end-on) camera, and the third recipe explicitly
tests joint dots before animation.

Ledger total: **0.00 credits**. The required fake 121-credit preflight was
refused locally; no network job was submitted. Seedance 2.5 was not used.

The attempted live command failed before provider submission because
`bl_ext.user_default.higgsfield_blender.fnf.session` is unavailable in this
plain Python environment. Consequently no job row was appended to the prompt
log and no README row was invented.
