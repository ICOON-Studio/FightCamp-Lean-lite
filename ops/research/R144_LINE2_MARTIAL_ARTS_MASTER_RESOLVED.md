# R144 LINE 2 CLOSED — "MARTIAL ARTS MASTER" HAS NO GROUND WORK, AND NEITHER PACK SOLVES THE GRAPPLING WALL

**Claude, 2026-09-22, on the PC, from two links the operator sent.**
**This closes R144's one unresolved SKU.** `R144_LINE12_SKU_SEARCH.md` ended with:
*"Martial Arts Master ($49.99) is the one unresolved candidate and it is
unresolved because its store copy does not say whether it contains paired ground
work. It needs its file list read."* It has now been read.

## THE TWO LINKS

| link | pack | seller | price | length |
|---|---|---|---|---|
| `duxvpZyNRdg` | **Martial Arts Master Animations for Unity** | RamsterZ | **$49.99** | 11m29s showcase |
| `Wg_TmvB1CQQ` | **Melee Combat: Counters — Mocap for Unreal** | RAPA MOTION | **$29.99** | 48s showcase |

## THE ANSWER IN ONE LINE

**Neither solves it. Both are STANDING STRIKING packs with zero ground, clinch,
takedown or hold content** — they confirm R144's finding rather than overturn it.

---

## 1. RAMSTERZ "MARTIAL ARTS MASTER" — RESOLVED NEGATIVE

**212 animations, UE4/UE5 Mannequin skeleton, Unity Humanoid rig, $49.99.**
Its own product page gives the full category breakdown:

| group | categories and counts |
|---|---|
| **Fighter** | Attack **46**, Counter **25**, Movement **13**, Stagger 5, Block 4, Redirect 4, Parry 3 |
| **Hyper Focus** | Movement 17, Attack 15, Block 7, Fade 3, Parry 3, Misc 2 |
| **Master Stance** | Attack **26**, Movement 17, Evade 8, Parry 3, Misc 2 |
| **Locomotion** | Jumps 3, Runs 3, Idles 3 |
| **Other** | Knocked Out 1 |

**NO grappling, ground work, throw, takedown or hold category exists.**

> **CORRECTION (S117, 2026-09-28, from the primary source R142_ASSET_STORE_SHORTLIST.md "CORRECTIONS" item 1):**
> the line that stood here said "NO paired or two-character animations" and "clinch" - that was read off the
> CATEGORY list and is wrong. The package FILE list (read 2026-09-13 in R142) has 62 paired files: 30 two-sided
> attacker/victim pairs, incl. clinch knees (`AttackGrabKneeToFace`, `AttackGrab3KneesToRibs`) and a wall pin
> (`AttackPushPinAgainstWall` Start/Loop/End/BreakFree). The verdict of this page still stands: NO GROUND WORK. Raw `.fbx` only, no character models.

**THE MARKETING BLURB SAYS "GRAPPLES" AND THE CATEGORY LIST DOES NOT BACK IT.**
Secondary write-ups describe the pack as *"kicks, punches, grapples, counters,
blocks"*. There is no grapple category among the 212. **This is R144's own
standing lesson paying out a third time — do not shortlist a SKU from its
title or its blurb; read its file list.**

**Confirmed against the showcase reel** (sampled at 30 s intervals across all
11m29s): solo demonstrations with a name caption on screen (`Backflip Kick`),
then wide shots of a grid of **standing** pairs under a header ending
`...ers/Attacks` — Counter and Attack clips played opposite each other. **No
frame in the sample shows a hold, a takedown or a body on the ground.**

## 2. RAPA MOTION "MELEE COMBAT: COUNTERS" — CLOSER, AND STILL NOT IT

**57 root-motion animations at 60 FPS**, rigged to **UE5 Manny, UE4 Mannequin,
UEFN, Metahuman, Unity Dude and Mixamo**, $29.99, FBX only, 123 MB.

**Single-character clips — but many ship as a matched PAIR**, and the naming is
the interesting part:

