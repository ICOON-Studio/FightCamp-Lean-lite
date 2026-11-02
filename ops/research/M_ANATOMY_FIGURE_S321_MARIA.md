# M_ANATOMY_FIGURE_S321_MARIA - Maria answer (seat queue SQ22)

Brief: research/M_ANATOMY_FIGURE_S321.md
Sent: 2026-10-31 10:10 | collected: 2026-10-31 10:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

**Recommendation**

Build the figure as a **3D render of a bought, royalty-free écorché (skinless muscle) model, mixed with her own skin**:
- The front of the body is shown as skin in her own skin tone.
- Muscle shows through only where she's hurt, plus a faint muscle layer on the hurt region.
- Her face stays as her own MetaHuman render.

Call it "skin first, muscle on damage". Render it in Blender with one locked camera and light set, as layered PNGs per build: a skin layer, a muscle layer, and region masks. Godot then fades the layers per region. It reads at 260×520, it looks film-quality, it stays her, and it needs no sculpting.

**Before any of this: the blood ruling.** "Blood that runs from an open cut" clashes with the ruling accepted on 2026-09-22:
- Blood appears only at the doctor or stoppage class, never per punch.
- Damage is shown as M13 trauma pips plus the M23 region ramp, so the readout matters more than gore.
- The doctor and stoppage board is the only blood board, deferred past M29.

The operator needs to either reopen that ruling or accept a cut drawn without running blood (below). I've specced both.

---

**1. Which look reads best at 260×520 over a dark broadcast**

The size problem first: at 520 px tall, her head is about 65 px, an eye is about 6 px, and a forearm muscle is about 10 to 15 px wide. Anything that depends on fine fibres, thin lines or translucent layers turns to noise. What survives is big shapes, value contrast against the dark broadcast, and one or two colours.

**Ranking, best first**

**1. (e) Skin first, muscle on damage.** The look of a medical illustration crossed with a sports-medicine app, at film-render quality.
- Why it wins:
  - It keeps the most identity: skin tone, build and face are all hers.
  - The muscle reveal becomes the damage signal itself, so the player reads "the red muscle is showing on her left ribs" in a second.
  - A skinned body against a dark background has a clean silhouette and strong value contrast.
- What fails at small size: the muscle-to-skin blend can turn muddy if it's soft. Use a crisp edge, about a 4 px feather at 1x.

**2. (b) Full écorché with her own face kept.** It's closest to the operator's premium reference and looks the most film-like up close.
- Why it's second:
  - At 520 px, a full muscle body is one big red-brown shape. Every region is already red, so a hit on a red region barely changes it, and damage has nothing to stand out against.
  - Identity is weaker below the neck: muscle bodies look alike, and skin tone disappears.
  - Over a dark broadcast, a dark-red figure is low contrast. It needs a rim light to survive.
- It works as the "medical view" between rounds (see the cutman section), not as the live fight figure.

**3. (a) Half skin, half écorché** (a split down the middle).
- It's a striking image, like a textbook, but it looks like a poster rather than a status readout.
- Hits on the skinned half and hits on the muscle half read differently, so the same damage looks inconsistent depending on which side it lands.
- The split line also cuts through the face, which costs identity at small size.

**4. (d) The M44 flat muscle map at a higher finish.** It's the most readable, but the operator has already rejected it as not premium. More finish won't change the category. Keep it as the fallback for low-end settings or accessibility.

**5. (c) Broadcast X-ray: glass skin with glowing muscles and skeleton.**
- What fails:
  - Translucent layers at 260 px turn into overlapping noise: the skeleton, the muscle edges and the skin outline all fight each other.
  - The glow looks like sci-fi, not a boxing broadcast.
  - Glowing reads as an alert everywhere, so a hit has nothing brighter to be.
  - The skeleton belongs only to an X-ray moment, such as a suspected fracture or orbital damage in the doctor check.

