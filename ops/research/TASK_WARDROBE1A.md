# TASK WARDROBE1A (S211) - dress the MetaHuman cast in the free clothes the operator claimed (pipeline proof, then the 19 $0-ready looks)

Model: Codex gpt-6.1-sol, reasoning high - the SAME Codex seat right AFTER MH5 (TASK_MH5_CAST_LOOK.md), same worktree/branch as MH5 so the
cast is exported ONCE with bodies (MH5) and clothes (this) together. Toolkit: AgentComms/CODEX_TOOLKIT.md.

## Operator rulings (verbatim)
- Q-S208-1: "we donot spend money on this" (clothing must be $0).
- Q-S209-1 (board, S211): "Claimed all 4" - on his Fab account, Personal licence: Crew Neck T-Shirt for MetaHuman (F8), Basic Sweatpants
  (F13), Pedro Perin Boxing Glove (N3), Epic MetaHuman Clothing Construction Presets (3c0c4df1).
- MetaHumans only, never MPFB/Tripo bodies (S207). No fat people, no "attractive women" overload in coaches, no chest fold (MH5, C41-C46).

## Prior research
research/J_CLOTHES3_S209.md (s5 = the 30-look plan with item codes N1/N2/F1-F34/K1-K12; s2 licences; s5 "Rules for staying at $0"),
J_CLOTHES2_S208.md s4 (UE Creator assembly + export cost), MH2_DIGEST.md + STAFF1_DIGEST.md + MH4 digest (UE 5.8.2 MetaHuman Creator ->
export -> Blender -> embedded GLB, 1024 px textures), M_WARDROBE / S207 s3 tint+decal system (shared Skeleton3D, skinned garments,
BoneAttachment3D for rigid items, per-instance tint via RGB masks, logo decal slot).
## What would a human do?
A character artist proves ONE look end to end (Creator outfit -> export -> Godot, on the game camera) before batching 19.
## Prefab check
Done by John (J_CLOTHES3): free Fab parametric outfits; no free boxing trunks/wraps/boots exist (those are WARDROBE1B, Blender-made).

## Do
0. S212 operator (verbatim): "https://www.fab.com/channels/metahuman?is_free=1&tags=outfit
   https://www.fab.com/channels/metahuman?is_free=1&tags=hairstyle have we checked this ?" - outfits YES (J_CLOTHES3, S209), HAIRSTYLES
   NO. Re-read both free listings through Fab's public JSON (`/i/listings/search`, as J_CLOTHES3 did; web search is on) and write a table
   into your digest: every free MetaHuman OUTFIT not already in J_CLOTHES3 s5, and every free MetaHuman HAIRSTYLE (title, uid, price
   Personal/Professional, licence group, NoAI flag, male/female/any, strands groom or hair cards). Hair reaches Godot only as hair CARDS or
   a mesh (MH4 exported grooms that way) - say per hairstyle whether it ships cards/LODs. Pick the hairstyles that would give the cast more
   variety (MH4 cast_audit: unique groom per model); list the ones the operator must CLAIM on his Fab account in AgentComms/messages for
   Claude (he claims, never you). Use the ones already free in MetaHuman Creator first.
1. Get the claimed + free items into UE 5.8 (`C:\Program Files\Epic Games\UE_5.8`): Fab plugin inside the editor (Window > Fab, "My
   Library") or the Epic Launcher library "Add to project". If any login / licence / EULA prompt appears: STOP that step, write the exact
   prompt into your digest and AgentComms/messages for Claude (the operator signs in himself) - never click accept on his behalf.
2. PROOF (3 looks, J_CLOTHES3 s5): CO1 coach club tee (N2 tucked tee + F12 cargo + F20 running shoes), ME3 female member (F3 crop top +
   F17 shorts + F20), ST4 front desk (F7 blouse + F16 carpenter + F27 flats) on three DIFFERENT MH5 bodies. Export through the MH4
   pipeline to GLB (garments skinned to the shared MetaHuman skeleton; animation-only clips must still drive them). Godot stills of all
   three on the GYM camera in the game (club floor) AND walking (UAL walk clip) - open every still; cloth must not explode, clip
   through the body at the hips/armpits, or hide under the skin. GLB size budget: keep each look <= the MH4 body GLB + 25%.
3. Then the other $0-ready looks of s5 (19 total), tint/decal variants per role (club colour + logo decal for coaches/staff).
4. Boxers in the ring keep bare torso + their current trunks until WARDROBE1B (Blender trunks/wraps) - do not touch the fight kit.
5. `CREDITS_CC_BY.md` at repo root for any CC-BY item used (author, title, URL). Never feed NoAI items or their renders to AI tools.
6. Digest `research/WARDROBE1A_DIGEST.md` (look table: look id, body, items, GLB size, still path), commit + push your branch.

## Owned files
Cast GLBs + their import settings under the MH4/MH5 cast folder, the cast manifest MH5 owns, `Tools/metahuman/*` export scripts (or wherever
MH4 put them), `previews/wardrobe1a/`, `CREDITS_CC_BY.md`, the digest. Not FightStagePlayer/GameState/FightRealtime.

## The one trap
Parametric MetaHuman outfits resize in Creator but their export can drop or mis-weight helper joints (MHNATIVE1 found 341 joints, many
helper/corrective). Check the garment moves with the body in a WALK still, not just a rest pose - a rest-pose still hides every weight bug.
