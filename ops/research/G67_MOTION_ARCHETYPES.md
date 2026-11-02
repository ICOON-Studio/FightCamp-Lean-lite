# G67 — THE MOTION ARCHETYPE MAP, AND THE PROMPT FOR EACH ONE

**Agent:** Grok (grok.com, Expert). **Landed by Claude, S48, 2026-09-22.**
**Worked:** 3m 41s. Delivered in chat, transcribed here.

**THE THREE LINES IT LED WITH:** 120 archetypes. **77 of 189 grappling
techniques DO NOT read solo.** Least sure: sacrifice throws (tomoe / sumi /
yoko) — even with a coach-demo convention they often read as a man falling down.

Labels: DOCUMENTED = catalogue / prior research. INFERENCE = rule applied to
nodes not listed. NEW = this map / these prompts.

**Its inputs, DOCUMENTED:** `technique_catalog.json` v6 — 696 nodes, 15
disciplines, `skill` 162, `move` 452, `sequence` 82 → 534 want motion. Grapple
move+seq: judo 111 + BJJ 51 + wrestling 13 + sambo 14 = **189**. Higgsfield is
single-actor; paired jobs returned one body 8/8. Contract §9: same noun ≠ same
motion (mawashi ≠ MT round; jab ≠ kizami). J17: slice by type, height is a
modifier. Sequences are multi-beat and this generator already froze on those.

---

## 1. THE ARCHETYPE SET — 120

Count after each id is techniques served. Counts are INFERENCE from names and
branches, not a per-node bind table.

**Punches / hands — 18.** `jab_box` 8 · `cross_box` 7 · `hook_L` 10 / `hook_R`
10 (incl. body hook) · `upper_L` 6 / `upper_R` 6 · `overhand_R` 4 ·
`check_hook_L` 3 (pivot off the incoming line; not a stationary hook) ·
`hammer_dn` 4 · `clinch_short_hook` 5 · `kizami` 3 / `gyaku` 4 / `oi_zuki` 3
(karate — different chamber and step from boxing; contract forbids the merge) ·
`ura_zuki` 2 / `kagi_zuki` 2 / `age_zuki` 3 · `shuto_uchi` 8 / `uraken` 5
(path, not fist-shape).

**Elbows — 9.** `empi_age` `empi_yoko` `empi_ushiro` `empi_otoshi`
`empi_mawashi` (karate, ~2 each) · `mt_elbow_H_L` `mt_elbow_H_R` `mt_elbow_dn`
`mt_elbow_spin` (MT/sanda/silat — swing-through, not karate snap).

**Knees — 4.** `knee_long` 8 / `knee_clinch` 10 / `knee_switch` 3 / `knee_fly` 3.

**Kicks — 22.** `teep` 6 · `mae_keage` 5 / `mae_kekomi` 4 (snap vs thrust; not a
teep) · `mawashi_karate_R` 6 / `_L` 4 (snap, retract) · `mt_round_R` 8 / `_L` 5
(shin through, no retract) · `mt_low_R` 6 / `_L` 4 (chopping posture, not a high
kick aimed down) · `yoko_keage` 3 / `yoko_kekomi` 4 · `tkd_side` 3 (TKD
chamber/hop — check before merging with yoko) · `chasse_lat` 3 (savate piston) ·
`ushiro` 4 / `spin_hook` 5 / `spin_back` 4 · `axe` 3 / `mikazuki` 3 /
`ura_mawashi` 3 · `cap_armada` 4 / `cap_martelo` 3 / `cap_bencao` 2 (ginga
origin, not karate spins) · `oblique` 3.

**Evade / block — 12.** `slip_L` `slip_R` `pull` `roll` `parry` `cover` (~15
nodes) · `shin_check` 6 / `catch_kick` 5 · `age_uke` `gedan_barai` `soto_uke`
`uchi_uke` (~20 nodes on 4 paths).

**Footwork — 5.** `step_in` `step_out` `pivot` `lateral` `level_change` (~20).

**Shots / takedown entries — 8.** `shot_single` `shot_double` `shot_blast`
`high_crotch` `ankle_pick` `duck_under` `snapdown` `sprawl` (~25 nodes).
Double-leg is ONE id across arts, per contract §9.

**Throws (coach-demo) — 22.** Do not merge across Kodokan classes. Gaeshi
counters that reverse the same entry stay on the parent — timing, not a new
path. *Ashi:* osoto, ouchi, kouchi, kosoto, deashi, sasae, hiza_guruma,
ashi_guruma. *Koshi:* ogoshi, harai_goshi, uchi_mata, koshi_guruma,
tsurikomigoshi. *Te:* ippon_seoi, morote_seoi, tai_otoshi, kata_guruma.
*Sutemi:* tomoe, sumi_gaeshi, ura_nage, tani_otoshi, soto_makikomi. Serves judo
nage (~69), sambo hip/trip, sanda throws, pencak sapuan, karate nage (~9).
**Suplex keeps its own id when the lift-back-bridge arch is visible; ashi-guruma
shares the wheel with o-guruma and takes one clip.**

