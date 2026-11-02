# U60 / U60B — Judo & Brazilian Jiu-Jitsu: the real vocabulary

Task: `TASK_U60.md` then `TASK_U60B.md`. Schema: `TECHNIQUE_CATALOGUE_CONTRACT.md`
(sections 10–12 for combinations + grades).
Deliverable JSON: `U60_judo_bjj_nodes.json` (**not** merged into `technique_catalog.json`).

---

## U60B — GRADES AND COMBINATIONS

### Grades (contract §11)

Every node now has `grade` (art vocabulary) and `grade_rank` (1 = first taught).

| Art | Vocabulary | Source |
|---|---|---|
| **Judo** | `6th kyu` … `1st kyu`, then `1st dan` / `2nd dan` | **Kodokan Gokyo no Waza (1920)** teaching order for nage; Kodokan katame classification for pins/chokes/locks. Ukemi/kumi-kata at 6th kyu beneath all throws. |
| **BJJ** | `white belt`, `blue belt`, `purple belt`, `brown belt`, `black belt` (no stripes) | **Alliance-style teaching order (INFERENCE)** for when a move is taught; **IBJJF Rules Book (June 2024)** for legality-gated brown-belt material (heel hooks, slicers, kneebars, toe holds). No single IBJJF teach-list exists — NOT FOUND as a syllabus. |

`tier` stays (1–4) as the coarse simulation axis; it is derived from grade bands, not a substitute.

### Combinations (contract §§10, 12)

Branch `combinations` — each node lists **all** component technique ids in `prerequisites`; `grade_rank` is never below any component.

| Id | Components | Notes |
|---|---|---|
| `judo_renraku_osoto_ouchi` | osoto + ouchi | Classic renraku-waza |
| `judo_renraku_ouchi_osoto` | ouchi + osoto | Reverse direction |
| `judo_renraku_seoi_kouchi` | seoi + kouchi | Classic renraku-waza |
| `judo_renraku_kouchi_seoi` | kouchi + seoi | Reverse direction |
| `judo_renraku_deashi_osoto` | deashi + osoto | Foot sweep into major outer |
| `judo_renraku_harai_osoto` | harai-goshi + osoto | Hip into osoto |
| `judo_renraku_sasae_taiotoshi` | sasae + tai-otoshi | Posture break into hand throw |
| `judo_renraku_uchimata_ouchi` | uchimata + ouchi | Inner thigh feint |
| `judo_renzoku_osoto` | osoto-gari + osoto-otoshi + osoto-guruma | Renzoku (continuous) family |
| `judo_tomoe_chain` | tomoe-nage + juji-gatame | Existing; moved to `combinations` |
| `bjj_submission_chain` | armbar + triangle + omoplata | Existing; moved |
| `bjj_kimura_chain` | kimura + scissor sweep + armbar | Existing; moved |
| `bjj_chain_kimura_sweep_back` | kimura + hip-bump + back control | Kimura → sweep → back take |
| `bjj_chain_guillotine_mount` | guillotine + mount | Guillotine finish path |
| `bjj_back_take_rnc` | RNC + leg-drag pass | Existing; moved |
| `brazilian_jiu_jitsu_darce_chain` | D'Arce + Anaconda | Existing; moved |

**Counts after U60B:** 187 nodes, **16** combinations, **187** graded. Validator: `VALIDATION OK`, unread effects **0**, missing-grade warning **gone**.

### Unread effect remap (U60B)

Six keys the code never reads were remapped onto read keys (values kept; collisions take max):

| was (unread) | now (read) | Rationale |
|---|---|---|
| `balance_break` | `throw_setup` | Kuzushi is throw setup |
| `counter_ready` | `takedown_ready` | Grip-break opens a throw/takedown window |
| `opponent_stamina` | `pin_control` | Osaekomi pressure already scored as pin |
| `reaction_punish` | `submission_setup` | Chain punishes via setup pressure |
| `score_or_damage` | `throw_damage` | Counter ura-nage scores as throw damage |
| `surprise` | `submission_setup` | Gogoplata is an unusual submission setup |

**Deliberately kept:** none of the six — all remapped.

---

## FIX-UP (contract vocabulary)

Validator (`tools/validate_technique_nodes.py`) failed first delivery with **145 role
errors** — nodes used the live catalogue's older role list (`takedown`,
`submission`, `transition`, `escape`, `adaptation`, `counter`) instead of the
contract five: `damage` · `setup` · `defense` · `control` · `finish`. Also 5
nodes had `kind: sequence` (only `move`|`skill` are legal).

Remap applied in JSON (technique content unchanged):

| was | now | count |
|---|---|---:|
| takedown | damage | 69 |
| submission | finish | 48 |
| transition | control | 15 |
| escape | defense | 4 |
| adaptation | setup | 3 |
| counter | damage | 1 |
| kind sequence | move | 5 |

---

## NEW EFFECT KEYS

**None coined.** U60B remapped six unread keys onto existing read keys (see table above).

---

## Counts (this delivery)

