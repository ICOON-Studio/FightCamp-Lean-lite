# FightCamp asset report — 2026-09-20

**Claude · what the game actually owns, what it uses, and the two things that would stop a release**

Built from `Godot/assets/asset_manifest.json`, the tree on disk, the Unity Asset Store download
cache, the public Asset Store API, and — added in revision 2 — the **actual My Assets list** read
from the operator's own signed-in browser at `assetstore.unity.com/account/assets`. **No purchase
was made.**

> **REVISION 3, same day.** Rev 1 covered what was DOWNLOADED. Rev 2 added the account list (§5):
> ten owned, five never downloaded. **Rev 3: MMA Arena has now been downloaded** — 452 MB, through
> the Editor's Package Manager — and its contents verified (§5). It contains `OctagonCage.fbx`,
> `OctagonFloor.fbx` and `OctagonCageDoor.fbx` plus 28 more arena meshes, all FBX and PNG, all
> portable to Godot. **The venue gap is now an extraction job, not an acquisition problem.**
>
> **REVISION 4.** Remocapp — the 11th package, invisible on the web list — installed and opened up
> (§5). It is markerless full-body mocap, it is a RECEIVER ONLY, and its stream is plain **OSC on
> port 39570** with a 20-bone humanoid, so Unity is not required to consume it.

---

## 1. The headline

**Two findings matter more than the rest.**

1. **The game's twelve fighters and its retargeted clips are shipping on UNRECORDED licence terms.**
   The manifest marks both `approved` — "may be referenced by shipped code" — and then says
   `licence: NOT RECORDED`. These are the *only* fighters in the game. Everything else here is
   replaceable; this is not.
2. **The paired grappling animation this project has treated as its bottleneck is already owned,
   downloaded, approved and wired.** Armbar, strangle, double-leg, body-lock takedown and a reversal
   are all bound in `FightClipBinding.PAIRED_BINDINGS`. **Seven further paired clips are owned and
   unused** — including ground-and-pound.

And one omission: **there is no fight audio at all.** The 29 MB `audio/` folder is a single menu
track.

---

## 2. Licence status — the release blockers

| pack | status | licence | risk |
|---|---|---|---|
| `tripo_fighters` (f01–f12) | **approved** | **NOT RECORDED** — Tripo plan terms | **HIGH** — the only fighters in the game |
| `ludo_retarget_clips` | **approved** | **NOT RECORDED** — Ludo terms | **HIGH** — referenced by shipped code |
| `ramsterz_hand_to_hand_set` | approved | Unity EULA (no AI clause in the Unity copy) | clear |
| `ramsterz_full_mount_attacks` | approved | Unity EULA | clear |
| `boot_stage_baked_idles` | approved | inherits RamsterZ H2H | clear |
| `move_pairs` | approved | inherits RamsterZ H2H | clear |
| `motifect_martial_arts` | **candidate** | free pack README: commercial use OK, **no redistribution of raw animation data** | cannot ship until approved |
| `magicpot_fighting_motions_vol1` | **candidate** | Unity EULA | cannot ship until approved |
| `polyronin_old_school_gym` | placeholder | Unity EULA | blockout only |
| `slimui_3d_modern_menu_ui` | **rejected** | Unity EULA | do not use (still on disk) |

**The two NOT RECORDED rows are the single most valuable thing to close**, and neither needs
engineering — they need the operator to read the Tripo and Ludo plan terms they generated under and
write the answer into the manifest. Generated-asset terms commonly vary by plan tier and by whether
the output is redistributed inside a product, which is exactly what shipping a game does.

**Motifect also carries a restriction already recorded:** its 17 weapon clips (sword, staff, spear)
are marked not for use in a sport sim.

---

## 3. What is on disk

**345 MB total under `Godot/assets/`.**

| area | size | contents |
|---|---|---|
| `anim/` | 211 MB | 178 clips in four audition packs, plus 2 authored pairs and 3 baked boot idles |
| `images/` | 56 MB | 62 files |
| `audio/` | 29 MB | **one menu track. No fight audio.** |
| `models/` | 25 MB | 12 rigged fighters + 1 |
| `ui/` | 10 MB | 643 files |
| `videos/` | 7 MB | 2 files |
| `icons/` | 4.4 MB | 666 files |
| `vendor/` | 369 KB | Poly Ronin gym equipment |