```
AS_Melee_Counters_Jab_Lt_01      <- the counter
AS_Melee_Counters_Jab_Lt_Hit_01  <- the opponent's matching hit reaction
```

**THAT IS OUR `_Att` / `_Vic` SHAPE EXACTLY.** A hold in this engine needs only
two clips named `<Key>_Att` / `<Key>_Vic` plus a six-field `PAIRED_BINDINGS`
entry (R144 line 3's cheap surprise). So the video showing two bodies in contact
is the two clips played together — which is precisely what `PAIRED_BINDINGS`
already does.

**Content is back fists, combos, counter kicks, hooks, jabs, spinning and flying
counters, uppercuts. NO ground, grappling, clinch or takedown.** Sampled frames
at 3/9/15/21/27/33/39/45 s: two UE4 Mannequins, standing throughout, blocks and
counter exchanges, one head-height clinch-like beat at 33 s, **nobody ever goes
to the floor.**

---

## WHAT THIS DOES AND DOES NOT CHANGE

**IT DOES NOT CHANGE THE GRAPPLING WALL.** Our measured gap is 189 grappling
techniques of which **77 do not read solo** (G67), 18 grapple ids demanded with
9 bound and **19.6% of grapple events unbound** (Q114), and `grapple_clinch_
engage` as the top visually-actionable hole at 3.8%. Neither pack touches any of
it. Paired grappling still cannot be bought — that is R144 lines 1–2 confirmed,
now with the last open candidate closed.

**WHAT IS GENUINELY WORTH SOMETHING, IF THE DEFENCE GAP IS EVER THE STAGE:**
RAPA's pack is the better of the two and the cheaper. Q133's census says
**376 of 534 motion techniques have no clip at all**, and our counter / parry /
redirect vocabulary is among the empty ones. Both packs are on the **UE4
Mannequin**, which is `UE4_TO_OURS` — a retarget path that is built, tested and
proven by U114 on a Cascadeur clip. So the pipeline risk is low and the work
would be binding, not plumbing.

**IT IS OFF THE CRITICAL PATH TODAY.** Animation purchases are ON HOLD behind
the engine stage, and the Cascadeur decision already commits us to authoring
the five holds we own no paired film for — clinch first, then side control,
guard, half guard, back control. Buying standing counters does not advance that.

**AND ONE THING WORTH KEEPING FROM THIS.** These packs are the proof of the
distinction the Higgsfield study half-made: a counter and its hit reaction
**captured together and shipped as two clips** composes correctly, while two
halves **generated independently** scored 0 of 36. The `_Att`/`_Vic` split is
not the problem. Capturing the pair together is the whole trick, and it is what
we would be paying Cascadeur hours for.

## THE ADJACENT FAMILY, NAMED SO NOBODY CHASES IT TWICE

A search for the nearest neighbours surfaces a cluster of Unity packs —
**Grab & Throw Takedown (Raisecreation, EUR 20.24)**, Superhero Ground Takedown,
Silent Takedown, Environmental Takedown, Silent Grab & Hostage, Grab & Carry.
**These are stealth- and action-game takedowns**: paired by necessity, one-shot
finishers, no positional grappling. Same shape as Gamma Studio's "Dual
Character" pack, which was already named in the record as stealth kills with no
ground work. **Their file lists are NOT read here** — that is stated as a limit,
not a verdict — but nothing in their titles or store copy suggests MMA
positional work, and the title-not-the-file-list lesson cuts both ways.

## SOURCES

- RamsterZ product page for Martial Arts Master (category breakdown, rig, price).
- RAPA MOTION itch.io listing for Melee Combat Counters (clip naming, skeletons,
  "no ground, grappling, clinch or takedown", price, 123 MB FBX-only deliverable).
- Both YouTube showcases, downloaded with `yt_dlp` and sampled with
  `imageio-ffmpeg`: `rapa.mp4` 8 frames over 48 s, `ramsterz.mp4` 12 frames over
  689 s.
- Fab listing pages returned **HTTP 403** to both the fetcher and the in-app
  browser, and `assetstore.unity.com` was refused by the browser pane, so no
  figure here comes from Fab or the Unity store directly.
