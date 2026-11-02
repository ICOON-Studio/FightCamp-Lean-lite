# Two Point Museum HUD numbers (S268) - layout rules only, nothing shipped

Operator S268: "i want this to be at 2point museum standards they use icons and nice modals". Method = S243 (UnityPy 1.25.3,
fallback 6000.0.63f1, his install, dumps outside the repo: E:/FightCamp/tmp/tpm_study/hud, script hud_dump.py / hud_sprites.py).
Ghidra not used: the HUD layout lives in the asset bundles (RectTransforms), not in GameAssembly code.

TPM authors its UI on a 3840x2160 canvas. Halved for our 1080p:

| element | TPM (4K) | ours (1080p) | source |
|---|---|---|---|
| modal title bar | 160 px | 80 px | MessageTutorialPopupUI */TopPanel |
| panel title bar | 115 px | ~57 px | UI_InGame_Building_P_QueueBuildInfo/MainPanel/TitleBar |
| screen margin of a docked panel | 64 px | 32 px | QueueBuildInfo pos (64, -64) |
| modal content column | 1024 px wide, 3 columns at -600/0/600 | 512 px | ContentPanel0..2 |
| modal button row | 1200 x 120 | 600 x 60 | BottomPanel/button |
| modal body text | 42 pt | 21 px | ContentPanel*/text |
| tooltip | 570 px wide, title 36 pt, body 30 pt | 285 px, 18 / 15 px | UI_General_P_Tooltip_ItemSelectionEntry |
| HUD resource icons | 70-90 px (tiny 42) | 35-45 px (21) | UI_Atlas_HUD_Shared (Cash, Kudosh, MuseumLevel) |
| inspector stat icons | 106 px | 53 px | RightInspector_Knowledge / BuzzRating |
| meter bar | 260 x 45, icon base circle 62 | 130 x 22, 31 | UI_Atlas_Icons_InGame_General (Bar Base/Fill, bar icon base) |
| arrows | 36 x 40 | 18 x 20 | same atlas |

Rules we take: ONE persistent strip (resources/time/goal) + icon buttons; everything else is a modal opened on demand with a dim
backdrop, a title bar with an icon and a close X; tooltips on every icon. Built S268: ui/GymTopBar.gd + ui/HudModal.gd
(switch hud_topbar, GAME_ON).
