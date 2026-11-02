# R140 — THE JUDO PACK, PRICED AND AUDITED FROM THE LISTING

**Collected by Claude from the store, the FAB mirror and the preview video,
2026-09-12.** This supersedes TASK_J25, which was written to ask John the same
questions and is no longer needed — the operator handed over the store search
and the answers were all reachable directly.

**Why it matters:** the operator ruled judo playable *conditional on realistic
grappling execution*. R139 gave the grapple path a vocabulary; the remaining
blocker for judo specifically is that **we own zero standing throws**. Our paired
pack is `Full Mount Attacks` — 16 moves, 12 usable, every one from full mount or
a bodylock/double-leg entry.

---

## THE CANDIDATE

**Judo AnimSet — wemakethegame — €110.40 on the Unity Asset Store**

| | |
|---|---|
| **Contents** | **47 anims + 9 poses** |
| **Paired** | **DOCUMENTED.** FAB listing: *"This asset consists of an attacker(atk) and a victim(hit)."* |
| **Throws** | **8 paired** — `Setmotion01_atk`/`_hit` … `Setmotion08_atk`/`_hit` |
| **Rig** | *"Humanoid version included"* — retargets to our 22-bone map |
| **Extras** | Root motion **and** in-place, T-pose included |
| **Licence (Unity)** | **Standard Unity Asset Store EULA** |
| Size / version | 91.7 MB · v1.13 · Nov 2024 · Unity 2020.3.12 |
| Ratings | None yet ("not enough ratings"), 13 views/week |

### The utility clips are not filler and we would otherwise have to buy them

`fall_01`, `fall_02`, `fall_03` (breakfalls), `rise_01`, `rise_02`, `rise_03`
(recoveries), `roll_f_01`, `roll_f_02`, `dodge_left`, `dodge_right`, `down01`,
`grab`, `idle`, `jump`, plus 16 movement clips. **Judo needs ukemi as much as it
needs throws**, and we own none.

---

## BUY IT ON UNITY, NOT ON FAB — AND THE REASON IS THE STANDING RULE AGAIN

| | Unity Asset Store | FAB (Epic) |
|---|---|---|
| price | **€110.40** | €123.06 – €307.69 |
| licence | Standard Unity Asset Store EULA | **"Allows usage with AI: No"** |

**FAB is more expensive AND carries an explicit AI prohibition the Unity EULA
does not.** This is the identical trap R105 addendum 2 found with RamsterZ, where
buying the direct FBX would have bought the same 32 clips under a strictly worse
licence. The rule holds a second time, on a different publisher: **buy on the
Unity store, never the alternative storefront.**

(Our standing constraint applies here too: never pass one of these clips to Ludo
or any generator as reference, seed or input. Play, retarget and edit freely.)

---

## THE ONE THING NOT PUBLISHED: WHICH EIGHT THROWS

**The publisher never names them.** Not in the Unity listing, not on FAB, not in
the preview video's on-screen overlay, and not in the UE editor asset list the
video walks through. They are `Setmotion01`–`08` everywhere.

Watching the preview at full resolution places **three by FAMILY, not by name**:

- **`Setmotion_06`** — tori turns his back in, uke drawn onto his back →
  **seoi-nage / koshi-guruma family**
- one throw with uke **fully inverted overhead** → **kata-guruma / te-guruma family**
- one with uke **horizontal across tori's hip** → **o-goshi / harai-goshi /
  uchi-mata family**

They are genuine standing judo, full amplitude, with uke taking real breakfalls.

**NO FURTHER NAMES ARE RECORDED HERE, DELIBERATELY.** Identifying a specific
gokyo throw from preview frames would be a guess, and a guess written down
becomes a fact three sessions later. This project spent 2026-09-12 retracting
exactly that class of claim.

---

## AND WE DO NOT NEED THEM — THE BINDING IS WATCHED, NOT TRUSTED

**Operator ruling: do not email the publisher; we identify the moves ourselves.**
That is the better method regardless, because we bind clips to OUR catalogue ids,
not to the publisher's labels.

The procedure, once bought:

1. Buy on Unity, pull via Package Manager, **extract WITHOUT importing** and
   audit from the files — the procedure that already worked for both RamsterZ
   packs.
2. Retarget onto f01 through the existing BoneMap. The listing says Humanoid, so
   this should be the same path; verify, do not assume.
3. **Open `FightAnimLab` and watch all eight.**
   `Godot_v4.7.2-stable_win64.exe --path Godot res://scenes/FightAnimLab.tscn`
4. Bind each `Setmotion0N` to the judo catalogue id it actually looks like.

**STEP 3 IS NOT OPTIONAL AND R127 IS WHY.** Three technique bindings were the
wrong move — both "uppercuts" rendered as a knee lift and a turn away — and were
justified in-file by sentences like *"a spinning elbow IS a horizontal elbow"*.
They were never watched. The operator broke four bindings in that lab in under a
minute. A binding asserted from a filename is worth nothing.

---

## WHAT THIS LEAVES

- **Karate, taekwondo** — the operator's condition is already met (R138).
- **Wrestling, MMA takedowns** — bodylock and double-leg are what we own.
- **BJJ** — mount finishes owned; guard passes, sweeps and back-takes not.
- **Judo** — **one €110.40 purchase from being possible**, plus R139 level 2
  (influence) and level 3 (position truth) for the "realistic execution" half.

**TASK_J25 is superseded and should not be sent.** John's queue still holds J23
(unanswered) and J24 (written, unsent).


---

# R140b - ALL SEVEN "JUDO" RESULTS, EVALUATED

