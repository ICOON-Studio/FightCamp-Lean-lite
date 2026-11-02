# JOHN_MOCAP_MORE_S271 - where do we get MORE real boxing motion capture like the Rokoko free takes? (research only)

Operator S271, on the 11 Rokoko free-fight renders: "all 11 look perfect , how can we make more of those ?"
What we have: Rokoko "13 free fight animations" (captured by Sam Lazarus with a Rokoko suit; free for any game, commercial).
5 boxing takes (Boxing, ShadowBoxing, FightingIdle, 2 knockouts) -> 10 single punches cut, mostly jabs + 1 cross + 1 rear body shot.
We need: lead/rear hooks, uppercuts (lead + rear), body hooks, slips, rolls, blocks/parries, head + body hit reactions, clinch
entry, footwork (step in/out, pivot, circle), knockdown + get-up, corner sitting. Skeleton: anything Mixamo-named or UE5 Manny
retargets cleanly through our MixamoMotion path. Budget: ZERO money right now (operator: "i dont have money now").
Already out (do not propose): ViCoS, QuickMagic, Harmony4D (licence), Bandai Namco dataset (non-commercial), Ludo text-to-motion
(tested S270, all takes failed), Mixamo/ActionForge/H2H (owned, not boxing), Meshy library (owned, 45 clips - being judged now).

Answer, longest complete answer you can give, every claim with its URL and the licence text quoted:
1. Every FREE source of real (captured, not keyframed) boxing / martial-arts-striking mocap whose licence allows a commercial game:
   Rokoko's other free packs / Rokoko Motion Library free items, CMU Graphics Lab Motion Capture Database (which subjects are
   boxing; its exact licence wording), Mixamo's mocap-origin boxing clips, university datasets, Unity/Unreal free packs, itch.io.
2. VIDEO -> MOCAP tools with a free tier whose output we may ship commercially: Rokoko Vision (free tier limits, clip length,
   export format, licence of output), Move.ai, DeepMotion Animate 3D, Plask, RADiCAL, FreeMoCap (open source), any other.
   For each: what a single phone video of a real boxer shadowboxing would give us, how clean hands/feet are, known failure modes.
3. If we film our own boxer (a local gym, a phone on a tripod): the exact capture recipe (camera height/distance, fps, clothing,
   lighting, one move per take, take length) that gives the cleanest result in the best free tool from (2).
4. Rank the top 5 routes by (quality of boxing motion) x (zero cost) x (licence safety), with the first concrete step for each.