**Real references (to learn from, never to copy)**
- Sports-science body maps, for one clear region-by-region status read. They're the readability benchmark, not the look.
- Medical anatomy apps (3D muscle-layer viewers), for the layered skin-to-muscle reveal and clean studio renders on a neutral background.
- Fight-game damage screens between rounds (Fight Night Champion's damage view, the EA UFC games), for zooming in on the injured area between rounds. Their exact presentation is NOT VERIFIED here; I'm citing the idea only.
- Broadcast health graphics (F1's tyre graphics, or the injury graphics in football broadcasts) for how a few saturated colours on a neutral figure read instantly on TV.

---

**2. Blood, swelling, ice and hit glow, readable in one second**

General rules:
- Animate only events, never a steady state, and nothing loops forever.
- Only one thing moves at a time on the figure.
- Every state also gets a small icon or word chip beside the figure, so nothing relies on colour alone.

**Hit glow (each landed punch)**
- A soft warm white-to-amber flash, #FFD089, at the impact point, radius about 18 px at 1x.
- It rises in 60 ms, holds 80 ms, then fades over 350 ms, about 0.5 s in total.
- Strong punches get a 1.3× radius, not a longer flash.
- The region underneath then steps one shade along its damage ramp and stays there. That step is the lasting information; the flash is only the cue.
- Don't use a red flash (it reads as blood), and don't shake the figure.

**Swelling (grows over time)**
- The region swells as a real shape change: the swollen area's outline bulges by up to 4 to 6 px at its maximum, done as a layered blend between the "normal" and "swollen" renders per area.
- The swollen area gets a colour shift to a deep purple-red, about #6E2A3A, over the skin, at up to 60% opacity.
- It grows in steps: after a hit to that area, it eases to the new size over 300 ms, then holds. Never continuous breathing or pulsing.
- An eye swollen shut shows as the eye slit closed on the face render, plus an eye-closed icon.

**Cut**
- *Under the current ruling (no blood):* a cut is a short dark line, 10 to 14 px long and 2 px wide at 1x, in #3A1414, with a thin bright edge on one side so it looks open. A cut icon goes beside it. No liquid.
- *If the operator reopens the blood ruling:*
  - Blood is #7A0F14 to #9E1B1E with a slight gloss highlight, never bright scarlet.
  - It runs only in short, slow events: a drip path grows 20 to 40 px downward over 1.5 to 2 s after each hit to the cut, then stops and stays as a dried trail, darkening to #4A0D10 over about 10 s.
  - Maximum two active trails per cut.
  - No splatter, no spray, and no blood on the hit glow.
  - The drip path follows the figure's shape: from the brow down beside the eye, never across it, so it doesn't cover the face.

**Ice (between rounds)**
- A pale blue-white pack shape, #DCEFF8 with a soft frosted edge, about 28×18 px on the neck or the swollen region.
- It appears with a 200 ms scale-in, then a slow 1.5 s cool-blue tint, #9CC9E6 at 30%, spreads into the area.
- On a swelling, that area shrinks one step over 600 ms when the treatment resolves.
- On the neck, show a small "calm" effect: the heart-rate chip slows (EXAMPLE). The figure itself doesn't pulse.
- Don't use teal. It's reserved for the UI, so keep the ice white to pale blue.

**What not to animate**
- Constant breathing, a heartbeat pulse, idle sways, looping blood, or blinking glows.
- Any animation during the live exchange other than the hit flash.
- Particles.
- Camera moves on the figure while the fight is live.

---

**3. Keeping the figure hers**

- **Face:** her own MetaHuman head, rendered with the same camera and lights as the body and placed on top. This alone carries most of the identity.
- **Build:** buy or rig one male and one female base, and drive build with shape keys: height, shoulder width, chest and hip width, arm and leg girth, and muscle definition. Render 4 to 5 body sizes per sex, from flyweight to heavyweight, and assign the nearest to each boxer. That's enough variety at 520 px.
- **Skin tone:** the skin layer is rendered neutral and tinted per boxer, using a 6 to 8 step ramp matched to each MetaHuman's albedo. Use multiply plus a separate highlight pass, so dark skin keeps its highlights and doesn't turn flat.
- **Kit:** her trunks in her kit colours from M43, and her tape and gloves as small colour areas, since the hands are about 20 px. Hair comes from her head render.
- **Her side of the screen:** the figure faces into the screen from her edge, a slight turn towards centre, matching her corner colour as a thin rim light (red or blue corner). That shows whose figure it is at a glance.

---

**4. Production: the best quality per hour**

**Buy and render: one écorché model plus one skinned base, rendered in Blender.** Here's why:
- **Generated images** can't be kept consistent per build, pose, region and state across 12 boxers, and many generators raise the "unrecorded source" problem. It fails our provenance rule.
- **2D drawing** at film quality is slow, and every build or state needs repainting.
- **A bought model** gives real anatomy. Rendering is repeatable: change the build, render again. The licence gives us a recorded source.

**Buying checklist**
- A licence that explicitly allows use in a commercial game and in rendered images. Keep the licence and the receipt in the provenance ledger.
- Female and male versions, or one that can be adapted.
- Separate muscle objects or material IDs for each region, so we can make per-region masks.
- A clean neutral pose (A-pose), real-world scale, and PBR textures.
- Ideally with a skin layer or a matching skinned base.

**Render setup (Blender Cycles)**
- **Camera:** orthographic, or a long lens at about 85 to 100 mm equivalent, looking straight on at chest height. The figure fills about 90% of the frame height.
- **Resolution:** render at 4× the display size, 1040×2080, then downscale for crisp edges, plus a 2× version for 4K.
- **Pose:** a neutral standing pose, about 15° turned towards the screen centre, arms slightly away from the body so the ribs and flanks show. Use the same pose for every build.
- **Lights:**
  - A three-point studio setup. Key: a large softbox up and to the front-left, at about 45°, 5500 K.
  - Fill: a softbox front-right at about 0.4× the key.
  - Rim: two strip lights behind at about 1.2× the key, one per side, so the outline separates from a dark background.
  - In-game, the rim nearest the screen centre gets her corner colour. Render it as a separate pass so it can be tinted.
- **Background:** transparent (film transparent on), with no floor and no shadow catcher.
- **Passes to export per build:**
  - Skin RGBA
  - Muscle RGBA
  - Region masks (six or more regions as separate greyscale masks)
  - A shadow and AO pass
  - The rim pass, to tint
  - Optional swelling variants per region (shape-key renders)
- **Colour management:** AgX or Filmic, the same as the game, so the figure matches the broadcast.

**In Godot**
- Composite the layers in a small 2D shader: per-region skin-to-muscle reveal, damage tint ramp, swelling blend, then the hit flash and the cut, ice and blood overlays.
- Tap targets are the region masks, enlarged by 12 px for between-rounds taps.
- **Between rounds:** the figure slides out to about 2× size, with muscle shown across the whole figure. That's where option (b) earns its place. The player taps a region, and the cutman's and second's actions appear as icons on it. Words such as "Close cut", "Enswell" and "Ice: neck (calms)" are EXAMPLE pending Kalli.

**Effort estimate (rough):** 1 to 2 days to set up the model, regions and render scene; about 1 hour of rendering and checking per build size per sex; 2 to 3 days for the Godot compositing shader and the tap targets. That's my estimate, not a measured plan.

**Next step I'd suggest:** a single still at 260×520 over a dark broadcast frame, comparing (e) and (b) on one build at two damage levels, so the operator judges the look at actual size before we buy anything big. I can find three candidate écorché models with their licences checked if you want to go ahead.
