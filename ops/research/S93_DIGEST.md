# S93 DIGEST - THE FIGHTER GENERATOR PILOT (2026-09-26/27, Claude)

**Shipped:** 2268d484 (generator), e6690fe8 (Q194 merge), 3ec7ed7b (Q195 task), fb82333e (D39 DESK card).

## The generator (gate: MET except "in the game" - that is C213)
- `Godot/scripts/FighterLook.gd` (pure): athlete id -> FNV-1a seed -> clamped weights for 22 shape + 6 macro keys
  (pairs exclusive) + ancestry on a bounded simplex (each 0.15..0.70, sum 1 - the sheet's normalise-after-clamp could
  fall to 0.08) + one of nine CC0 MakeHuman male skins (dominant ancestry x age). `fighter_look_contract_test`:
  627 checks, 7/7 mutants caught.
- `Godot/scripts/FighterPortrait.gd`: the card is a studio render of the SAME seeded man (G128: 105 mm, 3/4, key
  45 deg camera-left, two rims, SSS skin, AgX, SSAO). `fighter_portrait_same_man_test`: ring and card carry identical
  weights and skin, camera on the head; 30 checks, 2/2 mutants caught.
- `Tools/generator/mpfb_build_base.py` fixes found by LOOKING at the sheet:
  (1) MPFB `Root` bone rested at -90 deg X; FightClipRetarget treats Hips as root, so clips came out ~80 deg wrong.
  Root dropped -> 0.69-0.95 deg mean vs the source clips (f01: 0.61-0.63), `tools/s93_pilot_retarget_probe.gd`
  (idle, hit reaction, knockdown; population f01 vs pilot at basis weights, catalogue ramsterz_h2h).
  (2) `age_young` 0.28 was ~15 years old -> 0.40 (~20). (3) Macro keys changed stature; the skeleton does not follow
  blend shapes, so each is normalised to the basis height (height stays FighterPhysique's). (4) Eyes + eyebrows as
  MHCLO proxies refit once per body key, so they carry the same 31 keys.
- Pilot is TRUE metres, origin at the soles: feet 0.006 m while clips play -> lift 0.0 (f01 needs 0.925).
- CC0 verified per file (each .mhmat/.mhclo header). Raw zip (267 MB) stays on D:/AI/mpfb_assets, URL in the manifest.
- Open: eye texture reads bloodshot; faces within one ancestry vary subtly; no hair/clothes (G129 researching).

## Collected
- **Q194 (Qwen) MERGED**: KB/MMA 6/6 md5 identical re-measured by Claude on master. Qwen's subset line ("all fail
  both sides") was a stale-worktree artefact and was not relied on.
- **D39 (Dola)**: tenure 12-18 months used as PROXY (no links); DESK card now says a member is worth ~$732 and the
  desk pays at 1 extra member every 2 weeks. Her "7 members pay the wage" arithmetic rejected.
- G128 was already on disk.

## Found
- `judge_panel_test`, `fight_realtime_test`, `grapple_adapter_test` red on master (green in the 9847dd13 nightly).
  Qwen's Q195 bisect already names **4f789137 Q183: footwork_economy default ON all rulesets** as first bad.

## Tests (subsets, Claude's runs)
retarget 3/3, floor 3/3, lobby/front_door/membership 2/2, both new tests green; asset_manifest back to its 4
pre-existing Mixamo fails; fight subset 12: 3 fails, identical on master and with Q194.