| Set | Count | Status |
|---|---:|---|
| Judo nage-waza | **68** | DOCUMENTED — full Kodokan list |
| Judo katame-waza | **32** (10 + 12 + 10) | DOCUMENTED — matches operator breakdown |
| Judo extras (ukemi, kumi-kata, retained skills) | 6 | Existing catalog skills/sequences kept |
| BJJ technique nodes | **70** | See family line below |
| Combinations (judo renraku/renzoku + BJJ chains) | **16** | U60B — includes 5 relocated existing chains |
| **Total nodes in JSON** | **187** | 176 techniques kept + 11 new combo nodes |

Katame confirmation against Kodokan / IJF Academy Classification (1 Apr 2017):
**10 osaekomi-waza, 12 shime-waza, 10 kansetsu-waza = 32.** **Does not differ** from the operator's stated split.

Nage confirmation: **16 te + 10 koshi + 21 ashi + 5 ma-sutemi + 16 yoko-sutemi = 68.** DOCUMENTED on Kodokan Global and the IJF Academy PDF.

---

## Sources (labelled)

### Judo — DOCUMENTED
1. **Kodokan Global — Names of Judo Techniques** (`kdkjd.org` / `kdkjudo.org` technique-name list; PDF dated with the 1 Apr 2017 classification).
2. **IJF Academy — IJF/Kodokan Classification of Judo** (British Judo hosted PDF; terminology follows Kawamura & Daigo Kodokan dictionary; classification date **1 April 2017**).
3. **Gokyo no Waza (1920 revision)** — five groups of eight (40 throws) used as the teaching-order tier spine.

### BJJ — mixed
1. **Operator checklist** `U60_INPUT_BJJ_BELT_CHECKLIST.md` — **INFERENCE-grade** band skeleton (White→Blue / Blue→Purple / Purple→Brown / Black). Individual entries verified or rejected below.
2. **IBJJF Rules Book (June 2024 EN)** — **DOCUMENTED** legality table for heel hooks, reaping, slicers, kneebars, toe holds, wrist locks. Used for per-node `flags`, not for inventing technique names.
3. **No single federation syllabus owns BJJ.** Tier bands follow the operator checklist mapped to IBJJF adult competition maturity, cross-checked against common academy progressions (Gracie Barra / Alliance-style ordering is **INFERENCE**, stated as such). Where checklist and IBJJF disagree on *when* a move is legal, **IBJJF wins for flags**; checklist wins for *when it is taught* as a tier.

---

## Tier mapping

### Judo (Gokyo → tiers)
| Group | Tier | Rationale |
|---|---|---|
| Dai-ikkyo (1st kyo) | 1 Foundation | First teaching set |
| Dai-nikyo | 2 Core | Second teaching set |
| Dai-sankyo | 3 Advanced | Third teaching set |
| Dai-yonkyo | 3 Advanced | Fourth teaching set |
| Dai-gokyo | 4 Signature | Fifth teaching set |
| Shinmeisho-no-waza (recognised throws outside the 1920 Gokyo) | 4 Signature | Contract: shinmeisho as Signature |

Foundation skills `judo_ukemi` / `judo_kumikata` sit at tier 1 beneath all throws.

### BJJ (belt bands → tiers) — source named
| Band | Tier | Source |
|---|---|---|
| White → Blue | 1 Foundation | Operator checklist band (verified against common academy white-belt survival lists — INFERENCE on exact school) |
| Blue → Purple | 2 Core | Same |
| Purple → Brown | 3 Advanced | Same; checklist had merged purple/brown/black — **split here** |
| Brown → Black / black-belt systems | 4 Signature | Heel hooks, worm guard, berimbolo, slicers, chain mastery |

---

## Branches added

**Judo:** `te_waza`, `koshi_waza`, `ashi_waza`, `ma_sutemi_waza`, `yoko_sutemi_waza`, `osaekomi_waza`, `shime_waza`, `kansetsu_waza`, retained `ukemi_grips`, plus U60B `combinations`.

**BJJ:** existing `positions`, `escapes`, `sweeps`, `submissions`, `leg_locks`, `guard_retention`, plus added `guard`, `passing`, `takedowns`, plus U60B `combinations`.

---

## Shared judo ↔ BJJ ids (ONE id, not two)

These throws/holds are **one catalogue id** under judo, flagged `shared_disciplines: ["judo","brazilian_jiu_jitsu"]`. BJJ does **not** get a second spelling.

**Throws:** `judo_osotogari`, `judo_seoinage` (Ippon-seoi-nage), `judo_seoinage_twohand` (Seoi-nage), `judo_uchimata`, `judo_taiotoshi`, `judo_haraigoshi`, `judo_deashi`, `judo_ouchigari`, `judo_kouchigari`, `judo_morotegari`, `judo_kuchikitaoshi`, `judo_kibisugaeshi`, `judo_tomoenage`.

**Katame that BJJ also names:** `judo_kesagatame`, `judo_katagatame`, `judo_kamishihogatame`, `judo_yokoshihogatame`, `judo_tateshihogatame`, `judo_jujigatame`, `judo_udegarami`, `judo_sankaku`, `judo_hadakajime`, `judo_okurierijime`, `judo_namijujijime`, `judo_sodegurumajime`, plus sankaku-gatame.