**Ground solo — 6.** `shrimp` `bridge_upa` `tech_stand` `sitout` `granby`
`wall_walk` (~8).

**Ground convention — 6.** `pass_torreando` `pass_knee_cut` `sweep_scissor`
`sweep_hip_bump` `guard_pull` `arm_drag` (~15).

**Weapons — 4.** `stick_fore` `stick_back` `stick_thrust` `stick_roof` (arnis
~13). Empty-hand arnis reuses punch/elbow archetypes.

**Misc — 4.** `upkick` 2 · `gnp_elbow` 3 · `kick_catch_entry` 3 ·
`stance_settle` 8 (a short 1.2 s return-to-guard, usable as a hover fallback).

---

## 2. THE LINE THAT MUST NOT BE CROSSED

**The rule, applicable to nodes neither of us listed:** a new clip is required
**iff a competent practitioner watching a 2-second hover would say "that is the
wrong technique."** Tested in this order:

1. **Tool changes** (fist / shin / instep / heel / elbow / knee / stick) →
   SPLIT. DOCUMENTED: contact surface is how the arts distinguish.
2. **Path changes** (straight / hook / rise / drop / spin / reap /
   load-on-hips / sacrifice) → SPLIT.
3. **Chamber + recovery change even when the noun matches** (kizami ≠ jab,
   mawashi ≠ MT round, keage ≠ kekomi, TKD side ≠ yoko kekomi) → SPLIT.
   DOCUMENTED contract §9.
4. **Limb / side** (lead ≠ rear) → SPLIT. A mirror is a southpaw of the *same*
   limb, not the other hand.
5. **Height only** (head vs body on the same punch path) → DO NOT SPLIT. Lean +
   IK. *Exception:* MT low kick vs mid/high round — posture and swing change.
6. **Fist shape only** (nukite, ippon-ken, hiraken, nakadaka) → DO NOT SPLIT.
   Use a still of the hand.
7. **Power / speed / reach** → DO NOT SPLIT. Playback scale ±15% and step-in.
8. **Sequence / renraku / combo node** → DO NOT GENERATE. Stitch components.
9. **`kind: skill`** → no clip.
10. **Contact IS the technique** (choke wrap, joint break, pin chest-to-chest)
    → no solo clip. See §4.

---

## 3. THE PROMPT, PER ARCHETYPE

**Shared wrapper — paste around every action clause.** NEW, built on the
operator's 2026-09-14 recipe.

> Single adult fighter, one body only, empty gym canvas, no opponent visible.
> Locked camera, three-quarter front, full body head-to-feet, no cut, no orbit.
> Start in **[STANCE]**. **[ACTION]**. Invisible target at **[POINT]**; weight
> and hips treat the target as solid. Trail foot planted until weight shifts.
> Guard returns. End in the same **[STANCE]**, same mark on the floor. Root
> motion on the hips, not the mesh. One action only. No combo. No second beat.

| Stance token | Use |
|---|---|
| `orthodox_mma` | boxing/KB/MMA punches, most kicks |
| `southpaw_mma` | only when the other lead is AUTHORED, not a mirror |
| `muay_open` | teep, MT round, knees, elbows |
| `zenkutsu` | karate zuki/geri/uke/uchi |
| `ginga` | capoeira only |
| `wrestle_square` | shots, sprawl, duck-under |
| `kumikata_air` | judo/sambo throws (sleeve-lapel mime) |
| `ground_hip` | shrimp / bridge |
| `stick_medio` | arnis |

**Durations:** punches/elbows/uke 2.0 s · kicks 2.4 s · knees 2.0 s · footwork
1.6 s · shots/sprawl 2.8 s · throws 3.2 s · ground solo 2.8 s · pass/sweep mime
3.0 s · stick 2.0 s · flying/spin 3.0 s. **No loops except `stance_settle`
1.2 s.**

