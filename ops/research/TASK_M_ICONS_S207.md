TASK M_ICONS_S207 (Maria, art direction) - FightCamp S207

FightCamp is a PC deep boxing-gym management sim (Football Manager class). The fighter profile's Techniques tab will show the
boxer's moves as an ICON GRID (the operator asked: "i would like to see icons of the moves there"). Our lead designer (Ludo)
wrote the icon art spec below. Your job: draw 6 SAMPLE icons that follow it exactly, so the operator can judge the style before
all 54 get made.

Draw these 6 (one consistent style, 256x256 each, on the spec's tile background, plus ONE sheet with all 6 in a row):
  1. Jab (boxing_jab)  2. Rear Cross (boxing_cross)  3. Lead Hook (boxing_lead_hook)  4. Slip (boxing_slip)
  5. Inside Uppercut (boxing_inside_uppercut)  6. High Guard / Stance (boxing_stance_guard)
Then show tile states on the Jab icon: LEARNED, LEARNABLE/IN TRAINING, LOCKED, IN DEMO (spec's colours and badges).
Rules: our UI highlight teal is reserved for the UI - follow the spec's colours; no text inside the pictogram except the badges;
readable at 64x64. Reply with the images and a short note of anything in the spec you could not follow and why.

=== LUDO'S ICON ART SPEC (verbatim, first part - the global style guide and the families; the rest repeats the pattern) ===
Here is the complete, production-ready art specification for all 54 nodes of the technique tree, designed for an icon sheet or sprite atlas (e.g., an 8×7 grid of 128×128 or 256×256 master vectors).

GLOBAL ART & ICON STYLE GUIDE (For Artists & Texture Pipelines)
Canvas & Dimensions: Master resolution 256×256 px (rendered down to 64×64 px and 48×48 px in-engine without loss of legibility).
Grid & Safety Margins: Outer boundary padding of 16px. Primary visual action contained within a circular safe area d = 224px.
Perspective & Camera:
Strikes, Hooks, & Combos: 3/4 isometric side-profile or clean lateral profile.
Footwork & Ring Craft: High-angle top-down (downward $60^\circ$ bird’s-eye perspective on canvas texture with footprint decals and rotational vectors).
Infighting & Clinch: Chest-level frontal/isometric close-contact.
Palette & Rendering Style: High-contrast graphic minimalism (Vector / Precision Blueprint aesthetic):
Background Container: Dark slate vignette (#0F172A center to #020617 edge), subtle diagonal carbon-fiber/canvas hatch at 5% opacity.
Player Fighter Anatomy (Executor): Stark clean chalk white (#F8FAFC) silhouette line work with solid #1E293B inner body fills. Left hand/glove identified with subtle cyan rim lighting (#38BDF8), right hand/glove identified with subtle steel rim lighting (#94A3B8).
Opponent Anatomy (Dummy / Target): Muted slate silhouette (#475569) with 40% alpha, dashed outlines (#334155) to indicate incoming strikes or target zones.
Kinetic Vector & Impact Language:
Thrust/Impact Vectors: Bold vibrant gold (#D69E2E) arrows with tapering speed trails.
Defensive Evasions: Electric cyan (#38BDF8) motion displacement arcs.
Opponent Incoming Threats: Desaturated crimson (#EF4444) dashed attack lines showing avoided danger.
Target Impact Starburst: Concentric sharp geometric shock diamond (#F59E0B) at point of impact.
COMPLETE 54-NODE TECHNIQUE PICTOGRAM DIRECTORY
BRANCH 1: FUNDAMENTALS (3 NODES)
+------------------------------------------------------------------------------------------------------+
| ID: boxing_stance_guard | NAME: Stance and High Guard | TIER: T1 Foundation                          |
| COMPOSITION: Frontal 3/4 torso view of orthodox boxer. Both gloves raised to temple/cheekbone level. |
| Gloves form a tight defensive barrier with elbows tucked parallel protecting floating ribs.         |
| KEY ACCENTS: Dual vertical cyan guard brackets flanking the boxer's head, indicating cover.          |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_distance_read | NAME: Finding the Range | TIER: T1 Foundation                             |
| COMPOSITION: Profile silhouette. Lead arm extended forward with an open/half-clenched glove lightly  |
| measuring distance against an opponent's forehead silhouette.                                        |
| KEY ACCENTS: Horizontal segmented gold measurement calipers (radar/ruler tick marks) between gloves. |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_breathing_rhythm | NAME: Breathing and Rhythm | TIER: T1 Foundation                       |
| COMPOSITION: Boxer silhouette in relaxed, spring-loaded bounce posture. Stylized lungs/diaphragm core |
| glowing softly with rhythmic sine-wave rings radiating outward from the mouth/nose.                  |
| KEY ACCENTS: Twin pulsing cyan wave-crests undulating horizontally beneath the boxer's feet.         |
+------------------------------------------------------------------------------------------------------+

BRANCH 2: STRAIGHT PUNCHING (7 NODES)
+------------------------------------------------------------------------------------------------------+
| ID: boxing_jab | NAME: Jab | TIER: T1 Foundation                                                     |
| COMPOSITION: Pure profile view facing right. Left lead arm fully extended horizontally like a piston |
| at head height. Rear right glove glued to chin.                                                      |
| KEY ACCENTS: Straight, razor-sharp gold spear vector through the glove centerline into a small impact |
| diamond.                                                                                             |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_cross | NAME: Rear Cross | TIER: T1 Foundation                                            |
| COMPOSITION: Dynamic 3/4 rear-to-front perspective. Right shoulder violently driven forward, hips    |
| rotated, rear foot pivoted on ball. Rear fist extended deep into opponent's center-line.             |
| KEY ACCENTS: Heavy rotational torque arrow around waistline, followed by a thick gold power arrow.   |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_double_jab | NAME: Double Jab | TIER: T2 Core                                             |
| COMPOSITION: Profile view. Lead arm rendered with twin motion ghosting (overlapping trail frames) in |
| rapid succession. Two consecutive fist silhouettes.                                                  |
| KEY ACCENTS: Dual stacked gold chevron arrows (`>>`) accelerating toward the opponent's face.        |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_jab_body | NAME: Jab to the Body | TIER: T2 Core                                          |
| COMPOSITION: Low profile view. Boxer has dipped knees and bent waist, shooting the lead jab down at  |
| a 30-degree declining angle beneath an opposing high guard into the solar plexus.                    |
| KEY ACCENTS: Downward-angled gold thrust arrow terminating at an illuminated target zone on torso.  |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_cross_body | NAME: Cross to the Body | TIER: T2 Core                                      |
| COMPOSITION: Deep level change. Right knee lowered near canvas, hips fully engaged, rear fist driving |
| forward and downward directly into the stomach of an upright opposing silhouette.                    |
| KEY ACCENTS: Downward diagonal heavy gold vector with trailing spiral wind-up line.                  |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_up_jab | NAME: Up Jab | TIER: T3 Advanced                                                 |
| COMPOSITION: Crouched boxer exploding vertically. Lead fist rising along an upward 45-degree angle   |
| from a low, non-telegraphed hip origin directly underneath the opponent's guard.                     |
| KEY ACCENTS: Vertical ascending gold arrow with an upward speed-line spray.                          |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_overhand | NAME: Overhand Right | TIER: T3 Advanced                                       |
| COMPOSITION: Aggressive 3/4 angle. Boxer ducking head slightly off-center to the left, rear arm      |
| looping high over the top in a violent, looping overhead downward arc.                              |
| KEY ACCENTS: Pronounced downward-curving gold rainbow-arc vector smashing through a raised guard.    |
+------------------------------------------------------------------------------------------------------+

BRANCH 3: HOOKS & BODYWORK (7 NODES)
+------------------------------------------------------------------------------------------------------+
| ID: boxing_lead_hook | NAME: Lead Hook | TIER: T2 Core                                               |
| COMPOSITION: Front-facing 3/4 view. Lead left arm bent at a rigid 90-degree angle, elbow level with  |
| shoulder, torso rotated sharply right on lead heel pivot.                                            |
| KEY ACCENTS: Broad horizontal curved gold scythe vector cutting across the frame to the jaw target.  |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_rear_hook | NAME: Rear Hook | TIER: T2 Core                                               |
| COMPOSITION: Mirrored 3/4 angle. Right arm looping horizontally, rear shoulder swung forward, weight |
| transferred across the front foot.                                                                   |
| KEY ACCENTS: Wide looping inward gold power arc striking the left temple/jawline of the dummy.       |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_lead_uppercut | NAME: Lead Uppercut | TIER: T2 Core                                       |
| COMPOSITION: Close isometric view. Lead arm dropped low then driving strictly upward, palm facing    |
| backward, knees rising out of a crouch.                                                              |
| KEY ACCENTS: Vertical straight upward gold rocket arrow splitting the gap between opposing gloves.   |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_rear_uppercut | NAME: Rear Uppercut | TIER: T2 Core                                       |
| COMPOSITION: Rear leg driving upward from the floor. Rear fist rising in a tight vertical power line |
| straight under the chin silhouette.                                                                  |
| KEY ACCENTS: Deep upward spiral vector with an explosive impact diamond under the jaw.              |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_body_hook | NAME: Lead Hook to the Body | TIER: T3 Advanced                               |
| COMPOSITION: Crouched profile. Left arm executing a tight, vicious 90-degree hook specifically       |
| targeting the lower right side (anatomical liver zone) of the opponent's torso.                      |
| KEY ACCENTS: Horizontal curving gold arc targeting a highlighted amber liver silhouette graphic.     |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_rear_hook_body | NAME: Rear Hook to the Body | TIER: T3 Advanced                          |
| COMPOSITION: Boxer driving rear hook inward into the opponent's spleen/rib area on the left side of  |
| their body. Rear shoulder dipped.                                                                    |
| KEY ACCENTS: Inward-driving gold sickle vector slamming into the lower ribcage area.                 |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_shovel_hook | NAME: Shovel Hook | TIER: T3 Advanced                                       |
| COMPOSITION: 45-degree hybrid strike: half hook, half uppercut. Fist angled diagonally upward and    |
| inward, digging directly under the opponent's floating ribcage.                                      |
| KEY ACCENTS: Upward-diagonal 45-degree gold wedge arrow with concussive shockwave rings.             |
+------------------------------------------------------------------------------------------------------+

BRANCH 4: COMBINATIONS (6 NODES)
+------------------------------------------------------------------------------------------------------+
| ID: boxing_one_two | NAME: One-Two | TIER: T1 Foundation                                             |
| COMPOSITION: Sequential twin-fist display. Faint lead jab glove leading, followed immediately by a  |
| dominant, fully driven rear cross behind it.                                                         |
| KEY ACCENTS: Numbered badges `"1"` (cyan) and `"2"` (gold) linked by a linear kinetic trail ribbon.  |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_one_two_hook | NAME: One-Two-Hook | TIER: T2 Core                                         |
| COMPOSITION: Three-strike cascade: Straight jab line, followed by a straight cross line, terminating |
| in a sharp horizontal lead hook arc.                                                                 |
| KEY ACCENTS: Cascading numbered pills `"1" -> "2" -> "3"` forming an "L" shaped strike trajectory.  |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_jab_body_head | NAME: Jab Body, Jab Head | TIER: T3 Advanced                              |
| COMPOSITION: Split-level visualization. Lower ghosted jab arrow targeting torso, instantly followed  |
| by an elevated upper solid jab arrow snapping the chin upward.                                       |
| KEY ACCENTS: Vertical zig-zag gold vector connecting low hit zone to high hit zone.                  |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_counter_combination | NAME: Counter Combination | TIER: T4 Signature                      |
| COMPOSITION: Boxer slipping an incoming crimson punch line, followed by a fast two-punch return      |
| cross and hook combo striking the exposed opening.                                                   |
| KEY ACCENTS: Incoming red threat dashed line deflecting wide, countered by twin linked gold bolts.   |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_liver_combo | NAME: Jab-Cross-Lead Hook to the Body | TIER: T4 Signature                  |
| COMPOSITION: Dual high punches targeting the guard, forcing the dummy's hands upward, leaving the   |
| lower torso wide open for a vicious dipping lead hook.                                               |
| KEY ACCENTS: Two high red diversion vectors, crowned by a massive gold scythe targeting the liver.   |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_six_punch_combo | NAME: Six-Punch Combination | TIER: T4 Signature                        |
| COMPOSITION: Flurry of fists represented by an intricate, flowing geometric web of 6 striking vectors|
| (Jab, Cross, Hook, Uppercut, Hook, Cross) overwhelming a guarded silhouette.                         |
| KEY ACCENTS: Circular energy ribbon containing 6 gold stars surrounding a broken shield icon.        |
+------------------------------------------------------------------------------------------------------+

BRANCH 5: DEFENSE & COUNTERS (15 NODES)
+------------------------------------------------------------------------------------------------------+
| ID: boxing_catch | NAME: Catch the Jab | TIER: T1 Foundation                                         |
| COMPOSITION: Front-facing perspective. Boxer's rear right glove open with palm facing outward like a |
| baseball mitt, smothering an incoming red jab fist inches from their face.                           |
| KEY ACCENTS: Circular cyan shock-absorption ring radiating from the center of the catching palm.     |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_parry | NAME: Parry | TIER: T1 Foundation                                                 |
| COMPOSITION: Boxer's open lead glove performing a crisp downward/inward slap against the wrist of an  |
| incoming red strike, redirecting it harmlessly off-target.                                           |
| KEY ACCENTS: Angular cyan deflection arrow pushing the red punch trajectory downward at 45 degrees.  |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_slip | NAME: Slip | TIER: T1 Foundation                                                   |
| COMPOSITION: Torso and head tilted sharply off the center line. An incoming straight punch passes     |
| directly over the boxer's dipped shoulder through empty air.                                         |
| KEY ACCENTS: Cyan curved dodge arrow around the red attack line; double-line center-axis marker.     |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_block_elbow | NAME: Elbow and Forearm Block | TIER: T2 Core                               |
| COMPOSITION: Boxer raising their left elbow high and turning forearm inward, fielding a heavy hook   |
| cleanly on the thick triangular elbow bone and forearm meat.                                         |
| KEY ACCENTS: Heavy cyan armor-plate chevron overlaying the raised forearm; spark on point of impact. |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_bob_weave | NAME: Bob and Weave | TIER: T2 Core                                           |
| COMPOSITION: Boxer dipping their entire upper body beneath a swinging red hook in a deep, circular   |
| "U" shaped duck-and-roll movement.                                                                   |
| KEY ACCENTS: Prominent cyan "U" shape curved vector dipping low and surfacing on the other side.     |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_catch_counter | NAME: Catch and Return | TIER: T2 Core                                    |
| COMPOSITION: Right hand catches an incoming jab while the left hand simultaneously explodes forward  |
| with a return counter-punch into the opponent's exposed jaw.                                         |
| KEY ACCENTS: Twin simultaneous vectors: Cyan catch pad on right, Gold linear counter-arrow on left.  |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_pull | NAME: Pull | TIER: T2 Core                                                         |
| COMPOSITION: Boxer bending sharply backward at the waist and hips by 2 inches, allowing an incoming  |
| punch to miss the tip of their nose by millimeters.                                                  |
| KEY ACCENTS: Backward-curving cyan motion vector arching away from a frustrated red punch line.      |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_roll | NAME: Roll Under | TIER: T2 Core                                                   |
| COMPOSITION: Boxer transferring weight smoothly from lead leg to back leg while rolling shoulders in |
| a continuous semi-circle under an incoming cross.                                                    |
| KEY ACCENTS: Circular sweeping cyan orbital path wrapping underneath the incoming attack vector.     |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_slip_counter | NAME: Slip-Cross Counter | TIER: T2 Core                                   |
| COMPOSITION: Boxer slips head to the outside of an incoming jab, instantaneously firing a hard rear   |
| cross over the opponent's outstretched arm.                                                          |
| KEY ACCENTS: Diagonal slip displacement indicator paired with a straight gold counter-strike bolt.   |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_check_hook | NAME: Check Hook | TIER: T3 Advanced                                         |
| COMPOSITION: Opponent aggressively charging forward. Boxer pivoting 90 degrees on lead foot, hitting |
| a sharp lead hook that catches the rusher flush as the boxer pivots clear.                           |
| KEY ACCENTS: Circular rotational compass pivot on canvas + wide horizontal gold hook vector.         |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_check_hook_pivot | NAME: Check Hook and Pivot | TIER: T3 Advanced                         |
| COMPOSITION: Complete sequence of the check hook, displaying the full exit angle: Boxer landing hook  |
| and completely clearing out to the opponent's blind side.                                            |
| KEY ACCENTS: 90-degree curved escape path vector sweeping behind the charging red opponent.          |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_counter_over_jab | NAME: Counter Over the Jab | TIER: T3 Advanced                         |
| COMPOSITION: Opponent's low jab extended. Boxer's right arm looping cleanly over top of the opponent's|
| lead shoulder and arm, driving straight down the pipe into their chin.                               |
| KEY ACCENTS: Elevated over-the-top gold trajectory crossing over a depressed red vector.             |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_long_guard | NAME: Long Guard | TIER: T3 Advanced                                         |
| COMPOSITION: Boxer posting their lead arm fully extended with palm braced against opponent's forehead |
| or shoulder, while rear glove covers their own chin, creating a stiff distance barrier.              |
| KEY ACCENTS: Horizontal rigid cyan beam acting as a spacer bar preventing forward entry.             |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_pull_counter | NAME: Pull-Cross Counter | TIER: T3 Advanced                               |
| COMPOSITION: Signature Mayweather-style move: Head pulled back just out of range of a jab, then rear |
| cross snaps forward instantly like a coiled spring into the opening.                                 |
| KEY ACCENTS: Spring-coil tension graphic expanding into a laser-straight gold counter-punch vector.  |
+------------------------------------------------------------------------------------------------------+
| ID: boxing_shoulder_roll | NAME: Shoulder Roll | TIER: T3 Advanced                                   |
| COMPOSITION: Philly Shell stance. Lead shoulder rolled high to tuck the chin, rear hand covering jaw. |
| An incoming right hand bounces harmlessly off the sloped shoulder muscle.                            |
| KEY ACCENTS: Deflection arc spraying upward off an illuminated cyan shoulder armor emblem.           |
+------------------------------------------------------------------------------------------------------+

BRANCH 6: FOOTWORK & RING CRAFT (11 NODES)
+------------------------------------------------------------------------------------------------------+
[... spec continues for the remaining technique families in the same pattern ...]