### The animation packs

| pack | clips | size | status |
|---|---|---|---|
| Motifect Martial Arts | 80 | 59 MB | candidate — AI-generated, free, kicks only (U46: zero punches, zero paired grappling) |
| Magicpot Fighting Motions Vol 1 | 43 | 14 MB | candidate |
| RamsterZ Full Mount Attacks | 36 | 35 MB | **approved, paired** |
| RamsterZ Hand to Hand Set | 19 | 102 MB | **approved** |

### The twelve fighters

`f01`–`f12`, rigged, covering boxing / MMA / bare-knuckle across both sexes and several weights
(welter, heavy, fly, middle, light, LHW, straw, bantam, feather). Loaded at runtime through
`GLTFDocument`. R95's verdict stands: **bodies shippable, faces not.**

---

## 4. The paired grappling — owned, and half of it unused

`Paired_FullMount_*_Att.fbx` / `_Vic.fbx`, 16 pairs. **Five are bound** in
`FightClipBinding.gd:882`:

| grapple role | clip | length |
|---|---|---|
| `grapple_sweep` | `Paired_FullMount_Reversal` | 1.83 s |
| `grapple_takedown` | `Paired_FullMount_Takedown_DoubleLeg_Start` | 1.67 s |
| `grapple_throw` | `Paired_FullMount_Takedown_BodyLock_Start` | 2.33 s |
| `grapple_submission_attempt` | `Paired_FullMount_H2H_ArmBar` | 4.47 s |
| `grapple_submission_finish` | `Paired_FullMount_H2H_Strangle` | 6.00 s |

**Seven owned, approved, extracted and NOT bound:**

- `Paired_FullMount_H2H_Punches` — **ground and pound**, a real fight behaviour with no clip bound
- `Paired_FullMount_H2H_HeadSmash`
- `Paired_FullMount_AttackBlock` — defence from inside the mount
- `Paired_FullMount_PushOff`
- `Paired_FullMount_VictimAttack` — the bottom man doing something, rather than being acted upon
- `Paired_FullMount_Takedown_BodyLock_Loop` and `_End` — the middle and end of a takedown whose
  START is already bound

That last one matters: the body-lock takedown is bound to its **Start** only, and its Loop and End
are sitting unused next to it. The four remaining pairs are weapon clips (axe, knife, blunt) and are
not usable in a sport sim.

**This is the cheapest animation work available** — the clips are bought, legal, converted and
present; each needs a `PAIRED_BINDINGS` entry, not an acquisition.

---

## 5. Unity Asset Store — the account owns TEN, and five were never downloaded

Read from `assetstore.unity.com/account/assets` in the operator's signed-in browser, 2026-09-20.

### Owned but NEVER DOWNLOADED — five

| package | publisher | size | bought | verdict for this project |
|---|---|---|---|---|
| **MMA Arena** | MARPA STUDIO | **452.9 MB** | 2026-09-13 | **DOWNLOADED 2026-09-20.** The venue the game does not have. Contents verified below. |
| Cloth Dynamics | Christian Kahler | 197.2 MB | 2026-09-13 | **Skip.** Unity-only runtime: compute shaders, Shader Graph, Unity components. Nothing crosses to Godot. |
| Animation Recorder Lite | Develoop Team | 14.0 MB | 2026-09-13 | **Skip.** A Unity *Editor* tool. We record through Godot and Blender. |
| FREE - 32 RPG Animations | Blink | 7.5 MB | 2026-09-13 | **Maybe.** Free, tiny, and its changelog names strafe left/right — locomotion is a live weakness (U89: "bodies do not walk"). Worth a look, not a priority. |
| Control Rig | Ash Dev | 263.3 KB | 2026-09-13 | **Skip.** Unity rigging tool. |

**MMA Arena is the find.** The game's entire venue inventory today is 369 KB of Poly Ronin gym
equipment marked `placeholder` — "blockout only, never in a shipped scene against the R18 visual
bar". The operator's standing verdict on the 3D fight is that it is *painful to watch*, and M20's
framing spec is written around a RING deck at 1.2700 m versus a CAGE deck at 0.1300 m with the
camera 9–11 m back — a real arena is exactly what that spec is meant to frame. A 452.9 MB arena
already paid for is the cheapest large visual upgrade available.

### MMA Arena — downloaded and opened, 2026-09-20

