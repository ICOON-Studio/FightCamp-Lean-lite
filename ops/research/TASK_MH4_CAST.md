# TASK MH4 - a big, varied, FIT MetaHuman cast: redo the 4 staff + many more people (S207)
Model: gpt-6.1-sol (Codex). Worktree E:\FightCamp\wt\MH4, branch codex/mh4-cast. Long task - work in batches, commit after each
batch, keep going (no run limit).

## Operator (S207, verbatim)
"stop making fat people , redo all the staf and make way more of them we need variety" / "i do not want to see mbfb model anywhere
again". MetaHumans are the ONLY bodies the game will ship (fighters, staff, members, customers).

## The pipeline you already built (reuse it - read first)
Tools/metahuman/ (mh2_run.py / mh2_build.py / staff1_run.py, staff1_finish.py, staff1_audit.py, bl_build_glb*.py), digests
research/MH2_DIGEST.md and STAFF1_DIGEST.md (UE 5.8.2 MetaHuman Creator -> export -> Blender -> embedded GLB, 1024 px
textures, the 4K/8K garment freeze trap, guarded launches). One UE and one Godot of this task at a time; watchdog before each.

## Body rule (the operator's "no fat people")
Every body is FIT. Adults: lean/athletic Creator body settings; BMI 20-26 for staff and members, waist <= 0.50 x height for men and
<= 0.47 x height for women; no visible belly. Boxers: lean-muscular for their weight class (fly to heavy), waist <= 0.48 x height.
Older people (coach 50-60) stay fit too - grey hair and face age, not weight. Record height/weight/waist per character in an audit JSON
and FAIL your own audit if any body breaks the rule.

## The cast (batch 1 = 24 people; more after the operator sees it)
- REDO the 4 staff (coach, desk clerk, physio, trainer) fit, replacing mh_staff_*.glb in place (same file names).
- Staff, new: 2 more coaches (one woman), 1 cutman, 1 more desk clerk (man), 1 cleaner, 1 more physio (man).
- Boxers: 12 total = the 4 existing mh_boxer_01-04 (keep if fit, rebuild any that breaks the body rule) + 8 new: 5 men + 3 women,
  spread over weight classes fly/bantam/light/welter/middle/light-heavy/heavy, different faces, skin tones, hair, ages 19-34.
- Members/customers: 4 (2 men, 2 women; mixed ages 18-45; fit).
VARIETY RULE: no two characters share the same face preset, and no two share the same groom + skin tone; spread ethnicities
(European, African, East Asian, South Asian, Latin, Middle Eastern) across the cast; at least 40% women outside the male-boxer rows.
Clothing: only Creator's default garment is installed - use it with DIFFERENT colours per role (palette below) until the wardrobe task
(WARDROBE1) brings real clothes; boxers in trunks as MH2 did. Palette (Maria S206): coach navy #23324a + cream #efe4cf; staff black
#22201f; physio white #f2f2ee; members grey-blue #7d8a99 / dark #3a4048; boxers one strong colour each.

## Deliver per batch
- GLBs in Godot/assets/models/metahuman/ (mh_boxer_05.., mh_staff_<role>_<n>.glb, mh_member_<n>.glb) + per-model JSON (preset, groom,
  height, weight, waist, BMI, bytes) + previews/mh4/cast_audit.json.
- Lineup stills with `Godot/tools/mh_lineup.gd` (extend it to take any list of names via `names=a,b,c`; head to feet; front view;
  6 per image) -> previews/mh4/lineup_<n>.png. Open every lineup yourself; fix bodies that look heavy or alike.
- Do NOT post anything to the review board; Claude does.

## Owned files
- `Tools/metahuman/` (new configs/scripts for MH4)
- `Godot/assets/models/metahuman/` (new + rebuilt GLBs and their JSON/textures)
- `Godot/tools/mh_lineup.gd`
- `previews/mh4/` (NEW)
- `research/MH4_DIGEST.md` (NEW)

## Acceptance
cast_audit.json: every character passes the body rule and the variety rule (print both checks); lineup PNGs for all; existing
staff tests still green: `python Godot/tools/run_tests.py --jobs 1 --only staff,metahuman,mh2` (nothing green goes red).
Commit + push after every batch of ~6; print the audit table at the end.

## Prior research
MH1/MH2/MH3/STAFF1 digests, M_STYLE_SHEET_S206.md, GYM_LOOK_METAHUMAN_S207.md.
## What would a human do?
A character artist makes a varied cast in MetaHuman Creator from presets, checks the line-up side by side, exports in batches.
## Prefab check
MetaHuman Creator (free with UE, installed) is the tool; Fab MetaHuman presets are the source of variety.
## The one trap
Garment compile at 4K/8K froze the PC in MH1 - keep the startup texture cap override the STAFF1 run used.