BJJ nodes that *point at* a judo id without duplicating it: `bjj_armbar` → `judo_jujigatame`; `bjj_kimura` → `judo_udegarami`; `bjj_arm_triangle` → `judo_katagatame`; `bjj_ezekiel` → `judo_sodegurumajime`.

**BJJ-native takedowns only** (no judo twin): `bjj_guard_pull`, `bjj_arm_drag`, `bjj_ankle_pick`. Double-leg / single-leg competition entries map to shared `judo_morotegari` / `judo_kuchikitaoshi` rather than new `bjj_double_leg` ids.

---

## BJJ root-family line (where drawn, and why)

**Rule used:** one family = one primary mechanical goal (the finish or the control problem), not every named entry from every position.

Examples:
- Armbar from guard **and** mount → **one** family (`bjj_armbar`).
- Kimura / Americana → same ude-garami family; Americana kept as a named node only because the checklist and IBJJF discourse treat it as a distinct checkpoint, flagged as same family.
- Inside heel hook / outside heel hook → **one** family (`brazilian_jiu_jitsu_heel_hook`).
- X-guard and single-leg X → **one** guard family (`bjj_x_guard`).
- D'Arce and Anaconda → separate choke families (different underhooks) plus a retained chain sequence.

**Submission / control root families delivered ≈ 35** (chokes, joint locks, leg locks). The remaining BJJ nodes are **positional vocabulary, escapes, passes, sweeps, and retained sequences** that the input file explicitly said were missing — without them the syllabus has nowhere to hang the submissions. Concepts from the PDF ("32 Principles", "Teaching & Strategy") were **not** emitted as moves.

---

## Checklist verification (operator input)

| Checklist entry | Verdict |
|---|---|
| Shrimping / bridging / frames / seatbelt / posture | Kept as escapes + `bjj_posture_break` skill |
| Torreando, knee cut, scissor, hip bump | Kept |
| Double leg | **Shared** → `judo_morotegari` (no second id) |
| Armbar, kimura/americana, RNC | Kept; RNC split from sequence |
| De La Riva, X/SLX, half/deep half | Kept |
| Over-under / leg drag, berimbolo | Kept |
| Triangle, guillotine, straight ankle | Kept |
| Spider & worm | Kept, **`gi_only`** |
| Heel hooks, kneebars, toe holds | Kept with **IBJJF flags** |
| "32 Principles" / "Teaching & Strategy" / "Submission Chains" as concepts | **Rejected as moves**; chains kept only where already sequenced in catalog |

---

## Gi / ruleset flags (per node)

### Gi-only (representative)
Spider, worm, lasso; bow-and-arrow, cross-collar, clock, baseball-bat; most Kodokan lapel/sleeve shime-waza (`gi_only` on those shime nodes).

### IBJJF-restricted (flags on node)
| Technique | Flag |
|---|---|
| Wrist lock | `ibjjf_min_belt: blue` |
| Kneebar, toe hold, bicep slicer, calf slicer | `ibjjf_min_belt: brown` |
| Heel hook | `ibjjf_min_belt: brown` + `ibjjf_nogi_only` + `gi_illegal` |

### IJF competition-illegal (still in Kodokan list)
`judo_kanibasami`, `judo_kawazugake`, `judo_dojime`, `judo_ashigarami` — flagged `ijf_competition_illegal`. Present because the **vocabulary** includes them; the simulation must not score them under a judo ruleset without reading the flag.

`combat_rulesets.json` today has no per-technique illegal list — these flags are the hook for that matrix.

---

## Contradictions with the existing 18 / 20 nodes

1. **Template size** — existing 18 judo / 20 BJJ are a frame, not the art. Replaced by full vocabulary above.
2. **`judo_seoinage`** in catalog is named Ippon-seoi-nage — retained; canonical Seoi-nage added as `judo_seoinage_twohand`.
3. **`judo_uranage_counter`** kept as the old counter framing; canonical **Ura-nage** is `judo_uranage`.
4. **`bjj_guard_pass`** retargeted to Torreando (Foundation); knee-cut already had its own id.
5. **`brazilian_jiu_jitsu_darce_chain`** retained; D'Arce and Anaconda also exist as separate families.
6. Phases in contract (`standing` / `clinch` / `ground`) used for new nodes; existing catalog used finer phases (`ground_top` etc.) — merge layer should normalise.

---

## Prerequisite graph

Validated acyclic in the generator (`dag_ok: true`). Teaching order inside each Gokyo group is a chain; shinmeisho counters require the attack they counter; BJJ builds White survival → Blue systems → Purple/Brown legality-gated offense.

---

## NOT FOUND

- A single **official** IBJJF "belt technique syllabus" listing required techniques per belt — **NOT FOUND**. IBJJF publishes **illegal-by-belt** tables, not a teach-list. Tiering therefore uses the operator band + academy INFERENCE, with IBJJF for legality only.
- Exact Gracie Barra curriculum PDF was not in-repo; band alignment is INFERENCE against publicly described GB belt expectations, not a page citation.
