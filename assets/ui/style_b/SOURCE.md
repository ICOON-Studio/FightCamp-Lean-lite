# style_b - flat comic menu art (S399), for the blind A/B in ops/research/STYLE_AB_S398.md

Made with Ludo (operator's Pro plan, `ludo image edit` / `image generate-with-style`, 0.5 credit each), 2026-11-07.
- portraits/<body>.png: each body's OWN studio photo (assets/ui/face/studio/<body>.jpg) restyled with NO face reference
  (operator S399: "i want whatever is on the image to match the fighter"; a style reference carried boxer 01's face into
  others - those are kept in portraits_v1_refbleed/ and not used).
- icons/: the four threat kinds (threat_weapon, threat_habit, threat_weakness, threat_game) and four answers (answer_angle,
  answer_elbows, answer_busy, answer_pressure), generated with style _trial2/editImage-1cfc1019-v1.png. The -vN files are
  the variants not picked. threat_game is boot soles (boxers wear boots).
Switch: PromoShot.ui_art() - `ui_art=b` user arg or `ui_art` in user://settings.cfg; default "a".
- fullbody/<stem>.png (S534, owner "Keep painted" Q-S294-289 and "switch them on the fight too"): every full-body render in
  assets/ui/art/fullbody (19 bodies x orthodox / southpaw / 2 poses x red / blue kit = 152) restyled with `ludo image edit`
  (0.5 credit each, 76 total), the body's OWN portrait in portraits/ as the reference (no other body's face). Prompt: "Turn this 3D
  render into a flat comic book illustration matching the reference exactly: thick black ink outlines on every shape, flat matte
  colour fills with one simple cel shadow tone, no gloss, no shine, no photographic skin, simple drawn muscle lines like the
  reference. Same face, same pose, same stance and guard; keep the gloves, shorts, wraps and boots in exactly their colours."
  Then tools/fit_painted_bodies.py fits each onto its render's 600x800 canvas (same height, foot line, centre), so FaceFrame's
  "fullbody" head boxes and the versus layout hold. Read through RosterCards.body_path() when PromoShot.ui_art() is "b".
- fullbody/ REPAINTED S534 (owner "the fighter's arms are too skiny", then Q-S294-290 "Follow Strength"): the same 152 with an
  athlete's build - "toned, defined arms, shoulders and forearms of a trained fighter ... not skinny, not bulky" and "keep the
  ... shorts, top ... in exactly their colours and their cut" added to the prompt (76 credits). The 3D fight thickens the arms
  by Strength on top (scripts/fight3d/v2/ArmBuild.gd); the paintings are one toned build for everyone.
