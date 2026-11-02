# J51: Fight camera craft. How broadcast crews shoot a fight, and what FightCamp's watched-fight camera should do

Task J51, assigned 2026-09-25. Research only; no code. Target path in the repo: `research/J51_FIGHT_CAMERA_CRAFT.md`. All sources were read on 2026-09-25.

**Tags.** SOURCED = URL plus verbatim quote (source IDs in §7). JUDGEMENT = my reasoning, stated. PROXY = a number borrowed from a nearby field (e.g. a Unity default or a cinema rule) and adapted, with the adaptation shown. NOT FOUND = searched, nothing citable. COUNT = my own arithmetic, method stated. Source types: DEV, BROADCAST, TRADE, ACADEMIC, PRESS, COUNT, COMMUNITY, STANDARD (EBU).

---

## §0 Short answer

**Why our camera shakes.** Every frame, our camera re-aims at a box drawn around every limb of both fighters. A jab pushes one hand about an arm's length out and back in well under a second, and a kick pushes a foot out even further. That box therefore jumps on every strike. The camera then chases the box in both aim and zoom, so every punch becomes a small whip-pan and every kick a zoom pump. The camera has no "don't care" zone, no weight and no speed limit, so it passes every twitch of the animation straight to the screen. Game-camera writers name this exact failure: "Slight or unintentional camera motion caused by reactions of the player character … should be avoided" (Haigh-Hutchinson) [S43], and Nesky's 50 mistakes include "Rapidly shifting field-of-view" and "Excessively shaking the camera" [S44].

**What the pros do.** In boxing, most of what viewers see comes from two matched cameras on a raised platform facing the ring. Camera 1 holds a steady head-to-toe shot of both fighters. Camera 2 sits at the same angle but tighter, trunks-up. Director Rick Tugman describes these as "two shots from the front of the ring that are most of what a viewer sees" [S1]. Handheld operators on the ring apron or cage platforms, a jib or rail camera, and a camera 90 degrees round the ring add variety. Directors mostly add variety by **cutting**, not by whipping a camera around. They cut sparingly, always return "home" to Camera 1, and never jump across the ring to the opposite side. Sky's boxing director Sara Chenery says they "come out head-to-toe when the referee says 'break' … not when a boxer is in the middle of a really big exchange" [S2]. Tugman says "I'm not going to cut this up like it's chop suey" [S1]. Operators frame the pair of bodies, not the gloves, and they zoom slowly and on purpose ("do a slow zoom in and help show the drama") [S1].

**What we should build (details in §6).** Aim at a smoothed midpoint of the two fighters' chests and hips, and never at hands or feet. Use a dead zone so small drift does not move the camera at all. Use a critically damped spring with a half-life of roughly 0.3 s for aim and roughly 1 s for zoom. Hard-cap pan and zoom speed. Only change zoom when the fighters' separation changes a lot (hysteresis). Get variety from a small set of fixed "broadcast" camera positions linked by cut rules, and not from constant camera motion. The main live camera should never shake.

---

## §1 The human answer: the director's craft and the main operator's craft

**The director's job is to keep the viewer oriented.** Tugman (35 years; ShoBox, ProBox TV, Glory, WSOF): "There's no reason for me as a director to jar the audience, to change the perspective of what the audience sees" [S1]. He also describes a specific MMA failure he disliked when directing World Series of Fighting: directors "would go from left to right, and now the fighters [have swapped sides on the screen]. I have always gone home … back to the main matched camera, then off to somewhere else" [S1]. (SOURCED, BROADCAST)

**Chenery on moving versus cutting.** Sky Sports director Sara Chenery sees too many cuts as the rookie mistake: "you don't have to keep cutting off the camera, which is the thing that's so distracting if you watch coverage of boxing the first time people do it. They just keep cutting the cameras because they're moving so fast. What we're trying to do is slow it all down and go to cameras at the right time" [S2]. Her tool for keeping one continuous shot is a ringside jib with "a gentle, fluid move". When the referee blocks a fixed camera, "you have to cut, whereas when you've got a jib, if the ref gets in the way, they can just move around past him" [S2]. She also cuts less for fast lighter-weight fighters and more for heavyweights (see §4) [S2]. (SOURCED, BROADCAST via TRADE)