`%APPDATA%\Unity\Asset Store-5.x\Marpa Studio\3D ModelsEnvironments\MMA Arena.unitypackage`,
452 MB. Pulled through the Unity Editor's Package Manager (My Assets → Download), which is the only
route that exists — the web store has no download and its own page controller only hands off to the
Editor. **244 entries, and the useful ones all travel:**

| kind | count | travels to Godot? |
|---|---|---|
| `.fbx` meshes | **31** | **yes** |
| `.png` textures | **138** | **yes** |
| `.mat` materials | 29 | no — Unity material assets; rebuild from the PNGs |
| `.prefab` | 31 | no — Unity-only |
| `.unity` scene, `.lighting` | 2 | no — Unity-only, but useful as a layout reference |

**The three that matter:** `OctagonCage.fbx`, `OctagonFloor.fbx`, `OctagonCageDoor.fbx`. The rest is a
complete arena around them — `SecondFloorSeatsBase`, `TopFloorSeatBase`, `PlaneSeat`, `Chair`,
`Stairs`, `Pillar`, `Truss`, `CeilingFrame`, `CeilingLamp`, `SmallLamp`, `ScoreBoard`, `AdBoard`,
`LightScreen`, `TopFloorScreen`, `LongWall`, `SmallWall`, the barricades, entrances and `Windows`.
Publisher states Unity 2022.3.8 as the original version, which does not matter for raw FBX.

Two things remain before it is in the game: the meshes need the same extract-and-convert pass the
animation packs went through (materials rebuilt from the PNGs, since `.mat` does not travel), and
its licence — standard Unity EULA, fine for use — must be **recorded in the manifest** like the
rest. It is not yet in the repo: 452 MB is an LFS decision, not something to add unilaterally.

### Remocapp — the 11th package, and the most interesting thing on the account

The Editor's Package Manager reports **11 packages**, one more than the web My Assets page: a
**Remocapp** entry (REMOCAPP PTY LTD, v1.0.0, bought 2026-09-13). It does not appear on the web list
because it is a **UPM package, not a `.unitypackage`** — which is also why its button reads *Install*
rather than *Download*, and why it never showed up in the Asset Store download cache.

