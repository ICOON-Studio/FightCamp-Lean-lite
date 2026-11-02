# TASK MALE1 - CLAUDE (+ John, Kalli) - men's boxing in the gym: a male boxer the player can sign, train and fight

Status: OPEN (S370, Claude). Operator S370: "i want your playthroughs to have 2 fighters. male fighter , female bjj
fighter". The game is women-only today (four women's divisions, 14 female MetaHuman boxers, no sex field, "she/her" in
the text) - a restart default, never a board decision. Memory feedback-playthrough-two-fighters-s370.

## Parts and owners
1. JOHN (J_MEN1): England Boxing senior men's weight classes and bout rules (rounds x minutes), real heights/reaches
   by class if sourced. No class enters the game without a source.
2. KALLI (K_MEN1): the men's opponents per division (3 + a mismatch, the S341 format: name, first, club = a real UK
   amateur club, age, stance, style, threat, weak, w/l, rating) + DIVISION_RIVALS lines for the World pages.
3. CLAUDE, code: f["sex"] ("f"/"m", old saves read "f"); Data.DIVISIONS gain men's classes (from J_MEN1) with their
   opponents (K_MEN1); a fighter books only in her/his own sex's divisions; the walk-in and the scouting pool can be men;
   one pronoun helper (Words.pron(f, "she"/"her"/"hers")) and a pass over every on-screen she/her (grep, file by file,
   tests that read words updated); Faces/bodies picked by sex; tale of the tape/HUD unchanged.
4. CLAUDE, bodies: 4-6 male MetaHuman boxers through the S332 Unreal pipeline (ops/Tools/metahuman, ~4 min each in UE,
   only on a GREEN PC with Chrome/Brave closed - the S332 commit-memory trap), ring photos + headshots baked.
5. CLAUDE, the male holo: ALREADY OWNED - the S353 pack (CGTrader #6489289 "Musclenames Male & Female", E:/FightCamp/
   licensed/ecorche_aaaxis, never in a repo) holds BOTH figures in one mesh (602k verts); S353 baked the female half.
   Separate the male figure in Blender (loose parts / its half), render it with tools/holo_render_blender.py, bake with
   tools/bake_holo_figure.py into assets/ui/body/holo_m*, and pick holo by f["sex"].
6. The guide tour and every playtest: a male boxer + Ana (BJJ) from the first week (tools/guide_tour.gd).

## Acceptance
A quick-start career signs a male boxer at the walk-in (or through Scouting), trains him (his week, his award road),
books him a men's bout, and the 3D fight shows two men; Ana trains and rolls in the same career; no "she/her" on a man's
screens; golden_path + save_load + every words test green; the guide GIF follows both.

## Contract
OWNS: scripts/state/Data.gd, scripts/rules/Words.gd, scripts/rules/Faces.gd, scripts/rules/Recruit.gd, tools/guide_tour.gd, tests/male_boxer_test.gd
RED_TEST: tests/male_boxer_test.gd -> MALE_BOXER failures=0
REGRESSION: golden_path_test, save_load_test, fight_words_contract_test, faces_test
VISUAL: yes