**How the main operator works.** No operator interview I found gives framing numbers such as "the pair fills X% of the frame" (NOT FOUND). What operators and directors do describe is the division of labour:
- Camera 1 is the "head-to-toe" camera and Camera 2 is the "tight-follow … trunks up" camera. The tight shot "shows the reach, how far the fighters are from each other" [S1].
- A former wrestling director and handheld operator on a forum describes the same split. One camera gets "head to toe framing so that one can see all the motion leading into and out of striking", and a second gets "more intimate framing; try to stay on torso for strikes and to watch the fighters faces". His main complaint about the wide operator is that he "keeps zooming in because he's bored shooting wide shots" [S27]. (COMMUNITY. Useful because it shows the wide camera's value is holding still.)
- HBO ringside handheld operators "cover everything, close and wide … as the fighters go into their corners, each [operator] takes a fighter". Their cameras "concentrate on the corners, but also follow the fight and zoom in according to the action" [S12]. (SOURCED, BROADCAST operators quoted in TRADE)

**Trend: closer and lower cameras.** Chenery: "we don't really go for the long lens head-to-toe in-out coverage of many years ago … There's a lot more handheld, so you feel as close as you can" [S2]. Tugman likes apron cameras "because they show the same level and point-of-view that the fighter sees", but only when the action is "right in your face" [S1]. So FightCamp's main camera can sit lower and closer than a classic long-lens view, as long as it stays steady.

**Zoom as storytelling, not tracking.** "Don't be afraid to use your lens. Your lens tells the story. Zoom in, don't be afraid to do a slow zoom in and help show the drama" [S1]. His signature "through the ropes" shot starts low, holds "for a beat or two", then pushes in [S1]. In other words, a zoom is a deliberate, slow move that starts from a held frame. It is not a frame-by-frame reaction to limb positions. (SOURCED, BROADCAST)

**What never happens on air.** No source gives a numeric ban, but the pattern across sources is consistent:
- Whip or swish pans on the live fight: NOT FOUND in any fight director's description. A US high-school sports-TV best-practice sheet states it outright: "All zooms and pans have to be smooth and gradual. No swish pans or fast zooms" [S29]. (BROADCAST guidance, football context)
- Cutting across the ring to the opposite apron: explicitly avoided [S1].
- Cutting out wide in the middle of an exchange: avoided [S2].
- Constantly repeated shots or a static show are also a failure ("One of the pet peeves I have is guys using the same shot over and over again") [S1]. The fix is timed variety, not jitter.

---

## §2 Camera plans

### 2a Boxing ring (typical TV layout, merged from several productions)

| Position | Height / placement | Lens / shot size | Role | Share of live air |
|---|---|---|---|---|
| **Cam 1 "main matched", head-to-toe** | Raised platform facing the ring. HBO: "in the middle of the audience … you had to see above the second rope, meaning the fighters would be clear of all the ropes" [S12]. At Sky/Wembley the platform was "built up over two rows of seats" [S2]. | HBO recreation: Angenieux 25-250 mm zoom [S12]. At Wembley, Cams 1-2 were "a very long way from the ring" on a Fuji 25-1000 mm [S15]. Shot: head-to-toe two-shot [S1]. | Establishing shot and the "home" to escape to [S1]. | Cams 1 and 2 together are "most of what a viewer sees" [S1] (SOURCED, qualitative). A % share is NOT FOUND. |
| **Cam 2 "tight-follow", trunks-up** | Same platform and axis as Cam 1 [S1] | "trunks up" / "waist-up" [S1] | Reach and distance; corner barrages ("nine times out of ten I'm going to Camera 2") [S1] | See above |
| **Cams 3/4 apron handhelds** | On the apron or on 2'×2' platforms "at the same level as the fighters" [S12]. Set back to 8 ft during COVID [S5]. | Wide-angle lenses [S1]. HBO recreation: Fujinon Cabrio 19-90 mm [S12]. | Close action on their side; corners between rounds; injuries [S1][S12] | Used "the most" for alternate angles by Tugman [S1]. % NOT FOUND. |
| **Cam 5 "90-degree"** | "90 degrees off from your main matched cameras … from around one corner, and from a higher position" [S1] | Not stated | Referee and corner relationships; alternate axis, used carefully [S1] | Low (JUDGEMENT from "I never say I go to … the 90-degree camera, because I don't want to change the axis") [S1] |
| **Low "through the ropes" cams** | Sky Cams 5/6 "low down shooting up through the ropes" [S2] | Low angle | Artistic low angles, corner men [S2] | Low (JUDGEMENT) |
| **Ringside jib** | In a corner. Only "limited lateral movement" allowed [S2] | Head-to-toe to tight, moving [S2] | Continuous coverage that moves round the referee instead of cutting [S2]. Tugman prefers to keep it for replays [S1]. | High at Sky (Chenery prefers jib head-to-toe to a long lens) [S2] |
| **High / overhead** | HBO high camera "40′-50′ up" on 24-290 mm [S12]. JITA over the ring. PBC 36-camera overhead array "used solely for replays" [S8]. | Wide/top | Ring walks, big wides, replays [S8][S12] | Low during live rounds (JUDGEMENT) |
| **Canvas-level / corner POV** | PBC "MattCam robotic X-Mo systems mounted flush with the top of the canvas on opposite sides" [S8]. ESPN "bumper cam" POVs "buried in the mat" in two corners [S6]. | Wide POV | Knockdown and replay angles [S8] | Replay only (JUDGEMENT) |

Typical counts (SOURCED, TRADE): ESPN/Top Rank "standard 10-camera complement … three hard cameras, four cabled handhelds, one RF handheld, and two high-speed robos" [S5]. Other events: Lomachenko v Lopez 20+ [S7], Wilder v Fury II 38 [S6], Sky Joshua v Klitschko 16 on the ring [S2], BT Fury v Whyte 26 [S14], DAZN Joshua v Dubois 18 in the fight truck [S15], Mayweather v McGregor 24 [S10], FOX PBC PPV 22 [S9]. PLSN's summary of the standard layout: "Traditionally there is a camera 1 and camera 2 which are hard cameras facing the ring. Camera 3 and 4 are handheld, and the 90-degree camera is number 5. No one has truly broken out from that standard format" [S11]. Ring size: "a 24×24 ring — with the ropes at 22×22" [S10].

### 2b MMA cage (UFC)

| Position | Height / placement | Lens / shot size | Role | Share of live air |
|---|---|---|---|---|
| **4 cage-side handhelds** | Camera platforms at the cage, "looking down into the cage" [S24]. In 2009 the operators "stood on tall stools at four corners of the octagon" [S25]. The Sphere release mentions "the four camera platforms on the Octagon" [S22]. | Not stated | The main live coverage: "we get really great coverage with just four handheld cameras" (Greg Louw, Concom) [S3] | Primary (SOURCED, qualitative). % NOT FOUND. |
| **2 of those at 6x slo-mo** | Left and right of the Octagon [S3] | Faces and big hits | "account for 90% of our slo-mo replays" [S3] | Live plus 90% of slo-mo replays |
| **JITACam** (jib-in-the-air on a rail) | Above the cage on "a 30-ft. rail system … to travel back and forth across the Octagon" [S3]. Lighting truss "32 ft. above the Octagon" [S21]. | Wide to medium, overhead-ish | "one of our four coverage cameras on the Octagon during the fights" [S3]. "both an amazing beauty and an essential [fight] coverage camera" (Borsari) [S19]. | Significant (SOURCED, qualitative) |
| **Robotic overhead** | "one above the Octagon mounted on a truss in the lighting grid" [S4]. At the Sphere: "300 feet above the action" [S23]. | Top-down | Overhead coverage, including grappling (JUDGEMENT: no quote ties it specifically to ground fighting) | NOT FOUND |
| **Reverse / hard camera** | "a Sony HDC-2500 reverse shot" [S3] | — | Reverse angle | NOT FOUND |
| **Fence-line fixed** | "several fixed cameras shooting above and through the fence" [S17]. Fletcher Nucleus "embedded in a corner pad" [S21]. | Wide POV | Replay and alternates | Replay (JUDGEMENT) |
| **Jib at floor** | At Fight Island, with no crowd: "We put the jib in the six o'clock position … actually cover the fights with it" (Borsari) [S4] | — | Live coverage when space allows | Situational |
| **Coach POVs** | "two are attached to BR Remote robotic heads mounted on the apron deck … pointed at fighters' coaches" [S4] | — | Corner instructions and reactions for replay [S4] | Low |
| **Replay arrays** | 4DReplay: "30 cameras on the apron … pointing directly at the center" [S20] | — | "multi-angle highlights" [S20] | Replay only |

Counts (SOURCED): about "eight-camera execution" in 2005 [S19]. "The traditional 14-camera plan it uses for UFC PPV fights" (2011) [S26b, see S26 note]. UFC 200: 18 cameras [S18]. UFC 246: 16 cameras in the arena, 4 dedicated to the Octagon [S3]. Fight Island: 19 cameras, 6 on the Octagon [S4]. UFC 300: 27 cameras plus the 30-camera 4DReplay array [S20]. The Sphere: 48 cameras [S22]. Louw on the cage: "all the action take[s] place within a 30-ft. circumference around that Octagon" [S3].

**Key difference from boxing (JUDGEMENT).** Boxing's live picture rests on the fixed matched pair (Cams 1/2). UFC's rests on four cage-side handhelds looking down into the cage, plus the JITA, so the "main camera" role rotates between operators. A boxing watched fight can hold one steady main camera. An MMA watched fight needs cut rules that choose between 4 elevated quadrant positions (plus overhead) according to where the pair is in the cage.

---

## §3 Main operator framing rules

| # | Rule | Number | Tag | Source |
|---|---|---|---|---|
| F1 | Wide main shot is head-to-toe of both fighters; tight shot is trunks-up from the same axis | Cam 1 = head-to-toe; Cam 2 = trunks/waist-up | SOURCED | S1 ("head-to-toe (1) and trunks-up (2)") |
| F2 | Frame the torsos, not the gloves, for strikes | "try to stay on torso for strikes" | SOURCED (COMMUNITY) | S27 |
| F3 | The wide operator holds the wide shot and does not zoom in out of boredom | — | SOURCED (COMMUNITY) | S27 |
| F4 | Hard cameras sit high enough to see over the second rope | height = clear of all ropes | SOURCED | S12 |
| F5 | Eyes about one-third down from the top of the frame; tighter shots need less headroom | 1/3 from top | SOURCED (COMMUNITY reference) | S31 |
| F6 | Keep essential action inside the action-safe area | 3.5% in from each edge (93% × 93% usable) | SOURCED (STANDARD) | S30 ("The action safe area is 3.5% and the graphics safe area is 5%") |
| F7 | Pan no faster than one full frame width every 7 s (24 fps, 180° shutter). Higher frame rates allow faster pans. | 7 s per frame width | SOURCED (DEV/manufacturer) | S28 |
| F8 | No swish pans, no fast zooms; zooms and pans smooth and gradual | qualitative | SOURCED (BROADCAST guidance, football) | S29 |
| F9 | Zoom is a slow, deliberate storytelling move from a held frame | "hold the shot for a beat or two, then … push through the ropes" | SOURCED | S1 |
| F10 | Anticipate where the fighter is going instead of reacting | qualitative | SOURCED | S12 (Palladino) |
| F11 | How far the pair may drift before the operator reframes | — | NOT FOUND (no operator gives a number) | — |
| F12 | Pan speed in deg/s or zoom time for fight coverage | — | NOT FOUND | — |
| F13 | Lead room on a moving subject | exists as a concept, no number | SOURCED (concept only) | S31 |
| F14 | Stay wide enough that a sudden move doesn't force a whip pan | "Don't zoom so tightly that you have to swish pan" | SOURCED (BROADCAST guidance) | S29 |

**Takeaway.** The pros' rules say **what** to frame (both bodies, head-to-toe or trunks-up, torso for strikes) and **how steadily** (no swish pans, slow deliberate zooms). No source gives a numeric reframe threshold or pan speed for fights, so §6 uses PROXY or JUDGEMENT for those.

---

## §4 Cutting and replays

**Typical shot length on a live fight feed: NOT FOUND.** I found no published average shot length (ASL) or cuts-per-minute figure for live boxing or MMA. I did not measure one myself. Doing so would mean downloading broadcast video, which the task rules out unless it can be done legitimately, and I found no official shot-change metadata. The closest academic work is Ludwig & Bertling (2017) on live soccer. The abstract shows only that "a lower cutting rate leads the consumer to perceive less aesthetic appeal", with the effect moderated by fandom. It gives no cut rates in the abstract [S32] (ACADEMIC, abstract only). Indirect clue: UFC's 4K crew "sometimes stay on certain angles longer than the faster-paced HD cut" [S17]; "We'll cut less cameras for a 4K show" [S18] (TRADE).

**What triggers a cut (SOURCED unless marked).**

| Trigger | What the director does | Source |
|---|---|---|
| Referee says "break" / fighters separate | Come out to head-to-toe, "not when a boxer is in the middle of a really big exchange" | S2 |
| Fighter trapped in a far corner, barrage | "nine times out of ten I'm going to Camera 2, which is waist-up, tighter in the corner. That way, if something breaks, I have a place to escape to, which is my Camera 1" | S1 |
| Action right in front of an apron camera | Cut to that apron camera ("IN YOUR LIVING ROOM!") only when the action is close to it | S1 |
| Commentator talks about stance or footwork | "I go to the wider shot so we can see their feet, or I might go to the jib for just a few seconds" | S1 |
| Commentator talks about reach | Tight-follow (trunks-up) | S1 |
| Cut or injury | "You can't show it by being wide. You have to get in tight" | S1 |
| Referee blocks the shot | Fixed cameras must cut; the jib moves round the referee instead | S2 |
| Fighter doesn't come out after the round (injury) | Corner camera operator finds the injury, director takes that camera | S1 |
| Fighter speed | Lighter and faster fighters: fewer cuts. Heavier fighters in the pocket: more cuts | S2 |
| Axis rule | Never apron to opposite apron. Always go back through Camera 1 ("gone home") | S1 |

**Replay angles and speeds (SOURCED, TRADE).**
- UFC: two cage-side 6x slo-mo handhelds "account for 90% of our slo-mo replays" [S3]. Coach POVs are used "for replay at the end of the fights" [S4]. The 4DReplay apron array gives multi-angle highlights [S20].
- Boxing: PBC's canvas-level MattCams "give a unique view of a punch landing … if a knockout or knockdown happens, you are going to see that really well from a [floor-level view]" [S8]. The 36-camera overhead array was replay-only [S8]. Showtime cut HD close-ups out of a 4K wide "for replay … of key punches, as well as analysis of potential low blows, head-butts" [S10]. In the HBO-style film setup, a 12-foot-high corner crane camera "was used in conjunction with [the handhelds] for alternate-angle knockout shots" [S12]. Wilder v Fury II used a 120-camera 4DReplay array for 360° replays [S6].
- Replay speeds used: 6x (UFC) [S3], 4x superslow (DAZN) [S15], and 8x and 6x (ESPN Wilder v Fury II) [S6].

**When replays are shown (JUDGEMENT).** No source gives an exact rule. Directors are clearly reluctant to leave live action during an exchange [S2], so in practice replays go into natural breaks: knockdown counts, between rounds and after the stoppage.

---

## §5 Games: camera smoothing precedent

| Game / tool | Dead zone | Damping / spring | Aim target | Rate limits | Tag / source |
|---|---|---|---|---|---|
| **Cinemachine 2.x Framing Transposer** | Default `m_DeadZoneWidth = 0f`, height 0 | X/Y/Z damping default `1f`. Soft zone `0.8f`. Lookahead 0 | Follow target or Target Group. Group framing size `0.8f`. FOV range 3 to 60 | None as such; damping only | DEV [S35] source, [S33] docs |
| **Cinemachine 3.x Position Composer** (damping "simulates the lag that a real camera operator introduces" [S34]; lookahead "can amplify the noise" [S33]) | Dead zone off by default; size when enabled `0.2 × 0.2` of the screen. Hard limits `0.8 × 0.8` | Damping `Vector3.one` (1 s) | Tracking target with offset | Hard limits keep the target in frame | DEV [S35], [S34] |
| **Cinemachine 3.x Rotation Composer** (aim) | Same composition defaults | Damping `(0.5, 0.5)` | LookAt target | — | DEV [S35] |
| **Cinemachine 3.x Group Framing** | — | Damping `2` | Group bounds. `FramingSize = 0.8f`. FOV range 1 to 100 | — | DEV [S35] |
| **Cinemachine damping units** | — | "dampTime … the time it would take to reduce the original amount to a negligible percentage". Residual `kNegligibleResidual = 0.01f`. So damping T gives a half-life of 0.1505 × T (COUNT: ln2/ln100): 1 → 0.15 s, 2 → 0.30 s, 0.5 → 0.075 s | — | — | DEV [S35], COUNT |
| **Godot Camera2D** | Drag margins default `0.2` each side (drag off by default) | `position_smoothing_speed = 5.0`. Implementation is `c = speed * delta` lerp per frame, which gives a half-life of about 0.14 s (COUNT, approximation) | Node position | Rotation smoothing 5.0 | DEV [S36][S37] |
| **Godot Camera2D smoothing bug** | — | "delta time dependent … It can overshoot the target (when position_smoothing_speed * delta > 1.0)" | — | — | DEV [S38] (Jan 2026 PR) |
| **Godot Camera3D** | No built-in smoothing. Docs advise lerping in `_process`: "a Camera3D that realigns slightly every 1/10th of a second … will often be noticeable" | — | — | FOV default 75° | DEV [S36][S39] |
| **Godot SpringArm3D** | — | Not a spring: a collision cast. `spring_length = 1.0`, `margin = 0.01` | — | — | DEV [S36] |
| **Phantom Camera (Godot addon) 3D** | `dead_zone_width = 0.0`, `dead_zone_height = 0.0` (Framed mode) | `follow_damping` off by default; `follow_damping_value = (0.1, 0.1, 0.1)`; `look_at_damping_value = 0.25`. SmoothDamp with `omega = 2 / damping_time` (critically damped). 0.1 → step half-time about 0.08 s (COUNT) | Follow modes include GROUP (multiple targets) with auto distance min 1 / max 5 / divisor 10 | — | DEV [S40] |
| **Critically damped spring math** | — | Holden: "critically damped, meaning it returns to the goal as fast as possible without extra oscillation". Exact half-life damper `lerp(x, g, 1 - 2^(-dt/halflife))`. `halflife_to_damping = 4·ln2 / halflife` | — | Frame-rate independent | ACADEMIC/DEV [S41]. Juckett: "reach equilibrium as fast as possible without oscillating" [S42] |
| **Haigh-Hutchinson (Retro Studios), GDC 2005 paper, "Fighting" section** | "Minimize camera motion whenever possible" | "Low-pass filters can help smooth out irregularities" | "**Focal point between enemies rather than one specific character; usually allows a better view of both**" | "**Limit the reorientation speed of the camera** … instant reorientation should occur infrequently, and never in quick succession" | DEV [S43] |
| **John Nesky (Journey), GDC 2014, 50 mistakes** | — | "Letting independent forces compete to push the camera" (indecisive camera) | "Focusing only on the avatar" | "Rapidly shifting field-of-view"; "Excessively shaking the camera"; "Rapidly transitioning to a new camera position"; "Violating the 180 degree rule"; "Letting cuts remap directional controls" | DEV via COMMUNITY notes [S44] |
| **Nesky, Georgia Tech talk 2013** | — | Replaced force-based motion with "a virtual camera operator that makes decisions about what to do rather than responding to forces" | — | "unexpected zooming is a big contributor of motion sickness" | DEV [S45] (auto-captions) |
| **EA UFC 5** | NOT FOUND | NOT FOUND | Arcade camera: "prioritize staying perpendicular to the fighters". Beta had motions "more jittery than they had to be. The camera has been improved" | "Arcade" moves "more quickly"; "Cinematic" is less responsive, per a player guide [S50] | DEV [S46]; PRESS [S50] |
| **EA UFC 5 KO replay** | — | — | The replay system knows "whether it's a right fist or a left fist … can place the cameras in the most compelling and dramatic positions" | — | DEV [S47] |
| **EA UFC (2014) philosophy** | — | — | "Our replay and presentation cameras mimic the stuff that fans are used to seeing." A fist-cam "immediately snaps you out of the immersion" (Brian Hayes) | — | PRESS [S48] |
| **Fight Night Round 2 (2004)** | — | — | Deliberately "more cinematic flair than what you see on TV … we can get our cameras in the ring" | — | PRESS [S49] |
| **Undisputed** | NOT FOUND | NOT FOUND | Per-venue camera choice. Players turn off "screen shake" because it gave "a wobble like effect as if … you are fighting on a boat" | Patch notes found only fix camera clipping ("camera clipping through the ceiling") | COMMUNITY [S51]; DEV [S52] |
| **Madden NFL 27** | — | — | Quick Presentation change: "cameras now stay on the field when the play call UI appears instead of immediately cutting … preserves field awareness" | — | DEV [S53] (fewer cuts treated as a quality-of-life improvement) |

**Takeaway.** No shipped fight game publishes dead-zone or spring numbers (NOT FOUND for UFC, Fight Night, Undisputed). The best public numbers are tool defaults plus spring maths. The strongest design rules are Haigh-Hutchinson's for fighting games (aim between the fighters, limit reorientation speed, low-pass filter) and Nesky's (no rapid FOV change, no excess shake, no competing forces). Out-of-the-box defaults are *too twitchy* for a broadcast look: Cinemachine rotation damping 0.5 is a half-life of about 0.075 s and Phantom Camera's 0.1 about 0.08 s, both with zero dead zone. They are tuned for player-driven cameras, not a watched fight.

---

## §6 VERDICT: numeric camera spec for FightCamp's watched fight

Units: H = one fighter's standing height (use the taller fighter). Frame fractions are of screen width or height. "Half-life" is the time to close half the remaining error, using the exact form in Holden [S41]. Each line has a tag.

### 6.1 What the camera looks at
| Parameter | Value | Tag and reasoning |
|---|---|---|
| Aim target | Midpoint of the two fighters' **core points**. Core point per fighter = average of pelvis and upper-chest (spine) bones. Never hands, feet or weapons. | SOURCED principle: "Focal point between enemies" [S43]; "stay on torso for strikes" [S27]. Bone choice is JUDGEMENT. |
| Vertical aim | Put the core midpoint about 45% down from the top of the frame, so heads sit near the upper third | PROXY from the eyes-at-1/3 rule [S31]. The exact 45% is JUDGEMENT. |
| Framing extent (for zoom) | Capsule per fighter: core point ± 0.35 m sideways, from feet to head top. Limb bones excluded. | JUDGEMENT. This is the direct fix for "kick pumps zoom". |
| Pre-filter on the target | Low-pass the raw midpoint (half-life 0.08 s) before the dead zone | SOURCED principle: low-pass filters [S43]. Number is JUDGEMENT. |
| Lookahead | 0 | SOURCED: lookahead amplifies animation noise [S33]; Cinemachine default 0 [S35] |

### 6.2 Dead zone, soft zone, hard limits
| Parameter | Value | Tag |
|---|---|---|
| Dead zone (aim) | 0.20 width × 0.12 height of screen, centred on the aim point. No rotation while the smoothed midpoint is inside it. | PROXY: Cinemachine 3 dead-zone size when enabled is 0.2 [S35]. The height is reduced by JUDGEMENT because fighters barely move vertically. |
| Soft zone | Out to 0.80 of the screen. Damped correction happens here. | PROXY: Cinemachine soft zone / hard limit default 0.8 [S35] |
| Hard limit | Both fighters' capsules stay inside the action-safe area: 3.5% in from each edge. If breached, the camera corrects at the max rate (6.4). | SOURCED: EBU R95 [S30] |
| Reframe threshold | Start correcting only when the midpoint leaves the dead zone (±10% of width from centre). Stop when it is back within ±3%. | PROXY (from the dead zone) plus JUDGEMENT on the ±3% hysteresis. Operator number NOT FOUND (F11). |

### 6.3 Damping (critically damped springs)
| Channel | Half-life | Tag |
|---|---|---|
| Aim / pan-tilt rotation | **0.30 s** (allowed range 0.25–0.40) | PROXY: Cinemachine Group Framing damping 2 = 0.30 s half-life (COUNT from [S35]). Chosen over the 0.075 s rotation default because the broadcast goal is a "heavy camera" [S34]. |
| Camera position (dolly/orbit follow) | **0.45 s** | JUDGEMENT (slower than aim, so parallax doesn't wobble) |
| Zoom / FOV (live) | **1.0 s** | JUDGEMENT, anchored to "slow zoom" [S1] and "no fast zooms" [S29] |
| Orbit to stay perpendicular to the fighters' line | **1.5 s** half-life on the yaw target, plus rate cap 6.4 | UFC 5 Arcade intent "staying perpendicular to the fighters" [S46]. The number is JUDGEMENT (a watched fight needs no input-mapping stability, so it can be slower). |
| Spring type | Critically damped (damping ratio 1), frame-rate independent exact update. Not `lerp(a, b, k*delta)`. | SOURCED [S41][S42]. Godot's naive lerp overshoots when `speed*delta > 1` [S38]. |

### 6.4 Rate limits (applied after the spring)
| Parameter | Value | Tag |
|---|---|---|
| Max pan (yaw) speed during live action | **one frame width per 2.8 s**, i.e. hFOV / 2.8 deg/s. That is about 14°/s at 40° hFOV and about 21°/s at 60°. | PROXY: RED's 7 s-per-frame-width rule for 24 fps [S28], scaled by 60/24 because RED says higher frame rates allow faster pans. COUNT for the arithmetic. |
| Absolute pan cap | 25°/s | JUDGEMENT |
| Max pan acceleration | 40°/s² (a pan ramps up over about 0.5 s) | JUDGEMENT ("smooth and gradual" [S29]) |
| Max tilt speed | 50% of the pan cap | JUDGEMENT |
| Max zoom rate (live) | Change in ln(FOV) of at most **0.15 per second** (about 15% per second, so a 1.5× zoom takes about 2.7 s) | JUDGEMENT anchored to "slow zoom" [S1] and Nesky's "unexpected zooming is a big contributor of motion sickness" [S45] |
| Zoom hysteresis | Change the target FOV only if the required framing differs from the current one by more than **20%**, or has done so for more than **0.75 s** | JUDGEMENT. Kills the kick-driven zoom pump. |
| Deliberate push-in ("through the ropes" / drama) | Hold 1.0 s, then zoom in over 2–4 s, at most once per 20 s | SOURCED shape "hold the shot for a beat or two, then … push" [S1]. Numbers are JUDGEMENT. |
| Roll | 0° | SOURCED principle: roll is disorienting in regular game cameras [S43] |
| Camera shake on the live main camera | **None** | SOURCED principle: Nesky's "Excessively shaking the camera" [S44]; Undisputed players switch it off [S51] |

### 6.5 Shot sizes (vertical frame height, in fighter heights H)
| Shot | Frame height | Use | Tag |
|---|---|---|---|
| Cam 2 "trunks-up" (tight) | **0.75 H** | Pocket exchanges and corner barrages | SOURCED shot definition [S1]; the H value is JUDGEMENT (waist-up plus headroom) |
| Cam 1 "head-to-toe" (default live) | **1.4 H** (both full bodies plus about 15% margin) | Default; separation after "break" | SOURCED definition [S1]; value is JUDGEMENT |
| Wide live limit | **2.5 H** | Fighters far apart / circling | JUDGEMENT |
| Ring wide (cut only) | whole ring (about 4–5 H) | Establishing shot at round start and ring walks, never as a live zoom target | SOURCED: Camera 1 "starts with a big wide shot of the ring … and it pushes in" [S13] |
| Live clamp | 0.75 H to 2.5 H. Anything outside needs a **cut**, not a zoom. | JUDGEMENT, following F14 [S29] |

### 6.6 Camera positions to build
- **Ring (boxing, kickboxing, Muay Thai).** Cam 1/2 matched pair: one position 7–9 m from ring centre, lens about 1.6 m above the canvas (just clearing the second rope [S12]), looking slightly down. Cam 2 is the same spot, tighter. Our ring is 24 ft (7.3 m), ropes 22 ft [S10]. Cams 3/4 apron: about 1.2 m above canvas just outside the near ropes, wide lens (hFOV about 70°). Cam 5 at 90°: high, off one corner, for referee and corner shots only [S1]. Corner jib: slides round the referee instead of cutting [S2]. Canvas-level corner cams: replay only [S6][S8]. Roles are SOURCED; distances and heights are JUDGEMENT.
- **MMA cage.** Four elevated quadrant positions, lens about 1.2 m above the fence top, looking down [S3][S24][S25]. Add an overhead rail camera (about 10 m up, 9 m of travel) [S3][S21], a top-down robo camera, and fence-line POVs for replay [S17]. The live camera is the quadrant camera closest to the pair that sees them side-on. Layout SOURCED; selection rule JUDGEMENT.

### 6.7 Cut rules
| Rule | Value | Tag |
|---|---|---|
| Minimum live shot length | **3.0 s** (1.5 s only for an immediate reaction cut to a knockdown) | JUDGEMENT. ASL NOT FOUND. |
| Typical hold on Cam 1/2 | 8–20 s. Alternate angles 3–6 s, then back "home" | JUDGEMENT anchored to "go back to the main matched camera, then off to somewhere else" [S1] and "cut … a lot less" [S2] |
| Home rule | Every alternate-angle shot returns to Cam 1 (or Cam 2) before another alternate | SOURCED [S1] |
| Axis rule | Never cut between cameras on opposite sides of the fighters' line. Never apron to opposite apron. | SOURCED [S1]; Nesky's "Violating the 180 degree rule" [S44] |
| No cut mid-exchange | Suppress cuts while any strike is in flight or for 0.6 s after one lands. Queue the cut for the separation. | SOURCED principle [S2]. The 0.6 s is JUDGEMENT. |
| Separation / "break" | Cut to Cam 1 head-to-toe | SOURCED [S2] |
| Corner trap (fighter's back within 1.2 m of a corner, 1.5 s or longer) | Cut to Cam 2 tight. Escape back to Cam 1 when they leave. | SOURCED behaviour [S1]; thresholds JUDGEMENT |
| Action within 2 m of the near apron camera | Allowed cut to that apron camera, at most once per 30 s | SOURCED ("IN YOUR LIVING ROOM!") [S1]; numbers JUDGEMENT |
| Clinch (boxing) | Stay on Cam 2 tight. Cut to Cam 1 on the referee's break. | SOURCED ("break") [S2]; the clinch hold is JUDGEMENT |
| MMA ground position | Cut to the overhead/JITA or to the quadrant camera that sees both torsos. Hold at least 5 s. | JUDGEMENT (no source on ground coverage; NOT FOUND) |
| Fast (light) vs slow (heavy) fighters | Cut-rate multiplier 0.7× for fast fighters and 1.3× for slow heavyweights | SOURCED direction [S2]; multipliers JUDGEMENT |
| Cutting rate ceiling | At most 6 cuts per 3-minute round excluding replays (average shot at least 30 s) | JUDGEMENT (no ASL source) |

### 6.8 Knockdown, stoppage and replay rules
| Situation | Rule | Tag |
|---|---|---|
| Knockdown, live | Stay on the current Cam 1/2 or cut once to Cam 2 on the downed fighter. No slow motion live. | JUDGEMENT |
| Knockdown replay | During the count (or at the round break if the fighter rises fast): 1 or 2 replays, each 3–5 s of source at **6x** slow motion. First from the ringside low/side camera nearest the impact, second from the canvas-level or corner-crane angle. | SOURCED angles and speeds [S3][S8][S12]; lengths JUDGEMENT |
| Replay angle choice | Choose the camera that sees the landing limb's side (left or right strike) | SOURCED precedent: UFC 5 knows "right fist or a left fist … can place the cameras" [S47] |
| Round end | Up to 2 replays of the best exchange of the round (6x or 4x), then corner cams "each takes a fighter" | SOURCED [S12][S15][S3]; count JUDGEMENT |
| KO / stoppage | Live: hold the wide or tight shot that has both fighters for at least 3 s. Then the replay package: 3 angles (main side, low/canvas, overhead or crane), 6x. | SOURCED angle set [S3][S6][S8][S12]; count JUDGEMENT |
| Replay camera freedom | Replay cameras may be more cinematic, but no fist-cams | SOURCED: EA's "snaps you out of the immersion" [S48] |

---

## §7 Sources index (all read 2026-09-25)

| ID | Source | Date | Type | URL |
|---|---|---|---|---|
| S1 | Bad Left Hook, director Rick Tugman interview | 2023-11-12 (UTC) | BROADCAST (director, in PRESS) | https://www.badlefthook.com/2023/11/11/23932974/explainer-behind-the-scenes-sports-television-broadcast-tv-director-rick-tugman-boxing-news-2023 |
| S2 | SVG Europe, Sky Joshua v Klitschko (dir. Sara Chenery) | 2017-05-03 | TRADE / BROADCAST | https://www.svgeurope.org/blog/headlines/joshua-vs-klitschko/ |
| S3 | SVG, UFC 246 (Greg Louw, Concom) | 2020-01-17 | TRADE | https://www.sportsvideo.org/2020/01/17/ufc-246-conor-mcgregors-return-to-the-octagon-packs-a-hefty-production-punch/ |
| S4 | SVG, UFC Fight Island (Craig Borsari) | 2020-07-17 | TRADE | https://www.sportsvideo.org/2020/07/17/ufc-creates-live-production-ecosystem-from-scratch-on-fight-island-in-abu-dhabi/ |
| S5 | SVG, ESPN/Top Rank Vegas | 2020-06-09 | TRADE | https://www.sportsvideo.org/2020/06/09/espn-returns-to-live-events-ring-with-top-rank-boxing-productions-in-vegas/ |
| S6 | SVG, Wilder v Fury II | 2020-02-21 | TRADE | https://www.sportsvideo.org/2020/02/21/wilder-vs-fury-2-espn-fox-sports-team-up-on-outsize-boxing-production-in-vegas/ |
| S7 | SVG, Lomachenko v Lopez | 2020-10-16 | TRADE | https://www.sportsvideo.org/2020/10/16/lomachenko-vs-lopez-sets-up-as-one-of-espns-biggest-boxing-productions-of-the-year/ |
| S8 | SVG, PBC tech toys | 2015-03-13 | TRADE | https://www.sportsvideo.org/2015/03/13/premier-boxing-champions-offers-up-bevy-of-tech-toys-across-nbc-spike-tv-and-cbs/ |
| S9 | FOX Sports PressPass, PBC PPV | 2019-03-14 | PRESS | https://www.foxsports.com/presspass/blog/2019/03/14/fox-sports-packs-punch-dual-skycams-slo-mo-arsenal-pbc-title-fight-arlingtons-cowboys-cathedral/ |
| S10 | SVG, Showtime Mayweather v McGregor | 2017-08-25 | TRADE | https://www.sportsvideo.org/2017/08/25/mayweather-mcgregor-showtime-sports-to-deploy-most-cameras-ever-for-record-breaking-ppv-fight/ |
| S11 | PLSN, Modern-Day Boxing | 2015-10-15 | TRADE | https://plsn.com/articles/lighting-for-the-camera/modern-day-boxing/ |
| S12 | American Cinematographer, Southpaw (HBO operators) | AC Aug 2015, reposted 2024-07-27 | TRADE / BROADCAST operators | https://theasc.com/article/southpaw-mauro-fiore-2/ |
| S13 | Sony Pro, F5500 at Fury v Whyte (EMG) | 2022 (fight 2022-04-23) | PRESS (vendor) | https://pro.sony/ue_US/live-production/live-production-insights/tyson-fury |
| S14 | SVG Europe, BT Fury v Whyte (EMG) | 2022-05-20 | TRADE | https://www.svgeurope.org/blog/headlines/inside-the-production-of-bt-sports-tyson-fury-versus-dillian-whyte-fight-at-wembley-stadium-with-emg-uk/ |
| S15 | SVG Europe, DAZN Joshua v Dubois | 2024-09-23 | TRADE | https://www.svgeurope.org/blog/headlines/world-first-for-dazn-cloudbass-on-delivering-the-first-ever-full-cinematic-live-boxing-production-in-europe-for-the-joshua-v-dubios-fight/ |
| S16 | SVG Europe, Sky Haye v Bellew 2 | 2018-05-08 | TRADE | https://www.svgeurope.org/blog/headlines/live-from-the-o2-haye-bellew-2-gets-sky-sports-boxings-biggest-spec/ |
| S17 | WIRED, UFC 4K truck | 2016-11 | PRESS | https://www.wired.com/2016/11/inside-ufc-4k-truck/ |
| S18 | SVG, UFC 200 4K/HD | 2016-07-08 | TRADE | https://www.sportsvideo.org/2016/07/08/ufc-200-promises-robust-side-by-side-4k-1080i-live-productions/ |
| S19 | SVG, UFC at 30 (Borsari) | 2023-11-16 | TRADE | https://www.sportsvideo.org/2023/11/16/ufc-turns-30-craig-borsari-looks-back-at-three-decades-of-production-innovation-inside-the-octagon/ |
| S20 | SVG, UFC 300 | 2024-04-12 | TRADE | https://www.sportsvideo.org/2024/04/12/ufc-300-ppv-event-to-deploy-30-cameras-on-the-octagon-ar-graphics/ |
| S21 | SVG, UFC 306 Sphere | 2024-09-12 | TRADE | https://www.sportsvideo.org/2024/09/12/ufc-turns-up-the-production-and-operations-firepower-for-historic-pay-per-view-at-sphere/ |
| S22 | UFC 306 records press release PDF | 2024-09-25 | PRESS | https://s202.q4cdn.com/437702206/files/doc_news/2024/09/UFC-306-AT-SPHERE-SETS-RECORDS_Final-Sept-25-2024.pdf |
| S23 | SBJ, UFC Sphere tech | 2024-09-13 | PRESS | https://www.sportsbusinessjournal.com/Articles/2024/09/13/ufc-sphere/ |
| S24 | Fstoppers, UFC filming | 2018-04-05 | PRESS | https://fstoppers.com/originals/how-ufc-films-its-pay-view-events-and-promos-238825 |
| S25 | Bloody Elbow, UFC 100 production | 2009-07-13 | PRESS | https://bloodyelbow.com/2009/07/13/the-massive-task-of-producing-the/ |
| S26 | SVG, UFC Apex BOC; S26b SVG 2011 Concom/Fox (search snippet only) | 2020-11-13 / 2011-11-11 | TRADE | https://www.sportsvideo.org/2020/11/13/ufcs-ip-based-state-of-the-art-broadcast-ops-center-goes-live-at-ufc-apex-despite-pandemic/ ; https://www.sportsvideo.org/2011/11/11/concom-fox-sports-bring-ufc-to-the-masses/ |
| S27 | DV Info Net forum, Shooting Boxing | undated | COMMUNITY | https://www.dvinfo.net/forum/open-dv-discussion/465615-shooting-boxing-print.html |
| S28 | RED, Panning Speed Best Practices | undated | DEV (manufacturer guide) | https://www.reddigitalcinema.com/red-101/camera-panning-speed |
| S29 | MHSAA single-camera football best practices | undated | BROADCAST guidance | https://www.mhsaa.com/sites/default/files/Media/SBP/Best%20Practices%20Single%20Camera-Football.pdf |
| S30 | EBU R 95 v1.1 safe areas | 2017-06 | STANDARD | https://tech.ebu.ch/docs/r/r095.pdf |
| S31 | Wikipedia, Headroom | live page | COMMUNITY | https://en.wikipedia.org/wiki/Headroom_(photographic_framing) |
| S32 | Ludwig & Bertling, cutting rates (abstract) | 2017 | ACADEMIC (abstract only) | https://www.bisp-surf.de/Record/PU202003001458 |
| S33 | Cinemachine 2.10 Framing Transposer docs | 2.10.7 docs | DEV | https://docs.unity3d.com/Packages/com.unity.cinemachine@2.10/manual/CinemachineBodyFramingTransposer.html |
| S34 | Cinemachine 3.1 Position Composer docs | 3.1.7 docs | DEV | https://docs.unity3d.com/Packages/com.unity.cinemachine@3.1/manual/CinemachinePositionComposer.html |
| S35 | Cinemachine source, main branch (defaults, Damper) | fetched 2026-09-25 | DEV | https://github.com/Unity-Technologies/com.unity.cinemachine/tree/main/com.unity.cinemachine/Runtime |
| S36 | Godot class XML (Camera2D/3D, SpringArm3D) | fetched 2026-09-25 | DEV | https://github.com/godotengine/godot/tree/master/doc/classes |
| S37 | Godot camera_2d.cpp | fetched 2026-09-25 | DEV | https://github.com/godotengine/godot/blob/master/scene/2d/camera_2d.cpp |
| S38 | Godot PR #114824 | 2026-01 | DEV | https://github.com/godotengine/godot/pull/114824 |
| S39 | Godot docs, physics interpolation | latest | DEV | https://docs.godotengine.org/en/latest/tutorials/physics/interpolation/advanced_physics_interpolation.html |
| S40 | Phantom Camera phantom_camera_3d.gd | fetched 2026-09-25 | DEV | https://github.com/ramokz/phantom-camera/blob/main/addons/phantom_camera/scripts/phantom_camera/phantom_camera_3d.gd |
| S41 | Holden, Spring-Roll-Call | 2021 | ACADEMIC/DEV | https://theorangeduck.com/page/spring-roll-call |
| S42 | Juckett, Damped Springs | undated | DEV | https://www.ryanjuckett.com/damped-springs/ |
| S43 | Haigh-Hutchinson, GDC 2005 paper (mirror) | 2005 | DEV | https://www.sambuz.com/doc/fundamentals-of-real-time-camera-design-pdf-document-728929 |
| S44 | Nesky, 50 Game Camera Mistakes (notes + Vault) | 2014 | DEV via COMMUNITY notes | https://shermanrose.uk/knowledge/programming/games/50-game-camera-mistakes/ ; https://gdcvault.com/play/1020460/50-Camera |
| S45 | Nesky, Georgia Tech talk (auto-captions) | 2013-04-15 | DEV (auto-captions) | https://www.youtube.com/watch?v=qHhetpaZBTs |
| S46 | EA, UFC 5 post-beta changes | 2023-10-08 | DEV | https://www.ea.com/games/ufc/ufc-5/news/ufc-5-post-beta-changes |
| S47 | EA, UFC 5 presentation | 2023 | DEV | https://www.ea.com/games/ufc/ufc-5/news/ufc-5-presentation |
| S48 | GameSpot, EA UFC (Brian Hayes) | 2014-06-06 | PRESS | https://www.gamespot.com/articles/how-ea-sports-ufc-wants-to-show-off-ps4-and-xbox-one-potential/1100-6419785/ |
| S49 | GameSpot, Fight Night Round 2 Q&A | 2004-12-07 | PRESS | https://www.gamespot.com/articles/fight-night-round-2-working-title-qanda/1100-6114568/ |
| S50 | Dexerto, UFC 5 camera settings | 2023 | PRESS | https://www.dexerto.com/gaming/best-camera-settings-for-ufc-5-2355024/ |
| S51 | Steam, Undisputed camera thread | 2025-09-06 | COMMUNITY | https://steamcommunity.com/app/1451190/discussions/0/594033220191062932/ |
| S52 | Undisputed update notes | 2023-04-17 | DEV | https://playundisputed.com/news/update-notes-17april2023 |
| S53 | EA, Madden 27 presentation | 2026 | DEV | https://www.ea.com/games/madden-nfl/news/madden-27-sights-and-sounds |
| S54 | GDC Vault, Juicing Your Cameras (abstract) | 2016 | DEV | https://gdcvault.com/play/1023146/Math-for-Game-Programmers-Juicing |

---

## §8 Still unknown (NOT FOUND)

1. **The share of live airtime per camera** (for example "Cam 1 is on air X% of a round"). Found only qualitatively: "most of what a viewer sees" [S1] and "four handheld cameras" [S3].
2. **Average shot length or cuts per minute on a live boxing or MMA feed.** No published study or trade figure found, and not measured (see §9).
3. **Operators' numeric framing rules**: drift before reframing, two-shot headroom %, pan deg/s, zoom time.
4. **Interviews with UFC live director Anthony Giordano on framing or cutting.** He is named as the long-time UFC live director [S26b], but I found no craft interview.
5. **MMA ground-fighting coverage rules** (which camera carries grappling). The overhead cameras exist [S4][S23], but no quote ties them to ground fighting.
6. **ONE Championship, PFL and Bellator camera plans.** Not found in the trade press searched.
7. **Fight-game camera numbers**: EA UFC 1–5, Fight Night Champion and Undisputed publish no dead-zone, spring, aim-target or rate-limit values. The same goes for FIFA, NBA 2K and Madden broadcast cameras.
8. **Lens focal lengths for real UFC cage cameras.** HBO boxing lenses are known only from a film recreation [S12].
9. **Full text of the GDC talks** (see §9).

## §9 Limits

- **Blocked or partial reads.** ResearchGate timed out (abstract read via BISp SURF). The GDC S3 PDF for S43 was not a PDF, so a mirror was used. RED was read via curl; ASC and Sony via WebFetch. The GitHub API was rate-limited, so Cinemachine defaults come from raw `main` files and may differ in other versions.
- **Auto-captions.** S45 was read from YouTube auto-captions, so the wording may contain transcription errors. Captions for "50 Game Camera Mistakes" (C7307qRmlMI) and a UFC behind-the-scenes video (qLI-yPSoZB0) were rate-limited and not read.
- **No video was downloaded**, so there is no ASL COUNT. The COUNT items are arithmetic only: damp time to half-life (T × ln2/ln100), SmoothDamp half-time, the Godot speed approximation, and pan rates.
- **Film vs broadcast.** S12 is a film recreating HBO coverage with HBO operators; its lenses and heights are "HBO-style", not a verified HBO plan.
- **Interviewer insertions.** Some bracketed phrases in S1 are the writer's, not Tugman's; claims rest on Tugman's own words.
- **Instructions in fetched content.** None tried to instruct me; only ordinary newsletter boilerplate (SVG Europe safe-sender request), ignored.
- **Recency.** Camera counts are per-event examples (2015–2024), not constants.

---

## Appendix A: Grok leads, unverified (not counted anywhere above)

The Grok CLI pass (grok-4.6, xhigh, live search) ran to completion (exit 0, about 5.3 min). The leads below were **not** re-checked by me and are not used in §0–§6. Re-checked leads were promoted into the body (e.g. S12, S13, S16, S18, S19, S26, S44, S45, S47, and the Godot lerp example in S39).

- grok lead, unverified: A UFC camera operator (UFC 108 behind-the-scenes video) says his camera does "the standup head to toe … considered like … your safety camera. So I get a lot of the stuff that is replayed." https://www.youtube.com/watch?v=qLI-yPSoZB0 (2012). Captions were rate-limited.
- grok lead, unverified: SVG 2014, Showtime 4K X-Mo replays ("the mouth piece getting punched out"). https://www.sportsvideo.org/2014/05/16/showtime-boxing-rings-bell-on-inertia-unlimited-4k-x-mo/
- grok lead, unverified: SVG Europe 2025, DAZN Eubank Jr v Benn II: 26 cameras including four F5500Vs, six 3500Vs, Luna Falcon 4-point, three drones. https://www.svgeurope.org/blog/headlines/epic-rematch-dazn-on-bringing-eubank-jr-v-benn-ii-to-spectacular-life-with-1080p-hdr-cinematic-cameras-and-drones/
- grok lead, unverified: TVBEurope 2021: "Matchroom Media will be responsible for live production of the fights, working in close collaboration with DAZN." https://www.tvbeurope.com/live-production/dazn-packs-a-punch-with-matchroom-boxing-deal
- grok lead, unverified: Undisputed ships Zoomed Out / Zoomed In / Ring Dolly / Over the Shoulder cameras, and a YouTuber says Ring Dolly "moves too much". https://www.youtube.com/watch?v=LUnOLRHsAQ4 (2024-10-23)
- grok lead, unverified: Undisputed X post 2022-02-17 on "camera changes". https://x.com/PlayUndisputed/status/1494371692914880512
- grok lead, unverified: Fight Night Champion player guide: default "Dynamic" camera "limits your field of view"; "Wide" shows more of the ring. https://gameslatestnews.com/2025/07/26/fight-night-champion-camera-hud-guide/
- grok lead, unverified: UFC 5 patch notes: "Fixed a camera issue that occurred during the ground game after the bodylock trip from a double-leg drive." https://www.battlefield.com/games/ufc/ufc-5/news/ufc-5-patch-notes-1 (2023-12-06)
- grok lead, unverified: Unity SmoothDamp implements Thomas Lowe, "Critically Damped Ease-In/Ease-Out Smoothing", Game Programming Gems 4 (2004), pp. 95–101. https://www.alexisbacot.com/blog/the-art-of-damping ; https://gameenginegems.com/gemsdb/article.php?id=274
- grok lead, unverified: a mirrored Cinemachine manual says a large soft zone gives "really nice camera weight and lag. This is what real camera operators do!" https://manuals.plus/m/716f7b46a778f8ca58eaed290766217b9a499eab4ed0410b57b5d413defad0f3.