The operator asked for every asset the Unity search returns for `judo`. Both our
screens agree: **Results 1-7 of 7.** Every one is below with a verdict.

**Two of them solve gaps that are NOT judo, and one is the cheapest real win on
the board.**

| # | asset | price | verdict |
|---|---|---:|---|
| 1 | **Judo AnimSet** (wemakethegame) | EUR 110.40 | **BUY - for judo.** 8 paired throws + ukemi. The only paired standing throws here. |
| 2 | **Melee Counters - Motion Capture** (Rapa XR) | **EUR 27.59** | **BEST VALUE.** 57 root-motion counters, **rigged to UE4 Mannequin** - our exact rig. |
| 3 | **20 Fighters - Boxer, Karateka, Judoka** (Mixall) | EUR 36.79 | **FILLS R111's GI GAP.** Judoka, Karateka and Kickboxer bodies. |
| 4 | **Wrestling Finisher Animset** (wemakethegame) | EUR 110.40 | **Maybe.** 12 paired finishers, but we already own bodylock + double-leg. |
| 5 | AA_Olympics_Sports (activeanimation) | EUR 18.39 | **REJECT for judo** - see below. |
| 6 | 9t5 Low Poly Sports | EUR 4.59 | **REJECT.** Low-poly stylised; wrong visual bar. |
| 7 | Martial Arts ... Dojo Training Icons Pack | EUR 14.71 | **REJECT.** 2D icons, 130 assets. |

## 2. MELEE COUNTERS - EUR 27.59, AND IT LANDS ON THE OPERATOR'S OWN ASK

- **57 high-quality root-motion animations, 60 FPS.**
- **Rigged to UE4 Mannequin, Metahuman and Manny.** Both RamsterZ packs are UE4
  Mannequin and **one BoneMap already serves them** - so this is the retarget
  path we have already proven, not a new one.
- **It ships attacker AND receiver:** every counter has a `_Hit` companion
  (`Counter_Kick_Front_01` / `Counter_Kick_Front_Hit_01`). The same pairing idea
  as `_atk`/`_hit` and `_Att`/`_Vic`.
- Content: back-fist, hook, counter-combo and front/side kick counters, both sides.

**Why it matters beyond its price.** R130 group 1 is **counter/intercept - 9 tags
on 40 techniques, the largest unread mechanic** - and the operator's own words
were that a takedown should be contested by *"counters, like knees or dodge"*.
Today `stop_hit` sits on ten techniques and nothing can strike a man as he
shoots. If that layer gets built, **this is the film for it**, at a quarter the
price of the judo pack and on a rig we have already solved.

## 3. 20 FIGHTERS - EUR 36.79, AND IT CLOSES A GAP R111 WROTE DOWN

20 rigged Mecanim characters, **no animations** - we have animations, we lack
bodies: `BJJ_1, Boxer_1-4, Judoka_1, Karateka_1, Kickboxer_1, Kudoist_1-2,
KungFu_Master_1-2, MMA_fighter_1-2, Sambo_wrestler_1, Shaolin_monk,
Sumo_wrestler_1, Thai_boxer_1, Wrestler_1-2`.

R111, on the boot screen, verbatim: *"The operator asked for four figures: boxer,
MMA, karate in a white gi with a black belt, and a kickboxer. Three stand there
and only two mean anything... A gi is geometry, not a texture, and we own no gi
model."* This pack has the karateka in a gi, the judoka in a gi, and the
kickboxer - **the exact three figures that screen could not render** - and adding
one is already just an entry in `BootStage3D.FIGURES`.

**Flagged rather than hidden:** *"single-mesh and may not always be suitable for
close-ups"* (the same limitation our Tripo fighters have), "low poly mesh grid",
and a disclosure that **AI was used for the textures and a model blank**. That
does not breach our constraint - ours forbids feeding OUR clips to a generator -
but the operator should see it, and it bears on quality.

## 5. WHY AA_OLYMPICS_SPORTS IS REJECTED DESPITE BEING EUR 18.39

49 humanoid mocap clips, and exactly **two** are judo: `Judo_A`, `Judo_B`. The
listing states *"This package only includes character's action, without the
animation of props"* - these are **SOLO** motions. **A solo judo clip cannot show
a throw, because a throw needs uke.** Cheap, and useless for this purpose.

## 4. WRESTLING FINISHER - the honest "maybe"

12 paired finishers `_1p`/`_2p` plus headlock, chop and punch pairs; Humanoid,
root motion and in-place, T-pose; same publisher and structure as the Judo pack.
**But `Full Mount Attacks` already covers bodylock and double-leg**, and
"wrestling finisher" reads as pro-wrestling showmanship rather than sport
grappling. Lowest priority; audition before buying.

## RECOMMENDED ORDER, BY GAP CLOSED PER EURO

1. **Melee Counters - EUR 27.59.** Our exact rig, paired, and the film for the
   biggest unread mechanic. **HOLD until R130 group 1 is ruled on** - buying film
   for a layer that may not be built is the wrong order.
2. **20 Fighters - EUR 36.79.** Closes a gap already written down as a failure,
   and needs no engine work at all.
3. **Judo AnimSet - EUR 110.40.** Required for judo; nothing else supplies paired
   standing throws.
4. **Wrestling Finisher - EUR 110.40.** Only after auditioning.

All four: **EUR 185.18.** The first two together are **EUR 64.38** and close two
recorded gaps.

**Every one is on the Unity store under the Standard Unity Asset Store EULA** -
which is where the standing rule says to buy, and R140 above shows why: the same
Judo pack on FAB is EUR 123-308 **and** carries "Allows usage with AI: No".
