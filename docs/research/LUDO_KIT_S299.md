# Ludo S299 - women's amateur kit for the 3D fight (readability)

Asked 2026-10-29 (Ask Ludo, project FightCamp, fresh chat): replace the baggy Creator tee with a fitted sleeveless amateur
singlet painted on the body; decide singlet / trunks / waistband / gloves / trim / roughness so the two boxers and each body
part read apart at broadcast distance. Reply ~3.5k chars; the verdict table and rationale, verbatim:

| Element | Red Corner | Blue Corner | Visual Function & Rules |
| :--- | :--- | :--- | :--- |
| Singlet Body | 0.78, 0.08, 0.08 (Vibrant Scarlet) | 0.08, 0.28, 0.78 (Royal Cobalt) | Primary corner identifier; high saturation pops against dark crowds. |
| Singlet Piping / Trim | 0.92, 0.92, 0.92 (Off-White) | 0.92, 0.92, 0.92 (Off-White) | 1.5 cm mask stroke on neckline and armholes to frame bare skin from cloth. |
| Waistband | 0.95, 0.95, 0.95 (Pure White) | 0.95, 0.95, 0.95 (Pure White) | 10 cm wide band; IBA mandatory beltline rule (clarifies legal target area). |
| Trunks Body | 0.38, 0.03, 0.03 (Deep Crimson/Maroon) | 0.03, 0.10, 0.35 (Midnight Navy) | Distinct value separation (~40% darker) from singlet; prevents the single-blob silhouette. |
| Trunks Side Stripe | 0.92, 0.92, 0.92 (Off-White) | 0.92, 0.92, 0.92 (Off-White) | 3 cm vertical lateral stripe; tracks hip rotation and footwork stance in Godot. |
| Gloves | 0.62, 0.06, 0.06 (Keep) | 0.06, 0.16, 0.60 (Keep) | Retain current base, keep the white wrist cuff + white knuckle scoring target strip. |
| Boots | 0.08, 0.08, 0.08 (Matte Black) | 0.08, 0.08, 0.08 (Matte Black) | Grounded baseline; white upper trim ring to catch ankle movement. |
| Roughness (PBR) | 0.65 (Polyester/Lycra blend) | 0.65 (Polyester/Lycra blend) | Trunks satin accents 0.35; prevents blown-out top-light specular hot spots. |

> Under Godot 4's harsh downward arena keylights, monochromatic kits collapse into an unreadable visual silhouette, particularly
> when fighters clinch or cross their guards. Adhering to IBA amateur standards solves this mechanically: the 10 cm solid white
> waistband is mandatory in amateur boxing precisely so judges can immediately register low blows below the belt line, and
> in-game it provides an instantaneous 360-degree break between the torso and the lower body.
> By dropping the trunks into a deep secondary value (maroon and midnight navy) while lifting the sleeveless singlets into
> vibrant, higher-luminance primary tones, we achieve three clean, stacked visual values: Bright Singlet -> Stark White
> Beltline -> Dark Trunks, bounded by the bare skin of the shoulders and legs. The 1.5 cm white neck/armhole piping creates
> crisp edge definitions against MetaHuman skin tones, and the 0.65 roughness map ensures overhead spotlights deliver a soft
> cloth roll-off rather than high-specular washouts that blow out your color-coding.

## Verdict (Claude, S299) - built
- Singlet, waistband, piping, trunks colours and roughness 0.65: taken as given. Singlet = MH_Top, waistband + piping = MH_Trim
  (baked in Tools/metahuman/mh4_glb.py, one face row of piping), colours set at runtime in FightStage.
- Gloves and boots kept. Trunks side stripe, glove knuckle strip and boot trim ring: not now (small at broadcast distance;
  revisit if the films say the stance does not read).