Representative action clauses (the full set is in the Grok thread): `jab_box` —
sharp lead jab to face-height, snap back. `mt_round_R/L` — shin through the
mid-line, no retract, plant. `mt_low_R/L` — low round to an invisible lead
thigh, chop, posture drops. `shin_check` — lift shin into an incoming low kick
that is not shown. `catch_kick` — catch an invisible incoming leg at the belly,
hold one beat. `shot_single/double/blast` — penetration into invisible legs at
waist/ankle; **end driving through, not standing idle**. `sprawl` — hips down,
legs back, chest heavy on an invisible shot. **Throws** — from `kumikata_air`:
kuzushi then the named throw against an implied uke; **finish in a balanced
post-throw stance, not lying on a partner**. `pass_torreando`/`pass_knee_cut` —
walk around an implied guard on the floor. `gnp_elbow` — postured on shins, ONE
downward elbow into a floor-level target, not a loop. `kick_catch_entry` —
catch then step in, **stop before the slam** (the slam is contact).

---

## 4. THE GRAPPLING PROBLEM — 189, AND THIS IS THE ANSWER THAT SPENDS THE MONEY

| Bucket | Count | What |
|---|---|---|
| **READS SOLO** | **16** | The motion IS the technique. |
| **READS SOLO ONLY WITH A CONVENTION** | **96** | Coach-demo against an implied uke. |
| **DOES NOT READ SOLO** | **77** | The technique IS the contact. **Do not spend credits.** |

16 + 96 + 77 = 189.

**READS SOLO (16).** Wrestling: sprawl, duck_under, scramble_reversal. BJJ:
shrimp_escape, bridge_escape, guard_pull. Plus sit-out / granby-class scramble
and technical stand where authored as an escape. *Judo ukemi is `kind: skill`
and therefore not in the 189. Sambo: none clean.*

**CONVENTION (96).** State it on the card: **"coach demonstrating on air;
implied partner at grip range."** Hands hold a sleeve and lapel that are not
there. **Finish standing or on a knee, never hugging the floor as if mounted on
a body.** All judo nage (ashi 21 + te 16 + koshi 10 + ma-sutemi 6 + yoko-sutemi
16 = 69) · wrestling shots + suplex + mat_return + snapdown + chain_wrestle (9)
· sambo trips/hip/arm-drag/front-trip/counter-hip/jab-bodylock + the rolling
kneebar ENTRY ROLL only (8) · BJJ passes, sweeps (not berimbolo), arm-drag,
ankle-pick, frame-escape, back-escape (10).

**DOES NOT READ SOLO (77).** A solo clip here is a man hugging himself or
kicking the air. Judo osaekomi 10 · judo shime 12 · judo kansetsu 10 · judo
renraku/renzoku 10 (two throws — generator plus contact) · BJJ submissions +
berimbolo + submission chains ~19 (armbar, kimura, omoplata, triangle, RNC,
americana, guillotine, arm-triangle, darce, anaconda, ankle lock, heel hook and
the chains) · wrestling gut_wrench 1 · sambo straight ankle, kneebar, bent
kneebar, footlock-pass, throw-to-leglock and strike-bodylock chains ~6.

---

## 5. WHAT IT WOULD NOT GENERATE AT ALL

All **162** `skill` nodes (hover shows the node schematic) · all **82**
`sequence` nodes (stitch components) · **the 77 no-read grapples** (hover shows
a diagram or a two-body still — *"credits spent here look fake, the exact
complaint already collected"*) · fist-shape aliases (a still of the fist) ·
stance-only karate (22 stance skills) · head-vs-body duplicates of an
already-generated punch · southpaw duplicates (mirror) · reach/power variants ·
arnis double-weapon sequences · pins and control poses that do not move.

**CREDIT ORDER, NEW:** generate the **18 punches + 22 kicks + 9 elbows + 4 knees
+ 12 defence + 8 shots + sprawl + 6 ground solo** first — *"that covers what a
hover on the striking tree must not fake."* **Throws (22) only after those, and
only as coach-demo, labelled as such in the UI. Do not buy the 77.**

**And bind before you generate:** the 15 already wired and the ~125 on disk come
first, so no credit is spent duplicating an archetype we own.

---

## Claude's integration note

**This answers the concern raised when the operator released the credits:** a
solo armbar reads as miming. G67 puts a number on it — **77 of 189** — and
names them by family rather than hand-waving. At 0.1 credit a job, its
first-wave list (~80 archetypes) costs about **8 credits of 923.9**, so the
budget was never the constraint; knowing what NOT to buy was.

**J39 (John) is answering the same question from the research side, blind to
this**, on what published instructors actually do when demonstrating solo. When
both are in, compare the DOES-NOT-READ lists before spending anything. Where
they agree, the contact solver's solved two-body pose is the honest fallback.

**One wobble worth flagging:** §1's throw count visibly argues with itself
mid-list over whether suplex or ashi_guruma holds the 22nd slot. It resolves
(suplex keeps its id, ashi-guruma merges with o-guruma), but the count is
approximate and the task said counts are INFERENCE. Treat 120 as "about 120".