**Installed 2026-09-20**, 3.3 MB, to
`C:\Users\user\My project\Library\PackageCache\com.remocapp.remocapp@5091a92201f1`
(`"com.remocapp.remocapp": "1.0.0"` now in that project's `Packages/manifest.json`).

**What it is: markerless full-body + face + fingers motion capture** — real-time, no suit, no
markers, from a camera.

**What it is NOT: it is a RECEIVER ONLY.** Its own README, step 1: *"Download the Remocapp Windows
application and sign in at https://remocapp.com/ to get a license and activate the app."* The Unity
package takes a stream and applies it to a rig; the capture itself happens in a separate Windows
app behind a licence this project **does not own**. No sign-in was attempted and nothing was bought.

**Why it matters anyway — the stream is open.** It arrives over **OSC**, not through any Unity-only
channel:

| | |
|---|---|
| body address | `/Remocapp/Unity` |
| face address | `/Remocapp/Unity/Face` |
| default port | **39570** |
| skeleton | 20 bones, standard names |

The bone list is `Hips, Spine, LeftShoulder, LeftArm, LeftForeArm, LeftHand, RightShoulder,
RightArm, RightForeArm, RightHand, Neck, Head, LeftUpLeg, LeftLeg, LeftFoot, RightUpLeg, RightLeg,
RightFoot, LeftToeBase, RightToeBase` — the same vocabulary the retarget work already uses.

**So Unity is not required to consume it.** A Godot or Python OSC listener on port 39570 reads the
same stream. That is worth knowing because capturing motion is exactly this project's bottleneck:
Higgsfield text-to-motion produced one body per clip and **0 of 36** composed takedowns, paired
grappling had to be bought, and the footage pipeline is reduced to inferring rates from MediaPipe
tracks of other people's video. A camera in the room pointed at someone throwing the punch is a
different class of answer.

**It is not a recommendation to buy yet** — the app's price and licence terms are unread, markerless
single-camera capture is historically weak at exactly the ground and clinch work this game needs,
and the operator's standing ruling is that generator spend stays paused behind the engine stage.
Recorded as a live option with its protocol already known.

### Downloaded — five

Five packages in `%APPDATA%\Unity\Asset Store-5.x\`:

| package | publisher | size | in repo? |
|---|---|---|---|
| Hand to Hand Set | RamsterZ | 14.2 MB | yes, approved |
| Full Mount Attacks | RamsterZ | 6.0 MB | yes, approved |
| Fighting Motions Vol1 | Magicpot Inc | 3.7 MB | yes, candidate |
| Low Poly Old-School Gym Equipment | Poly Ronin | 0.4 MB | yes, placeholder |
| 3D Modern Menu UI | SlimUI | 13.6 MB | **rejected — on disk, unused** |

**Nothing needed downloading.** Every downloaded package is already extracted into the repo, and the
only one not in use is the one the manifest rejects.

---

## 6. What would actually fill the gaps, if anything is bought

Nothing below was purchased and nothing is recommended without the operator's say-so. Prices are
live from the store's public API, in EUR.

**The real gap is not grappling clips — it is sound.** J22 (John, collected today) priced a full
fight-audio bed at **59 distinct cues, ~302 files, about USD 47** via Gamemaster Pro plus
Sonniss/CC0 for the gaps. That is the largest quality gain per euro available to this project right
now, and the game currently has none of it.

For grappling, RamsterZ's own catalogue (67 packages) is the natural place to extend, because the
`_Att`/`_Vic` paired convention already matches the binding code:

| id | pack | EUR |
|---|---|---|
| 227376 | Wrestler Finishers Volume 1 | 36.79 |
| 248067 | Wrestler Finishers Volume 2 | 41.39 |
| 227027 | Hand to Hand Non-Lethal Counters | 22.99 |
| 227371 | Hand to Hand Finishers Volume II | 36.79 |

**But bind the seven free ones first.** They cost nothing, they are already legal and present, and
they will tell you whether the paired pipeline handles more variety before any money is spent.
Nothing in RamsterZ's catalogue is free and relevant (one free Doll Character, not applicable).

---

## 7. What could not be reached

**One click on the day, none needed next time.** The account list was read from the operator's
own signed-in browser and MMA Arena was downloaded through the Editor. The operator dismissed the
admin dialog on that run; the route to dismiss it automatically is now tested and recorded below. No credentials were entered and none were read from storage. Recorded for the next session, because it cost time: **there is no web download.** Unity's
My Assets page has no download control, its `Download_MyAssetsController` bundle calls no download
endpoint, and the legacy `/api/en-US/account/downloads/search.json` is now 404. The `.unitypackage`
comes only through the Editor's Package Manager → My Assets → Download.

The route, which works and is worth keeping: Unity Hub → Projects → **`My project`** (a URP sample
at `C:\Users\user\My project`, Unity 6.6) → Editor toolbar **Asset Store → My Assets** → select →
Download. **The "Administrator Privileges Detected" dialog STILL BLOCKS the project open.** This
report first claimed it had gone; the operator corrected it — they had clicked it themselves while
the window title was being polled, which is why the title looked like it advanced unaided. Tested
properly afterwards: the dialog is its own 372x200 window, **"Ignore Warning" sits at its rect +
(306, 173)**, and `mouse_event` clears it. **But the launch must go through Unity Hub** — running
`Unity.exe -projectPath` directly and then dismissing the dialog makes Unity exit within seconds,
twice out of twice. Hub → project row → clear the dialog → it opens. The status-bar line "Unity is
not designed to run with Administrator privileges" is what remains AFTER dismissal, never evidence
it did not appear. The Package Manager opens as its own window on the left monitor, not inside the
Editor frame.

## 8. Recommended order

1. **Record the Tripo and Ludo licence terms in the manifest.** No engineering; removes the only
   two unknown-licence rows, both of which are already marked shippable.
2. **Bind the seven unused paired clips**, starting with ground-and-pound and the body-lock
   Loop/End. Free, legal, present.
3. ~~Download MMA Arena~~ **DONE 2026-09-20.** Next step on it is the extract-and-convert pass
   into Godot, and a manifest entry with its licence and status.
4. **Buy the audio bed** (~USD 47) — the biggest missing dimension of the game.
5. **Decide Motifect and Magicpot**: both are `candidate`, together they are 123 of the 178 clips,
   and neither can ship until someone approves them.
6. Only then consider a Wrestler Finishers pack.
