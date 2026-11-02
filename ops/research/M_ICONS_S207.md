# M_ICONS_S207 - Maria's reply, verbatim (gbot thread 'Maria Art Director', saved S208 2026-10-12). Images: _maria_delivery/M_ICONS_S207 (requested S208)

[send-message t44s377] I'm on M_ICONS. I'm drawing the 6 sample move icons as vector art to Ludo's spec at 256×256, plus a sheet of all six and the four tile states on the Jab. I'm also checking each one still reads at 64×64.
[send-message t44s378] The six icons are being drawn now as clean vector art in Ludo's palette, and each one goes through at least two passes at 64px to make sure the jab, cross, hook and uppercut tell apart at that size.

Two gaps in the spec so far:
- **Inside Uppercut:** the excerpt has no entry for it, so I'm building it from the lead and rear uppercut entries using the spec's infighting camera.
- **Tile states:** the excerpt doesn't cover them, so I'll propose LEARNED, LEARNABLE/IN TRAINING, LOCKED and IN DEMO using only spec colours, with each state shown by its badge and border shape so it never depends on colour.
[send-message t44s379] Here are the 6 sample move icons, drawn as vector art to Ludo's spec at 256×256 on the slate tile, and the four tile states on the Jab. The third image is the same six at 64px, so you can judge readability at game size. One body build draws all six, so head, gloves, line weight and limbs match.

**Spec points I couldn't follow exactly, and why**
1. **Inside Uppercut:** the excerpt has no entry for it, so I built it from the lead and rear uppercut entries. The "palm facing backward" detail can't show on a round glove.
2. **Camera on the uppercut and hook:** the uppercut is near-profile instead of frontal, because a frontal view hid the opponent's guard. The hook's camera is 28° off profile instead of front-facing 3/4, because front-on the bent arm collapses into a straight bar.
3. **Rear-to-front cross:** it's weak at 64px. It reads from the waist torque ring and the thicker arrow, and without those it would look close to the jab.
4. **Tile states:** the excerpt doesn't define them, so these are my proposal, in spec colours only, never our UI teal. LEARNED is a gold border with a check. IN TRAINING is a slate border with a 60% cyan ring and a dumbbell. LOCKED is greyed to 35% with a dashed border and a padlock. IN DEMO is an amber corner ribbon with a play badge. Each state differs by shape, not just colour.
5. **Small sizes:** the 5% hatch disappears at 64 and 48px, so I suggest dropping it from the small exports. The speed trails and concentric diamonds shrink to slivers and a spark at 48px, but the arrow direction still separates the strikes.
6. **Opponent:** behind the spec's 40% slate ghost I added a faint dark fill (`#0B1222`, not a spec colour) so overlapping limbs don't turn to mush.
7. **Cyan vs teal:** the spec's cyan `#38BDF8` is a different colour from our UI teal, but next to the HUD the two will read as the same family. Worth a look before all 54 are made.

Weakest at 64px: the Inside Uppercut, where the two bodies clump together, then the Lead Hook and the Cross. The Jab, Slip and Guard read cleanly. All the files are on my computer in `/workspace/fightcamp-icons/`, including the SVG masters.
